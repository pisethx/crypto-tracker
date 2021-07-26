import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_tracker/constants/style.dart';
import 'package:crypto_tracker/models/asset.dart';
import 'package:crypto_tracker/services/database.dart';
import 'package:crypto_tracker/widgets/loader.dart';
import 'package:crypto_tracker/widgets/network_picture.dart';
import 'package:flutter/material.dart';
import 'package:crypto_tracker/constants/helper.dart';

class PortfolioCard extends StatefulWidget {
  const PortfolioCard({Key key}) : super(key: key);

  @override
  _PortfolioCardState createState() => _PortfolioCardState();
}

class _PortfolioCardState extends State<PortfolioCard> {
  Map<String, double> assetPrices = {};
  Map<String, String> assetLogos = {};
  void initAssetPrice() async {
    List<dynamic> cryptos = await fetchCrypto();
    assetPrices = {for (var crypto in cryptos) crypto.id: crypto.price};
    assetLogos = {for (var crypto in cryptos) crypto.id: crypto.logo};
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

          for (var qShot in snapshot.data.docs) {
            var transaction = qShot.data() as Map<String, dynamic>;
            if (snapshotData[transaction['asset']] == null) snapshotData[transaction['asset']] = 0;
            snapshotData[transaction['asset']] += transaction['amount'];
          }

          List<Asset> assets =
              snapshotData.entries.map((entry) => Asset(primaryAsset: entry.key, amount: entry.value)).toList();

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: assets.length,
            itemBuilder: (context, index) {
              Asset asset = assets[index];
              String primaryAsset = asset.primaryAsset;
              String secondaryAsset = asset.secondaryAsset;
              double amount = asset.amount;
              String logo = assetLogos[primaryAsset];
              double assetPrice = amount * assetPrices[primaryAsset];

              return Container(
                padding: EdgeInsets.all(14.0),
                margin: EdgeInsets.only(right: kScreenPaddingPx),
                width: 190.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          child: NetworkPicture(url: logo, radius: 20.0),
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.transparent,
                          radius: 20.0,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          primaryAsset,
                          style: kButtonTextStyle.copyWith(color: kGrayColor),
                        ),
                        Text(
                          '/' + secondaryAsset,
                          style: kButtonTextStyle.copyWith(color: kLightGrayColor),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      'Portfolio',
                      style: TextStyle(color: kLightGrayColor, fontSize: 12.0),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatCurrency(amount: assetPrice),
                          style: kSubtitleAmountStyle.copyWith(color: kGrayColor),
                        ),
                        SizedBox(height: 2.0),
                        Text(
                          '${formatNumber(amount: amount)} $primaryAsset',
                          style: kCaptionTextStyle,
                        ),
                      ],
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
