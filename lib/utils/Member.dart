class Member {
  final String name;
  final String id;

  const Member({
    this.name,
    this.id,
  });

  static Member fromJson(json) {
    return Member(
      name: json["user_name"],
      id: json['user_id'],
    );
  }
}
