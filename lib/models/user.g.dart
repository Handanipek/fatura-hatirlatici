// GENERATED CODE - DO NOT MODIFY BY HAND
// Bu dosya Hive tarafından otomatik olarak oluşturulmuştur.
// Manuel olarak değiştirmeyin çünkü yapılan değişiklikler üzerine yazılabilir.

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

// Hive için AppUser sınıfının adaptörü
class AppUserAdapter extends TypeAdapter<AppUser> {
  @override
  final int typeId = 1; // Sınıfın benzersiz tipi (typeId)

  // Hive verisini okurken kullanılır
  @override
  AppUser read(BinaryReader reader) {
    final numOfFields = reader.readByte(); // Okunacak alan sayısı
    final fields = <int, dynamic>{
      // Alan indekslerine göre verileri oku ve eşleştir
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    // Okunan verilerle AppUser nesnesi oluştur
    return AppUser(
      id: fields[0] as String,
      username: fields[1] as String,
      password: fields[2] as String,
    );
  }

  // Hive verisine yazarken kullanılır
  @override
  void write(BinaryWriter writer, AppUser obj) {
    writer
      ..writeByte(3) // Toplam alan sayısı
      ..writeByte(0) // İlk alanın indeks numarası
      ..write(obj.id) // İlk alanın değeri
      ..writeByte(1) // İkinci alanın indeks numarası
      ..write(obj.username) // İkinci alanın değeri
      ..writeByte(2) // Üçüncü alanın indeks numarası
      ..write(obj.password); // Üçüncü alanın değeri
  }

  // Tür eşitliği için hashCode
  @override
  int get hashCode => typeId.hashCode;

  // Tür eşitliği kontrolü
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AppUserAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
