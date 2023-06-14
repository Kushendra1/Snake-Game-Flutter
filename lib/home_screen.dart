import 'package:flutter/material.dart';
import 'package:frontend/navigation/app_router.dart';
import 'package:frontend/network/authentication_service.dart';
import 'package:frontend/utils/color_manager.dart';

import 'features/authentications/authentication_method/widgets/HeaderText.dart';
import 'features/authentications/authentication_method/widgets/sg_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // background widget
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const Image(
            image: AssetImage("assets/bg.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        // the sign in options
        Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    HeaderText(
                      text: "Snake",
                      color: ColorManager.headerText,
                      size: 60,
                    ),
                    Container(
                      child: Column(
                        children: [
                          SgButton(
                            buttonTitle: "Classic",
                            onBtnPressed: () {
                              Navigator.of(context).pushNamed(Routes.REGULAR_GAME_SCREEN);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SgButton(
                            buttonTitle: "Time Trial",
                            onBtnPressed: () {
                              Navigator.of(context).pushNamed(Routes.TIMED_GAME_SCREEN);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SgButton(
                            buttonTitle: "Leaderboard",
                            onBtnPressed: () {
                              Navigator.of(context).pushNamed(Routes.LEADERBOARD_SCREEN);
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        AuthService().signOut();
                      },
                      backgroundColor: ColorManager.backBtnColor,
                      child: const Icon(
                        Icons.exit_to_app,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
