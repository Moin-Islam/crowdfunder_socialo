class Stripe {
  final String name;
  final String email_address;

  const Stripe({
    this.name,
    this.email_address,
  });

  factory Stripe.fromJson(Map<String, dynamic> json) {
    return Stripe(
      name: json['USER_DATA'][0]["name"],
      email_address: json['USER_DATA'][0]['email_address'],
    );
  }
}
