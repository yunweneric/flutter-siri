import 'package:flutter_openui/chat/logic/chat/chat_bloc.dart';
import 'package:flutter_openui/chat/logic/speech/speech_bloc.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static void register() {
    final speechBloc = SpeechBloc();
    final chatBloc = ChatBloc();
    getIt.registerSingleton<SpeechBloc>(speechBloc);
    getIt.registerSingleton<ChatBloc>(chatBloc);
    print("Services registered!");
  }
}
