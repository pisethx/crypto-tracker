import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_tracker/models/crypto.dart';
import 'package:crypto_tracker/services/database.dart';
import 'package:crypto_tracker/widgets/crypto_tile.dart';
import 'package:crypto_tracker/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:crypto_tracker/constants/helper.dart';

class UserAssetList extends StatefulWidget {
  final Function onTap;

  const UserAssetList({
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  _UserAssetList createState() => _UserAssetList();
}

class _UserAssetList extends State<UserAssetList> {
  List<Crypto> cryptos;
  Map<String, double> assetPrices = {};

  void initAssetPrice() async {
    cryptos = await fetchCrypto();
    assetPrices = {for (var crypto in cryptos) crypto.id: crypto.price};
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

          List<Crypto> assets = cryptos
              .toList()
              .where((crypto) => snapshotData[crypto.id] != null && snapshotData[crypto.id] > 0)
              .toList();

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: assets.length,
                  itemBuilder: (context, index) {
                    final asset = assets[index];
                    asset.assetAmount = snapshotData[asset.id];

                    return CryptoTile(item: asset, onTap: widget.onTap);
                  },
                ),
              )
            ],
          );
        }

        return Loader();
      },
    );
  }
}
