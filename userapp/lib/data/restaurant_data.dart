import 'package:userapp/models/restaurant_model.dart';

class RestaurantData {
  static const List<Map<String, String>> restaurants = [
    {
      'id': '1',
      'name': 'Restaurant 1',
      'description': 'Delicious Italian Cuisine',
      'icon': '🍝',
    },
    {
      'id': '2',
      'name': 'Restaurant 2',
      'description': 'Asian Fusion Experience',
      'icon': '🍜',
    },
    {
      'id': '3',
      'name': 'Restaurant 3',
      'description': 'Premium Steakhouse',
      'icon': '🥩',
    },
    {
      'id': '4',
      'name': 'Restaurant 4',
      'description': 'Mexican Street Food',
      'icon': '🌮',
    },
    {
      'id': '5',
      'name': 'Restaurant 5',
      'description': 'Mediterranean Delights',
      'icon': '🍆',
    },
  ];

  static List<RestaurantModel> getRestaurants() {
    return restaurants
        .map((r) => RestaurantModel(
              id: r['id']!,
              name: r['name']!,
              description: r['description']!,
              imageUrl: r['icon']!,
            ))
        .toList();
  }
}
