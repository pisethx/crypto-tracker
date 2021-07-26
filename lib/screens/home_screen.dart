import 'package:crypto_tracker/constants/style.dart';
import 'package:crypto_tracker/models/crypto.dart';
import 'package:crypto_tracker/screens/home_tab.dart';
import 'package:crypto_tracker/screens/portfolio_tab.dart';
import 'package:crypto_tracker/screens/asset_tab.dart';
import 'package:crypto_tracker/screens/profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'dart:convert';
import 'package:crypto_tracker/constants/helper.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;

  Future<dynamic> _fetchSparklineData(String id) async {
    final String now = DateTime.now().subtract(Duration(days: 1)).toUtc().toIso8601String();

    final response = await http.get(formatApiUrl(type: 'sparkline', slug: '&ids=$id&start=$now'));

    if (response.statusCode != 200) throw Exception(response.statusCode);

    return json.decode(response.body)[0];
  }

  Future<List<double>> _getSparklinePrice(String id) async {
    final sparklineData = await _fetchSparklineData(id);
    List<dynamic> jsonPrices = sparklineData['prices'];
    List<double> prices = jsonPrices.map((price) => double.tryParse(price)).toList();

    return prices;
  }

  final _kBottomNavigationBarItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.data_saver_off), label: 'Portfolio'),
    BottomNavigationBarItem(icon: Icon(Icons.assessment), label: 'Prices'),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    Future<dynamic> _showAssetInfo(Crypto crypto) async {
      List<double> prices = await _getSparklinePrice(crypto.id);

      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(formatCryptoName(crypto), style: kPrimaryTextStyle.copyWith(fontSize: 20.0)),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Price", style: kSubtitleTextStyle.copyWith(fontWeight: FontWeight.bold)),
                        _buildCryptoInfoRow(title: "Price", value: formatCurrency(amount: crypto.price)),
                        _buildCryptoInfoRow(title: "Change", value: formatPercentage(crypto.priceChangePercentage)),
                        SizedBox(height: 30),
                        Text("Market Stats", style: kSubtitleTextStyle.copyWith(fontWeight: FontWeight.bold)),
                        _buildCryptoInfoRow(title: "Rank", value: crypto.rank),
                        _buildCryptoInfoRow(title: "Market Cap", value: crypto.marketCap),
                        _buildCryptoInfoRow(title: "Circulating Supply", value: crypto.circulatingSupply),
                        _buildCryptoInfoRow(title: "Max Supply", value: crypto.maxSupply),
                        SizedBox(height: 30),
                        Sparkline(data: prices, lineColor: kExpenseColor, fallbackHeight: 200),
                      ],
                    )),
              ],
            ),
          );
        },
      );
    }

    final _kTabPages = <Widget>[
      HomeTab(),
      PortfolioTab(),
      AssetTab(
        onTap: (Crypto crypto) {
          _showAssetInfo(crypto);
        },
      ),
      ProfileTab(),
    ];

    return Scaffold(
        // appBar: _currentTabIndex == 0
        //     ? null
        //     : AppBar(automaticallyImplyLeading: false, title: Text(_kBottomNavigationBarItems[_currentTabIndex].label)),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          showSelectedLabels: false,
          unselectedFontSize: 14.0,
          selectedFontSize: 14.0,
          iconSize: 30.0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: kLightGrayColor,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          items: _kBottomNavigationBarItems,
          currentIndex: _currentTabIndex,
          onTap: (int index) {
            setState(() {
              _currentTabIndex = index;
            });
          },
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 20.0),
            child: _kTabPages[_currentTabIndex],
          ),
        ));
  }
}

Widget _buildCryptoInfoRow({String title, dynamic value}) {
  var textValue = value;
  var textColor;

  if (value is double) textValue = value > 0 ? formatNumber(amount: value) : '-';

  if (value is String && (value.startsWith('-') || value.startsWith('+')))
    textColor = textValue.startsWith('-') ? kExpenseColor : kIncomeColor;

  return Padding(
    padding: const EdgeInsets.only(top: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kCaptionTextStyle.copyWith(fontWeight: FontWeight.bold)),
        Text(
          textValue,
          style: kCaptionTextStyle.copyWith(color: textColor),
        ),
      ],
    ),
  );
}
