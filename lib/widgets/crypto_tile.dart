import 'package:crypto_tracker/widgets/network_picture.dart';
import 'package:flutter/material.dart';
import 'package:crypto_tracker/constants/helper.dart';
import 'package:crypto_tracker/constants/style.dart';

class CryptoTile extends StatefulWidget {
  final Function onTap;
  final dynamic item;

  CryptoTile({Key key, this.onTap, this.item}) : super(key: key);

  @override
  _CryptoTileState createState() => _CryptoTileState();
}

class _CryptoTileState extends State<CryptoTile> {
  @override
  Widget build(BuildContext context) {
    String logo = widget.item.logo;
    String name = widget.item.name;
    String id = widget.item.id;
    double rank = widget.item.rank;
    double price = widget.item.price;
    String priceChangePercentage = widget.item.priceChangePercentage;

    return ListTile(
      onTap: () => widget.onTap(widget.item),
      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 20.0,
        child: NetworkPicture(
          url: logo,
          radius: 20.0,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(color: kDarkGrayColor),
          ),
          SizedBox(height: 3.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                id,
                style: TextStyle(color: kGrayColor, fontSize: 14.0),
              ),
              Container(
                margin: EdgeInsets.only(left: 6),
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                decoration: BoxDecoration(
                    color: kGrayColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    )),
                child: Text(
                  rank.toStringAsFixed(0),
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10.0),
                ),
              ),
            ],
          )
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formatCurrency(amount: price),
            textAlign: TextAlign.right,
            style: TextStyle(color: kDarkGrayColor, fontSize: 16.0),
          ),
          SizedBox(height: 3.0),
          Text(
            formatPercentage(priceChangePercentage),
            textAlign: TextAlign.right,
            style: TextStyle(
              color: priceChangePercentage.startsWith('-') ? kExpenseColor : kIncomeColor,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
