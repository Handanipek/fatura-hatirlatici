import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/bill.dart';
import '../providers/bill_provider.dart';

/// Fatura öğesini temsil eden widget
class BillItem extends StatelessWidget {
  /// Fatura nesnesi
  final Bill bill;

  /// Constructor
  const BillItem({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    // BillProvider'dan provider örneği alınır (dinlemeden)
    final provider = Provider.of<BillProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        elevation: 3, // Gölgelendirme seviyesi
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Yuvarlatılmış köşeler
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Duruma göre renk ve ikon gösteren dairesel avatar
              CircleAvatar(
                radius: 26,
                backgroundColor: bill.isPaid
                    ? const Color(0xFFA0D995) // Ödendi ise yeşil ton
                    : const Color(0xFFF5A9A9), // Ödenmedi ise kırmızı ton
                child: Icon(
                  bill.isPaid ? Icons.check_circle : Icons.schedule,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16), // Aralık
              // Fatura bilgilerini gösteren sütun
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fatura başlığı
                    Text(
                      bill.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    // Son ödeme tarihini formatlanmış biçimde göster
                    Text(
                      'Son ödeme: ${DateFormat.yMMMd().format(bill.dueDate)}',
                      style: const TextStyle(height: 1.4),
                    ),
                    // Fatura tutarını göster
                    Text(
                      'Tutar: ₺${bill.amount.toStringAsFixed(2)}',
                      style: const TextStyle(height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8), // Aralık
              // Silme ve ödeme durumu değiştirme butonlarını içeren sütun
              Column(
                children: [
                  // Faturayı silmek için çöp kutusu ikonu butonu
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey),
                    onPressed: () => provider.removeBill(bill.id),
                  ),
                  // Ödeme durumunu değiştirmek için metinli buton
                  GestureDetector(
                    onTap: () => provider.togglePaidStatus(bill),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: bill.isPaid
                            ? const Color(0xFFA0D995) // Ödendi ise yeşil
                            : const Color(0xFFF5A9A9), // Ödenmedi ise kırmızı
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        bill.isPaid ? 'Ödendi' : 'Bekliyor',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
