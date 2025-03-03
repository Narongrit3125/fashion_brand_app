// lib/models/brand_item.dart

class BrandItem {
  final int id;
  final String name;
  final String category;
  final DateTime date;
  final String imagePath;

  BrandItem({
    required this.id,
    required this.name,
    required this.category,
    required this.date,
    required this.imagePath,
  });

  // Convert a BrandItem to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'date': date.toIso8601String(),
      'imagePath': imagePath,
    };
  }

  // Create a BrandItem from a Map
  factory BrandItem.fromMap(Map<String, dynamic> map) {
    return BrandItem(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      date: DateTime.parse(map['date']),
      imagePath: map['imagePath'],
    );
  }
}