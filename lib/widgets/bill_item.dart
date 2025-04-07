import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/bill.dart';
import '../providers/bill_provider.dart';

class BillItem extends StatelessWidget {
  final Bill bill;

  const BillItem({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BillProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20), // Yükseklik artırıldı
          leading: CircleAvatar(
            radius: 26,
            backgroundColor: bill.isPaid ? const Color(0xFFA0D995) : const Color(0xFFF5A9A9),
            child: Icon(
              bill.isPaid ? Icons.check_circle : Icons.schedule,
              color: Colors.white,
              size: 28,
            ),
          ),
          title: Text(
            bill.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(
            'Son ödeme: ${DateFormat.yMMMd().format(bill.dueDate)}\nTutar: ₺${bill.amount.toStringAsFixed(2)}',
            style: const TextStyle(height: 1.4),
          ),
          isThreeLine: true,
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center, // HATA BURAYDI: Ortalandı
            children: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.grey),
                onPressed: () => provider.removeBill(bill.id),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => provider.togglePaid(bill.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: bill.isPaid ? const Color(0xFFA0D995) : const Color(0xFFF5A9A9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    bill.isPaid ? 'Ödendi' : 'Bekliyor',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          onTap: () => provider.togglePaid(bill.id),
        ),
      ),
    );
  }
}
