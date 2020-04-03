import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:portfolio/service/portfolio_data.dart';
import 'package:random_color/random_color.dart';

part 'portfolio_store.g.dart';

class PortfolioStore = _PortfolioStore with _$PortfolioStore;
enum PortfolioType { LOGIN, INITIATE_RESET, COMPLETE_RESET }

abstract class _PortfolioStore with Store {
  final PortfolioService portfolioService;
  @observable
  Portfolio portfolio;
  @observable
  bool loading;
  @observable
  bool sortAscending = true;

  _PortfolioStore(this.portfolioService) {
    this.loading = true;
    portfolio = portfolioService.refresh();
    this.loading = false;
  }

  @action
  void setPortfolio(Portfolio value) => portfolio = value;

  @action
  void setSortAscending(bool value) => sortAscending = value;

  @action
  void setLoading(bool value) => loading = value;

  @action
  void refreshPortfolio() {
    loading = true;
    portfolio = portfolioService.refresh();
    loading = false;
  }

  @computed
  List<Color> get colors => RandomColor().randomColors(count: portfolio.data.length);

  @action
  void sort(int col, bool ascending){
    setSortAscending(ascending);

    switch (col){
      case 2:
        this.portfolio.data.sort((a,b)=> ascending ?a.amount.compareTo(b.amount) : b.amount.compareTo(a.amount));
        break;
      case 3:
        this.portfolio.data.sort((a,b)=> ascending ?a.value.compareTo(b.value) : b.value.compareTo(a.value));
        break;
    }
  }
}
