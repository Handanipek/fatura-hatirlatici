import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzData;
import '../models/bill.dart';

/// Bildirim servisinin yönetildiği sınıf
class NotificationService {
  /// Flutter Local Notifications Plugin örneği
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  /// Bildirim sistemini başlatmak için kullanılan method
  static Future<void> init() async {
    // Zaman dilimlerini initialize et (bildirim zamanlaması için gerekli)
    tzData.initializeTimeZones();

    // Android için başlangıç ayarları (uygulama ikonunu belirler)
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // Platformlara özel başlangıç ayarları
    const settings = InitializationSettings(android: androidSettings);

    // Bildirim sistemi initialize edilir
    await _notifications.initialize(settings);
  }

  /// Belirli bir zamanda fatura hatırlatma bildirimi planlar
  ///
  /// [id]: Bildirim id'si, benzersiz olmalı
  /// [title]: Bildirim içeriğinde gösterilecek başlık
  /// [scheduledDate]: Bildirimin tetikleneceği tarih ve saat
  static Future<void> scheduleReminder({
    required int id,
    required String title,
    required DateTime scheduledDate,
  }) async {
    await _notifications.zonedSchedule(
      id, // Bildirim id'si
      'Fatura Hatırlatma', // Bildirim başlığı
      title, // Bildirim içeriği (fatura başlığı ve tutarı)
      tz.TZDateTime.from(scheduledDate, tz.local), // Planlanan tarih ve saat, yerel zaman dilimine göre
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'fatura_channel', // Kanal ID'si
          'Fatura Hatırlatıcı', // Kanal adı
          channelDescription: 'Fatura ödeme hatırlatma bildirimi', // Kanal açıklaması
          importance: Importance.max, // Maksimum önem seviyesi
          priority: Priority.high, // Öncelik yüksek
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Android için kesin ve uyku modunda da çalışacak şekilde ayarla
    );
  }
}
