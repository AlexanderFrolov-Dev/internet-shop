class CartInfo {
  final int userId;
  final int productId;
  final int quantity;

  CartInfo(this.userId, this.productId, this.quantity);

  factory CartInfo.fromJson(Map<String, dynamic> json) {
    return CartInfo(
      json['user_id'],
      json['product_id'],
      json['quantity'],
    );
  }
}