import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_tracker/constants/style.dart';
import 'package:crypto_tracker/services/database.dart';
import 'package:crypto_tracker/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:crypto_tracker/constants/helper.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({Key key}) : super(key: key);

  @override
  _BalanceCardState createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  Map<String, double> assetPrices = {};
  // Map<String, double> assetPrices30d = {};
  void initAssetPrice() async {
    List<dynamic> cryptos = await fetchCrypto();
    assetPrices = {for (var crypto in cryptos) crypto.id: crypto.price};
    // assetPrices30d = {
    //   for (var crypto in cryptos)
    //     crypto.id: ((crypto.lastMonthPriceChangePercentage / 100) * crypto.price) + crypto.price
    // };
  }

  @override
  void initState() {
    initAssetPrice();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Database.readItems(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Something went wrong');

        if (snapshot.hasData || snapshot.data != null) {
          Map<String, dynamic> snapshotData = {};
          Map<String, double> initialPrices = {};

          for (var qShot in snapshot.data.docs) {
            var transaction = qShot.data() as Map<String, dynamic>;
            if (snapshotData[transaction['asset']] == null) {
              snapshotData[transaction['asset']] = 0;
              initialPrices[transaction['asset']] = 0;
            }
            snapshotData[transaction['asset']] += transaction['amount'];
            initialPrices[transaction['asset']] += transaction['amount'] * transaction['price'];
          }
          // List<dynamic> snapshotData = snapshot.data.docs.map((qShot) => qShot.data()).toList();
          double balance = 0;
          double initialBalance = 0;
          double balanceChange = 0;
          double balanceChangePercentage = 0;

          for (MapEntry e in snapshotData.entries) {
            balance += e.value * assetPrices[e.key];
            initialBalance += initialPrices[e.key];
          }

          balanceChange = balance - initialBalance;
          balanceChangePercentage = balance == 0 ? 0 : balanceChange / balance;

          return Container(
            height: 200.0,
            margin: EdgeInsets.symmetric(horizontal: kScreenPaddingPx, vertical: 20.0),
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Balance', style: TextStyle(color: Colors.white, fontSize: 18.0)),
                SizedBox(height: 10.0),
                Text(
                  formatCurrency(amount: balance),
                  style: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                Text('Profit / Loss', style: TextStyle(color: Colors.white, fontSize: 12.0)),
                SizedBox(height: 2.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${balanceChange < 0 ? '-' : '+'} ${formatCurrency(amount: balanceChange.abs())}",
                      style: kSubtitleAmountStyle.copyWith(color: Colors.white),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          color: kLightGrayColor.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(35.0)),
                        ),
                        child: Row(
                          children: [
                            Icon(balanceChangePercentage < 0 ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                                size: 20.0, color: balanceChangePercentage < 0 ? kExpenseColor : kIncomeColor),
                            SizedBox(width: 2.0),
                            Text('${(balanceChangePercentage.abs() * 100).toStringAsFixed(2)} %',
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                          ],
                        ))
                  ],
                )
              ],
            ),
          );
        }

        return Loader();
      },
    );
  }
}
