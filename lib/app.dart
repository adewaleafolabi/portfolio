import 'package:crypto_font_icons/crypto_font_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:portfolio/portfolio_store.dart';
import 'package:portfolio/service/portfolio_data.dart';

class MyApp extends StatelessWidget {
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
        appBar: AppBar(
          elevation: 0,
          actions: [
            Observer(builder: (_) {
              return portfolioStore.selected.length > 0
                  ? IconButton(icon:Icon(Icons.delete),onPressed: ()=>portfolioStore.deleteUsingSelected(),)
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
    final NumberFormat nf = NumberFormat.compactSimpleCurrency(name: 'CAD');
    return Observer(
        builder: (_) => store.loading
            ? CircularProgressIndicator()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 100, bottom: 50),
                    color: Theme.of(context).primaryColor,
                    child: Center(
                      child: Text(
                        "${nf.format(store.portfolio.total ?? 0)}",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Observer(
                        builder: (_) => RefreshIndicator(
                          onRefresh: () => store.futureRefreshPortfolio(),
                          child: ListView.builder(
                              itemCount: store.portfolio.data.length,
                              itemBuilder: (ctx, index) => Observer(
                                  builder: (_) => PortfolioDataWidget(
                                      data: store.portfolio.data[index],
                                      toggleSelected: () => store.toggleSelect(
                                          store.portfolio.data[index]),
                                      isSelected: store.isSelected(
                                          store.portfolio.data[index]),
                                      selectionModeActivated: store.selected.length > 0,
                                      color: store.colors[index]))),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }
}

class PortfolioDataListView extends StatelessWidget {
  final List<PortfolioData> data;

  const PortfolioDataListView({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

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
    final TextStyle bold = TextStyle(fontWeight: FontWeight.bold);
    return GestureDetector(
      onTap: () => (isSelected || selectionModeActivated)
          ? toggleSelected()
          : showModalBottomSheet(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10)),
          ),
              context: context, builder: (context) => PortfolioDataEditWidget(data: data,)),
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
                    data.label ?? data.code,
                    style: bold,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      "${nf.format(data.unitPrice)}",
                      style: TextStyle(fontSize: 10, color: Colors.grey[10]),
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
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text("${nf.format(data.value)}",
                    style: bold, textAlign: TextAlign.right),
              ),
            ),
            Expanded(
              child: LinearPercentIndicator(
                animation: true,
                lineHeight: 15.0,
                animationDuration: 2500,
                percent: data.weight ?? 0,
                center: Text(
                  "${nfPercent.format(data.weight ?? 0)}",
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Theme.of(context).primaryColor,
                backgroundColor: Colors.deepPurpleAccent,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PortfolioDataEditWidget extends StatelessWidget {
  final PortfolioData data;

  const PortfolioDataEditWidget({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    TextEditingController _assetCode = TextEditingController(text: data.code);
    TextEditingController _assetQty = TextEditingController(text: '${data.amount}');
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _assetCode,
              decoration: InputDecoration(hintText: 'Asset Code'),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _assetQty,
              decoration: InputDecoration(hintText: 'Asset Quantity'),
              keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton.icon(onPressed: (){}, icon: Icon(Icons.delete, color: Colors.white,), label: Text('',style:  TextStyle(color: Colors.white,) ,), color: Colors.red,),
              )),
              Expanded(flex:2,child: FlatButton.icon(onPressed: (){}, icon: Icon(Icons.save, color: Colors.white,), label: Text('Save',style: TextStyle(color: Colors.white,),), color: Theme.of(context).primaryColor,)),
            ],
          )
        ],
      ),
    );
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
