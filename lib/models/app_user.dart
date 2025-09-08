
class AppUser {
  final String uid;
  final String email;
  final String? name;

  AppUser({required this.uid, required this.email, this.name});

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }
}
