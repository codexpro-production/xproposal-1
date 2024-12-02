import 'package:flutter/material.dart';
import '../services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController tcknVknController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController purchaseGroupController = TextEditingController();
  final TextEditingController telNumberController = TextEditingController();
  final TextEditingController faxNumberController = TextEditingController();
  final TextEditingController responsibleController = TextEditingController();

  bool _isButtonEnabled = false;
  String userType = 'Vendor'; // Default user type is Vendor
  String? _message;
  Color _messageColor = Colors.green;

void _checkFields() {
  setState(() {
    if (userType == "Vendor") {
      _isButtonEnabled = nameController.text.isNotEmpty &&
          surnameController.text.isNotEmpty &&
          tcknVknController.text.isNotEmpty &&
          emailController.text.isNotEmpty;
    } else if (userType == "Responsible") {
      _isButtonEnabled = nameController.text.isNotEmpty &&
          surnameController.text.isNotEmpty &&
          tcknVknController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          purchaseGroupController.text.isNotEmpty &&
          telNumberController.text.isNotEmpty &&
          faxNumberController.text.isNotEmpty &&
          responsibleController.text.isNotEmpty &&
          int.tryParse(telNumberController.text) != null &&
          int.tryParse(faxNumberController.text) != null &&
          int.tryParse(responsibleController.text) != null; // Kontrollere int dönüşüm ekleniyor
    } else {
      _isButtonEnabled = false;
    }
        debugPrint("Name: ${nameController.text}");
    debugPrint("Surname: ${surnameController.text}");
    debugPrint("TCKN/VKN: ${tcknVknController.text}");
    debugPrint("Email: ${emailController.text}");
    debugPrint("Purchase Group: ${purchaseGroupController.text}");
    debugPrint("Tel Number: ${telNumberController.text}");
    debugPrint("Fax Number: ${faxNumberController.text}");
    debugPrint("Responsible: ${responsibleController.text}");
    debugPrint("Tel Valid: ${int.tryParse(telNumberController.text) != null}");
    debugPrint("Fax Valid: ${int.tryParse(faxNumberController.text) != null}");
    debugPrint("Responsible Valid: ${int.tryParse(responsibleController.text) != null}");
  });
}

    Future<void> handleAddUser() async {
    String? tckn;
    String? vkn;
    final tcknVknValue = tcknVknController.text.trim();
    final email = emailController.text.trim();

    if (tcknVknValue.length == 11) {
      tckn = tcknVknValue;
      vkn = null;
    } else if (tcknVknValue.length == 10) {
      vkn = tcknVknValue;
      tckn = null;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen geçerli bir TCKN veya VKN girin!")),
      );
      return;
    }

    String result;
    if(userType == "Vendor"){
      result = await UserService.addUser(
        userType: userType,
        name: nameController.text.trim(),
        surname: surnameController.text.trim(),
        tckn: tckn,
        vkn: vkn,
        email: email,
        password: '',
    );
    } else if(userType == "Responsible"){
      result = await UserService.addUser(
        name: nameController.text.trim(),
        surname: surnameController.text.trim(), 
        email: email, 
        password: '', 
        userType: userType,
        purchaseGroup: purchaseGroupController.text.trim(),
        telNumber: int.tryParse(telNumberController.text.trim()),
        faxNumber: int.tryParse(faxNumberController.text.trim()),
        responsible: int.tryParse(responsibleController.text.trim()),
        );
    }else {
      result = "Geçersiz Kullanıcı Türü!";
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));

    if (result == "Kullanıcı başarıyla eklendi!") {
      clearFields();
    }
  }

  void clearFields() {
    nameController.clear();
    surnameController.clear();
    tcknVknController.clear();
    emailController.clear();
  }


  Future<void> sendActivationLink() async {
  final vknTckn = tcknVknController.text;
  final email = emailController.text;

  if (!isValidEmail(email)) {
    _showMessage("Lütfen geçerli bir e-posta adresi girin.", Colors.red);
    return;
  } else if (!isValidTcOrVkn(vknTckn)) {
    _showMessage("Lütfen geçerli bir TC Kimlik No veya VKN girin.", Colors.red);
    return;
  }

  String? activationToken = await UserService.getActivationToken(email: email);

  _showMessage("Aktivasyon bağlantısı başarıyla gönderildi!", Colors.green);
  print("Alınan Aktivasyon Token: $activationToken"); 
}

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegExp.hasMatch(email);
  }

  bool isValidTcOrVkn(String value) {
    return value.length >= 10 && RegExp(r'^[0-9]+$').hasMatch(value);
  }

  void _showMessage(String message, Color color) {
    setState(() {
      _message = message;
      _messageColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    double formHeight = 500; 
    if (userType == "Responsible") {
      formHeight = 700;
    }

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/login_image.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 500,
                            minHeight: constraints.maxHeight, 
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 12,
                                  spreadRadius: 4,
                                  color: Colors.grey.withOpacity(0.25),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Yeni Kullanıcı Oluştur",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: RadioListTile<String>(
                                        title: const Text("Satıcı Kaydı"),
                                        value: "Vendor",
                                        groupValue: userType,
                                        onChanged: (value) {
                                          setState(() {
                                            userType = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioListTile<String>(
                                        title: const Text("Sorumlu Kaydı"),
                                        value: "Responsible",
                                        groupValue: userType,
                                        onChanged: (value) {
                                          setState(() {
                                            userType = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: nameController,
                                  onChanged: (_) => _checkFields(),
                                  decoration: const InputDecoration(
                                    labelText: "İsim",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                TextField(
                                  controller: surnameController,
                                  onChanged: (_) => _checkFields(),
                                  decoration: const InputDecoration(
                                    labelText: "Soyisim",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                TextField(
                                  controller: tcknVknController,
                                  onChanged: (_) => _checkFields(),
                                  keyboardType: TextInputType.number,
                                  maxLength: 11,
                                  decoration: const InputDecoration(
                                    labelText: "T.C. Kimlik No veya Vergi Kimlik No",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: emailController,
                                  onChanged: (_) => _checkFields(),
                                  decoration: const InputDecoration(
                                    labelText: "E-Posta",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                if (userType == "Responsible") ...[
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: purchaseGroupController,
                                    onChanged: (_) => _checkFields(),
                                    decoration: const InputDecoration(
                                      labelText: "Satın Alma Grubu",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: telNumberController,
                                    onChanged: (_) => _checkFields(),
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: "Telefon Numarası",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: faxNumberController,
                                    onChanged: (_) => _checkFields(),
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: "Faks Numarası",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: responsibleController,
                                    onChanged: (_) => _checkFields(),
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: "Sorumlu",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_isButtonEnabled) {
                                      await handleAddUser();
                                      await sendActivationLink();
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Lütfen tüm alanları doldurun!")),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(double.infinity, 48),
                                    backgroundColor: _isButtonEnabled ? Colors.blue : Colors.grey,
                                  ),
                                  child: const Text("Kayıt Ol"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}