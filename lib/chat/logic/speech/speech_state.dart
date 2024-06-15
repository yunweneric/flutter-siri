part of 'speech_bloc.dart';

class SpeechState {
  final bool speechEnabled;
  final SpeechRecognitionResult? speechRecognitionResult;

  SpeechState({this.speechRecognitionResult, required this.speechEnabled});
}

class SpeechInitial extends SpeechState {
  SpeechInitial({required super.speechEnabled, super.speechRecognitionResult});
}

class StartListeningToUser extends SpeechState {
  StartListeningToUser({super.speechRecognitionResult, required super.speechEnabled});
}

class ListeningToUser extends SpeechState {
  ListeningToUser({super.speechRecognitionResult, required super.speechEnabled});
}

class StopListening extends SpeechState {
  StopListening({required super.speechEnabled});
}
