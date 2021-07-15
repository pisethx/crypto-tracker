import 'package:crypto_tracker/services/auth.dart';
import 'package:crypto_tracker/widgets/network_picture.dart';
import 'package:flutter/material.dart';
import 'package:crypto_tracker/models/asset.dart';
import 'package:crypto_tracker/models/transaction.dart';
import 'package:crypto_tracker/models/transaction_history.dart';
import 'package:crypto_tracker/widgets/transaction_card.dart';
import 'package:crypto_tracker/constants/enum.dart' as Enum;
import 'package:crypto_tracker/constants/style.dart';
import 'package:crypto_tracker/constants/helper.dart';
import 'package:intl/intl.dart';
import 'package:crypto_tracker/widgets/speed_dial.dart';
import 'package:crypto_tracker/screens/asset_tab.dart';

class HomeTab extends StatefulWidget {
  final double currentBalance = 69420.69;

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Widget _buildUserProfile() => Container(
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
            radius: 30.0,
            backgroundImage: NetworkImage(AuthService.currentUser.photoURL),
          ),
          // Container(
          //   height: 60,
          //   width: 60,
          //   decoration: BoxDecoration(
          //     color: Theme.of(context).primaryColor,
          //     borderRadius: BorderRadius.all(
          //       Radius.circular(18.0),
          //     ),
          //     image: DecorationImage(
          //         fit: BoxFit.cover,
          //         image: NetworkImage("https://static.coindesk.com/wp-content/uploads/2021/04/dogecoin.jpg")),
          //   ),
          // ),
        ],
      ));

  Widget _buildCurrentBalance({double balance, double monthlyProfitPercentage = 10, double monthlyProfit = 12484}) =>
      Container(
        height: 200.0,
        margin: EdgeInsets.symmetric(horizontal: kScreenPaddingPx, vertical: 20.0),
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
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
            SizedBox(height: 24.0),
            Text('Monthly Profit', style: TextStyle(color: Colors.white, fontSize: 12.0)),
            SizedBox(height: 2.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  formatCurrency(amount: monthlyProfit),
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
                        Icon(Icons.arrow_drop_up, size: 20.0, color: kExpenseColor),
                        SizedBox(width: 2.0),
                        Text(
                            '${monthlyProfitPercentage < 0 ? '-' : '+'}${monthlyProfitPercentage.toStringAsPrecision(2)}%',
                            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                      ],
                    ))
              ],
            )
          ],
        ),
      );

  Widget _buildPortfolio(Enum.TransactionType type) => Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: kScreenPaddingPx),
            child: Text('My Portfolio', style: kSubtitleTextStyle),
          ),
          _buildAssetCard(type)
        ],
      ));

  Widget _buildAssetCard(Enum.TransactionType type) {
    List<Asset> assets = [
      Asset(primaryAsset: 'BTC', amount: 1200),
      Asset(primaryAsset: 'BTC', amount: 1200),
      Asset(primaryAsset: 'BTC', amount: 1200),
      Asset(primaryAsset: 'BTC', amount: 1200),
      Asset(primaryAsset: 'BTC', amount: 1200),
      Asset(primaryAsset: 'BTC', amount: 1200),
      Asset(primaryAsset: 'BTC', amount: 1200),
    ];

    return Column(children: [
      Container(
        height: 160.0,
        padding: EdgeInsets.all(5.0),
        child: ListView.builder(
            itemCount: assets.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.all(14.0),
                margin: EdgeInsets.only(left: kScreenPaddingPx, top: 12.0),
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
                          child: NetworkPicture(url: assets[index].logoUrl, radius: 20.0),
                          backgroundColor: kPrimaryColor,
                          foregroundColor: Colors.white,
                          radius: 20.0,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          assets[index].primaryAsset,
                          style: kButtonTextStyle.copyWith(color: kGrayColor),
                        ),
                        Text(
                          '/' + assets[index].secondaryAsset,
                          style: kButtonTextStyle.copyWith(color: kLightGrayColor),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      'Portfolio',
                      style: TextStyle(color: kLightGrayColor, fontSize: 12.0),
                    ),
                    Row(
                      children: [
                        Text(
                          formatCurrency(amount: assets[index].amount),
                          style: kSubtitleAmountStyle.copyWith(color: kGrayColor),
                        ),
                        // SizedBox(height: 5.0),
                        // Text(
                        //   DateFormat('dd-MM-yyyy').format(transactions[index].datetime),
                        //   style: TextStyle(fontSize: 12.0, color: kGrayColor),
                        // ),
                      ],
                    )
                  ],
                ),
              );
            }),
      ),
    ]);
  }

  Widget _buildTransactionCards() => Container(
        margin: kScreenMargin.copyWith(top: 16.0),
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 30.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: kBoxShadowLg,
          borderRadius: BorderRadius.all(Radius.circular(18.0)),
        ),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TransactionCard(
                transaction: Transaction(type: Enum.TransactionType.Income, amount: 1200),
              ),
              VerticalDivider(
                width: 20.0,
                color: Colors.grey,
              ),
              TransactionCard(
                transaction: Transaction(type: Enum.TransactionType.Expense, amount: 1200),
              ),
            ],
          ),
        ),
      );

  Widget _buildTransactionHistory(Enum.TransactionType type) {
    String title;
    List<TransactionHistory> transactions = [
      TransactionHistory(title: 'Bitcoin', amount: 1200, type: type),
      TransactionHistory(title: 'Bitcoin', amount: 1200, type: type),
      TransactionHistory(title: 'Bitcoin', amount: 1200, type: type),
      TransactionHistory(title: 'Bitcoin', amount: 1200, type: type),
      TransactionHistory(title: 'Bitcoin', amount: 1200, type: type),
      TransactionHistory(title: 'Bitcoin', amount: 1200, type: type),
      TransactionHistory(title: 'Bitcoin', amount: 1200, type: type),
    ];

    if (type == Enum.TransactionType.Income) title = 'Sell';
    if (type == Enum.TransactionType.Expense) title = 'Buy';

    return Column(children: [
      Padding(
        padding: kScreenMargin.copyWith(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => {},
              child: Text(
                'See all',
                style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(visualDensity: VisualDensity.compact),
            )
          ],
        ),
      ),
      Container(
        height: 110.0,
        margin: EdgeInsets.only(bottom: 20.0),
        child: ListView.builder(
            itemCount: transactions.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                margin: kScreenMargin.copyWith(top: 12.0, bottom: 12.0, right: 0.0),
                width: 340.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: kBoxShadowSm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: transactions[index].iconColor,
                          foregroundColor: Colors.white,
                          child: transactions[index].icon,
                          radius: 30.0,
                        ),
                        SizedBox(width: 14.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transactions[index].title,
                              style: kButtonTextStyle.copyWith(color: kGrayColor),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              DateFormat('dd-MM-yyyy').format(transactions[index].datetime),
                              style: TextStyle(fontSize: 12.0, color: kGrayColor),
                            ),
                          ],
                        )
                      ],
                    ),
                    transactions[index].formattedAmount
                  ],
                ),
              );
            }),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    Future<dynamic> _showAddAsset(String type) {
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
                  child: Text(
                    'Add Transaction',
                    style: kPrimaryTextStyle.copyWith(fontSize: 20.0),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 200.0,
                    maxHeight: MediaQuery.of(context).size.height - 200,
                  ),
                  child: AssetTab(isDense: true),
                )
              ],
            );
          });
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildUserProfile(),
          _buildCurrentBalance(balance: widget.currentBalance),
          Container(
            child: Column(
              children: [
                _buildPortfolio(Enum.TransactionType.Income),
                // _buildTransactionCards(),
                // _buildTransactionHistory(Enum.TransactionType.Income),
                // _buildTransactionHistory(Enum.TransactionType.Expense),
              ],
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //     child: Icon(Icons.add),
      //     backgroundColor: kPrimaryColor,
      //     foregroundColor: Colors.white,
      //     onPressed: () {

      //     }),
      floatingActionButton: SpeedDialFabWidget(
        secondaryIconsList: [
          Icons.north_east,
          Icons.south_east,
        ],
        secondaryIconsText: [
          "BUY",
          "SELL",
        ],
        secondaryIconsOnPress: [
          () => _showAddAsset('buy'),
          () => _showAddAsset('sell'),
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
