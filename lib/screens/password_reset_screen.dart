import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/user_service.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;

  String? maskedEmail; // Maskelenmiş e-posta
  String? userEmail; // Veritabanından alınan e-posta
  String _errorFeedback = '';

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkFields);

    _fetchUserEmail(); // Kullanıcının e-posta adresini getir
  }

  void _checkFields() {
    setState(() {
      _isButtonEnabled = _emailController.text.isNotEmpty;
    });
  }

 Future<void> _fetchUserEmail() async {
  try {
    // Veritabanından kullanıcıya ait e-posta adresini çekiyoruz
    final email = await UserService.getUserEmail(); // Kullanıcı e-posta servisi

    if (email != null) {
      setState(() {
        userEmail = email;

        // Masking işlemi (Örneğin: "abc****@domain.com")
        final parts = email.split('@');
        
        if (parts.length == 2) {
          final localPart = parts[0];
          
          // Eğer yerel kısmın uzunluğu 3'ten büyükse, sadece ilk 3 karakteri göster ve geri kalanı yıldızla maskele
          final maskedLocalPart = localPart.length > 3
              ? localPart.substring(0, 3) + '*' * (localPart.length - 3)
              : localPart;
              
          // Maskelenmiş e-posta oluşturma
          maskedEmail = '$maskedLocalPart@${parts[1]}';
        } else {
          // E-posta formatı beklenmedikse, maskeleme yapılmaz
          maskedEmail = email; 
        }
      });
    } else {
      // Eğer e-posta null ise, kullanıcıya uygun bir mesaj gösterilebilir
      setState(() {
        maskedEmail = "E-posta adresi alınamadı.";
      });
    }
  } catch (error) {
    // Hata durumunda kullanıcıya bir hata mesajı gösterilebilir
    print('Kullanıcı e-posta adresi getirilemedi: $error');
    setState(() {
      maskedEmail = "E-posta adresi alınamadı.";
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifre Sıfırlama'),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Şifre sıfırlama işlemi için aşağıdaki e-posta adresinizi doğrulayın:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Text(
                  'Sistemdeki E-Posta Adresiniz: ${maskedEmail ?? "Yükleniyor..."}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'E-Posta Adresinizi Girin',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen bir e-posta adresi girin';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Geçerli bir e-posta adresi girin';
                    }
                    return null;
                  },
                ),
                if (_errorFeedback.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorFeedback,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isButtonEnabled
                      ? () async {
                          if (formKey.currentState!.validate()) {
                            await _sendPasswordResetRequest();
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.blue[700],
                  ),
                  child: const Text(
                    'Şifre Sıfırlama Linkini Gönder',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendPasswordResetRequest() async {
    final enteredEmail = _emailController.text;
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/request-password-reset'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': enteredEmail}),
      );

      if (response.statusCode == 200) {
        // Başarılı
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Başarılı'),
              content: const Text('Şifre sıfırlama linki e-posta adresinize gönderildi.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Tamam'),
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          _errorFeedback = 'E-posta adresinizle eşleşen bir kullanıcı bulunamadı.';
        });
      }
    } catch (e) {
      setState(() {
        _errorFeedback = 'Bir hata oluştu. Lütfen tekrar deneyin.';
      });
    }
  }
}
