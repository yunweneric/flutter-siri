import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_openui/chat/logic/speech/speech_bloc.dart';
import 'package:flutter_openui/chat/screens/components/circle_btn.dart';
import 'package:flutter_openui/core/service_locator.dart';
import 'package:flutter_openui/utils/assets.dart';
import 'package:flutter_openui/utils/sizing.dart';
import 'package:flutter_svg/svg.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;
  final speechBloc = getIt.get<SpeechBloc>();
  @override
  void initState() {
    controller = AnimationController(duration: Duration(milliseconds: 800), vsync: this);
    final Animation<double> curve = CurvedAnimation(parent: controller!, curve: Curves.linear);
    scaleAnimation = Tween<double>(begin: 1.1, end: 1).animate(curve);
    speechBloc.add(InitializeSpeechEvent());

    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void animate(bool isAnimating) {
    print(['isAnimating', isAnimating]);
    if (isAnimating) {
      controller!.stop();
    } else {
      controller!.repeat();
    }
    // setState(() => isAnimating = !isAnimating);
  }

  stopAndClose(bool isAnimating) async {
    if (isAnimating) {
      setState(() => isAnimating = !false);
      controller!.stop();
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizing.height(context) / 2,
      child: BlocConsumer<SpeechBloc, SpeechState>(
        listener: (context, state) {},
        builder: (context, state) {
          final isAnimating = state is ListeningToUser;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: TweenAnimationBuilder(
                    key: ValueKey(isAnimating),
                    duration: const Duration(milliseconds: 600),
                    tween: Tween<Offset>(begin: Offset(0, 50), end: Offset.zero),
                    builder: (context, value, child) {
                      // print(1 - (value.dy / 50).clamp(0, 1));
                      return Transform.translate(
                        offset: value,
                        child: Opacity(
                          opacity: 1 - (value.dy / 20).clamp(0, 1),
                          child: isAnimating
                              ? Text(
                                  state.speechRecognitionResult?.recognizedWords ?? '',
                                  style: Theme.of(context).textTheme.displaySmall,
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  "Hi Flutterist 👋\n What can I help you with today?",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.displayMedium,
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              actionButtons(isAnimating),
            ],
          );
        },
      ),
    );
  }

  Widget actionButtons(bool animating) {
    return Column(
      children: [
        AppSizing.k20(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            circleButton(
              context: context,
              onTap: () {},
              icon: AppAsset.keyboard,
            ),
            InkWell(
              onTap: () {
                animate(!animating);
                speechBloc.add(StartListeningEvent());
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: controller!,
                    builder: (context, value) {
                      return Transform.scale(
                        scale: scaleAnimation?.value ?? 1,
                        child: SvgPicture.asset(AppAsset.mic_circle, color: Theme.of(context).primaryColor),
                      );
                    },
                  ),
                  SvgPicture.asset(AppAsset.microphone, color: Theme.of(context).primaryColorDark),
                ],
              ),
            ),
            circleButton(
              context: context,
              onTap: () => speechBloc.add(StopListeningEvent()),
              icon: AppAsset.close,
            ),
          ],
        )
      ],
    );
  }
}
