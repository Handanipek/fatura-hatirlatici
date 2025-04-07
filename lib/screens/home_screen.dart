import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bill_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/bill_item.dart';
import 'add_bill_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUser = userProvider.currentUser;

      if (currentUser != null) {
        Provider.of<BillProvider>(context, listen: false)
            .loadBillsForUser(currentUser);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final billProvider = Provider.of<BillProvider>(context);
    final bills = billProvider.bills;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4C9F70),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Fatura Hatırlatıcı',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await Provider.of<UserProvider>(context, listen: false).logout();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF4C9F70),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.receipt_long, size: 40, color: Colors.white),
                    SizedBox(height: 12),
                    Text(
                      'Menü',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Ana Sayfa'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart_outlined),
              title: const Text('İstatistikler'),
              onTap: () {
                Navigator.of(context).pushNamed('/statistics');
              },
            ),
          ],
        ),
      ),
      body: bills.isEmpty
          ? const Center(
        child: Text(
          'Henüz fatura eklenmedi.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        itemCount: bills.length,
        itemBuilder: (ctx, i) => BillItem(bill: bills[i]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4C9F70),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddBillScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
