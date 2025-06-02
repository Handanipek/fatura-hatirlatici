import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bill_provider.dart';
import '../providers/user_provider.dart';

/// Yeni fatura ekleme ekranı
class AddBillScreen extends StatefulWidget {
  const AddBillScreen({super.key});

  @override
  State<AddBillScreen> createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  final _formKey = GlobalKey<FormState>(); // Form doğrulama için global key
  final _titleController = TextEditingController(); // Başlık için controller
  final _amountController = TextEditingController(); // Tutar için controller
  DateTime? _selectedDate; // Seçilen tarih, başlangıçta null

  /// Form gönderildiğinde çağrılır
  /// Form geçerliyse ve tarih seçiliyse faturayı ekler
  void _submit() {
    // Form geçerli değil veya tarih seçilmemişse işlemi durdur
    if (!_formKey.currentState!.validate() || _selectedDate == null) return;

    // Mevcut kullanıcıyı al
    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    if (user == null) return; // Kullanıcı yoksa işlemi durdur

    // Metin kutularından veri al
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;

    // Provider üzerinden fatura ekle
    Provider.of<BillProvider>(context, listen: false).addBill(
      title,
      amount,
      _selectedDate!,
      user.id, // Faturayı ekleyen kullanıcı ID'si
    );

    // İşlem tamamlandıktan sonra ekranı kapat
    Navigator.of(context).pop();
  }

  /// Tarih seçici açar ve seçilen tarihi günceller
  void _pickDate() async {
    final now = DateTime.now();
    // Tarih seçici dialog açılır
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now, // İlk tarih olarak seçili tarih ya da bugün
      firstDate: now, // Geçmiş tarihler seçilemez
      lastDate: DateTime(now.year + 5), // 5 yıl sonrası son tarih
      builder: (context, child) {
        // Tarih seçici teması (mor tonları)
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF6A4C93), // Mor ton
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: const Color(0xFF6A4C93)),
            ),
          ),
          child: child!,
        );
      },
    );

    // Eğer kullanıcı tarih seçtiyse, seçili tarihi güncelle
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ana renk olarak mor tonu tanımla
    final primaryColor = const Color(0xFF6A4C93);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Fatura Ekle'),
        backgroundColor: primaryColor,
        elevation: 0,
        // AppBar başlığının yazı rengi beyaz olarak ayarlandı
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Form(
          key: _formKey, // Form doğrulama anahtarı
          child: ListView(
            children: [
              // Başlık için metin girişi
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Fatura Başlığı',
                  labelStyle: TextStyle(color: primaryColor),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor.withOpacity(0.5), width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Başlık giriniz' : null,
              ),
              const SizedBox(height: 20),

              // Tutar için metin girişi (sadece sayısal)
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Tutar (₺)',
                  labelStyle: TextStyle(color: primaryColor),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor.withOpacity(0.5), width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'Tutar giriniz' : null,
              ),
              const SizedBox(height: 24),

              // Tarih seçimi için satır
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Tarih seçilmedi'
                          : 'Son tarih: ${_selectedDate!.toLocal()}'.split(' ')[0],
                      style: TextStyle(
                        fontSize: 16,
                        color: primaryColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pickDate, // Tarih seçme fonksiyonu çağrılır
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor.withOpacity(0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text('Tarih Seç'),
                  )
                ],
              ),
              const SizedBox(height: 36),

              // Fatura ekle butonu
              ElevatedButton(
                onPressed: _submit, // Submit fonksiyonu çağrılır
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  shadowColor: primaryColor.withOpacity(0.6),
                ),
                child: const Text(
                  'Fatura Ekle',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
