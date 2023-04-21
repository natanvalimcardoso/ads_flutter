import 'package:admob_flutter/modules/rewards/rewards_page.dart';
import 'package:flutter/material.dart';

import 'banner/banne_page.dart';
import 'in_app_purchase/in_app_purchase_page.dart';
import 'interstitial/interstitial_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const BannePage(),
    const InAppPurchasePage(),
    const InterstitialPage(),
    const RewardsPage(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddMob'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Banner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'InAppPurchase',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Interstitial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: ' Rewards',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _getSelectedColor(_selectedIndex),
        onTap: _onItemTapped,
      ),
    );
  }
}

Color _getSelectedColor(int index) {
  switch (index) {
    case 0:
      return Colors.amber[800]!;
    case 1:
      return Colors.blue;
    case 2:
      return Colors.green;
    case 3:
      return Colors.red;
    case 4:
      return Colors.purple;
    default:
      return Colors.amber[800]!;
  }
}
