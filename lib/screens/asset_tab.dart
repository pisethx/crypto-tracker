import 'package:crypto_tracker/widgets/crypto_tile.dart';
import 'package:crypto_tracker/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:crypto_tracker/widgets/search_bar.dart';
import 'package:crypto_tracker/constants/style.dart';
import 'package:crypto_tracker/models/crypto.dart';
import 'package:crypto_tracker/constants/helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AssetTab extends StatefulWidget {
  final bool isDense;
  final Function onTap;
  AssetTab({Key key, this.onTap, this.isDense = false}) : super(key: key);

  @override
  _AssetTabState createState() => _AssetTabState();
}

class _AssetTabState extends State<AssetTab> {
  Future<List<Crypto>> _cryptoCurrencies;

  @override
  void initState() {
    super.initState();

    _cryptoCurrencies = fetchCrypto();
  }

  void _setCrypto([String keyword = '']) {
    setState(() {
      _cryptoCurrencies = fetchCrypto(keyword);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _horizontalPadding = widget.isDense ? 10.0 : 20.0;

    RefreshController _refreshController = RefreshController(initialRefresh: false);

    void _onLoading() async {
      _refreshController.loadComplete();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: _horizontalPadding, vertical: 8.0),
          child: SearchBar(
            width: MediaQuery.of(context).size.width - (45 + _horizontalPadding * 2),
            isToggable: !widget.isDense,
            onChanged: _setCrypto,
            onCleared: _setCrypto,
          ),
        ),
        Expanded(
          child: Container(
            child: FutureBuilder<List<Crypto>>(
              future: _cryptoCurrencies,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) return Loader();

                if (snapshot.hasError) return Text("Error fetching data.");

                return SmartRefresher(
                  header: WaterDropHeader(waterDropColor: kPrimaryColor),
                  controller: _refreshController,
                  onRefresh: () {
                    _cryptoCurrencies = fetchCrypto('', true);

                    setState(() {});
                    // if failed,use refreshFailed()
                    _refreshController.refreshCompleted();
                  },
                  onLoading: _onLoading,
                  child: _buildCryptoList(snapshot),
                );

                // By default, show a loading spinner.
              },
            ),
          ),
        )
      ],
    );
  }

  ListView _buildCryptoList(AsyncSnapshot<List<Crypto>> snapshot) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        return CryptoTile(item: snapshot.data[index], onTap: widget.onTap);
      },
    );
  }
}
