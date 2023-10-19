import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SharedPreferencesKey {
  // 任意のアップデートをキャンセルした日時
  cancelledUpdateDateTime
}

final sharedPreferencesRepositoryProvider =
    Provider<SharedPreferencesRepository>((_) => throw UnimplementedError());

class SharedPreferencesRepository {
  SharedPreferencesRepository(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  Future<bool> save<T>(SharedPreferencesKey key, T value) async {
    if (value is int) {
      return sharedPreferences.setInt(key.name, value);
    }
    if (value is double) {
      return sharedPreferences.setDouble(key.name, value);
    }
    if (value is bool) {
      return sharedPreferences.setBool(key.name, value);
    }
    if (value is String) {
      return sharedPreferences.setString(key.name, value);
    }
    if (value is List<String>) {
      return sharedPreferences.setStringList(key.name, value);
    }
    return false;
  }

  Future<T?> fetch<T>(SharedPreferencesKey key) async {
    if (T.toString() == 'int') {
      return sharedPreferences.getInt(key.name) as T?;
    }
    if (T.toString() == 'double') {
      return sharedPreferences.getDouble(key.name) as T?;
    }
    if (T.toString() == 'bool') {
      return sharedPreferences.getBool(key.name) as T?;
    }
    if (T.toString() == 'String') {
      return sharedPreferences.getString(key.name) as T?;
    }
    if (T.toString() == 'List<String>') {
      return sharedPreferences.getStringList(key.name) as T?;
    }
    return null;
  }

  Future<bool> remove(SharedPreferencesKey key) =>
      sharedPreferences.remove(key.name);
}