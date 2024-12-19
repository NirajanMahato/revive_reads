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
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
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
      floatingActionButton: isKeyboardVisible
          ? null // Hide FAB when the keyboard is visible
          : FloatingActionButton(
              onPressed: () {
                // Push to the SellView as a new page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SellView()),
                );
              },
              backgroundColor: Colors.black,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
