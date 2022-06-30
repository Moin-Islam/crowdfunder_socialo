class Member {
  final String name;
  final String id;
  final String saleId;
  final String publishableKey;
  final String productPrice;

  const Member(
      {this.name,
      this.id,
      this.saleId,
      this.publishableKey,
      this.productPrice});

  static Member fromJson(json) {
    return Member(
        name: json["user_name"],
        id: json['user_id'],
        saleId: json['saleId'],
        publishableKey: json['publishable_key'],
        productPrice: json["product_price"]);
  }
}
