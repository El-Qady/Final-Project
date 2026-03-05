import 'package:final_project/core/themes/provider/mode_provider.dart';
import 'package:final_project/core/themes/themes.dart';
import 'package:final_project/features/About/presentation/views/about_view.dart';
import 'package:final_project/features/Auth/presentation/views/signin_view.dart';
import 'package:final_project/features/Auth/presentation/views/signup_view.dart';
import 'package:final_project/features/Splash/presentation/views/splash_view.dart';
import 'package:final_project/features/contact/presentation/cubits/contact_cubit/contact_cubit.dart';
import 'package:final_project/features/contact/presentation/views/contact_view.dart';
import 'package:final_project/features/diagnosis/presentation/cubits/diagnosis_cubit/diagnosis_cubit.dart';
import 'package:final_project/features/diagnosis/presentation/views/diagnosis_view.dart';
import 'package:final_project/features/history/presentation/views/history_view.dart';
import 'package:final_project/features/history/presentation/cubits/history_cubit/history_cubit.dart';
import 'package:final_project/features/diagnosis/data/services/api_services.dart';
import 'package:final_project/features/home/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:final_project/features/home/presentation/views/doctors_view.dart';
import 'package:final_project/features/home/presentation/views/home_view.dart';
import 'package:final_project/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: 'https://bmjcadvjmwvjxuoethjg.supabase.co',
    anonKey: 'sb_publishable_lxrcM3_0cr4n8LfNHWZNNg_SS5BRCc-',
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ModeProvider()..getMode(),
      child: const Mokhi(),
    ),
  );
}

class Mokhi extends StatelessWidget {
  const Mokhi({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeCubit()),
        BlocProvider(create: (context) => HistoryCubit()),
        BlocProvider(create: (context) => ContactCubit()),
        BlocProvider(create: (context) => DiagnosisCubit(ApiServices())),
      ],
      child: MaterialApp(
        title: 'Mokhi',
        home: SplashView(),
        debugShowCheckedModeBanner: false,
        theme: Themes.light,
        darkTheme: Themes.dark,
        themeMode: Provider.of<ModeProvider>(context).isDark
            ? ThemeMode.dark
            : ThemeMode.light,
        themeAnimationCurve: Curves.linear,
        themeAnimationDuration: Durations.extralong1,
        routes: {
          '/signin': (context) => const SignInView(),
          '/signup': (context) => const SignupView(),
          '/home': (context) => const HomeView(),
          '/doctorsView': (context) => const DoctorsView(),
          '/diagnosisView': (context) => const DiagnosisView(),
          '/historyView': (context) => const HistoryView(),
          '/aboutView': (context) => const AboutView(),
          '/contactView': (context) => const ContactView(),
        },
      ),
    );
  }
}
