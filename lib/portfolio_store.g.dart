// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PortfolioStore on _PortfolioStore, Store {
  Computed<List<Color>> _$colorsComputed;

  @override
  List<Color> get colors =>
      (_$colorsComputed ??= Computed<List<Color>>(() => super.colors)).value;

  final _$portfolioAtom = Atom(name: '_PortfolioStore.portfolio');

  @override
  Portfolio get portfolio {
    _$portfolioAtom.context.enforceReadPolicy(_$portfolioAtom);
    _$portfolioAtom.reportObserved();
    return super.portfolio;
  }

  @override
  set portfolio(Portfolio value) {
    _$portfolioAtom.context.conditionallyRunInAction(() {
      super.portfolio = value;
      _$portfolioAtom.reportChanged();
    }, _$portfolioAtom, name: '${_$portfolioAtom.name}_set');
  }

  final _$loadingAtom = Atom(name: '_PortfolioStore.loading');

  @override
  bool get loading {
    _$loadingAtom.context.enforceReadPolicy(_$loadingAtom);
    _$loadingAtom.reportObserved();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.context.conditionallyRunInAction(() {
      super.loading = value;
      _$loadingAtom.reportChanged();
    }, _$loadingAtom, name: '${_$loadingAtom.name}_set');
  }

  final _$sortAscendingAtom = Atom(name: '_PortfolioStore.sortAscending');

  @override
  bool get sortAscending {
    _$sortAscendingAtom.context.enforceReadPolicy(_$sortAscendingAtom);
    _$sortAscendingAtom.reportObserved();
    return super.sortAscending;
  }

  @override
  set sortAscending(bool value) {
    _$sortAscendingAtom.context.conditionallyRunInAction(() {
      super.sortAscending = value;
      _$sortAscendingAtom.reportChanged();
    }, _$sortAscendingAtom, name: '${_$sortAscendingAtom.name}_set');
  }

  final _$selectedAtom = Atom(name: '_PortfolioStore.selected');

  @override
  List<PortfolioData> get selected {
    _$selectedAtom.context.enforceReadPolicy(_$selectedAtom);
    _$selectedAtom.reportObserved();
    return super.selected;
  }

  @override
  set selected(List<PortfolioData> value) {
    _$selectedAtom.context.conditionallyRunInAction(() {
      super.selected = value;
      _$selectedAtom.reportChanged();
    }, _$selectedAtom, name: '${_$selectedAtom.name}_set');
  }

  final _$futureRefreshPortfolioAsyncAction =
      AsyncAction('futureRefreshPortfolio');

  @override
  Future<Null> futureRefreshPortfolio() {
    return _$futureRefreshPortfolioAsyncAction
        .run(() => super.futureRefreshPortfolio());
  }

  final _$_PortfolioStoreActionController =
      ActionController(name: '_PortfolioStore');

  @override
  void setPortfolio(Portfolio value) {
    final _$actionInfo = _$_PortfolioStoreActionController.startAction();
    try {
      return super.setPortfolio(value);
    } finally {
      _$_PortfolioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addToSelected(PortfolioData value) {
    final _$actionInfo = _$_PortfolioStoreActionController.startAction();
    try {
      return super.addToSelected(value);
    } finally {
      _$_PortfolioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSortAscending(bool value) {
    final _$actionInfo = _$_PortfolioStoreActionController.startAction();
    try {
      return super.setSortAscending(value);
    } finally {
      _$_PortfolioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$_PortfolioStoreActionController.startAction();
    try {
      return super.setLoading(value);
    } finally {
      _$_PortfolioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void refreshPortfolio() {
    final _$actionInfo = _$_PortfolioStoreActionController.startAction();
    try {
      return super.refreshPortfolio();
    } finally {
      _$_PortfolioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleSelect(PortfolioData value) {
    final _$actionInfo = _$_PortfolioStoreActionController.startAction();
    try {
      return super.toggleSelect(value);
    } finally {
      _$_PortfolioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteUsingSelected() {
    final _$actionInfo = _$_PortfolioStoreActionController.startAction();
    try {
      return super.deleteUsingSelected();
    } finally {
      _$_PortfolioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void sort(int col, bool ascending) {
    final _$actionInfo = _$_PortfolioStoreActionController.startAction();
    try {
      return super.sort(col, ascending);
    } finally {
      _$_PortfolioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'portfolio: ${portfolio.toString()},loading: ${loading.toString()},sortAscending: ${sortAscending.toString()},selected: ${selected.toString()},colors: ${colors.toString()}';
    return '{$string}';
  }
}
