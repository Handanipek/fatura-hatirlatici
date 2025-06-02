import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bill_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/bill_item.dart';
import 'calendar_screen.dart';
import 'add_bill_screen.dart';
import 'login_screen.dart';

/// Uygulamanın ana ekranı, kullanıcıya faturaların listesini gösterir.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Ana tema renkleri tanımlandı
  final Color primaryColor = const Color(0xFF6A4C93); // Mor ton
  final Color backgroundColor = const Color(0xFFF3F0FF); // Açık mor- beyaz ton

  @override
  void initState() {
    super.initState();

    // Widget ağacının oluşturulmasından sonra kullanıcı faturalarını yükle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUser = userProvider.currentUser;

      // Eğer kullanıcı varsa, o kullanıcıya ait faturaları yükle
      if (currentUser != null) {
        Provider.of<BillProvider>(context, listen: false)
            .loadBillsForUser(currentUser);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // BillProvider üzerinden faturaları al
    final billProvider = Provider.of<BillProvider>(context);
    final bills = billProvider.bills;

    return Scaffold(
      // Ekran arka plan rengi
      backgroundColor: backgroundColor,
      // Üstteki app bar
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 6,
        centerTitle: true,
        title: const Text(
          'Fatura Hatırlatıcı',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.1,
            color: Colors.white, // Yazı rengi beyaz yapıldı
          ),
        ),
        // Sağ üstte çıkış yap butonu
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Çıkış Yap',
            onPressed: () async {
              // Kullanıcı çıkışı gerçekleştir
              await Provider.of<UserProvider>(context, listen: false).logout();
              if (!mounted) return;
              // Login ekranına yönlendir ve önceki sayfaları temizle
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
          )
        ],
      ),
      // Yan menü (drawer)
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer başlığı kısmı
            DrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.6),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.receipt_long, size: 48, color: Colors.white),
                    SizedBox(height: 12),
                    Text(
                      'Menü',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Menü seçenekleri
            ListTile(
              leading: Icon(Icons.home_outlined, color: primaryColor),
              title: const Text('Ana Sayfa', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () => Navigator.pop(context), // Drawer kapat
              hoverColor: primaryColor.withOpacity(0.1),
            ),
            ListTile(
              leading: Icon(Icons.bar_chart_outlined, color: primaryColor),
              title: const Text('İstatistikler', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                // İstatistikler sayfasına yönlendir
                Navigator.of(context).pushNamed('/statistics');
              },
              hoverColor: primaryColor.withOpacity(0.1),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today_outlined, color: primaryColor),
              title: const Text('Takvim', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                // Takvim ekranına yönlendir
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => CalendarScreen()),
                );
              },
              hoverColor: primaryColor.withOpacity(0.1),
            ),
          ],
        ),
      ),
      // Ana içerik kısmı
      body: bills.isEmpty
          ? Center(
        child: Text(
          'Henüz fatura eklenmedi.',
          style: TextStyle(
            fontSize: 20,
            color: primaryColor.withOpacity(0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        itemCount: bills.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (ctx, i) => Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.05),
                  primaryColor.withOpacity(0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            // Fatura öğesi widget'ı
            child: BillItem(bill: bills[i]),
          ),
        ),
      ),
      // Yeni fatura ekleme için kayan buton
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        tooltip: 'Yeni Fatura Ekle',
        onPressed: () {
          // Fatura ekleme ekranına yönlendir
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddBillScreen()),
          );
        },
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
    );
  }
}
