import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/user.dart';

/// Kullanıcı yönetimi için provider.
/// Kullanıcı giriş, çıkış, kayıt ve mevcut kullanıcı durumunu yönetir.
class UserProvider extends ChangeNotifier {
  AppUser? _currentUser; // Şu anda oturum açmış kullanıcı

  /// Şu anki oturum açmış kullanıcıyı döner
  AppUser? get currentUser => _currentUser;

  /// Kullanıcı girişi yapar.
  /// Verilen kullanıcı adı ve şifre ile Hive kutusundaki kullanıcıları arar.
  /// Eşleşen kullanıcı bulunursa, oturum açar ve auth bilgisi kaydeder.
  /// Bulunamazsa hata fırlatır.
  Future<void> login(String username, String password) async {
    final box = Hive.box<AppUser>('users'); // 'users' kutusunu aç
    final users = box.values; // Tüm kullanıcılar

    try {
      // Kullanıcı adı ve şifre eşleşen kullanıcıyı bul
      final user = users.firstWhere(
            (u) => u.username == username && u.password == password,
      );
      _currentUser = user; // Oturumu aç
      final authBox = Hive.box<String>('auth'); // Auth kutusu
      authBox.put('loggedInUserId', user.id); // Oturum bilgisi kaydet
      notifyListeners(); // Dinleyicilere bildir
    } catch (e) {
      // Kullanıcı bulunamadığında veya şifre yanlışsa hata fırlat
      throw Exception('Kullanıcı bulunamadı veya şifre hatalı.');
    }
  }

  /// Kullanıcı çıkışı yapar.
  /// Mevcut kullanıcıyı null yapar ve auth bilgisini siler.
  Future<void> logout() async {
    _currentUser = null; // Oturumu kapat
    final authBox = Hive.box<String>('auth');
    authBox.delete('loggedInUserId'); // Oturum bilgisini sil
    notifyListeners(); // Dinleyicilere bildir
  }

  /// Auth kutusundan kayıtlı kullanıcı ID'sini okur ve
  /// o kullanıcıyı yükler (otomatik giriş için).
  Future<void> loadUserFromAuth() async {
    final authBox = Hive.box<String>('auth');
    final userId = authBox.get('loggedInUserId'); // Kayıtlı kullanıcı ID

    if (userId == null) {
      // Kayıtlı kullanıcı yoksa oturum kapalı say
      _currentUser = null;
      notifyListeners();
      return;
    }

    try {
      final box = Hive.box<AppUser>('users');
      final user = box.values.firstWhere((u) => u.id == userId); // Kullanıcıyı bul
      _currentUser = user;
    } catch (_) {
      // Kullanıcı bulunamazsa oturumu kapat
      _currentUser = null;
    }

    notifyListeners(); // Dinleyicilere bildir
  }

  /// Yeni kullanıcı kaydı yapar.
  /// Aynı kullanıcı adı varsa hata fırlatır.
  /// Yeni kullanıcı oluşturup Hive'a ekler ve oturum açar.
  Future<void> register(String username, String password) async {
    final box = Hive.box<AppUser>('users');

    // Aynı kullanıcı adının varlığı kontrol edilir
    if (box.values.any((u) => u.username == username)) {
      throw Exception('Bu kullanıcı adı zaten kullanılıyor.');
    }

    // Yeni kullanıcı oluşturulur
    final newUser = AppUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // ID olarak zaman damgası
      username: username,
      password: password,
    );

    await box.add(newUser); // Hive'a ekle
    _currentUser = newUser; // Oturum aç
    final authBox = Hive.box<String>('auth');
    authBox.put('loggedInUserId', newUser.id); // Oturum bilgisi kaydet
    notifyListeners(); // Dinleyicilere bildir
  }
}
