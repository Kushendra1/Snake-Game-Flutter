import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:frontend/database/game_database.dart';
import 'package:frontend/navigation/app_router.dart';

final auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initDynamicLink();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint("state resume");
      initDynamicLink();
    } else {
      debugPrint(state.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    AppRouter(context: context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: Routes.ROOT,
        onGenerateRoute: AppRouter.generateRoute);
  }
}

void initDynamicLink() async {
  try {
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      debugPrint("dynamic link data: ${initialLink.link.toString()}");
      bool isValid = auth.isSignInWithEmailLink(initialLink.link.toString());
      if (isValid) {
        debugPrint("The link is valid");
        handleDynamicLink(initialLink);
      } else {
        debugPrint("The link is not valid");
      }
    }

    PendingDynamicLinkData dynamicLinkData =
        await FirebaseDynamicLinks.instance.onLink.first;
    if (dynamicLinkData != null) {
      debugPrint("dynamic link data: ${dynamicLinkData.link.toString()}");
      bool isValid =
          auth.isSignInWithEmailLink(dynamicLinkData.link.toString());
      if (isValid) {
        debugPrint("The link is valid");
        handleDynamicLink(dynamicLinkData);
      } else {
        debugPrint("The link is not valid");
      }
    } else {
      debugPrint("dynamic link data is null");
    }
  } catch (e, s) {
    debugPrint("dynamic link error");
  }
}

void handleDynamicLink(PendingDynamicLinkData dynamicLinkData) async {
  final continueUrl = dynamicLinkData.link.queryParameters['continueUrl'] ?? "";
  final email = Uri.parse(continueUrl).queryParameters['email'] ?? "";
  final list = await auth.fetchSignInMethodsForEmail(email);

  debugPrint(list.length.toString());
  if (list.isEmpty) {
    // new user register the account to backend
    debugPrint("new user");
    final db = DatabaseManager.db;
    final userName = email.split("@")[0];
    var res = await db.addUser(userName, email);
    debugPrint(res.toString());
    debugPrint(
        "added user to backend successfully from register with email method");
  }

  final UserCredential userCredential = await auth.signInWithEmailLink(
      email: email, emailLink: dynamicLinkData.link.toString());

  if (userCredential != null) {
    debugPrint("Signed In Successfully");
  } else {
    debugPrint("Not able to sign in");
  }
}
