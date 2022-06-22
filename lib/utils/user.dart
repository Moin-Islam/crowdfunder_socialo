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
      name: json['USER_DATA'][0]["name"],
      email_address: json['USER_DATA'][0]['email_address'],
      purpose: json['USER_DATA'][0]['purpose'],
      profile_image: json['USER_DATA'][0]['profile_image'],
      invitation_code: json['USER_DATA'][0]['invitation_code'],
    );
  }
}
