import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:revive_reads/features/message/domain/repositiry/message_repository.dart';
import 'package:revive_reads/features/message/domain/use_case/get_messages_usecase.dart';
import 'package:revive_reads/features/message/domain/use_case/get_unread_message_count_usecase.dart';
import 'package:revive_reads/features/message/domain/use_case/init_socket_usecase.dart';
import 'package:revive_reads/features/message/domain/use_case/send_message_usecase.dart';
import 'package:revive_reads/features/message/presentation/view_model/message_event.dart';
import 'package:revive_reads/features/message/presentation/view_model/message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final GetUnreadMessageCountUseCase _getUnreadMessageCountUseCase;
  final InitSocketUseCase _initSocketUseCase;
  final IMessageRepository _messageRepository;

  MessageBloc({
    required GetMessagesUseCase getMessagesUseCase,
    required SendMessageUseCase sendMessageUseCase,
    required GetUnreadMessageCountUseCase getUnreadMessageCountUseCase,
    required InitSocketUseCase initSocketUseCase,
    required IMessageRepository messageRepository,
  })  : _getMessagesUseCase = getMessagesUseCase,
        _sendMessageUseCase = sendMessageUseCase,
        _getUnreadMessageCountUseCase = getUnreadMessageCountUseCase,
        _initSocketUseCase = initSocketUseCase,
        _messageRepository = messageRepository,
        super(const MessageState()) {
    on<InitializeSocketEvent>(_onInitializeSocket);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<GetUnreadCountEvent>(_onGetUnreadCount);
    on<NewMessageReceivedEvent>(_onNewMessageReceived);
    on<UpdateOnlineUsersEvent>(_onUpdateOnlineUsers);
  }

  Future<void> _onInitializeSocket(
    InitializeSocketEvent event,
    Emitter<MessageState> emit,
  ) async {
    _initSocketUseCase(event.userId);

    // Listen for new messages via socket
    _messageRepository.listenForNewMessages((newMessage) {
      add(NewMessageReceivedEvent(newMessage));
    });

    // Listen for online users
    _messageRepository.listenForOnlineUsers((onlineUsers) {
      add(UpdateOnlineUsersEvent(onlineUsers));
    });

    // Get initial unread count
    add(GetUnreadCountEvent());
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<MessageState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _getMessagesUseCase(event.userId);

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (messages) => emit(state.copyWith(
        isLoading: false,
        messages: messages,
      )),
    );
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    final result = await _sendMessageUseCase(
      event.receiverId,
      event.message,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        error: failure.message,
      )),
      (newMessage) {
        final updatedMessages = [...state.messages, newMessage];
        emit(state.copyWith(
          messages: updatedMessages,
        ));
      },
    );
  }

  Future<void> _onGetUnreadCount(
    GetUnreadCountEvent event,
    Emitter<MessageState> emit,
  ) async {
    final result = await _getUnreadMessageCountUseCase();

    result.fold(
      (failure) => null, // Don't update state if failed
      (unreadCount) => emit(state.copyWith(
        unreadCount: unreadCount,
      )),
    );
  }

  void _onNewMessageReceived(
    NewMessageReceivedEvent event,
    Emitter<MessageState> emit,
  ) {
    final updatedMessages = [...state.messages, event.message];
    emit(state.copyWith(
      messages: updatedMessages,
    ));

    // Also update unread count
    add(GetUnreadCountEvent());
  }

  void _onUpdateOnlineUsers(
    UpdateOnlineUsersEvent event,
    Emitter<MessageState> emit,
  ) {
    emit(state.copyWith(
      onlineUsers: event.onlineUsers,
    ));
  }

  @override
  Future<void> close() {
    _messageRepository.disconnectSocket();
    return super.close();
  }
}
