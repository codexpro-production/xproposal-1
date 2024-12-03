import 'package:flutter/material.dart';
import 'vendor_list_screen.dart'; 
import 'purchase_responsible_list_screen.dart';
import 'pdf_printer_screen.dart';

class XProposalScreen extends StatefulWidget {
  const XProposalScreen({super.key});

  @override
  State<XProposalScreen> createState() => _XProposalScreenState();
}

class _XProposalScreenState extends State<XProposalScreen> {
  int _selectedPage = 0;

  final List<Widget> _pages = [
    const ProposalContent(), 
    const VendorListScreen(),
    const PurchaseResponsibleScreen(),
    const PDFPrinterScreen(), 
  ];

  void _onSelectMenu(int index) {
    setState(() {
      _selectedPage = index;
    });
    Navigator.pop(context); // Drawer'ı kapatır.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('XProposal'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'settings') {
                print('Ayarlar sayfasına git');
              } else if (value == 'logout') {
                _logout(context);
              } else if (value == 'offers') {
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menü',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Ana Sayfa'),
              onTap: () => _onSelectMenu(0),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Satıcı Listesi'),
              onTap: () => _onSelectMenu(1),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Satın Alma Sorumlusu Listesi'),
              onTap: () => _onSelectMenu(2),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('İlan Bilgileri'),
              onTap: () => _onSelectMenu(3),
            ),
          ],
        ),
      ),
      body: _pages[_selectedPage],
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/');
  }
}

class ProposalContent extends StatelessWidget {
  const ProposalContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}