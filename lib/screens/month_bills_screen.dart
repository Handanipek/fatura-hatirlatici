import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bill.dart';
import '../providers/bill_provider.dart';
import '../widgets/bill_item.dart';

/// Belirli bir aya ait faturaları listeleyen ekran
class MonthBillsScreen extends StatelessWidget {
  // Ay numarası (1: Ocak, 2: Şubat, vb.)
  final int month;

  const MonthBillsScreen({super.key, required this.month});

  @override
  Widget build(BuildContext context) {
    // BillProvider'dan tüm faturaları al
    final bills = Provider.of<BillProvider>(context).bills;

    // Faturaları seçilen aya göre filtrele
    final monthBills = bills.where((b) => b.dueDate.month == month).toList();

    // Ay isimleri dizisi (index 0 boş, aylar 1-12 arası)
    const monthNames = [
      '', 'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];

    // Temel renk tanımı (mor tonları)
    const Color primaryColor = Color(0xFF6A4C93);

    return Scaffold(
      // Ekran arka plan rengi
      backgroundColor: const Color(0xFFF4F0FB),
      // Üstteki app bar
      appBar: AppBar(
        title: Text("${monthNames[month]} Ayı Faturaları"), // Ay adı başlık olarak gösterilir
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 6,
        shadowColor: primaryColor.withOpacity(0.6),
      ),
      // Ana içerik
      body: monthBills.isEmpty
      // Eğer seçilen ay için fatura yoksa kullanıcıya mesaj göster
          ? Center(
        child: Text(
          "Bu aya ait fatura bulunamadı.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      )
      // Faturalar varsa listele
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        itemCount: monthBills.length,
        itemBuilder: (ctx, i) => BillItem(bill: monthBills[i]), // Her faturayı BillItem widget'ı ile göster
      ),
    );
  }
}
