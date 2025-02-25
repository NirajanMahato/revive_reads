import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_reads/app/constants/api_endpoints.dart';
import 'package:revive_reads/app/shared_prefs/token_shared_prefs.dart';
import 'package:revive_reads/features/message/presentation/view/chat_screen.dart';
import 'package:revive_reads/features/message/presentation/view_model/message_bloc.dart';
import 'package:revive_reads/features/message/presentation/view_model/message_event.dart';
import 'package:revive_reads/features/message/presentation/view_model/message_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageView extends StatefulWidget {
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  String? userId;
  bool isLoading = true;
  List<UserBrief> conversationUsers = [];

  @override
  void initState() {
    super.initState();
    _loadUserIdAndInitSocket();
  }

  void _loadUserIdAndInitSocket() async {
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
        context.read<MessageBloc>().add(InitializeSocketEvent(id));
        _loadConversationUsers();
      },
    );
  }

  Future<void> _loadConversationUsers() async {
    setState(() {
      isLoading = true;
    });

    final users = await getUserList();

    setState(() {
      conversationUsers = users;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: userId == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Unread message count display
                BlocBuilder<MessageBloc, MessageState>(
                  builder: (context, state) {
                    if (state.unreadCount > 0) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        color: Colors.blue.shade50,
                        child: Row(
                          children: [
                            const Icon(Icons.mail, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(
                              'You have ${state.unreadCount} unread message${state.unreadCount > 1 ? 's' : ''}',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                // User List For chat
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : conversationUsers.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.message_outlined,
                                    size: 64,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No conversations yet',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Start by messaging a book seller',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadConversationUsers,
                              child: ListView.builder(
                                itemCount: conversationUsers.length,
                                itemBuilder: (context, index) {
                                  final user = conversationUsers[index];
                                  return _buildConversationItem(user);
                                },
                              ),
                            ),
                ),
              ],
            ),
    );
  }

  Widget _buildConversationItem(UserBrief user) {
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: 'http://10.0.2.2:5000/api/uploads/users/${user.avatar}',
        imageBuilder: (context, imageProvider) => CircleAvatar(
          backgroundImage: imageProvider,
        ),
        placeholder: (context, url) => const CircleAvatar(
          child: Icon(Icons.person),
        ),
        errorWidget: (context, url, error) => const CircleAvatar(
          child: Icon(Icons.person),
        ),
      ),
      title: Text(
        user.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          // Find the last message for this user
          final lastMessage = state.messages
              .where(
                  (msg) => msg.senderId == user.id || msg.receiverId == user.id)
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (lastMessage.isNotEmpty) {
            final message = lastMessage.first;
            final isUnread = message.receiverId == userId && !message.read;

            return Text(
              message.message,
              style: TextStyle(
                fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                color: isUnread ? Colors.black : Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          }

          return const Text('No messages yet');
        },
      ),
      trailing: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          // Check if user is online
          final isOnline = state.onlineUsers.contains(user.id);

          // Check for unread messages
          final unreadMessages = state.messages
              .where((msg) =>
                  msg.senderId == user.id &&
                  msg.receiverId == userId &&
                  !msg.read)
              .length;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (unreadMessages > 0)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadMessages.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                )
              else
                const SizedBox(height: 20),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOnline ? Colors.green : Colors.grey,
                ),
              ),
            ],
          );
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiverId: user.id,
              receiverName: user.name,
              receiverAvatar: user.avatar,
            ),
          ),
        );
      },
    );
  }

  // This method would fetch users from your backend
  Future<List<UserBrief>> getUserList() async {
    try {
      final prefs = TokenSharedPrefs(await SharedPreferences.getInstance());
      final tokenResult = await prefs.getToken();

      return tokenResult.fold(
        (failure) {
          print("Error fetching token: ${failure.message}");
          return [];
        },
        (token) async {
          try {
            final response = await Dio().get(
              '${ApiEndpoints.baseUrl}user/get-users-for-sidebar',
              options: Options(
                headers: {'Authorization': 'Bearer $token'},
              ),
            );

            if (response.statusCode == 200) {
              final List<dynamic> usersJson = response.data;
              return usersJson
                  .map((json) => UserBrief(
                        id: json['_id'],
                        name: json['name'],
                        email: json['email'] ?? '',
                        avatar: json['avatar'] ?? 'default_avatar.png',
                      ))
                  .toList();
            } else {
              throw Exception('Failed to load conversation users');
            }
          } catch (e) {
            print('Error fetching conversation users: $e');
            return [];
          }
        },
      );
    } catch (e) {
      print('Error in getUserList: $e');
      return [];
    }
  }
}

// A simple class to hold user information for the chat list
class UserBrief {
  final String id;
  final String name;
  final String email;
  final String avatar;

  UserBrief({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });
}
