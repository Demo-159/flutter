class Product {
  final int id;
  final String name;
  final double price;
  final String image;
  final int stockQuantity;
  final String sku;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.stockQuantity,
    required this.sku,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Sin nombre',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      image: json['images']?.isNotEmpty == true ? json['images'][0]['src'] : '',
      stockQuantity: json['stock_quantity'] ?? 0,
      sku: json['sku'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'stock_quantity': stockQuantity,
      'sku': sku,
    };
  }
}
