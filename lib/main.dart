import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:koolkwiz/firebase_options.dart';
import 'package:koolkwiz/firebase_service.dart';
import 'package:koolkwiz/marketplace/marketplace.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'app_state.dart';
import 'model/model.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(AuthGuard());
}

class AuthGuard extends StatefulWidget {
  AuthGuard({super.key});

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  @override
  initState() {
    loadApp();
    super.initState();
  }

  void loadApp() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      _player = await FirebaseService.createUser(userCredential);
      _quiz = await FirebaseService.createQuiz();
    } on FormatException catch (e) {
      print('Format Exception! \n $e');
    } catch (e) {
      print('An unknown exception occurred! \n $e');
    }
    setState(() {
      appLoaded = true;
    });
  }

  bool appLoaded = false;
  Player? _player;
  Quiz? _quiz;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Marketplace.theme,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && appLoaded) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => AppState(quiz: _quiz!, player: _player!),
                ),
                StreamProvider<Player>(
                  create: (_) => FirebaseService.playerStream(_player!),
                  initialData: _player!,
                  catchError: (_, error) {
                    throw Exception('Error in StreamProvider.Player!  $error');
                  },
                ),
                StreamProvider<List<Player>>(
                  create: (_) => FirebaseService.leaderboardStream(),
                  initialData: [],
                  catchError: (_, error) {
                    throw Exception(
                        'Error in StreamProvider.Leaderboard!  $error');
                  },
                )
              ],
              child: AppShell(),
            );
          }
          return SplashScreen();
        },
      ),
    );
  }
}
