part of 'chat_bloc.dart';

@immutable
class ChatEvent {}

class InitializeChat extends ChatEvent {}

class SendChat extends ChatEvent {
  final String text;

  SendChat({required this.text});
}
