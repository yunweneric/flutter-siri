import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_openui/core/config.dart';
import 'package:meta/meta.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial(apiKey: AppConfig.apiKey)) {
    on<InitializeChat>((event, emit) async {
      final apiKey = AppConfig.apiKey;
      ChatInitial(apiKey: apiKey);
    });
    on<SendChat>((event, emit) async {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: state.apiKey!);
      File image = File('asset/image/photo.png');
      final bytes = await image.readAsBytes();
      final content = [Content.data("mimeType", bytes)];
      final response = await model.generateContent(content);
      print(response);
      // final content = [Content.system(instructions)];
      // final content = [Content.text(event.text)];

      generateContent() async {
        final model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: state.apiKey!,
        );
        final prompt = 'Write a story about a magic backpack.';
        final content = [Content.text(prompt)];
        final response = await model.generateContent(content);
        print(response.text);
      }
    });
  }
}
