part of 'chat_bloc.dart';

@immutable
class ChatState {
  final String? apiKey;
  ChatState({this.apiKey});
}

class ChatInitial extends ChatState {
  ChatInitial({required super.apiKey});
}

class ChatSendLoading extends ChatState {
  ChatSendLoading({super.apiKey});
}

class ChatSendError extends ChatState {
  ChatSendError({super.apiKey});
}

class ChatSendSuccess extends ChatState {
  final GenerateContentResponse response;
  ChatSendSuccess({required this.response, super.apiKey});
}
