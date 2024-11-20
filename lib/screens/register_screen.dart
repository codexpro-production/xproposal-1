import 'package:flutter/material.dart';
import '../services/sap_service.dart';
import '../services/mail_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _vknTcknController = TextEditingController();
  final _emailController = TextEditingController();
  final SAPService _sapService = SAPService(); // SAPService nesnesi
  bool _isButtonEnabled = false;

  // Aktivasyon linkini gönderme işlemi
  Future<void> _sendActivationLink() async {
    final vknTckn = _vknTcknController.text;
    final email = _emailController.text;

    // VKN/TCKN ve e-posta doğrulama
    bool isValid = await _sapService.validateVknTcknAndEmail(vknTckn, email);
    if (!isValid) {
      _showError("Girilen VKN ve e-posta adresi hatalıdır.");
      return;
    }
    //////
    /// // Eğer doğrulama başarılıysa, e-posta gönder
    bool result = await sendMail(
      'Admin',  // Gönderen isim
      email,  // Kullanıcıdan alınan e-posta
      'Aktivasyon Linki',  // Konu
      'Bu bir aktivasyon mesajıdır. Lütfen bu linki tıklayarak şifrenizi sıfırlayın.',  // Mesaj
      context,  // Context
    );

    if (result) {
      _showMessage("Girilen e-posta adresine aktivasyon linki gönderilmiştir.");
    } else {
      _showError("E-posta gönderilemedi. Lütfen tekrar deneyin.");
    }
  }
    ///

  //   // BLOKAJ_DURUMU kontrolü
  //   bool isBlocked = await _sapService.checkIfBlocked(vknTckn);
  //   if (isBlocked) {
  //     _showError("VKN/TCKN sistemimizde blokajlı görünmektedir. Lütfen Satınalma Birimi ile iletişime geçiniz!");
  //     return;
  //   }

  //   // Blokaj yoksa aktivasyon linki gönder
  //   await _sapService.sendActivationLink(email);
  //   _showMessage("Girilen e-posta adresine aktivasyon linki gönderilmiştir.");
  // }

  // Hata mesajını gösterme fonksiyonu
  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error, style: TextStyle(color: Colors.red)),
      ),
    );
  }

  // Başarı mesajını gösterme fonksiyonu
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // TextField'ların kontrolü
  void _checkFields() {
    setState(() {
      _isButtonEnabled = _vknTcknController.text.isNotEmpty &&
          _emailController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Yeni Kullanıcı Oluştur",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text("Lütfen VKN/TCKN girin"),
              TextField(
                controller: _vknTcknController,
                onChanged: (_) => _checkFields(),
                keyboardType: TextInputType.number,
                maxLength: 11,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Vergi Kimlik No veya T.C. Kimlik No",
                ),
              ),
              SizedBox(height: 16),
              Text("Lütfen E-Posta Adresinizi Girin"),
              TextField(
                controller: _emailController,
                onChanged: (_) => _checkFields(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "E-posta",
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isButtonEnabled ? _sendActivationLink : null,
                child: Text("Yeni Kullanıcı Oluştur"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
