import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/bill.dart';
import '../services/notification_service.dart';
import '../models/user.dart';

/// Fatura verilerini yönetmek için kullanılan provider.
/// Hive veri tabanı ile çalışır ve değişiklikleri dinleyicilere bildirir.
class BillProvider with ChangeNotifier {
  late Box<Bill> _billBox; // Hive'daki 'bills' kutusu
  List<Bill> _userBills = []; // Şu anki kullanıcıya ait faturalar listesi

  /// Şu an gösterilen faturalar (kullanıcıya özel)
  List<Bill> get bills => _userBills;

  /// Belirtilen kullanıcıya ait faturaları Hive kutusundan yükler.
  /// Yükleme tamamlandığında dinleyicilere bildirim gönderir.
  Future<void> loadBillsForUser(AppUser user) async {
    _billBox = Hive.box<Bill>('bills'); // 'bills' kutusunu aç
    // Kullanıcıya ait faturaları filtrele
    _userBills = _billBox.values
        .where((bill) => bill.userId == user.id)
        .toList();
    notifyListeners(); // Dinleyicilere değişiklik bildir
  }

  /// Yeni bir fatura ekler ve Hive kutusuna kaydeder.
  /// Ayrıca, faturanın bir gün öncesine bildirim (reminder) planlar.
  void addBill(String title, double amount, DateTime dueDate, String userId) {
    final newBill = Bill(
      id: const Uuid().v4(), // Benzersiz ID oluştur
      title: title,
      amount: amount,
      dueDate: dueDate,
      userId: userId, // Faturayı ekleyen kullanıcı ID'si
    );
    _billBox.add(newBill); // Hive kutusuna ekle
    _userBills.add(newBill); // Yerel listeye ekle
    notifyListeners(); // Dinleyicilere bildir

    // Bildirim servisini kullanarak fatura tarihinden 1 gün önce hatırlatma ayarla
    NotificationService.scheduleReminder(
      id: _billBox.length, // Bildirim ID'si (fatura sayısı olarak)
      title: '${newBill.title} - ₺${newBill.amount}', // Bildirim başlığı
      scheduledDate: newBill.dueDate.subtract(const Duration(days: 1)), // Bildirim zamanı
    );
  }

  /// Belirtilen ID'ye sahip faturayı siler.
  /// Hive veritabanından ve yerel listeden kaldırır.
  void removeBill(String id) {
    final bill = _userBills.firstWhere((b) => b.id == id); // Faturayı bul
    bill.delete(); // Hive'dan sil
    _userBills.removeWhere((b) => b.id == id); // Yerel listeden çıkar
    notifyListeners(); // Dinleyicilere bildir
  }

  /// Verilen faturanın 'ödendi' durumunu tersine çevirir.
  /// Değişikliği Hive'a kaydeder ve dinleyicilere bildirir.
  void togglePaidStatus(Bill bill) {
    bill.isPaid = !bill.isPaid; // Durumu değiştir
    bill.save(); // Hive'da kaydet
    notifyListeners(); // Dinleyicilere bildir
  }
}
