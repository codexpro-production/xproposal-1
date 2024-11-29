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

  void _checkFields() {
    setState(() {
      _isButtonEnabled = nameController.text.isNotEmpty &&
          surnameController.text.isNotEmpty &&
          tcknVknController.text.isNotEmpty &&
          emailController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    double formHeight = 500; // Default height for Vendor
    if (userType == "Responsible") {
      formHeight = 700; // Adjust for Responsible
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
                            minHeight: constraints.maxHeight, // Adjust to screen height
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

                                // Toggle Buttons for User Type
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

                                // Common Fields
                                TextField(
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                    labelText: "İsim",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                TextField(
                                  controller: surnameController,
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

                                // Conditionally Render Additional Fields for "Responsible"
                                if (userType == "Responsible") ...[
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: purchaseGroupController,
                                    decoration: const InputDecoration(
                                      labelText: "Satın Alma Grubu",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: telNumberController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: "Telefon Numarası",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: faxNumberController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: "Faks Numarası",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: responsibleController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: "Sorumlu",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 24),

                                // Submit Button
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_isButtonEnabled) {
                                      // Call handleAddUser() from previous code
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
