import 'package:crypto_tracker/constants/helper.dart';
import 'package:flutter/material.dart';
import 'package:crypto_tracker/constants/enum.dart' as Enum;
import 'package:crypto_tracker/constants/style.dart';

class Transaction {
  String title;
  double amount;
  double amountChanges;
  Color color;
  Enum.TransactionType type;

  String get amountDayChange {
    String sign;
    if (this.type == Enum.TransactionType.Income) {
      sign = '+';
    }

    if (this.type == Enum.TransactionType.Expense) {
      sign = '-';
    }

    return '$sign ${formatCurrency(amount: 69)} (10%)';
  }

  Transaction({@required Enum.TransactionType type, @required double amount}) {
    this.amount = amount;
    this.type = type;

    if (type == Enum.TransactionType.Income) {
      this.title = 'Profit';
      this.color = kIncomeColor;
    }

    if (type == Enum.TransactionType.Expense) {
      this.title = 'Loss';
      this.color = kExpenseColor;
    }
  }
}
