import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:revive_reads/view/bottom_navigation_view/account_view.dart';
import 'package:revive_reads/view/bottom_navigation_view/chats_view.dart';
import 'package:revive_reads/view/bottom_navigation_view/home_view.dart';
import 'package:revive_reads/view/bottom_navigation_view/my_ads_view.dart';
import 'package:revive_reads/view/bottom_navigation_view/sell_view.dart';

class BottomNavigationView extends StatefulWidget {
  const BottomNavigationView({super.key});

  @override
  State<BottomNavigationView> createState() => _BottomNavigationViewState();
}

class _BottomNavigationViewState extends State<BottomNavigationView> {
  int _selectedIndex = 0;
  final List<Widget> lstBottomScreen = [
    const HomeView(),
    const ChatsView(),
    const SellView(),
    const MyAdsView(),
    const AccountView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Bottom Navigation View"),
      //   centerTitle: true,
      //   backgroundColor: Colors.grey,
      // ),
      body: SafeArea(child: lstBottomScreen[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 28,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(BoxIcons.bxs_home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(BoxIcons.bxs_message_square_dots),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: SizedBox.shrink(), // Empty item for the floating button
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(BoxIcons.bxs_bookmark_minus),
            label: 'My ads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black45,
        currentIndex: _selectedIndex,
        onTap: (index) {
          // Skip the middle button index (2) when tapping the BottomNavigationBar
          if (index != 2) {
            _onItemTapped(index);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _selectedIndex = 2; // Navigate to the SellView when FAB is pressed
          });
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
