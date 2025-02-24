import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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

  void _loadUserIdAndFetchData() async {
    final prefs = TokenSharedPrefs(await SharedPreferences.getInstance());
    final result = await prefs.getUserId();

    result.fold(
      (failure) {
        print("Error fetching user ID: ${failure.message}");
      },
      (id) {
        setState(() {
          userId = id;
        });
        context.read<AccountBloc>().add(LoadAccount(userId));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state.isLoggedOut) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (route) => false,
          );
        }

        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        body: BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null) {
              return Center(child: Text('Error: ${state.error}'));
            }

            if (state.account == null) {
              return const Center(child: Text('No account data available'));
            }

            final account = state.account!;

            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SafeArea(
                      child: Column(
                        children: [
                          // Logo
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
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl:
                                    "http://10.0.2.2:5000/api/uploads/users/${account.avatar}",
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'assets/default_avatar.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Name
                          Text(
                            account.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Email
                          Text(
                            account.email,
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),

                          // Address if available
                          if (account.address != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_on,
                                    color: Colors.grey[600]),
                                Text(
                                  account.address!,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),

                          const SizedBox(height: 8),

                          // Member since
                          Text(
                            'Member since: ${DateFormat('MMMM yyyy').format(account.createdAt)}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),

                          // Stats
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStat('Books Listed',
                                    account.bookListings.length.toString()),
                                _buildStat('Favorites',
                                    account.favorites.length.toString()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Edit Profile Button
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement edit profile
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.black87,
                      ),
                      child: const Text('Edit Profile'),
                    ),

                    const SizedBox(height: 10),

                    // Logout Button
                    OutlinedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Logout'),
                            content:
                                const Text('Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  context
                                      .read<AccountBloc>()
                                      .add(LogoutRequested());
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
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
