import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:portfolio/app_header.dart';
import 'package:portfolio/asset_distribution.dart';
import 'package:portfolio/portfolio_data_edit.dart';
import 'package:portfolio/portfolio_data_list.dart';
import 'package:portfolio/portfolio_data_widget.dart';
import 'package:portfolio/portfolio_store.dart';
import 'package:portfolio/service/database_helper.dart';
import 'package:portfolio/service/portfolio_data.dart';
import 'package:portfolio/service/portfolio_repository.dart';
import 'package:portfolio/service/portfolio_service.dart';

class MyApp extends StatelessWidget {
  PortfolioStore portfolioStore;
  final ThemeData appTheme = ThemeData(
      fontFamily: "Ubuntu",
      primaryColor: Color(0xFF08064e), //Color(0xFF20639B),

      accentColor: Color(0xFF0078FB));
  @override
  MyApp() {
    portfolioStore = PortfolioStore(
        PortfolioService(PortfolioRepository(DatabaseHelper.instance)));
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            Observer(builder: (_) {
              return portfolioStore.selected.length > 0
                  ? IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => portfolioStore.deleteUsingSelected(),
                    )
                  : Container();
            })
          ],
        ),
        backgroundColor: Colors.white,
        body: AppHomePage(
          store: portfolioStore,
        ),
      ),
    );
  }
}

class AppHomePage extends StatelessWidget {
  final PortfolioStore store;
  const AppHomePage({Key key, @required this.store}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    store.load();
    return Observer(
        builder: (_) => store.loading
            ? Center(child: CircularProgressIndicator())
            : store.portfolio == null
                ? AppNoDataWidget(
                    createPortfolioFunction: store.createPortfolio,
                  )
                : Column(
                    children: <Widget>[
                      Observer(
                          builder: (_) => AppHeader(
                                portfolio: store.portfolio,
                              )),
                      Observer(
                          builder: (_) => AssetDistribution(
                                portfolio: store.portfolio,
                              )),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: PortfolioDataList(store: store),
                        ),
                      ),
                    ],
                  ));
  }
}

class AppNoDataWidget extends StatelessWidget {
  final Function createPortfolioFunction;

  const AppNoDataWidget({Key key, this.createPortfolioFunction})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    PortfolioData item =
        PortfolioData(code: 'CAD', amount: 0, type: AssetType.CURRENCY);
    Portfolio portfolio = Portfolio(baseCurrency: 'CAD', data: [item]);
    return Container(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => createPortfolioFunction(portfolio),
              child: Icon(
                Icons.add,
                color: Theme.of(context).accentColor,
                size: 40,
              ),
            ),
            Text(
              "Create new portfolio",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
