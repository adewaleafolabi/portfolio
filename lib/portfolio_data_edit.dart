import 'package:flutter/material.dart';
import 'package:portfolio/portfolio_store.dart';
import 'package:portfolio/service/portfolio_data.dart';

class PortfolioDataEditWidget extends StatefulWidget {
  final PortfolioData data;
  final PortfolioStore store;

  const PortfolioDataEditWidget({Key key, this.data, this.store})
      : super(key: key);
  @override
  _State createState() => _State();
}

class _State extends State<PortfolioDataEditWidget> {
  TextEditingController _assetCode;
  TextEditingController _assetQty;
  AssetType _assetType;
  PortfolioData _data;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                hint: Text('Asset Type'),
                value: _data.type,
                onChanged: (newValue) {
                  setState(() {
                    print(newValue);
                    _data.type = newValue;
                    //_assetType = newValue;
                  });
                },
                items: AssetType.values
                    .map((e) => DropdownMenuItem(
                        child: Text('${e.toShortString()}'), value: e))
                    .toList(),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _assetCode,
              onChanged: (text) {
                setState(() {
                  _data.code = text;
                });
              },
              decoration: InputDecoration(hintText: 'Asset Code'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _assetQty,
              onChanged: (text) {
                setState(() {
                  _data.amount = double.tryParse(text);
                });
              },
              decoration: InputDecoration(hintText: 'Asset Quantity'),
              keyboardType:
                  TextInputType.numberWithOptions(signed: false, decimal: true),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  onPressed: () {
                    widget.store.deleteDataItem(_data);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  color: Colors.blueGrey[100],
                ),
              )),
              Expanded(
                  flex: 2,
                  child: FlatButton(
                    onPressed: () {
                      widget.store.saveDataItem(_data);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Theme.of(context).primaryColor,
                  )),
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    _assetCode = TextEditingController(text: _data.code);
    _assetQty = TextEditingController(text: '${_data.amount}');
    _assetType = _data.type;
  }

  @override
  void dispose() {
    super.dispose();
    _assetQty.dispose();
    _assetCode.dispose();
  }
}
