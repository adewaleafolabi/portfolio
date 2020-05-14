import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:portfolio/service/portfolio_data.dart';
import 'package:portfolio/service/portfolio_service.dart';
import 'package:random_color/random_color.dart';

part 'portfolio_store.g.dart';

class PortfolioStore = _PortfolioStore with _$PortfolioStore;
enum PortfolioType { LOGIN, INITIATE_RESET, COMPLETE_RESET }

abstract class _PortfolioStore with Store {
  final PortfolioService portfolioService;
  @observable
  Portfolio portfolio;
  @observable
  bool loading = false;
  @observable
  bool sortAscending = true;
  @observable
  List<PortfolioData> selected = [];
  @observable
  Map<String, double> prices = {};

  _PortfolioStore(this.portfolioService);

  @action
  Future<void> load() async {
    this.loading = true;
    portfolio = await portfolioService.load();
    if (portfolio == null) {
      this.loading = false;
      return;
    }
    var dp = await portfolioService.fetchPrices(portfolio.data, 'CAD');
    print(portfolioService.calculate(portfolio, dp).data);
    setPortfolio(portfolioService.calculate(portfolio, dp));
    this.loading = false;
  }

  @action
  void setPrices(Map<String, double> value) => prices = value;
  @action
  void setPortfolio(Portfolio value) => portfolio = value;

  @action
  void addToSelected(PortfolioData value) {
    var temp = selected;
    temp.add(value);
    this.selected = temp;
  }

  @action
  void setSortAscending(bool value) => sortAscending = value;

  @action
  void setLoading(bool value) => loading = value;

  @action
  Future refreshPortfolio() async {
    loading = true;
    this.prices = await portfolioService.fetchPrices(portfolio.data, 'CAD');
    setPortfolio(portfolioService.calculate(portfolio, prices));
    loading = false;
  }

  @action
  Future<Null> futureRefreshPortfolio() async {
    this.refreshPortfolio();
  }

  @action
  void toggleSelect(PortfolioData value) {
    if (this.selected.contains(value)) {
      this.selected.remove(value);
      this.selected = this.selected; //force state change
      return;
    }
    this.selected.add(value);
    this.selected = this.selected; //force state change
  }

  @action
  void deleteUsingSelected() {
    this.loading = false;
    this.portfolio.data.removeWhere((item) => selected.contains(item));
    this.selected = [];
    portfolioService.save(this.portfolio);
    this.portfolio = this.portfolio;
    this.loading = true;
  }

  @action
  void deleteDataItem(PortfolioData value) {
    this.loading = true;
    this.portfolio.data.remove(value);
    portfolioService.save(this.portfolio);
    this.portfolio = this.portfolio;
    this.loading = false;
  }

  @action
  void createPortfolio(Portfolio portfolio){
    print('create portfoliko called');
    this.loading = true;
    this.portfolioService.save(portfolio);
    this.portfolio = portfolio;
    this.refreshPortfolio();
    this.loading = false;
    print('create portfoliko ended');

  }

  @action
  void saveDataItem(PortfolioData value) {
    if(value.code == null){
      throw UnsupportedError("data code is null");
    }
    this.loading = true;
    if (this.portfolio.data.contains(value)) {
      this.portfolio.data.remove(value);
    }
    this.portfolio.data.add(value);
    portfolioService.save(this.portfolio);
    this.portfolio = this.portfolio;
    this.loading = false;
  }

  @computed
  List<Color> get colors =>
      RandomColor().randomColors(count: portfolio.data.length);

  bool isSelected(PortfolioData data) => this.selected.contains(data);

  @action
  void sort(int col, bool ascending) {
    setSortAscending(ascending);

    switch (col) {
      case 1:
        this.portfolio.data.sort((a, b) => ascending
            ? a.amount.compareTo(b.amount)
            : b.amount.compareTo(a.amount));
        break;
      case 2:
        this.portfolio.data.sort((a, b) => ascending
            ? a.value.compareTo(b.value)
            : b.value.compareTo(a.value));
        break;
    }
  }
}
