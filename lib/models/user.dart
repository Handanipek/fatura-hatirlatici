import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class AppUser {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String password;

  AppUser({
    required this.id,
    required this.username,
    required this.password,
  });
}
