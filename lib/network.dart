import 'dart:convert';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart';

const url = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '017722BD-8649-46A1-8933-5308FAC404C6';

class Network {
  Future<dynamic> getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoList) {
      http.Response response = await http
          .get(Uri.parse('$url/$crypto/$selectedCurrency?apikey=$apiKey'));

      if (response.statusCode == 200) {
        String data = response.body;
        var decodeData = jsonDecode(data);
        double price = decodeData['rate'];
        cryptoPrices[crypto] = price.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
