// ignore_for_file: public_member_api_docs, sort_constructors_first

class Bike {
  final String id;
  final String about;
  final String category;
  final String image;
  final String level;
  final String name;
  final String release;
  final num price;
  final num rating;
  Bike({
    required this.id,
    required this.about,
    required this.category,
    required this.image,
    required this.level,
    required this.name,
    required this.release,
    required this.price,
    required this.rating,
  });

  factory Bike.fromJson(Map<String, dynamic> json) {
    return Bike(
      id: json['id'] as String,
      about: json['about'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      level: json['level'] as String,
      name: json['name'] as String,
      release: json['release'] as String,
      price: json['price'] as num,
      rating: json['rating'] as num,
    );
  } 

  static Bike get empty => Bike(
    id: '', 
    about: '', 
    category: '', 
    image: '', 
    level: '', 
    name: '', 
    release: '', 
    price: 0, 
    rating: 0);
}
