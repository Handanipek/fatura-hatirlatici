import 'package:hive/hive.dart';

// Hive için bu dosyanın .g.dart dosyası ile bağlantısı
part 'user.g.dart';

// Hive veri tabanında 'AppUser' sınıfı için tip tanımı (typeId: 1)
@HiveType(typeId: 1)
class AppUser {
  // Kullanıcının benzersiz kimliği
  @HiveField(0)
  final String id;

  // Kullanıcı adı
  @HiveField(1)
  final String username;

  // Kullanıcı şifresi
  @HiveField(2)
  final String password;

  // Constructor - tüm alanlar zorunlu
  AppUser({
    required this.id,
    required this.username,
    required this.password,
  });
}
