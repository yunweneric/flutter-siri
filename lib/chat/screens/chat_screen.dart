import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_openui/chat/logic/speech/speech_bloc.dart';
import 'package:flutter_openui/chat/screens/speech_screen.dart';
import 'package:flutter_openui/screens/animated_bg.dart';
import 'package:flutter_openui/utils/assets.dart';
import 'package:flutter_openui/utils/colors.dart';
import 'package:flutter_openui/utils/sizing.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? animateRotation;
  Animation<double>? scaleAnimation;
  @override
  void initState() {
    controller = AnimationController(duration: Duration(milliseconds: 8000), vsync: this);
    final Animation<double> curve = CurvedAnimation(parent: controller!, curve: Curves.easeInOutBack);
    animateRotation = Tween<double>(begin: 0, end: pi * 2).animate(curve);
    scaleAnimation = Tween<double>(begin: 1.1, end: 1).animate(curve);
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void animate(bool isAnimating) {
    if (isAnimating) {
      controller!.stop();
    } else {
      controller!.repeat();
    }
    setState(() => isAnimating = !isAnimating);
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
      ),
      child: BlocConsumer<SpeechBloc, SpeechState>(
        listener: (context, state) {
          if (state is ListeningToUser || state is StartListeningToUser) {
            animate(false);
          }
          if (state is StopListening) {
            animate(true);
          }
        },
        builder: (context, state) {
          final isAnimating = state is ListeningToUser || state is StartListeningToUser;

          return Scaffold(
            body: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: AnimatedBG(controller: controller!, animateRotation: animateRotation),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: SvgPicture.asset(AppAsset.listening_grid, color: AppColors.white),
                ),
                chatUi(context, isAnimating),
              ],
            ),
          );
        },
      ),
    );
  }

  Visibility chatUi(BuildContext context, bool isAnimating) {
    return Visibility(
      visible: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.all(isAnimating ? 10 : 0),
        width: AppSizing.width(context),
        height: AppSizing.height(context),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(isAnimating ? AppSizing.top(context) : 0),
          boxShadow: [
            // BoxShadow(color: Theme.of(context).primaryColor.w, blurRadius: 10, spreadRadius: 2),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: AppSizing.width(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Chip(label: Text("Hey Flutter!")),
                    AppSizing.k10(context),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(radius: 5, backgroundColor: Colors.green),
                        Text("  Online"),
                      ],
                    )
                  ],
                ),
                LottieBuilder.asset(
                  AppAsset.siri,
                  animate: isAnimating,
                  width: AppSizing.width(context) / 2,
                  height: AppSizing.width(context) / 2,
                ),
                const SpeechScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
