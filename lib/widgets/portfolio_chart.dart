import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_tracker/models/asset.dart';
import 'package:crypto_tracker/services/database.dart';
import 'package:crypto_tracker/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:crypto_tracker/constants/helper.dart';
import 'package:pie_chart/pie_chart.dart';

class PortfolioChart extends StatefulWidget {
  const PortfolioChart({Key key}) : super(key: key);

  @override
  _PortfolioChartState createState() => _PortfolioChartState();
}

class _PortfolioChartState extends State<PortfolioChart> {
  Map<String, double> assetPrices = {};
  void initAssetPrice() async {
    List<dynamic> cryptos = await fetchCrypto();
    assetPrices = {for (var crypto in cryptos) crypto.id: crypto.price};
  }

  @override
  void initState() {
    initAssetPrice();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colorList = [
      Colors.blueAccent,
      Colors.redAccent,
      Colors.orangeAccent,
      Colors.pinkAccent,
      Colors.lightBlueAccent,
      Colors.deepPurpleAccent,
      Colors.greenAccent,
      Colors.deepOrangeAccent,
      Colors.indigoAccent,
      Colors.tealAccent,
      Colors.lightGreenAccent,
      Colors.cyanAccent,
      Colors.limeAccent,
      Colors.purpleAccent,
    ];

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

          List<Asset> assets = snapshotData.entries
              .map((entry) => Asset(primaryAsset: entry.key, amount: entry.value))
              .where((asset) => asset.amount > 0)
              .toList();

          final _unsortedPortfolioData = {
            for (Asset asset in assets)
              '${asset.amount.toStringAsFixed(2)} ${asset.primaryAsset}': asset.amount * assetPrices[asset.primaryAsset]
          };

          Map<String, double> portfolioData = SplayTreeMap.from(_unsortedPortfolioData,
              (key1, key2) => _unsortedPortfolioData[key2].compareTo(_unsortedPortfolioData[key1]));

          return PieChart(
            dataMap: portfolioData.isNotEmpty ? portfolioData : {'(No data)': 0},
            animationDuration: Duration(milliseconds: 800),
            colorList: portfolioData.isNotEmpty ? colorList : [Colors.grey],
            chartType: ChartType.ring,
            chartValuesOptions: ChartValuesOptions(
              showChartValuesInPercentage: true,
            ),
          );
        }

        return Loader();
      },
    );
  }
}
