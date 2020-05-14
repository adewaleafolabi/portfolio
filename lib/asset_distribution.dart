import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfolio/service/portfolio_data.dart';

class AssetDistribution extends StatelessWidget {
  final Portfolio portfolio;

  const AssetDistribution({Key key, this.portfolio}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          color: Colors.white,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var item in portfolio.assetDistribution.keys)
            Expanded(
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "${NumberFormat.decimalPercentPattern(decimalDigits: 2).format(portfolio.assetDistribution[item])}",
                    style: TextStyle( fontWeight: FontWeight.w700 , fontSize: 15, color: Theme.of(context).primaryColor),
                    textAlign: TextAlign.right,
                  ),
                  Text(item.toShortString(),textAlign: TextAlign.right, style: TextStyle(fontSize: 10,fontWeight: FontWeight.w500), ),

                ],
              ),
            )
        ],
      ),
    );
  }
}
