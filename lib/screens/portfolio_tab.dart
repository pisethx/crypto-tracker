import 'package:crypto_tracker/constants/style.dart';
import 'package:flutter/material.dart';

class PortfolioTab extends StatefulWidget {
  PortfolioTab({Key key}) : super(key: key);

  @override
  _PortfolioTabState createState() => _PortfolioTabState();
}

class _PortfolioTabState extends State<PortfolioTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Icon(
      Icons.pie_chart,
      color: kPrimaryColor,
    )));
  }
}
