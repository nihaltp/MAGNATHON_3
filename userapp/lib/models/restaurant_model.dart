class RestaurantModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory RestaurantModel.fromMap(Map<String, dynamic> map) {
    return RestaurantModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
