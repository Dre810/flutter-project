class AppUser {
  final String uid;
  final String email;
  final String role; // 'admin' or 'customer'

  AppUser({
    required this.uid,
    required this.email,
    required this.role,
  });

  // Convert Firestore document to AppUser
  factory AppUser.fromMap(Map<String, dynamic> data, String uid) {
    return AppUser(
      uid: uid,
      email: data['email'] ?? '',
      role: data['role'] ?? 'customer',
    );
  }

  // Convert AppUser to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role,
    };
  }
}