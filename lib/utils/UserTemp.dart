class User {
  final String name;
  final String image;

  const User({
    this.name,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['USER_DATA'][0]["name"],
      image: json['email_address'],
    );
  }
}
