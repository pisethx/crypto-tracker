import 'package:crypto_tracker/constants/style.dart';
import 'package:crypto_tracker/widgets/portfolio_chart.dart';
import 'package:crypto_tracker/widgets/portfolio_history.dart';
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
      body: SafeArea(
        child: Container(
          padding: kScreenPadding.copyWith(bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'My Portfolio',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              PortfolioChart(),
              SizedBox(height: 40.0),
              Text(
                'Transaction History',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: PortfolioHistory(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
