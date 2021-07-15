import 'package:flutter/material.dart';
import 'package:crypto_tracker/constants/enum.dart' as Enum;
import 'package:crypto_tracker/constants/style.dart';
import 'package:crypto_tracker/constants/helper.dart';

class TransactionHistory {
  String title;
  double amount;
  DateTime datetime;
  Color iconColor;
  Icon icon;
  Enum.TransactionType type;

  Map<String, dynamic> _getIcon(String title) {
    return {
      'icon': Icon(Icons.attach_money),
      'iconColor': kPrimaryColor,
    };
  }

  Text get formattedAmount {
    String sign;
    Color color;

    switch (type) {
      case Enum.TransactionType.Income:
        sign = '+';
        color = kIncomeColor;
        break;
      case Enum.TransactionType.Expense:
        sign = '-';
        color = kExpenseColor;
        break;
    }

    return Text('$sign ${formatCurrency(amount: amount)}', style: TextStyle(fontWeight: FontWeight.bold, color: color));
  }

  TransactionHistory({@required String title, @required double amount, @required Enum.TransactionType type}) {
    this.title = title;
    this.amount = amount;
    this.type = type;
    this.datetime = DateTime.now();

    this.icon = this._getIcon(title)['icon'];
    this.iconColor = this._getIcon(title)['iconColor'];
  }
}
