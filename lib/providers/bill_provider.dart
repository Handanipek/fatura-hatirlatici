import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/bill.dart';
import '../services/notification_service.dart';
import '../models/user.dart';

class BillProvider with ChangeNotifier {
  late Box<Bill> _billBox;
  List<Bill> _userBills = [];

  List<Bill> get bills => _userBills;

  Future<void> loadBillsForUser(AppUser user) async {
    _billBox = Hive.box<Bill>('bills');
    _userBills = _billBox.values
        .where((bill) => bill.userId == user.id)
        .toList();
    notifyListeners();
  }

  void addBill(String title, double amount, DateTime dueDate, String userId) {
    final newBill = Bill(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      dueDate: dueDate,
      userId: userId,
    );
    _billBox.add(newBill);
    _userBills.add(newBill);
    notifyListeners();

    NotificationService.scheduleReminder(
      id: _billBox.length,
      title: '${newBill.title} - ₺${newBill.amount}',
      scheduledDate: newBill.dueDate.subtract(const Duration(days: 1)),
    );
  }

  void removeBill(String id) {
    final bill = _userBills.firstWhere((b) => b.id == id);
    bill.delete();
    _userBills.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  void togglePaidStatus(Bill bill) {
    bill.isPaid = !bill.isPaid;
    bill.save();
    notifyListeners();
  }
}
