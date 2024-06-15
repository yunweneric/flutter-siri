import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_openui/chat/logic/chat/chat_bloc.dart';
import 'package:flutter_openui/chat/logic/speech/speech_bloc.dart';
import 'package:flutter_openui/core/service_locator.dart';
import 'package:flutter_openui/screens/splash_screen.dart';
import 'package:flutter_openui/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt.get<SpeechBloc>()),
        BlocProvider(create: (context) => getIt.get<ChatBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Bot',
        theme: ThemeData(
          primaryColorLight: AppColors.white,
          primaryColorDark: AppColors.bgColor,
          primaryColor: AppColors.primary,
          cardColor: AppColors.bgCard,
          scaffoldBackgroundColor: AppColors.bgColor,
          textTheme: TextTheme(
            displayLarge: GoogleFonts.inter(fontSize: 35, color: AppColors.white, fontWeight: FontWeight.w600),
            displayMedium: GoogleFonts.inter(fontSize: 20, color: AppColors.white, fontWeight: FontWeight.w500),
            displaySmall: GoogleFonts.inter(fontSize: 14, color: AppColors.white, fontWeight: FontWeight.w500),
            bodyMedium: GoogleFonts.inter(fontSize: 14, color: AppColors.white, fontWeight: FontWeight.w500),
          ),
          chipTheme: ChipThemeData(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
