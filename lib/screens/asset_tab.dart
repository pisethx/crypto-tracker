import 'package:flutter/material.dart';
import 'package:crypto_tracker/widgets/network_picture.dart';
import 'package:crypto_tracker/widgets/search_bar.dart';
import 'package:crypto_tracker/constants/style.dart';
import 'package:crypto_tracker/models/crypto.dart';
import 'package:crypto_tracker/constants/helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssetTab extends StatefulWidget {
  final bool isDense;
  AssetTab({Key key, this.isDense = false}) : super(key: key);

  @override
  _AssetTabState createState() => _AssetTabState();
}

class _AssetTabState extends State<AssetTab> {
  Future<List<Crypto>> _cryptoCurrencies;

  Future<List<Crypto>> _fetchCrypto([String keyword = '']) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getString('CRYPTO');

    if (result == null) {
      final response = await http.get(
          Uri.parse('https://api.nomics.com/v1/currencies/ticker?key=${dotenv.env['NOMICS_API_KEY']}&per-page=100'));

      if (response.statusCode != 200) throw Exception('Something went wrong');

      result = response.body;
      await prefs.setString('CRYPTO', response.body);
    }

    List<dynamic> data = json.decode(result);

    var cryptos = data.map((json) => Crypto.fromJson(json));

    if (keyword != '') {
      final _keyword = keyword.toLowerCase();
      cryptos = cryptos.where(
          (crypto) => crypto.name.toLowerCase().startsWith(_keyword) || crypto.id.toLowerCase().startsWith(_keyword));
    }

    return cryptos.toList();
  }

  @override
  void initState() {
    super.initState();

    _cryptoCurrencies = _fetchCrypto();
  }

  void _setCrypto([String keyword = '']) {
    setState(() {
      _cryptoCurrencies = _fetchCrypto(keyword);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _horizontalPadding = widget.isDense ? 10.0 : 20.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 8.0),
          child: SearchBar(
            width: MediaQuery.of(context).size.width - (45 + _horizontalPadding * 2),
            isToggable: !widget.isDense,
            onChanged: _setCrypto,
            onCleared: _setCrypto,
          ),
        ),
        Expanded(
          child: Container(
            child: FutureBuilder<List<Crypto>>(
              future: _cryptoCurrencies,
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text("${snapshot.error}");

                if (snapshot.hasData) return _buildCryptoList(snapshot);

                // By default, show a loading spinner.
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: kPrimaryColor,
                    )
                  ],
                );
              },
            ),
          ),
        )
      ],
    );
  }

  ListView _buildCryptoList(AsyncSnapshot<List<Crypto>> snapshot) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        String priceChangePercentage = snapshot.data[index].priceChangePercentage;
        String name = snapshot.data[index].name;
        String id = snapshot.data[index].id;
        double price = snapshot.data[index].price;
        String logo = snapshot.data[index].logo;

        return ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20.0,
            child: NetworkPicture(
              url: logo,
              radius: 20.0,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(color: kDarkGrayColor),
              ),
              SizedBox(height: 3.0),
              Text(
                id,
                style: TextStyle(color: kGrayColor, fontSize: 14.0),
              ),
            ],
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                formatCurrency(amount: price),
                textAlign: TextAlign.right,
                style: TextStyle(color: kDarkGrayColor, fontSize: 16.0),
              ),
              SizedBox(height: 3.0),
              Text(
                (priceChangePercentage.startsWith('-') ? '' : '+') + priceChangePercentage + '%',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: priceChangePercentage.startsWith('-') ? kExpenseColor : kIncomeColor,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
