import 'package:finance_quote/finance_quote.dart';
import 'package:portfolio/service/portfolio_data.dart';
import 'package:portfolio/service/portfolio_repository.dart';

class PortfolioService {
  final PortfolioRepository repository;

  PortfolioService(this.repository);
  Future<Portfolio> load() async {
    var data = await repository.findAll();
    if (data.isEmpty) {
      return null;
    }
    return data.first;
  }

  void save(Portfolio portfolio) async {
    if (portfolio.id == null || portfolio.id == 0) {
      await repository.insert(portfolio);
    } else {
      await repository.update(portfolio);
    }
  }

  Future<Map<String, double>> fetchPrices(
      List<PortfolioData> data, String portfolioCurrency) async {
    Map<String, double> prices = {};
    Map<AssetType, List<String>> assetCodes = {};

    data.forEach((element) {
      if (portfolioCurrency != element.code) {
        var code = element.code;
        if (element.type == AssetType.CURRENCY) {
          code = '$portfolioCurrency${element.code}=X';
        }
        print(element.type);
        if (assetCodes.containsKey(element.type)) {
          assetCodes[element.type].add(code);
        } else {
          assetCodes[element.type] = [code];
        }
      }
    });

    List<String> yahooAssets = ["${portfolioCurrency}USD=X"];
    List<String> coinCapAssets = [];
    if (assetCodes[AssetType.STOCK] != null) {
      yahooAssets.addAll(assetCodes[AssetType.STOCK]);
    }
    if (assetCodes[AssetType.CURRENCY] != null) {
      yahooAssets.addAll(assetCodes[AssetType.CURRENCY]);
    }
    if (assetCodes[AssetType.CRYPTO] != null) {
      coinCapAssets.addAll(assetCodes[AssetType.CRYPTO]);
    }

    Map<String, double> currenciesToConvert = {};
    await FinanceQuote.getPrice(
        quoteProvider: QuoteProvider.yahoo, symbols: yahooAssets)
        .then((quotes) {
      yahooAssets.forEach((element) {
        String currency = quotes[element]['currency'];
        prices[element] = double.parse(quotes[element]['price']);
        if (currency == 'USD') {
          prices[element] = prices[element] /
              double.parse(quotes['${portfolioCurrency}USD=X']['price']);
          currenciesToConvert['${portfolioCurrency}USD=X'] =
              double.parse(quotes['${portfolioCurrency}USD=X']['price']);
        }
        if (currency != portfolioCurrency &&
            !currenciesToConvert.containsKey(currency)) {
          currenciesToConvert[currency] = 0;
        }
      });
    }).catchError((err) {
      print(err);
    });

    await FinanceQuote.getPrice(
        quoteProvider: QuoteProvider.coincap, symbols: coinCapAssets)
        .then((quotes) {
      coinCapAssets.forEach((element) {
        String currency = quotes[element]['currency'];
        prices[element] = double.parse(quotes[element]['price'] ?? 0);
        if (currency == 'USD') {
          prices[element] = prices[element] /
              currenciesToConvert['${portfolioCurrency}USD=X'];
        }
      });
    }).catchError((err) {
      print(err);
    });
    return prices;
  }

  Portfolio calculate(Portfolio portfolio, Map<String, double> prices) {
    double total = 0;
    portfolio.data.forEach((e) {
      if (e != null && e.amount != null) {
        if (e.code == portfolio.baseCurrency && e.type == AssetType.CURRENCY) {
          e.value = e.amount;
          e.unitPrice = 1;
        } else {
          if (e.type == AssetType.CURRENCY) {
            e.value = e.amount *
                (1 / (prices['${portfolio.baseCurrency}${e.code}=X'] ?? 0));
            e.unitPrice = prices['${portfolio.baseCurrency}${e.code}=X'] ?? 0;
          } else {
            e.value = e.amount * (prices[e.code] ?? 0.0);
            e.unitPrice = prices[e.code] ?? 0;
          }
        }
        total += e.value;
      }
    });
    portfolio.total = total;
    portfolio.assetDistribution = {};
    portfolio.data.forEach((e) {
      e.weight = e.value / portfolio.total;
      if (portfolio.assetDistribution[e.type] == null) {
        portfolio.assetDistribution[e.type] = 0;
      }
      portfolio.assetDistribution[e.type] += e.weight;
    });

    return portfolio;
  }
}