import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // TextField için controllerlar
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Form validasyonu için GlobalKey
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Buton durumu ve hata mesajı için değişkenler
  bool _isLoading = false;
  String? _error;

  // Uygulamanın ana rengi (mor tonları)
  final Color primaryColor = const Color(0xFF6A4C93);

  // Giriş işlemi yapan async fonksiyon
  void _login() async {
    // Form validasyonunu kontrol et, geçerli değilse işlemi durdur
    if (!_formKey.currentState!.validate()) return;

    // Yükleniyor durumu aktif et ve hata mesajını temizle
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // UserProvider üzerinden giriş işlemini yap
      await Provider.of<UserProvider>(context, listen: false).login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      // Başarılı girişte HomeScreen sayfasına yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      // Hata oluşursa ekranda göster
      setState(() => _error = e.toString().replaceAll('Exception:', '').trim());
    } finally {
      // İşlem tamamlandığında yükleniyor durumunu kapat
      setState(() => _isLoading = false);
    }
  }

  // InputDecoration için tekrar kullanılabilir stil fonksiyonu
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true, // arka plan dolu
      fillColor: Colors.white, // arka plan rengi beyaz
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14), // köşe yuvarlama
        borderSide: BorderSide.none, // dış çerçeve yok
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 2), // aktifken renkli çerçeve
        borderRadius: BorderRadius.circular(14),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent), // hata rengi
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F0FB), // sayfa arka plan rengi
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Form(
            key: _formKey, // form key'i ekle
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Uygulama ikonu
                Icon(Icons.lock_outline, size: 72, color: primaryColor),
                const SizedBox(height: 20),

                // Başlık metni
                Text(
                  'Fatura Hatırlatıcı',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 40),

                // Kullanıcı adı girişi
                TextFormField(
                  controller: _usernameController,
                  decoration: _inputDecoration('Kullanıcı Adı'),
                  validator: (value) =>
                  value!.isEmpty ? 'Kullanıcı adı giriniz' : null,
                ),
                const SizedBox(height: 18),

                // Şifre girişi
                TextFormField(
                  controller: _passwordController,
                  decoration: _inputDecoration('Şifre'),
                  obscureText: true,
                  validator: (value) =>
                  value!.isEmpty ? 'Şifre giriniz' : null,
                ),
                const SizedBox(height: 24),

                // Hata mesajı varsa göster
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      _error!,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Giriş Yap butonu
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50), // buton yüksekliği
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor: primaryColor.withOpacity(0.6),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                      : const Text(
                    'Giriş Yap',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white, // **Beyaz yazı rengi**
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Kayıt ol linki
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: Text(
                    'Hesabınız yok mu? Kayıt olun',
                    style: TextStyle(
                      color: primaryColor.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    ),
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
