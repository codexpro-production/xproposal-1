// import 'package:flutter/material.dart';
// import '../services/user_service.dart'; // Servis sınıfını import edin

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   // Kullanıcı girdilerini tutacak TextEditingController'lar
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController surnameController = TextEditingController();
//   final TextEditingController tcknVknController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   Future<void> handleAddUser() async {
//     // TCKN veya VKN kontrolü
//     String? tckn;
//     String? vkn;
//     final tcknVknValue = tcknVknController.text.trim();

//     if (tcknVknValue.length == 11) {
//       tckn = tcknVknValue;
//       vkn = null;
//     } else if (tcknVknValue.length == 10) {
//       vkn = tcknVknValue;
//       tckn = null;
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Lütfen geçerli bir TCKN veya VKN girin!")),
//       );
//       return;
//     }

//     // `UserService` sınıfını kullanarak API çağrısını yapın
//     String result = await UserService.addUser(
//       name: nameController.text.trim(),
//       surname: surnameController.text.trim(),
//       tckn: tckn,
//       vkn: vkn,
//       email: passwordController.text.trim(),
//     );

//     // Kullanıcıya sonucu göster
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));

//     // Başarılıysa alanları temizle
//     if (result == "Kullanıcı başarıyla eklendi!") {
//       _clearFields();
//     }
//   }

//   void _clearFields() {
//     nameController.clear();
//     surnameController.clear();
//     tcknVknController.clear();
//     passwordController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Kullanıcı Kayıt Ekranı"),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(
//                 labelText: "İsim",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             TextField(
//               controller: surnameController,
//               decoration: const InputDecoration(
//                 labelText: "Soyisim",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             TextField(
//               controller: tcknVknController,
//               keyboardType: TextInputType.number,
//               maxLength: 11,
//               decoration: const InputDecoration(
//                 labelText: "TCKN veya VKN",
//                 border: OutlineInputBorder(),
//                 hintText: "10 haneli (VKN) veya 11 haneli (TCKN)",
//               ),
//             ),
//             const SizedBox(height: 16.0),
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: const InputDecoration(
//                 labelText: "Şifre",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 24.0),
//             ElevatedButton(
//               onPressed: () async {
//                 if (nameController.text.isEmpty ||
//                     surnameController.text.isEmpty ||
//                     tcknVknController.text.isEmpty ||
//                     passwordController.text.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("Lütfen tüm alanları doldurun!")),
//                   );
//                   return;
//                 }
//                 await handleAddUser();
//               },
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size(double.infinity, 48),
//               ),
//               child: const Text("Kullanıcı Ekle"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     // Bellek sızıntılarını önlemek için controller'ları temizleyin
//     nameController.dispose();
//     surnameController.dispose();
//     tcknVknController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
// }
