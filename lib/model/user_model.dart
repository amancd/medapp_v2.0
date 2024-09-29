class UserModel {
  String name;
  String email;
  String bio;
  String date;
  String blood;
  String createdAt;
  String phoneNumber;
  String uid;
  String adhaar;

  UserModel({
    required this.name,
    required this.email,
    required this.bio,
    required this.date,
    required this.blood,
    required this.createdAt,
    required this.phoneNumber,
    required this.uid,
    required this.adhaar
  });

  // from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      date: map['date'] ?? '',
      bio: map['bio'] ?? '',
      uid: map['uid'] ?? '',
      blood: map['blood'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      createdAt: map['createdAt'] ?? '',
      adhaar: map['adhaar'] ?? '',
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "uid": uid,
      "bio": bio,
      "date": date,
      "blood": blood,
      "phoneNumber": phoneNumber,
      "createdAt": createdAt,
      "adhaar": adhaar,
    };
  }
}
