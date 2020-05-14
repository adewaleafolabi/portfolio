import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:portfolio/portfolio_data_edit.dart';
import 'package:portfolio/portfolio_data_widget.dart';
import 'package:portfolio/portfolio_store.dart';
import 'package:portfolio/service/portfolio_data.dart';

class PortfolioDataList extends StatelessWidget {
  final PortfolioStore store;

  const PortfolioDataList({Key key, this.store}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Observer(
        builder: (_) => RefreshIndicator(
          onRefresh: () => store.futureRefreshPortfolio(),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 20),
                    itemCount: store.portfolio.data.length,
                    itemBuilder: (ctx, index) => Observer(
                        builder: (_) => PortfolioDataWidget(
                            store: store,
                            data: store.portfolio.data[index],
                            toggleSelected: () => store.toggleSelect(
                                store.portfolio.data[index]),
                            isSelected: store.isSelected(
                                store.portfolio.data[index]),
                            selectionModeActivated:
                            store.selected.length > 0,
                            color: store.colors[index]))),
              ),
              FlatButton(child: Icon(Icons.add),onPressed: ()=>showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10)),
                  ),
                  context: context,
                  builder: (context) => PortfolioDataEditWidget(
                    data: PortfolioData(amount: 0),
                    store: store,
                  )),)
            ],
          ),
        ),
      ),
    );
  }
}
