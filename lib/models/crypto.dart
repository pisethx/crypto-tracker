class Crypto {
  String id;
  String name;
  String logo;
  double marketCap;
  double price;
  String priceChangePercentage;

  Crypto({this.id, this.name, this.logo, this.marketCap, this.price, this.priceChangePercentage});

  factory Crypto.fromJson(Map<String, dynamic> json) => Crypto(
        id: json["id"],
        name: json["name"],
        logo: json["logo_url"],
        marketCap: double.tryParse(json["market_cap"] ?? '0'),
        price: double.tryParse(json["price"] ?? '0'),
        priceChangePercentage: (double.tryParse(json["1d"]["price_change_pct"] ?? '0') * 100).toStringAsFixed(2),
      );
}
