// lib/models/item.dart

class Item {
  final String id;
  final String name;
  final String? icon;

  Item({
    required this.id,
    required this.name,
    this.icon,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }
}
