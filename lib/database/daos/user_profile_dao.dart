import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/user_profile_table.dart';

part 'user_profile_dao.g.dart';

@DriftAccessor(tables: [UserProfile])
class UserProfileDao extends DatabaseAccessor<AppDatabase>
    with _$UserProfileDaoMixin {
  UserProfileDao(super.db);

  Future<UserProfileData?> getProfile() =>
      select(userProfile).getSingleOrNull();

  Stream<UserProfileData?> watchProfile() =>
      select(userProfile).watchSingleOrNull();

  Future<int> insertProfile(UserProfileCompanion profile) =>
      into(userProfile).insert(profile);

  Future<bool> updateProfile(UserProfileCompanion profile) async {
    final rowsAffected = await (update(userProfile)
          ..where((t) => t.id.equals(profile.id.value)))
        .write(profile);
    return rowsAffected > 0;
  }

  Future<int> deleteProfile() => delete(userProfile).go();

  Future<bool> hasProfile() async {
    final row = await (select(userProfile)..limit(1)).getSingleOrNull();
    return row != null;
  }
}
