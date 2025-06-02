// GENERATED CODE - DO NOT MODIFY BY HAND
// Bu dosya Hive için otomatik olarak oluşturulmuştur.

part of 'bill.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

// Bill modelinin Hive'da nasıl okunup yazılacağını tanımlayan adaptör sınıfı
class BillAdapter extends TypeAdapter<Bill> {
  @override
  final int typeId = 0; // Modelin benzersiz tipi (bill.dart'taki @HiveType ile uyumlu)

  // Hive verisini okuyarak Bill nesnesi oluşturur
  @override
  Bill read(BinaryReader reader) {
    final numOfFields = reader.readByte(); // Okunacak alan sayısı
    final fields = <int, dynamic>{
      // Okunan alanlar, alan numarası ve değeri şeklinde alınır
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bill(
      id: fields[0] as String,           // id alanı
      title: fields[1] as String,        // title alanı
      amount: fields[2] as double,       // amount alanı
      dueDate: fields[3] as DateTime,    // dueDate alanı
      isPaid: fields[4] as bool,         // isPaid alanı
      userId: fields[5] as String,       // userId alanı
    );
  }

  // Bill nesnesini Hive için yazdırır (serialize eder)
  @override
  void write(BinaryWriter writer, Bill obj) {
    writer
      ..writeByte(6)                     // Toplam alan sayısı
      ..writeByte(0)                     // id alan numarası
      ..write(obj.id)                    // id değeri
      ..writeByte(1)                     // title alan numarası
      ..write(obj.title)                 // title değeri
      ..writeByte(2)                     // amount alan numarası
      ..write(obj.amount)                // amount değeri
      ..writeByte(3)                     // dueDate alan numarası
      ..write(obj.dueDate)               // dueDate değeri
      ..writeByte(4)                     // isPaid alan numarası
      ..write(obj.isPaid)                // isPaid değeri
      ..writeByte(5)                     // userId alan numarası
      ..write(obj.userId);               // userId değeri
  }

  @override
  int get hashCode => typeId.hashCode; // Hash kodu, typeId'ye göre

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||           // Aynı nesne ise true
          other is BillAdapter &&             // Diğer nesne BillAdapter ise ve
              runtimeType == other.runtimeType &&
              typeId == other.typeId;         // typeId eşitse true döner
}
