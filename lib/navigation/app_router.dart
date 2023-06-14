import 'package:flutter/material.dart';
import 'package:frontend/features/authentications/authentication_method/widgets/HeaderText.dart';
import 'package:frontend/features/regular_game/classic_game.dart';
import 'package:frontend/features/timed_game/timed_snake_game.dart';
import 'package:frontend/home_screen.dart';
import 'package:frontend/message_screen.dart';
import 'package:frontend/network/authentication_service.dart';

import '../features/authentications/register/registration_screen.dart';
import '../features/authentications/sign_in/sign_in_screen.dart';
import '../features/leaderboard/leaderbord.dart';

/// All new screen names should be added here.
class Routes {
  static const String ROOT = "/";
  static const String HOME_SCREEN = "home_screen";
  static const String RESIGER_SCREEN = "register_screen";
  static const String SIGN_IN_SCREEN = "sign_in_screen";
  static const String REGULAR_GAME_SCREEN = "regular_game_screen";
  static const String TIMED_GAME_SCREEN = "timed_game_screen";
  static const String LEADERBOARD_SCREEN = "leaderboard_screen";
  static const String MESSAGE_SCREEN = "message_screen";
}

/// All new screen should be added here.
/// Just retrieve the name you added from the Routes class and add it as a case.
/// When you want to navigate to a new screen, just call Navigator.of(context).pushNamed(Routes.SCREEN_NAME)
/// NOTE: this navigation will not work if you have not registered the screen name on this generateRoute method
/// For example:
/// if you created a new screen called game screen. Add static const String GAME_SCREEN = "game_screen" to Routes class
/// then on generateRoute add a new case
/// case Routes.GAME_SCREEN:
/// then return the MaterialPageRoute(builder: (_) => const Scaffold(body: GameScreen()))
class AppRouter {
  final BuildContext context;

  AppRouter({required this.context});

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case Routes.ROOT:
        return MaterialPageRoute(
            builder: (context) => AuthService().handleAuthState(context));
      case Routes.HOME_SCREEN:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: HomeScreen(),
                ));
      case Routes.SIGN_IN_SCREEN:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: SignInScreen(),
                ));
      case Routes.RESIGER_SCREEN:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: RegistrationScreen(),
                ));
      case Routes.MESSAGE_SCREEN:
        if (args is String) {
          return MaterialPageRoute(
              builder: (_) => Scaffold(
                    body: MessageScreen(
                      message: args,
                    ),
                  ));
        }
        return _errorRoute();
      case Routes.REGULAR_GAME_SCREEN:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: ClassicGame(),
                ));
      case Routes.TIMED_GAME_SCREEN:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: TimedSnakeGame(),
                ));
      case Routes.LEADERBOARD_SCREEN:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: LeaderBoard(),
                ));
      default:
        return MaterialPageRoute(
            builder: (context) => AuthService().handleAuthState(context));
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: HeaderText(
            text: "ERROR",
          ),
        ),
      );
    });
  }
}

// final GoRouter router = GoRouter(
//     debugLogDiagnostics: true,
//     routes: <GoRoute>[
//       GoRoute(
//         path: Routes.HOME,
//         name: Routes.HOME,
//         builder: (BuildContext context, GoRouterState state) {
//           return const Scaffold(
//             body: AuthenticationMethodScreen(),
//           );
//         },
//         routes: [
//           GoRoute(
//             path: Routes.RESIGER_SCREEN,
//             name: Routes.RESIGER_SCREEN,
//             pageBuilder: (context, state) {
//               return CustomTransitionPage(
//                 key: state.pageKey,
//                 child: const Scaffold(
//                   resizeToAvoidBottomInset: false,
//                   body: RegistrationScreen(),
//                 ),
//                 transitionDuration: const Duration(milliseconds: 300),
//                 transitionsBuilder:
//                     (context, animation, secondaryAnimation, child) {
//                   return SlideTransition(
//                     position: Tween<Offset>(
//                             begin: const Offset(0, 1), end: Offset.zero)
//                         .animate(animation),
//                     child: child,
//                   );
//                 },
//               );
//             },
//           ),
//           GoRoute(
//             path: Routes.SIGN_IN_SCREEN,
//             name: Routes.SIGN_IN_SCREEN,
//             pageBuilder: (context, state) {
//               return CustomTransitionPage(
//                 key: state.pageKey,
//                 child: const Scaffold(
//                   resizeToAvoidBottomInset: false,
//                   body: SignInScreen(),
//                 ),
//                 transitionDuration: const Duration(milliseconds: 300),
//                 transitionsBuilder:
//                     (context, animation, secondaryAnimation, child) {
//                   return SlideTransition(
//                     position: Tween<Offset>(
//                             begin: const Offset(0, 1), end: Offset.zero)
//                         .animate(animation),
//                     child: child,
//                   );
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//     ],
//     redirect: (context, state) async {});
