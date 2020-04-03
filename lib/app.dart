import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:portfolio/portfolio_store.dart';
import 'package:portfolio/service/portfolio_data.dart';
import 'package:random_color/random_color.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final PortfolioStore portfolioStore = PortfolioStore(PortfolioService());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Ubuntu",
        primarySwatch: Colors.deepPurple,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
          body: AppHomePage(
            store: portfolioStore,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => portfolioStore.refreshPortfolio(),
            tooltip: 'Refresh',
            child: Icon(Icons.refresh),
          )),
    );
  }
}

class AppHomePage extends StatelessWidget {
  final PortfolioStore store;
  const AppHomePage({Key key, @required this.store}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final TextStyle tableHeader = TextStyle(
        fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black);
    final NumberFormat nf = NumberFormat(
      '#,##0.##',
    );
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Observer(
                  builder: (_) => CustomPaint(
                    painter: CurvePainter(Colors.purple, Colors.purpleAccent, Colors.deepPurple),
                    child: Container(
                      decoration: BoxDecoration(
                        color:Theme.of(context).primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top:100,bottom: 50),
                        child: Center(
                          child: Text(
                                "${NumberFormat.compactCurrency(name: 'CAD',symbol: '\$').format(store.portfolio.total ?? 0)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  fontSize: 30,
                                  letterSpacing: 2,
                                ),
                              ),
                        ),
                      ),
                    ),
                  )),
              Observer(
                  builder: (_) => Container(
                    child: DataTable(
                      dataRowHeight: 50,
                      sortAscending: store.sortAscending,
                      sortColumnIndex: 3,
                      columns: [
                        DataColumn(
                            label: Text(
                          "Asset",
                          style: tableHeader,
                        )),
                        DataColumn(
                          label: Text("Price", style: tableHeader),
                          numeric: true,
                          tooltip: 'Price',
                        ),
                        DataColumn(
                          label: Text("Quantity", style: tableHeader),
                          numeric: true,
                          tooltip: 'Quantity',
                          onSort: (columnIndex, ascending) =>
                              store.sort(columnIndex, ascending),
                        ),
                        DataColumn(
                          label: Text("Value", style: tableHeader),
                          numeric: true,
                          tooltip: 'Value',
                          onSort: (columnIndex, ascending) =>
                              store.sort(columnIndex, ascending),
                        ),
                        DataColumn(
                            label: Text("Weight", style: tableHeader),
                            numeric: true,
                            tooltip: 'Weight'),
                      ],
                      rows: buildDataRows(store.portfolio.data, store.colors, context),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

List<DataRow> buildDataRows(List<PortfolioData> data, List<Color> colors, BuildContext context) {
  final NumberFormat nfPercent = NumberFormat('#,##0.##%');
  final NumberFormat nf = NumberFormat(
    '#,##0.##',
  );
  final TextStyle bold = TextStyle(fontWeight: FontWeight.bold);
  List<DataRow> rows = [];
  for (int i = 0; i < data.length; i++) {
    rows.add(DataRow(cells: [
      DataCell(Row(
        children: <Widget>[
          Text(
            data[i].label ?? data[i].code,
            style: bold,
          ),
        ],
      )),
      DataCell(Text(
        "${nf.format(data[i].unitPrice)}",
        style: bold,
      )),
      DataCell(Text(
        "${nf.format(data[i].amount)}",
        style: bold,
      )),
      DataCell(Text(
        "${nf.format(data[i].value)}",
        style: bold,
      )),
      DataCell(LinearPercentIndicator(
        width: MediaQuery.of(context).size.width / 4,
        animation: true,
        lineHeight: 15.0,
        animationDuration: 2500,
        percent: data[i].weight ?? 0,
        center: Text("${nfPercent.format(data[i].weight ?? 0)}",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w800),),
        linearStrokeCap: LinearStrokeCap.roundAll,
        progressColor: colors[i],
      )),
    ]));
  }
  return rows;
}

class PortfolioDataWidget extends StatelessWidget {
  final PortfolioData data;

  const PortfolioDataWidget({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

IconData getIcon(PortfolioData data) {
  IconData iconData;
  switch (data.type) {
    case AssetType.CRYPTO:
      iconData = CryptoFontIcons.ETH;
      break;
    case AssetType.CURRENCY:
      iconData = Icons.attach_money;
      break;
    case AssetType.STOCK:
      iconData = Icons.graphic_eq;
      break;
  }

  return iconData;
}


class CurvePainter extends CustomPainter{
  final Color colorOne, colorTwo, colorThree;

  CurvePainter(this.colorOne, this.colorTwo, this.colorThree);
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();


    path.lineTo(0, size.height *0.75);
    path.quadraticBezierTo(size.width* 0.10, size.height*0.70, size.width*0.17, size.height*0.90);
    path.quadraticBezierTo(size.width*0.20, size.height, size.width*0.25, size.height*0.90);
    path.quadraticBezierTo(size.width*0.40, size.height*0.40, size.width*0.50, size.height*0.70);
    path.quadraticBezierTo(size.width*0.60, size.height*0.85, size.width*0.65, size.height*0.65);
    path.quadraticBezierTo(size.width*0.70, size.height*0.90, size.width, 0);
    path.close();

    paint.color = colorThree;
    canvas.drawPath(path, paint);

    path = Path();
    path.lineTo(0, size.height*0.50);
    path.quadraticBezierTo(size.width*0.10, size.height*0.80, size.width*0.15, size.height*0.60);
    path.quadraticBezierTo(size.width*0.20, size.height*0.45, size.width*0.27, size.height*0.60);
    path.quadraticBezierTo(size.width*0.45, size.height, size.width*0.50, size.height*0.80);
    path.quadraticBezierTo(size.width*0.55, size.height*0.45, size.width*0.75, size.height*0.75);
    path.quadraticBezierTo(size.width*0.85, size.height*0.93, size.width, size.height*0.60);
    path.lineTo(size.width, 0);
    path.close();

    paint.color = colorTwo;
    canvas.drawPath(path, paint);

    path =Path();
    path.lineTo(0, size.height*0.75);
    path.quadraticBezierTo(size.width*0.10, size.height*0.55, size.width*0.22, size.height*0.70);
    path.quadraticBezierTo(size.width*0.30, size.height*0.90, size.width*0.40, size.height*0.75);
    path.quadraticBezierTo(size.width*0.52, size.height*0.50, size.width*0.65, size.height*0.70);
    path.quadraticBezierTo(size.width*0.75, size.height*0.85, size.width, size.height*0.60);
    path.lineTo(size.width, 0);
    path.close();

    paint.color = colorOne;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

}