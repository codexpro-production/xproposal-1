import 'package:flutter/material.dart';

class XProposalScreen extends StatelessWidget {
  const XProposalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('XProposal'),
        actions: [
          // Kullanıcı adı ve menü
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'settings') {
                // Ayarlara git
                print('Ayarlar sayfasına git');
              } else if (value == 'logout') {
                // Çıkış yap
                _logout(context);
              } else if (value == 'offers') {
                // Tekliflerime git
                print('Tekliflerime git');
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'offers',
                  child: Text('Tekliflerim'),
                ),
                const PopupMenuItem<String>(
                  value: 'settings',
                  child: Text('Ayarlar'),
                ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Çıkış Yap'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: Center(
                child: Text(
                  'Tekliflerinizi Yapınız',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 6, 
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/product${index + 1}.jpg',
                          fit: BoxFit.cover,
                          height: 150,
                          width: double.infinity,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ürün ${index + 1}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(index + 1) * 100} EUR',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Fiyat Girişi',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/');
  }
}
