import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bill_provider.dart';
import '../widgets/bill_item.dart';

/// Ödenen veya ödenmeyen faturaların filtrelenmiş listesini gösteren ekran
class FilteredBillsScreen extends StatelessWidget {
  // showPaid true ise ödenen faturalar, false ise ödenmeyen faturalar gösterilir
  final bool showPaid;

  const FilteredBillsScreen({super.key, required this.showPaid});

  @override
  Widget build(BuildContext context) {
    // Provider üzerinden tüm faturaları al
    final bills = Provider.of<BillProvider>(context).bills;

    // Faturaları isPaid durumuna göre filtrele
    final filteredBills = bills.where((b) => b.isPaid == showPaid).toList();

    // Ana renk olarak mor tonu tanımla
    final primaryColor = const Color(0xFF6A4C93);

    return Scaffold(
      appBar: AppBar(
        // AppBar başlığı, filtre durumuna göre değişir
        title: Text(
          showPaid ? 'Ödenen Faturalar' : 'Ödenmeyen Faturalar',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        elevation: 6,
        shadowColor: primaryColor.withOpacity(0.6),
        centerTitle: true,
      ),
      // Eğer filtreye uygun fatura yoksa ekrana bilgi mesajı göster
      body: filteredBills.isEmpty
          ? Center(
        child: Text(
          'Bu grupta hiç fatura bulunamadı.',
          style: TextStyle(
            fontSize: 18,
            color: primaryColor.withOpacity(0.7),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      )
      // Filtrelenmiş faturalar varsa liste olarak göster
          : ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        itemCount: filteredBills.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (ctx, i) {
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.hardEdge,
            // Kartın arka planında gradient renk geçişi
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.1),
                    primaryColor.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              // Her bir fatura öğesi BillItem widget'ı ile gösterilir
              child: BillItem(bill: filteredBills[i]),
            ),
          );
        },
      ),
    );
  }
}
