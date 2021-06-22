class User {
  final String uid;
  final String name;
  final String email;
  final String about;
  final String profilePic;
  final List<String> savedVenturesList;

  User({
    this.uid,
    this.name,
    this.email,
    this.about,
    this.profilePic,
    this.savedVenturesList,
  });

  User.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        email = json['email'],
        about = json['about'],
        profilePic = json['profilePic'],
        savedVenturesList = json['savedVenturesList'];
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'about': about,
      'profilePic': profilePic,
      'savedVenturesList': savedVenturesList,
    };
  }
}
