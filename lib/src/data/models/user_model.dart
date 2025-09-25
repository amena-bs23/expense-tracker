class UserModel {
  const UserModel({
    this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.passwordHash,
    required this.createdAtMs,
  });

  final int? id;
  final String email;
  final String firstName;
  final String lastName;
  final String passwordHash;
  final int createdAtMs;

  Map<String, Object?> toDb() => {
        'id': id,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'password_hash': passwordHash,
        'created_at': createdAtMs,
      }..removeWhere((key, value) => value == null);

  static UserModel fromDb(Map<String, Object?> row) => UserModel(
        id: row['id'] as int?,
        email: row['email'] as String,
        firstName: row['first_name'] as String,
        lastName: row['last_name'] as String,
        passwordHash: row['password_hash'] as String,
        createdAtMs: row['created_at'] as int,
      );
}





