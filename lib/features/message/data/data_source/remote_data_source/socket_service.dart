import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:revive_reads/app/constants/api_endpoints.dart';
import 'package:revive_reads/features/message/data/model/message_model.dart';

class SocketService {
  IO.Socket? socket;
  String? userId;

  // Singleton pattern
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  // Initialize socket connection
  void initSocket(String userId) {
    this.userId = userId;
    socket = IO.io(
      ApiEndpoints.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({'userId': userId})
          .build(),
    );

    socket!.connect();
    socket!.onConnect((_) {
      print('Socket connected: ${socket!.id}');
    });

    socket!.onDisconnect((_) {
      print('Socket disconnected');
    });

    socket!.onConnectError((error) {
      print('Socket connection error: $error');
    });
  }

  // Listen for new messages
  void onNewMessage(Function(MessageModel) callback) {
    socket?.on('newMessage', (data) {
      callback(MessageModel.fromJson(data));
    });
  }

  // Listen for unread message updates
  void onUpdateUnreadMessages(Function(bool) callback) {
    socket?.on('updateUnreadMessages', (data) {
      callback(data);
    });
  }

  // Listen for online users
  void onOnlineUsers(Function(List<String>) callback) {
    socket?.on('getOnlineUsers', (data) {
      List<String> onlineUsers = List<String>.from(data);
      callback(onlineUsers);
    });
  }

  // Disconnect socket
  void disconnect() {
    socket?.disconnect();
    socket = null;
  }

  // Check if socket is connected
  bool isConnected() {
    return socket?.connected ?? false;
  }
}