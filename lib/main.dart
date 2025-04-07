import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/bill.dart';
import 'providers/bill_provider.dart';
import 'screens/home_screen.dart';
import 'screens/statistics_screen.dart';
import 'services/notification_service.dart';
import 'screens/login_screen.dart';
import 'models/user.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive ve Notification başlatma
  await Hive.initFlutter();
  Hive.registerAdapter(BillAdapter());
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<Bill>('bills');
  await Hive.openBox<User>('users');
  await NotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BillProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fatura Hatırlatıcı',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const LoginScreen(), // ✅ Buraya eklenecek
        routes: {
          '/statistics': (_) => const StatisticsScreen(),
        },
      ),
    );
  }
}
