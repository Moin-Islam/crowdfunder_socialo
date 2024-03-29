class Product {
  final String productID;
  final String saleCount;
  final String productURL;
  final String productPrice;
  final String productName;
  final String productDescription;

  const Product(
      {this.productID,
      this.productName,
      this.productURL,
      this.productPrice,
      this.saleCount,
      this.productDescription});

  static Product fromJson(json) {
    return Product(
        productID: json["product_id"],
        productName: json['product_name'],
        productURL: json['product_url'],
        productPrice: json['product_price'],
        saleCount: json["sale_count"],
        productDescription: json["product_description"]);
  }
}
