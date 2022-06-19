class User {
  final String name;
  final String email_address;
  final String purpose;
  final String profile_image;
  final String invitation_code;

  const User(
      {this.name,
      this.email_address,
      this.purpose,
      this.profile_image,
      this.invitation_code});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email_address: json['email_address'],
      purpose: json['purpose'],
      profile_image: json['profile_image'],
      invitation_code: json['invitation_code'],
    );
  }
}
