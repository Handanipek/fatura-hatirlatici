import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bill_provider.dart';
import '../widgets/bill_item.dart';
import 'add_bill_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BillProvider>(context);
    provider.loadBills(); // Hive'dan faturaları yükle

    final bills = provider.bills;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4F2), // Soft arkaplan
      appBar: AppBar(
        backgroundColor: const Color(0xFF4C9F70), // Soft yeşil
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
        padding: const EdgeInsets.symmetric(vertical: 8),
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
