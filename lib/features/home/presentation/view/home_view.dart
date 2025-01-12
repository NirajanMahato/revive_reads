import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:revive_reads/features/home/presentation/view/bottom_view/sell_view.dart';
import 'package:revive_reads/features/home/presentation/view_model/home_cubit.dart';
import 'package:revive_reads/features/home/presentation/view_model/home_state.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
        return state.views.elementAt(state.selectedIndex);
      }),
      bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
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
            currentIndex: state.selectedIndex,
            onTap: (index) {
              context.read<HomeCubit>().onTabTapped(index);
            },
          );
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
