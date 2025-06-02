import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';

/// Kayıt olma ekranı
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Kullanıcı adı için text controller
  final TextEditingController _usernameController = TextEditingController();

  // Şifre için text controller
  final TextEditingController _passwordController = TextEditingController();

  // Form validasyonunu kontrol etmek için global key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Yüklenme durumu için flag
  bool _isLoading = false;

  // Hata mesajı için değişken
  String? _error;

  /// Kayıt işlemini başlatır
  void _register() async {
    // Form validasyonu sağlanmazsa işlemi durdur
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true; // Yüklenme başladı
      _error = null; // Önceki hata mesajını temizle
    });

    try {
      // UserProvider üzerinden kayıt olma işlemi
      await Provider.of<UserProvider>(context, listen: false).register(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      // Başarılı kayıt sonrası ana ekrana yönlendir
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
      );
    } catch (e) {
      // Hata mesajını yakala ve gösterilecek hale getir
      setState(() => _error = e.toString().replaceAll('Exception:', '').trim());
    } finally {
      // Yüklenme tamamlandı
      setState(() => _isLoading = false);
    }
  }

  /// Form alanlarının stilini belirler
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true, // Arka plan dolu
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none, // Normalde çerçeve yok
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF6A4C93), width: 2), // Odaklanınca mor renkli çerçeve
        borderRadius: BorderRadius.circular(14),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red.shade700, width: 2), // Hata durumunda kırmızı çerçeve
        borderRadius: BorderRadius.circular(14),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red.shade900, width: 2), // Odaklanmış hata durumu
        borderRadius: BorderRadius.circular(14),
      ),
      labelStyle: const TextStyle(
        color: Color(0xFF6A4C93),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FA), // Arka plan rengi
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Form(
            key: _formKey, // Form key'i bağla
            child: Column(
              children: [
                // Üstte yuvarlak mor arka planlı ikon
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF6A4C93),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(Icons.person_add_alt_1_outlined, size: 64, color: Colors.white),
                ),

                const SizedBox(height: 20),

                // Başlık metni
                const Text(
                  'Kayıt Ol',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A4C93),
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 36),

                // Kullanıcı adı alanı
                TextFormField(
                  controller: _usernameController,
                  decoration: _inputDecoration('Kullanıcı Adı'),
                  validator: (value) => value!.isEmpty ? 'Kullanıcı adı giriniz' : null,
                ),

                const SizedBox(height: 18),

                // Şifre alanı
                TextFormField(
                  controller: _passwordController,
                  decoration: _inputDecoration('Şifre'),
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? 'Şifre giriniz' : null,
                ),

                const SizedBox(height: 28),

                // Hata mesajı varsa göster
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),

                // Kayıt ol butonu
                ElevatedButton(
                  onPressed: _isLoading ? null : _register, // Yükleniyorsa buton devre dışı
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: const Color(0xFF6A4C93),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: Colors.purpleAccent,
                    elevation: 8,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Kayıt Ol', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ),

                const SizedBox(height: 20),

                // Giriş ekranına yönlendiren metin butonu
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: Text(
                    'Zaten hesabınız var mı? Giriş yapın',
                    style: TextStyle(color: Colors.purple.shade700, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
