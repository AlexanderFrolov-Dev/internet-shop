class Product {
  final String name;
  final String description;
  final String imageUrl;
  final int price;

  Product({required this.name, required this.description, required this.imageUrl, required this.price});

  // Создаем фабрический конструктор для удобного парсинга данных из json
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      price: json['price'],
    );
  }
}
