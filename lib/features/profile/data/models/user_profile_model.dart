class UserProfileModel {
  const UserProfileModel({
    required this.name,
    required this.email,
    required this.role,
    required this.company,
    required this.bio,
  });

  final String name;
  final String email;
  final String role;
  final String company;
  final String bio;

  UserProfileModel copyWith({
    String? name,
    String? email,
    String? role,
    String? company,
    String? bio,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      company: company ?? this.company,
      bio: bio ?? this.bio,
    );
  }
}
