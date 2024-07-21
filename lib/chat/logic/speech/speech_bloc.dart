import 'package:bloc/bloc.dart';
import 'package:flutter_openui/chat/logic/chat/chat_bloc.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

part 'speech_event.dart';
part 'speech_state.dart';

class SpeechBloc extends Bloc<SpeechEvent, SpeechState> {
  final ChatBloc chatBloc;
  SpeechBloc(this.chatBloc) : super(SpeechInitial(speechEnabled: false)) {
    on<InitializeSpeechEvent>(onInitializeSpeechEvent);
    on<StartListeningEvent>(onStartListeningEvent);
    on<StopListeningEvent>(onStopListeningEvent);
    on<ListeningEvent>(onListeningEvent);
    on<StartSpeakingEvent>(onStartSpeakingEvent);
    on<StopSpeakingEvent>(onStopSpeakingEvent);
  }
  SpeechToText speechToText = SpeechToText();

  FlutterTts flutterTts = FlutterTts();

  onInitializeSpeechEvent(InitializeSpeechEvent event, Emitter<SpeechState> emit) async {
    final speechEnabled = await speechToText.initialize(
      // finalTimeout: const Duration(seconds: 60),
      onStatus: ((status) {
        print(["status", status == 'done']);
        if (status == "done") {
          add(StopListeningEvent());
          String? words = state.speechRecognitionResult?.recognizedWords;
          if (words != null) {
            chatBloc.add(SendChat(text: words));
          }

          add(StartSpeakingEvent(text: state.speechRecognitionResult?.recognizedWords ?? "No text has been added!"));
          Future.delayed(
            const Duration(seconds: 5),
            () {
              print(["Triggering ...", status]);
              add(StartListeningEvent());
            },
          );
        }
      }),
    );
    await flutterTts.awaitSpeakCompletion(true);

    emit(SpeechInitial(speechEnabled: speechEnabled));
  }

  void onStartListeningEvent(StartListeningEvent event, Emitter<SpeechState> emit) async {
    emit(StartListeningToUser(speechEnabled: state.speechEnabled));
    await speechToText.listen(
      onSoundLevelChange: ((level) {}),
      // pauseFor: const Duration(seconds: 2),
      listenOptions: SpeechListenOptions(
          // listenMode: ListenMode.dictation,
          // autoPunctuation: true,
          // enableHapticFeedback: true,
          ),
      onResult: ((result) {
        add(ListeningEvent(result));
      }),
    );
  }

  void onListeningEvent(ListeningEvent event, Emitter<SpeechState> emit) async {
    emit(ListeningToUser(speechRecognitionResult: event.result, speechEnabled: state.speechEnabled));
  }

  void onStopListeningEvent(StopListeningEvent event, Emitter<SpeechState> emit) async {
    await speechToText.stop();
    emit(StopListening(speechEnabled: state.speechEnabled));
  }

  Future<void> onStartSpeakingEvent(StartSpeakingEvent event, Emitter<SpeechState> emit) async {
    add(StopSpeakingEvent());
    await flutterTts.setVolume(0.5);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(event.text);
    add(StopSpeakingEvent());
  }

  Future<void> onStopSpeakingEvent(StopSpeakingEvent event, Emitter<SpeechState> emit) async {
    await flutterTts.stop();
  }
}
