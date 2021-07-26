class Crypto {
  double assetAmount = 0;
  String id;
  String name;
  String logo;
  double marketCap;
  double maxSupply;
  double circulatingSupply;
  double price;
  double rank;
  String priceChangePercentage;
  double lastMonthPriceChangePercentage;

  Crypto(
      {this.id,
      this.name,
      this.logo,
      this.marketCap,
      this.maxSupply,
      this.circulatingSupply,
      this.price,
      this.rank,
      this.priceChangePercentage,
      this.lastMonthPriceChangePercentage});

  factory Crypto.fromJson(Map<String, dynamic> json) {
    final String price = json["1d"] != null ? json["1d"]["price_change_pct"] : '0';
    final String lastMonthPriceChangePercentage = json["30d"] != null ? json["30d"]["price_change_pct"] : '0';

    return Crypto(
        id: json["id"],
        name: json["name"],
        logo: json["logo_url"],
        rank: double.tryParse(json["rank"]),
        maxSupply: double.tryParse(json["max_supply"] ?? '0'),
        circulatingSupply: double.tryParse(json["circulating_supply"] ?? '0'),
        marketCap: double.tryParse(json["market_cap"] ?? '0'),
        price: double.tryParse(json["price"] ?? '0'),
        priceChangePercentage: (double.tryParse(price) * 100).toStringAsFixed(2),
        lastMonthPriceChangePercentage: (double.tryParse(lastMonthPriceChangePercentage) * 100));
  }
}
