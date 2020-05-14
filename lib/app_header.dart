import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfolio/portfolio_store.dart';
import 'package:portfolio/service/portfolio_data.dart';
class AppHeader extends StatelessWidget {
  final Portfolio portfolio;

  const AppHeader({Key key, this.portfolio}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.only(top: 100, bottom: 50),
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Text(
          portfolio == null ? "--": "${NumberFormat.compactSimpleCurrency(name: portfolio.baseCurrency).format(portfolio.total ?? 0)}",
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Colors.white),
        ),
      ),
    );
  }
}
