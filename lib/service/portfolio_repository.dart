import 'package:portfolio/service/database_helper.dart';
import 'package:portfolio/service/portfolio_data.dart';

class PortfolioRepository {
  final DatabaseHelper engine;

  PortfolioRepository(this.engine);

  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  Future<Portfolio> find(String id) async {
    var data = await engine.query("portfolio", id);
    if (data.isEmpty) {
      return null;
    }
    var db = await engine.database;
    var items = await db
        .query('portfolio_data', where: 'portfolioId = ?', whereArgs: [id]);
    data.first['data'] = items;
    return Portfolio.fromJson(data.first);
  }

  Future<List<Portfolio>> findAll() async {
    List<Portfolio> output = [];
    var db = await engine.database;
    var raw = await engine.queryAllRows('portfolio');
    for (int i = 0; i < raw.length; i++) {
      var items = await db.query('portfolio_data',
          where: 'portfolioId = ?', whereArgs: [raw[i]['id']]);
      Portfolio p = Portfolio.fromJson(raw[i]);
      p?.data = items.map((e) => PortfolioData.fromJson(e)).toList();
      output.add(p);
    }
    return output;
  }

  Future<void> insert(Portfolio value) async {
    var data = value.toJson();
    var items = data['data'];
    data.remove('data');
    data.remove('assetDistribution');
    int portfolioId = await engine.insert('portfolio', data);
    for (var value1 in (items as List)) {
      value1['portfolioId'] = portfolioId;
      value1['id'] == null ? await engine.insert('portfolio_data', value1): await engine.update('portfolio_data', value1);
    }
  }

  Future<void> update(Portfolio value) async {
    value.data.forEach((element) => element.portfolioId = value.id);
    var data = value.toJson();
    var items = data['data'];
    data.remove('data');
    data.remove('assetDistribution');
    print(data);
    await engine.update('portfolio', data);
    for (var value1 in (items as List)) {
      print(value1);
      value1['id'] == null ? await engine.insert('portfolio_data', value1): await engine.update('portfolio_data', value1);
    }
  }
}
