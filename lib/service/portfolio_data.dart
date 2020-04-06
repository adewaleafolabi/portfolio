import 'package:finance_quote/finance_quote.dart';

class Portfolio {
  List<PortfolioData> data;
  double total;
  String baseCurrency = "CAD";
  Portfolio(this.data);
}

enum AssetType { CRYPTO, CURRENCY, STOCK }

class PortfolioData {
  String code = "";
  double unitPrice = 0;
  double amount = 0;
  double value = 0;
  double weight = 0;
  String label = "";
  AssetType type;

  PortfolioData(this.code, this.amount, this.value, this.weight,
      {this.label, this.type});

  @override
  String toString() {
    return 'PortfolioData{code: $code, amount: $amount}';
  }
}

class PortfolioService {
  Portfolio portfolio;

  PortfolioService() {
    portfolio = Portfolio([
      PortfolioData("QQQ", 113, 0, 0),
      PortfolioData("QQC-F.TO", 27, 0, 0),
      PortfolioData("XIU.TO", 86, 0, 0),
      PortfolioData("BTC-CAD", 0.67, 0, 0, type: AssetType.CRYPTO),
      PortfolioData("ETH-CAD", 32.41, 0, 0, type: AssetType.CRYPTO),
      PortfolioData("ICX-CAD", 999, 0, 0, type: AssetType.CRYPTO),
      //PortfolioData("POWR", 4516, 0, 0),
      PortfolioData("ADA-CAD", 6273, 0, 0, type: AssetType.CRYPTO),
      PortfolioData('CADNGN=X', 400000, 0, 0, label: "NGN"),
      PortfolioData("CAD", 12097, 12097, 0),
      //PortfolioData("CAD", 13000, 13000, 0, label: "Bonus"),
    ]);
    //portfolio = refresh();
  }

  Portfolio refresh() {
    var symbols = [
      'USDCAD=X',
      'QQQ',
      'QQC-F.TO',
      'XIU.TO',
      'BTC-CAD',
      'ETH-CAD',
      'ICX-CAD',
      'ADA-CAD',
      'CADNGN=X'
    ];

    FinanceQuote.getPrice(quoteProvider: QuoteProvider.yahoo, symbols: symbols)
        .then((quotePrice) {
      print(quotePrice);
      if (portfolio.total == null) {
        portfolio.total = 0;
      }

      double cadUSD = double.parse(quotePrice['USDCAD=X']['price'] ?? 0);
      double ngnCAD = double.parse(quotePrice['CADNGN=X']['price'] ?? 0);
      double total = 0;
      for (var i = 0; i < portfolio.data.length; i++) {
        if (quotePrice.containsKey(portfolio.data[i].code)) {
          var data = quotePrice[portfolio.data[i].code];
          double parsedPrice = double.parse(data['price'] ?? 0);
          if (data['currency'] == 'USD') {
            portfolio.data[i].value =
                portfolio.data[i].amount * (parsedPrice * cadUSD);
            portfolio.data[i].unitPrice = (parsedPrice * cadUSD);
          } else {
            portfolio.data[i].value = portfolio.data[i].amount * parsedPrice;
            portfolio.data[i].unitPrice = parsedPrice;
          }
        }
        if (portfolio.data[i].label == 'NGN') {
          portfolio.data[i].value = portfolio.data[i].amount / ngnCAD;
        }
        total += portfolio.data[i].value;
      }
      portfolio.total = total;
    });
    if (portfolio.total != null && portfolio.total != 0) {
      for (var i = 0; i < portfolio.data.length; i++) {
        if (portfolio.data[i].value != null || portfolio.data[i].value != 0)
          portfolio.data[i].weight = portfolio.data[i].value / portfolio.total;
      }
    }
    return portfolio;
  }


  void calculate(){

  }
}
