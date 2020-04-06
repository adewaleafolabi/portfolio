import 'dart:async';

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
  @observable
  List<PortfolioData> selected = [];

  _PortfolioStore(this.portfolioService) {
    this.loading = true;
    portfolio = portfolioService.refresh();
    this.loading = false;
  }

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
    void refreshPortfolio() {
      loading = true;
      portfolio = portfolioService.refresh();
      loading = false;
    }

    @action
    Future<Null> futureRefreshPortfolio() async {
      this.refreshPortfolio();
    }

    @action
    void toggleSelect(PortfolioData value){
      if(this.selected.contains(value)){
        this.selected.remove(value);
        this.selected = this.selected; //force state change
        return;
      }
      this.selected.add(value);
      this.selected = this.selected; //force state change
    }

    @action
    void deleteUsingSelected(){
      this.portfolio.data.removeWhere((item) => selected.contains(item));
      this.selected = [];
      this.portfolio = this.portfolio;
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
