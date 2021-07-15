import 'package:flutter/material.dart';
import 'package:crypto_tracker/models/transaction.dart';
import 'package:crypto_tracker/constants/helper.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  TransactionCard({@required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          transaction.title,
          style: TextStyle(color: transaction.color, fontWeight: FontWeight.w800, fontSize: 14.0),
        ),
        SizedBox(height: 10.0),
        Text(
          formatCurrency(amount: transaction.amount),
          style: TextStyle(color: transaction.color, fontWeight: FontWeight.w800, fontSize: 18.0),
        ),
        SizedBox(height: 8.0),
        Text(
          transaction.amountDayChange,
          style: TextStyle(color: transaction.color, fontSize: 12.0),
        ),
        // TextButton.icon(
        //   onPressed: () => {},
        //   label: Text(transaction.buttonText),
        //   icon: Icon(Icons.add),
        //   style: TextButton.styleFrom(
        //     primary: Theme.of(context).primaryColor,
        //   ),
        // ),
      ],
    );
  }
}
