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
  bool appLoaded = false;
  Player? _player;
  Quiz? _quiz;

  @override
  initState() {
    loadApp();
    super.initState();
  }

  void loadApp() async {
    try {
      _quiz = await FirebaseService.createQuiz();
      _player = await FirebaseAuth.instance
          .signInAnonymously()
          .then((credential) async {
        return await FirebaseService.createPlayerAndJoinQuiz(
          credential,
          _quiz!.id,
        );
      });
    } on FormatException catch (e) {
      print('Format Exception! \n $e');
    } catch (e) {
      print('An unknown exception occurred! \n $e');
    }
    setState(() {
      appLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Marketplace.theme,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.data != null && appLoaded) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => AppBloc(quiz: _quiz!, player: _player!),
                ),
                StreamProvider<Player>(
                  create: (_) => FirebaseService.playerStream(
                      player: _player!, quizId: _quiz!.id),
                  initialData: _player!,
                  catchError: (_, error) => throw (error!),
                ),
                StreamProvider<Quiz>(
                  create: (_) => FirebaseService.quizStream(quizId: _quiz!.id),
                  initialData: _quiz!,
                  catchError: (_, error) => throw (error!),
                ),
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
