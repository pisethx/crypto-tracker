import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:crypto_tracker/constants/style.dart';

class Asset {
  String primaryAsset;
  String secondaryAsset;
  double amount;
  double percentageChange;
  Timestamp created;
  String docId;

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

  Asset(
      {@required String primaryAsset,
      String secondaryAsset = 'USDT',
      Timestamp created,
      String docId,
      @required double amount}) {
    this.primaryAsset = primaryAsset;
    this.secondaryAsset = secondaryAsset;
    this.amount = amount;
    this.created = created;
    this.docId = docId;
  }

  Asset.fromJson(Map<String, dynamic> json)
      : primaryAsset = json['primaryAsset'],
        secondaryAsset = json['secondaryAsset'],
        amount = json['amount'],
        created = json['created'];

  Map<String, dynamic> toJson() {
    return {
      'primaryAsset': this.primaryAsset,
      'secondaryAsset': this.secondaryAsset,
      'amount': this.amount,
      'created': this.created
    };
  }
}
