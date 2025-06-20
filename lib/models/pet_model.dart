import 'package:hive/hive.dart';

part 'pet_model.g.dart';

@HiveType(typeId: 0)
class Pet {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int age;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final String imageUrl;

  @HiveField(5)
  bool isAdopted;

  @HiveField(6)
  bool isFavorited;

  Pet({
    required this.id,
    required this.name,
    required this.age,
    required this.price,
    required this.imageUrl,
    this.isAdopted = false,
    this.isFavorited = false,
  });

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
    id: json['id'],
    name: json['name'],
    age: json['age'],
    price: json['price'].toDouble(),
    imageUrl: json['imageUrl'],
    isAdopted: json['isAdopted'] ?? false,
    isFavorited: json['isFavorited'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'price': price,
    'imageUrl': imageUrl,
    'isAdopted': isAdopted,
    'isFavorited': isFavorited,
  };
}
