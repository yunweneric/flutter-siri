part of 'speech_bloc.dart';

class SpeechEvent {}

class InitializeSpeechEvent extends SpeechEvent {}

class StartListeningEvent extends SpeechEvent {}

class ListeningEvent extends SpeechEvent {
  final SpeechRecognitionResult result;

  ListeningEvent(this.result);
}

class StopListeningEvent extends SpeechEvent {}
