import 'package:crypto_tracker/models/crypto.dart';
import 'package:crypto_tracker/services/auth.dart';
import 'package:crypto_tracker/services/database.dart';
import 'package:crypto_tracker/widgets/balance_card.dart';
import 'package:crypto_tracker/widgets/network_picture.dart';
import 'package:crypto_tracker/widgets/numeric_text_field.dart';
import 'package:crypto_tracker/widgets/outlined_text_field.dart';
import 'package:crypto_tracker/widgets/portfolio_card.dart';
import 'package:crypto_tracker/widgets/primary_button.dart';
import 'package:crypto_tracker/widgets/user_asset_list.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:crypto_tracker/constants/style.dart';
import 'package:crypto_tracker/constants/helper.dart';
import 'package:crypto_tracker/widgets/speed_dial.dart';
import 'package:crypto_tracker/screens/asset_tab.dart';
import 'package:crypto_tracker/widgets/pop_back_button.dart';

class TransactionType {
  static String get BUY {
    return 'Buy';
  }

  static String get SELL {
    return 'Sell';
  }
}

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _modalBottomSheetHeight = MediaQuery.of(context).size.height - 200;
    double amount;
    double pricePerAsset = 0;

    _onAddTransaction({Crypto crypto, double amount, double pricePerAsset}) async {
      await Database.addItem(asset: crypto.id, amount: amount, price: pricePerAsset);

      Navigator.of(context).pop();
      Timer(Duration(milliseconds: 100), () => Navigator.of(context).pop());
    }

    Widget _buildPortfolio() {
      return Container(
        margin: EdgeInsets.only(left: kScreenPaddingPx, right: kScreenPaddingPx, top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Portfolio', style: kSubtitleTextStyle),
            Container(
                height: 160.0, margin: EdgeInsets.only(top: 20.0), padding: EdgeInsets.all(5.0), child: PortfolioCard())
          ],
        ),
      );
    }

    Future<dynamic> _showAddTransaction(Crypto crypto, String type) {
      pricePerAsset = crypto.price;
      bool _isLoading = false;

      return showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      PopBackButton(),
                      NetworkPicture(url: crypto.logo, radius: 13),
                      SizedBox(width: 10),
                      Text(
                        '$type ${formatCryptoName(crypto)}',
                        style: kPrimaryTextStyle.copyWith(fontSize: 20.0),
                      ),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: _modalBottomSheetHeight,
                    maxHeight: _modalBottomSheetHeight,
                  ),
                  child: Padding(
                    padding: kScreenPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            NumericTextField(
                              initialValue: amount,
                              suffixText: crypto.id,
                              height: 60,
                              onChanged: (val) {
                                amount = double.tryParse(val);
                              },
                            )
                          ],
                        ),
                        OutlinedTextField(
                          initialValue: num.parse(pricePerAsset.toStringAsFixed(2)),
                          keyboardType: TextInputType.number,
                          labelText: 'Price per coin',
                          onChanged: (val) {
                            pricePerAsset = double.tryParse(val);
                          },
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: PrimaryButton(
                              loading: _isLoading,
                              label: 'Add Transaction',
                              onPressed: () {
                                if (amount <= 0 || pricePerAsset < 0) return;

                                // Cannot sell more than you own
                                if (type == TransactionType.SELL && amount > crypto.assetAmount) return;

                                setState(() {
                                  _isLoading = true;
                                });

                                _onAddTransaction(
                                  crypto: crypto,
                                  amount: amount * (type == TransactionType.SELL ? -1 : 1),
                                  pricePerAsset: pricePerAsset,
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          });
    }

    Future<dynamic> _showSelectAsset(String type) {
      return showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      PopBackButton(),
                      Text(
                        type == TransactionType.BUY ? 'Buy' : 'Sell',
                        style: kPrimaryTextStyle.copyWith(fontSize: 20.0),
                      ),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: _modalBottomSheetHeight,
                    maxHeight: _modalBottomSheetHeight,
                  ),
                  child: type == TransactionType.BUY
                      ? AssetTab(
                          isDense: true,
                          onTap: (Crypto crypto) {
                            _showAddTransaction(crypto, type);
                          },
                        )
                      : UserAssetList(
                          onTap: (Crypto crypto) {
                            _showAddTransaction(crypto, type);
                          },
                        ),
                )
              ],
            );
          });
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UserProfile(),
          BalanceCard(),
          Container(
            child: Column(
              children: [_buildPortfolio()],
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDialFabWidget(
        secondaryIconsList: [
          Icons.north_east,
          Icons.south_east,
        ],
        secondaryIconsText: [
          TransactionType.BUY.toUpperCase(),
          TransactionType.SELL.toUpperCase(),
        ],
        secondaryIconsOnPress: [
          () => _showSelectAsset(TransactionType.BUY),
          () => _showSelectAsset(TransactionType.SELL),
        ],
        secondaryBackgroundColor: Theme.of(context).primaryColor,
        secondaryForegroundColor: Colors.white,
        primaryBackgroundColor: Theme.of(context).primaryColor,
        primaryForegroundColor: Colors.white,
        primaryIconExpand: Icons.add,
        primaryIconCollapse: Icons.add,
        rotateAngle: 0.8,
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kScreenPaddingPx),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome', style: TextStyle(color: kGrayColor, fontSize: 18.0)),
              Text(AuthService.currentUser.displayName,
                  style: TextStyle(color: kDarkGrayColor, fontSize: 24.0, fontWeight: FontWeight.bold)),
            ],
          ),
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(AuthService.currentUser.photoURL),
          )
        ],
      ),
    );
  }
}
