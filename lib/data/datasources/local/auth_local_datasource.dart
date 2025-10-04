import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _cachedUserKey = 'CACHED_USER';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = sharedPreferences.getString(_cachedUserKey);
    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(
      _cachedUserKey,
      json.encode(user.toJson()),
    );
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(_cachedUserKey);
  }
}
