import 'package:hive/hive.dart';

// Hive için otomatik oluşturulacak dosya bildirimi
part 'bill.g.dart';

// Hive veri modelini tanımlıyoruz, typeId her model için benzersiz olmalı
@HiveType(typeId: 0)
class Bill extends HiveObject {
  // Fatura benzersiz kimliği
  @HiveField(0)
  String id;

  // Fatura başlığı veya açıklaması
  @HiveField(1)
  String title;

  // Fatura tutarı (para birimi olarak)
  @HiveField(2)
  double amount;

  // Faturanın son ödeme tarihi
  @HiveField(3)
  DateTime dueDate;

  // Faturanın ödenip ödenmediğini gösterir (varsayılan false)
  @HiveField(4)
  bool isPaid;

  // Faturayı ekleyen kullanıcıya ait kullanıcı kimliği
  @HiveField(5)
  String userId; // ✅ Yeni alan: faturayı kimin eklediğini tutar

  // Constructor: tüm alanlar zorunlu, isPaid opsiyonel ve varsayılan false
  Bill({
    required this.id,
    required this.title,
    required this.amount,
    required this.dueDate,
    this.isPaid = false,
    required this.userId,
  });
}
