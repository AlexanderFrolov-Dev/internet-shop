class Product {
  final int id;
  final String name;
  final String description;
  final String image;
  final double price;
  int quantity = 0;

  Product({required this.id, required this.name, required this.description, required this.image, required this.price});

  // Создаем фабрический конструктор для удобного парсинга данных из json
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      price: json['price'],
    );
  }
}
