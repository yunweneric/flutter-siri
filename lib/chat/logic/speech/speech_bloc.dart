import 'package:bloc/bloc.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'speech_event.dart';
part 'speech_state.dart';

class SpeechBloc extends Bloc<SpeechEvent, SpeechState> {
  SpeechBloc() : super(SpeechInitial(speechEnabled: false)) {
    on<InitializeSpeechEvent>(onInitializeSpeechEvent);
    on<StartListeningEvent>(onStartListeningEvent);
    on<StopListeningEvent>(onStopListeningEvent);
    on<ListeningEvent>(onListeningEvent);
  }
  SpeechToText speechToText = SpeechToText();

  onInitializeSpeechEvent(InitializeSpeechEvent event, Emitter<SpeechState> emit) async {
    final speechEnabled = await speechToText.initialize();
    emit(SpeechInitial(speechEnabled: speechEnabled));
  }

  void onStartListeningEvent(StartListeningEvent event, Emitter<SpeechState> emit) async {
    await speechToText.listen(
      onSoundLevelChange: ((level) {
        print(level);
      }),
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        autoPunctuation: true,
        enableHapticFeedback: true,
      ),
      onResult: ((result) {
        add(ListeningEvent(result));
      }),
    );
  }

  void onListeningEvent(ListeningEvent event, Emitter<SpeechState> emit) async {
    // print(['result 2', event.result.toJson()]);
    emit(ListeningToUser(speechRecognitionResult: event.result, speechEnabled: state.speechEnabled));
  }

  void onStopListeningEvent(StopListeningEvent event, Emitter<SpeechState> emit) async {
    await speechToText.stop();
    emit(StopListening(speechEnabled: state.speechEnabled));
  }
}
