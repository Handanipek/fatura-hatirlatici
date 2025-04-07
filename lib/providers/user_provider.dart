import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;

  Future<void> login(String username, String password) async {
    final box = Hive.box<AppUser>('users');
    final users = box.values;

    try {
      final user = users.firstWhere(
            (u) => u.username == username && u.password == password,
      );
      _currentUser = user;
      final authBox = Hive.box<String>('auth');
      authBox.put('loggedInUserId', user.id);
      notifyListeners();
    } catch (e) {
      throw Exception('Kullanıcı bulunamadı veya şifre hatalı.');
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    final authBox = Hive.box<String>('auth');
    authBox.delete('loggedInUserId');
    notifyListeners();
  }

  Future<void> loadUserFromAuth() async {
    final authBox = Hive.box<String>('auth');
    final userId = authBox.get('loggedInUserId');

    if (userId == null) {
      _currentUser = null;
      notifyListeners();
      return;
    }

    try {
      final box = Hive.box<AppUser>('users');
      final user = box.values.firstWhere((u) => u.id == userId);
      _currentUser = user;
    } catch (_) {
      _currentUser = null;
    }

    notifyListeners();
  }




  Future<void> register(String username, String password) async {
    final box = Hive.box<AppUser>('users');
    if (box.values.any((u) => u.username == username)) {
      throw Exception('Bu kullanıcı adı zaten kullanılıyor.');
    }
    final newUser = AppUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: username,
      password: password,
    );
    await box.add(newUser);
    _currentUser = newUser;
    final authBox = Hive.box<String>('auth');
    authBox.put('loggedInUserId', newUser.id);
    notifyListeners();
  }
}
