import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'network.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';
  int rate;
  // var newRate;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      Network network = Network();
      isWaiting = false;
      var data = await network.getCoinData(selectedCurrency);
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  // ignore: missing_return

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> itemList = [];
    for (int i = 0; i < currenciesList.length; i++) {
      var newItem = DropdownMenuItem(
        child: Text(currenciesList[i]),
        value: currenciesList[i],
      );

      itemList.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: itemList,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iosCupertino() {
    List<Text> pickerItemList = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);

      pickerItemList.add(newItem);
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        getData();
      },
      children: pickerItemList,
    );
  }

  Column makeCards() {
    List<CrytoCard> crytoCards = [];
    for (String crypto in cryptoList) {
      crytoCards.add(
        CrytoCard(
          selectedCurrency: selectedCurrency,
          crytoCurrency: crypto,
          value: isWaiting ? '?' : coinValues[crypto],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: crytoCards,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosCupertino() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CrytoCard extends StatelessWidget {
  const CrytoCard(
      {Key key, this.value, this.selectedCurrency, this.crytoCurrency})
      : super(key: key);
  final String value;
  final String selectedCurrency;
  final String crytoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crytoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
