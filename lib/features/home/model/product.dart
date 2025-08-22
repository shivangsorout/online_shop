class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final double rating;
  final String thumbnail;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.rating,
    required this.thumbnail,
  });

  // Factory constructor to create a Product object from JSON
  factory Product.fromJson(Map<dynamic, dynamic> json) {
    return Product(
      id: json[idKey],
      name: json[nameKey],
      description: json[descriptionKey],
      price: json[priceKey],
      rating: json[ratingKey],
      thumbnail: json[thumbnailKey],
    );
  }

  // Method to convert a Product object into json structure.
  Map<String, dynamic> toJson() {
    return {
      idKey: id,
      nameKey: name,
      descriptionKey: description,
      priceKey: price,
      ratingKey: rating,
      thumbnailKey: thumbnail,
    };
  }
}

// Keys constant for the product model
const String idKey = 'id';
const String nameKey = 'title';
const String descriptionKey = 'description';
const String priceKey = 'price';
const String ratingKey = 'rating';
const String thumbnailKey = 'thumbnail';
