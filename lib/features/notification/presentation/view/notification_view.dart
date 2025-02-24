import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_reads/app/di/di.dart';
import 'package:revive_reads/features/notification/domain/entity/notification_entity.dart';
import 'package:revive_reads/features/notification/presentation/view_model/notification_bloc.dart';
import 'package:revive_reads/features/notification/presentation/view_model/notification_event.dart';
import 'package:revive_reads/features/notification/presentation/view_model/notification_state.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<NotificationBloc>()..add(FetchNotificationsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          actions: [
            BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                if (state is NotificationLoaded &&
                    state.notifications.any((n) => !n.isRead)) {
                  return TextButton(
                    onPressed: () {
                      context
                          .read<NotificationBloc>()
                          .add(MarkNotificationsAsReadEvent());
                    },
                    child: const Text('Mark all as read'),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NotificationError) {
              return Center(child: Text(state.message));
            }

            if (state is NotificationLoaded) {
              if (state.notifications.isEmpty) {
                return const Center(
                  child: Text('No notifications'),
                );
              }

              return ListView.builder(
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return _buildNotificationItem(notification);
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildNotificationItem(NotificationEntity notification) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: notification.isRead
            ? Colors.grey.withOpacity(0.2)
            : Colors.blue.withOpacity(0.2),
        child: Icon(
          _getNotificationIcon(notification.type),
          color: notification.isRead ? Colors.grey : Colors.blue,
        ),
      ),
      title: Text(
        notification.message,
        style: TextStyle(
          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Text(
        _getTimeAgo(notification.createdAt),
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      tileColor: notification.isRead ? null : Colors.blue.withOpacity(0.05),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'book_approval':
        return Icons.book;
      case 'message':
        return Icons.message;
      default:
        return Icons.notifications;
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
