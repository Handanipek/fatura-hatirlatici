import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/bill.dart';
import 'models/user.dart';
import 'providers/bill_provider.dart';
import 'providers/user_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/statistics_screen.dart';
import 'services/notification_service.dart';

/// Uygulama giriş noktası
void main() async {
  // Flutter'ın widget bağlamını başlatır
  WidgetsFlutterBinding.ensureInitialized();

  // Hive veritabanı Flutter için başlatılır
  await Hive.initFlutter();

  // Hive için model adaptörleri kaydedilir
  Hive.registerAdapter(BillAdapter());
  Hive.registerAdapter(AppUserAdapter());

  // Hive kutuları açılır
  await Hive.openBox<Bill>('bills');
  await Hive.openBox<AppUser>('users');
  await Hive.openBox<String>('auth');

  // Bildirim servisi başlatılır
  await NotificationService.init();

  // Uygulama çalıştırılır
  runApp(const MyApp());
}

/// Ana uygulama widget'ı
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Provider ile BillProvider ve UserProvider dinleyicileri eklenir
      providers: [
        ChangeNotifierProvider(create: (_) => BillProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Debug banner kapalı
        title: 'Fatura Hatırlatıcı', // Uygulama başlığı
        theme: ThemeData(
          // Temanın ana rengi belirlenir
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true, // Material 3 teması kullanılır
        ),
        home: const RootPage(), // Başlangıç sayfası
        routes: {
          '/statistics': (_) => const StatisticsScreen(), // İstatistik ekranı rotası
        },
      ),
    );
  }
}

/// RootPage widget'ı: Kullanıcının giriş yapıp yapmadığını kontrol eder
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  // Yüklenme durumunu tutar
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Mikro görev olarak kullanıcı bilgisi yüklenir
    Future.microtask(() async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.loadUserFromAuth(); // Auth bilgisine göre kullanıcı yükle
      if (mounted) {
        setState(() => _isLoading = false); // Yüklenme tamamlandı
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    // Eğer yüklenme devam ediyorsa yükleniyor göstergesi
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Kullanıcı giriş yapmışsa HomeScreen, yoksa LoginScreen gösterilir
    return userProvider.currentUser == null
        ? const LoginScreen()
        : const HomeScreen();
  }
}
