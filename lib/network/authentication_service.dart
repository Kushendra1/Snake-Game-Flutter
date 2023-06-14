import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:frontend/features/authentications/authentication_method/auth_method_screen.dart';
import 'package:frontend/home_screen.dart';
import 'package:frontend/navigation/app_router.dart';
import 'package:frontend/network/AppResponse.dart';
import 'package:frontend/utils/state_helpers.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../database/game_database.dart';

class AuthService {
  // Handle auth state
  handleAuthState(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          if (StateHelpers.fromDynamicLink) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.of(context).pop();
            });
            StateHelpers.fromDynamicLink = false;
          }
          return const Scaffold(
            resizeToAvoidBottomInset: false,
            body: HomeScreen(),
          );
        } else {
          return const Scaffold(
            body: AuthenticationMethodScreen(),
          );
        }
      },
    );
  }

  // sign in with google
  sigInWithGoogle() async {
    User? user;
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      try {
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        user = userCredential.user;
        // check if this user exists in the backend
        // if the user does not exist in the backend then send this user to the backend otherwise continue
        try {
          final db = DatabaseManager.db;
          final email = user?.email;
          final userName = email?.split("@")[0];
          if (email != null && userName != null) {
            await db.addUser(userName, email);
          }
          debugPrint("added user to backend successfully from google sign in");
        } catch (e) {
          debugPrint("user already exists through google sign In: $e");
        }
      } catch (e) {
        debugPrint("Google Sign In Error: $e");
      }
    }
    return user;
  }

  // register with email
  Future registerWithEmail(
      {required String email, required Function(bool) callback}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final list = await auth.fetchSignInMethodsForEmail(email);
      if (list.isNotEmpty) {
        debugPrint("User already exists");
        callback(false);
      } else {
        debugPrint("New user");
        return await auth
            .sendSignInLinkToEmail(
          email: email,
          actionCodeSettings: ActionCodeSettings(
              url: "https://snakegame.page.link/c2Sd?email=$email",
              handleCodeInApp: true,
              androidPackageName: 'com.example.frontend',
              androidMinimumVersion: '1'),
        )
            .then((value) {
          callback(true);
        });
      }
    } catch (e) {
      debugPrint("Error while sending dynamic link $e");
    }
  }

  // sign in with email
  Future signInWithEmail(
      {required String email, required Function(bool) callback}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final list = await auth.fetchSignInMethodsForEmail(email);
      if (list.isEmpty) {
        debugPrint("User does not exists");
        callback(false);
      } else {
        debugPrint("Existing user signing in");
        return await auth
            .sendSignInLinkToEmail(
          email: email,
          actionCodeSettings: ActionCodeSettings(
              url: "https://snakegame.page.link/c2Sd?email=$email",
              handleCodeInApp: true,
              androidPackageName: 'com.example.frontend',
              androidMinimumVersion: '1'),
        )
            .then((value) {
          callback(true);
        });
      }
    } catch (e) {
      debugPrint("Error while sending dynamic link $e");
    }
  }

  Future<AppResponse> retrieveDynamicLinkAndSignIn(
      {required bool fromColdState}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      PendingDynamicLinkData? dynamicLinkData;
      if (fromColdState) {
        dynamicLinkData = await FirebaseDynamicLinks.instance.getInitialLink();
      } else {
        dynamicLinkData = await FirebaseDynamicLinks.instance.onLink.first;
      }

      if (dynamicLinkData == null) {
        debugPrint("dynamic Link Data null");
        return AppResponse.notFound(
            id: "notFound", message: "Dynamic link data null");
      }

      bool validLink =
          auth.isSignInWithEmailLink(dynamicLinkData.link.toString());

      if (validLink) {
        final continueUrl =
            dynamicLinkData.link.queryParameters['continueUrl'] ?? "";
        final email = Uri.parse(continueUrl).queryParameters['email'] ?? "";
        final UserCredential userCredential = await auth.signInWithEmailLink(
            email: email, emailLink: dynamicLinkData.link.toString());

        if (userCredential != null) {
          debugPrint("Signed In Successfully");
          return AppResponse.success(message: "Signed In Successfully");
        } else {
          debugPrint("Not able to sign in");
          return AppResponse.notFound(message: "Not able to sign in");
        }
      } else {
        debugPrint("Link is not valid");
        return AppResponse.notFound(message: "Link is not valid");
      }
    } catch (e, s) {
      debugPrint("error: ${e.toString()}");
      return AppResponse.error(error: e, message: s.toString());
    }
  }

  // sign out google
  signOut() async {
    try {
      await GoogleSignIn().disconnect();
    } catch (e) {
      debugPrint("User was not logged in from google sign in ${e.toString()}");
    }
    FirebaseAuth.instance.signOut();
  }
}
