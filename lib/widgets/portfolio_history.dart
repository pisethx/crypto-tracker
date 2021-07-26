import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_tracker/constants/style.dart';
import 'package:crypto_tracker/models/asset.dart';
import 'package:crypto_tracker/screens/home_tab.dart';
import 'package:crypto_tracker/services/database.dart';
import 'package:crypto_tracker/widgets/loader.dart';
import 'package:crypto_tracker/widgets/network_picture.dart';
import 'package:crypto_tracker/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:crypto_tracker/constants/helper.dart';
import 'package:intl/intl.dart';

String formatTransactionAmount({double amount, String asset}) {
  return '${amount < 0 ? '-' : '+'}${formatNumber(amount: amount.abs())} $asset';
}

class PortfolioHistory extends StatefulWidget {
  const PortfolioHistory({Key key}) : super(key: key);

  @override
  _PortfolioHistoryState createState() => _PortfolioHistoryState();
}

class _PortfolioHistoryState extends State<PortfolioHistory> {
  Map<String, double> assetPrices = {};
  Map<String, String> assetNames = {};
  Map<String, String> assetLogos = {};

  void initAssetPrice() async {
    List<dynamic> cryptos = await fetchCrypto();
    assetPrices = {for (var crypto in cryptos) crypto.id: crypto.price};
    assetNames = {for (var crypto in cryptos) crypto.id: crypto.name};
    assetLogos = {for (var crypto in cryptos) crypto.id: crypto.logo};
  }

  @override
  void initState() {
    initAssetPrice();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<dynamic> _showTransactionInfo(Asset asset) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(('Transaction Detail'), style: kPrimaryTextStyle.copyWith(fontSize: 20.0)),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTransactionInfoRow(
                            title: 'Type',
                            value: asset.amount > 0 ? TransactionType.BUY : TransactionType.SELL,
                            textColor: asset.amount < 0 ? kExpenseColor : kIncomeColor),
                        _buildTransactionInfoRow(
                          title: 'Date',
                          value: DateFormat('MMM d, y HH:mm a').format(
                            DateTime.tryParse(asset.created.toDate().toString()),
                          ),
                        ),
                        _buildTransactionInfoRow(
                            title: 'Quantity',
                            value: formatTransactionAmount(amount: asset.amount, asset: asset.primaryAsset),
                            textColor: asset.amount < 0 ? kExpenseColor : kIncomeColor),
                        Container(
                          margin: EdgeInsets.only(top: 60.0),
                          child: PrimaryButton(
                            onPressed: () {
                              Database.deleteItem(docId: asset.docId);
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.delete),
                            label: 'Remove Transaction',
                          ),
                        )
                      ],
                    )),
              ],
            ),
          );
        },
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: Database.readItems(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Something went wrong');

        if (snapshot.hasData || snapshot.data != null) {
          List<Asset> assets = snapshot.data.docs.map((qShot) {
            var transaction = qShot.data() as Map<String, dynamic>;
            return Asset(
                primaryAsset: transaction['asset'],
                amount: transaction['amount'].toDouble(),
                created: transaction['created'],
                docId: qShot.id);
          }).toList();

          return ListView.builder(
            itemCount: assets.length,
            itemBuilder: (context, index) {
              Asset asset = assets[index];
              String primaryAsset = asset.primaryAsset;
              // String secondaryAsset = asset.secondaryAsset;
              String name = assetNames[asset.primaryAsset];
              double amount = asset.amount;
              String logo = assetLogos[primaryAsset];
              double assetPrice = amount * assetPrices[primaryAsset];

              return ListTile(
                onTap: () => _showTransactionInfo(asset),
                contentPadding: EdgeInsets.all(4.0),
                leading: CircleAvatar(
                  child: NetworkPicture(url: logo, radius: 18.0),
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.transparent,
                  radius: 18.0,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(color: kDarkGrayColor),
                    ),
                    SizedBox(height: 3),
                    Text(primaryAsset, style: kCaptionTextStyle.copyWith(color: kGrayColor)),
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatCurrency(amount: assetPrice),
                      style: kContentTextStyle,
                    ),
                    SizedBox(height: 3),
                    Text(
                      formatTransactionAmount(amount: amount, asset: primaryAsset),
                      style: kCaptionTextStyle.copyWith(color: assetPrice > 0 ? kIncomeColor : kExpenseColor),
                    )
                  ],
                ),
              );
            },
          );
        }

        return Loader();
      },
    );
  }
}

Widget _buildTransactionInfoRow({String title, dynamic value, Color textColor}) {
  var textValue = value;

  if (value is double) textValue = value > 0 ? formatNumber(amount: value) : '-';

  return Padding(
    padding: const EdgeInsets.only(top: 20.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: kContentTextStyle.copyWith(fontWeight: FontWeight.bold)),
        Text(
          textValue,
          style: kContentTextStyle.copyWith(color: textColor),
        ),
      ],
    ),
  );
}
