import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_profile_model.dart';

class ProfileNotifier extends Notifier<UserProfileModel> {
  @override
  UserProfileModel build() {
    return const UserProfileModel(
      name: 'DevWatch User',
      email: 'developer@devwatch.app',
      role: 'DevOps Engineer',
      company: 'DevWatch',
      bio: 'Monitoring cloud infrastructure and application performance.',
    );
  }

  void updateProfile({
    required String name,
    required String email,
    required String role,
    required String company,
    required String bio,
  }) {
    state = state.copyWith(
      name: name,
      email: email,
      role: role,
      company: company,
      bio: bio,
    );
  }

  void resetProfile() {
    ref.invalidateSelf();
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, UserProfileModel>(
  ProfileNotifier.new,
);
