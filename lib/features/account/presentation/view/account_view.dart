import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_reads/app/shared_prefs/token_shared_prefs.dart';
import 'package:revive_reads/features/account/presentation/view_model/account_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  late String userId;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetchData();
  }

  // Fetch userId from SharedPreferences and dispatch event
  void _loadUserIdAndFetchData() async {
    final prefs = TokenSharedPrefs(await SharedPreferences.getInstance());
    final result = await prefs.getUserId();

    result.fold(
      (failure) {
        // Handle error, maybe navigate to login
        print("Error fetching user ID: ${failure.message}");
      },
      (id) {
        setState(() {
          userId = id;
        });

        // Dispatch the event to load user data
        context.read<AccountBloc>().add(LoadUser(userId));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          // Show loading indicator while data is being fetched
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error message if there's an error
          if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }

          // Display user data if loaded
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SafeArea(
                    child: Column(
                      children: [
                        // Logo aligned to the left
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/logo/Logo1.png',
                              height: 40,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Profile Image
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            "http://10.0.2.2:5000/api/uploads/users/${state.user.avatar}",
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Name
                        Text(
                          state.user.fullName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Email
                        Text(
                          state.user.email,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),

                        // Location
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on, color: Colors.grey[600]),
                            Text(
                              state.user.address ?? 'N/A',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Member since
                        Text(
                          'Member since: ${state.user.address}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Buttons
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.black87,
                    ),
                    child: const Text('Edit Profile'),
                  ),

                  const SizedBox(height: 10),

                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ActionButton(
                        text: 'Ad Posts',
                        isSelected: true,
                        onTap: () {},
                      ),
                      ActionButton(
                        text: 'Sold',
                        onTap: () {},
                      ),
                      ActionButton(
                        text: 'Save Lists',
                        onTap: () {},
                      ),
                      ActionButton(
                        text: 'Analytics',
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Books',
                        border: InputBorder.none,
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.text,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black87 : Colors.white,
          border: Border.all(color: Colors.black87),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
