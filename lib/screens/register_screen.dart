import 'package:flutter/material.dart';
import '../services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController tcknVknController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController purchaseGroupController = TextEditingController();
  final TextEditingController telNumberController = TextEditingController();
  final TextEditingController faxNumberController = TextEditingController();
  final TextEditingController responsibleController = TextEditingController();

  String userType = '';
  String? _message;
  Color _messageColor = Colors.green;
  bool _isButtonEnabled = false;

  void _checkFields() {
    setState(() {
      _isButtonEnabled = _formKey.currentState?.validate() ?? false;
    });
  }

  Future<void> handleAddUser() async {
    final tcknVknValue = tcknVknController.text.trim();
    String? tckn = tcknVknValue.length == 11 ? tcknVknValue : null;
    String? vkn = tcknVknValue.length == 10 ? tcknVknValue : null;

    if (tckn == null && vkn == null) {
      _showMessage("Geçerli bir TCKN veya VKN girin!", Colors.red);
      return;
    }

    try {
      final result = await UserService.addUser(
        userType: userType,
        name: nameController.text.trim(),
        surname: surnameController.text.trim(),
        tckn: tckn,
        vkn: vkn,
        email: emailController.text.trim(),
        password: '',
        purchaseGroup: userType == "Responsible" ? purchaseGroupController.text.trim() : null,
        telNumber: userType == "Responsible" ? int.tryParse(telNumberController.text.trim()) : null,
        faxNumber: userType == "Responsible" ? int.tryParse(faxNumberController.text.trim()) : null,
        responsible: userType == "Responsible" ? int.tryParse(responsibleController.text.trim()) : null,
      );

      _showMessage(result, Colors.green);

      if (result == "Kullanıcı başarıyla eklendi!") {
        clearFields();
      }
    } catch (error) {
      _showMessage(error.toString(), Colors.red);
    }
  }

  void _showMessage(String message, Color color) {
    setState(() {
      _message = message;
      _messageColor = color;
    });
  }

  void clearFields() {
    nameController.clear();
    surnameController.clear();
    tcknVknController.clear();
    emailController.clear();
    purchaseGroupController.clear();
    telNumberController.clear();
    faxNumberController.clear();
    responsibleController.clear();
    setState(() {
      _isButtonEnabled = false;
      userType = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = MediaQuery.of(context).size.width;

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
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05), // 5% of the screen width
                          child: FractionallySizedBox(
                            widthFactor: 0.9, // Makes the card occupy 90% of the screen width
                            child: Card(
                              elevation: 4, // Adds shadow to the card
                              color: Colors.white, // White background color for the card
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // Rounded corners
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Form(
                                  key: _formKey,
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
                                              title: const Text("Satıcı"),
                                              value: "Vendor",
                                              groupValue: userType,
                                              onChanged: (value) {
                                                setState(() {
                                                  userType = value!;
                                                  _checkFields();
                                                });
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: RadioListTile<String>(
                                              title: const Text("Sorumlu"),
                                              value: "Responsible",
                                              groupValue: userType,
                                              onChanged: (value) {
                                                setState(() {
                                                  userType = value!;
                                                  _checkFields();
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        controller: nameController,
                                        decoration: const InputDecoration(labelText: "İsim", border: OutlineInputBorder()),
                                        validator: (value) => value != null && value.isEmpty ? "İsim boş olamaz." : null,
                                        onChanged: (_) => _checkFields(),
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        controller: surnameController,
                                        decoration: const InputDecoration(labelText: "Soyisim", border: OutlineInputBorder()),
                                        validator: (value) => value != null && value.isEmpty ? "Soyisim boş olamaz." : null,
                                        onChanged: (_) => _checkFields(),
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        controller: tcknVknController,
                                        decoration: const InputDecoration(
                                          labelText: "T.C. Kimlik No veya Vergi Kimlik No",
                                          border: OutlineInputBorder(),
                                        ),
                                        keyboardType: TextInputType.number,
                                        maxLength: 11,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Bu alan boş olamaz.";
                                          }
                                          if (!(value.length == 10 || value.length == 11)) {
                                            return "TCKN 11, VKN 10 haneli olmalıdır.";
                                          }
                                          if (!RegExp(r'^\d+$').hasMatch(value)) {
                                            return "Sadece rakamlar kullanılabilir.";
                                          }
                                          return null;
                                        },
                                        onChanged: (_) => _checkFields(),
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        controller: emailController,
                                        decoration: const InputDecoration(labelText: "E-Posta", border: OutlineInputBorder()),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "E-Posta boş olamaz.";
                                          }
                                          final emailRegExp = RegExp(
                                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
                                          if (!emailRegExp.hasMatch(value)) {
                                            return "Geçerli bir e-posta girin.";
                                          }
                                          return null;
                                        },
                                        onChanged: (_) => _checkFields(),
                                      ),
                                      if (userType == "Responsible") ...[
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          controller: purchaseGroupController,
                                          decoration: const InputDecoration(labelText: "Satın Alma Grubu", border: OutlineInputBorder()),
                                          validator: (value) => value != null && value.isEmpty ? "Bu alan boş olamaz." : null,
                                          onChanged: (_) => _checkFields(),
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          controller: telNumberController,
                                          decoration: const InputDecoration(labelText: "Telefon", border: OutlineInputBorder()),
                                          validator: (value) => value != null && value.isEmpty ? "Bu alan boş olamaz." : null,
                                          keyboardType: TextInputType.number,
                                          onChanged: (_) => _checkFields(),
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          controller: faxNumberController,
                                          decoration: const InputDecoration(labelText: "Faks", border: OutlineInputBorder()),
                                          validator: (value) => value != null && value.isEmpty ? "Bu alan boş olamaz." : null,
                                          keyboardType: TextInputType.number,
                                          onChanged: (_) => _checkFields(),
                                        ),
                                        const SizedBox(height: 16),
                                        TextFormField(
                                          controller: responsibleController,
                                          decoration: const InputDecoration(labelText: "Sorumlu", border: OutlineInputBorder()),
                                          validator: (value) => value != null && value.isEmpty ? "Bu alan boş olamaz." : null,
                                          keyboardType: TextInputType.number,
                                          onChanged: (_) => _checkFields(),
                                        ),
                                      ],
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: _isButtonEnabled ? handleAddUser : null,
                                        child: const Text("Kullanıcı Ekle"),
                                      ),
                                      if (_message != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 16),
                                          child: Text(
                                            _message!,
                                            style: TextStyle(color: _messageColor, fontSize: 16),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
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
