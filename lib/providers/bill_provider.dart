import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/bill.dart';
import 'package:uuid/uuid.dart';
import '../services/notification_service.dart';

class BillProvider with ChangeNotifier {
  late Box<Bill> _billBox;

  List<Bill> get bills => _billBox.values.toList();

  Future<void> loadBills() async {
    _billBox = Hive.box<Bill>('bills');
    notifyListeners();
  }

  void addBill(String title, double amount, DateTime dueDate) {
    final newBill = Bill(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      dueDate: dueDate,
    );

    _billBox.add(newBill);
    notifyListeners();

    // Bildirim tarihi: 1 gün öncesi
    NotificationService.scheduleReminder(
      id: _billBox.length, // Benzersiz ID
      title: '${newBill.title} - ₺${newBill.amount}',
      scheduledDate: dueDate.subtract(const Duration(days: 1)),
    );
  }


  void removeBill(String id) {
    final bill = _billBox.values.firstWhere((b) => b.id == id);
    bill.delete();
    notifyListeners();
  }

  void togglePaid(String id) {
    final bill = _billBox.values.firstWhere((b) => b.id == id);
    bill.isPaid = !bill.isPaid;
    bill.save();
    notifyListeners();
  }
}
