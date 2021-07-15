import 'package:flutter/material.dart';
import 'package:crypto_tracker/constants/style.dart';

class Asset {
  String primaryAsset;
  String secondaryAsset;
  double amount;
  double percentageChange;
  String logoUrl;

  Text get formattedPercentageChange {
    String sign;
    Color color;

    if (percentageChange > 0) {
      sign = '+';
      color = kIncomeColor;
    } else {
      sign = '-';
      color = kExpenseColor;
    }

    return Text('$sign$percentageChange%', style: TextStyle(fontWeight: FontWeight.bold, color: color));
  }

  Asset({@required String primaryAsset, String secondaryAsset = 'USDT', @required double amount}) {
    this.primaryAsset = primaryAsset;
    this.secondaryAsset = secondaryAsset;
    this.amount = amount;

    this.logoUrl =
        'https://s3.us-east-2.amazonaws.com/nomics-api/static/images/currencies/${primaryAsset.toLowerCase()}.svg';
  }
}
