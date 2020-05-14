import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:portfolio/portfolio_data_edit.dart';
import 'package:portfolio/portfolio_store.dart';
import 'package:portfolio/service/portfolio_data.dart';
class PortfolioDataWidget extends StatelessWidget {
  final PortfolioData data;
  final Color color;
  final PortfolioStore store;
  final bool isSelected;
  final bool selectionModeActivated;
  final void Function() toggleSelected;
  const PortfolioDataWidget(
      {Key key,
        this.data,
        this.color,
        this.store,
        this.isSelected,
        this.toggleSelected,
        this.selectionModeActivated})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final NumberFormat nfPercent = NumberFormat('#,##0.##%');
    final NumberFormat nf = NumberFormat(
      '#,##0.##',
    );
    final NumberFormat snf =
    NumberFormat.compactSimpleCurrency(name: store.portfolio.baseCurrency);
    final TextStyle bold = TextStyle(fontWeight: FontWeight.bold);
    return GestureDetector(
      onTap: () => (isSelected || selectionModeActivated)
          ? toggleSelected()
          : showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10)),
          ),
          context: context,
          builder: (context) => PortfolioDataEditWidget(
            data: data,
            store: store,
          )),
      onLongPress: () => toggleSelected(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
        decoration: BoxDecoration(
            color: isSelected ? Colors.grey[200] : Colors.transparent,
            border: Border(
                bottom: BorderSide(
                    width: isSelected ? 0.3 : 0.1, color: Colors.grey))),
        child: Row(
          children: <Widget>[
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    ((data.label ?? data.code) ?? "").toUpperCase(),
                    style: bold.copyWith(color: Colors.grey[900]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      "${nf.format(data.unitPrice)}",
                      style: TextStyle(fontSize: 10, color: Colors.blueGrey),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  "${nf.format(data.amount)}",
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text("${snf.format(data.value)}",
                    style: bold.copyWith(color: Colors.grey[900]),
                    textAlign: TextAlign.right),
              ),
            ),
            Expanded(
              child: LinearPercentIndicator(
                animation: true,
                lineHeight: 12.5,
                animationDuration: 2500,
                percent: data.weight ?? 0,
                center: Text(
                  "${nfPercent.format(data.weight ?? 0)}",
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).accentColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}