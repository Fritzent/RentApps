class Account {
  final String uid;
  final String email;
  String name;
  Account({
    required this.uid,
    required this.email,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'name': name,
    };
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      uid: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
    );
  }
}
