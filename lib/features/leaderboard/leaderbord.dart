import 'package:flutter/material.dart';
import 'package:frontend/database/game_database.dart';
import 'package:frontend/database/user_score.dart';
import 'package:frontend/features/authentications/authentication_method/widgets/HeaderText.dart';

import '../../utils/color_manager.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const Image(
            image: AssetImage("assets/bg.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  backgroundColor: ColorManager.backBtnColor,
                  child: Image.asset(
                    'assets/arrow_back.png',
                    width: 24.0,
                    height: 24.0,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    Expanded(
                      child: HeaderText(
                        text: "Leaderboard",
                        color: Colors.white,
                        align: TextAlign.center,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                          ),
                          color: ColorManager.fromHex("#8BB7F0"),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: HeaderText(
                          text: "Name",
                          color: Colors.white,
                          align: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                          ),
                          color: ColorManager.fromHex("#F78F8F"),
                        ),
                        child: HeaderText(
                          text: "Score",
                          color: Colors.white,
                          align: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                FutureBuilder(
                  future: _getAllUsersScore(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      final data = snapshot.data;
                      if (data != null) {
                        final userScores =
                            data.map((map) => UserScore.fromJson(map)).toList();
                        debugPrint("all scores data: $data");
                        return Expanded(
                          child: ListView.builder(
                            itemCount: userScores.length,
                            itemBuilder: (context, index) {
                              return listWidget(userScores[index].username,
                                  userScores[index].score.toString());
                            },
                          ),
                        );
                      } else {
                        return const SizedBox(
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    } else {
                      return const SizedBox(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  }),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  listWidget(String name, String score) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: ColorManager.fromHex("#B08159"),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: HeaderText(
              text: name,
              color: Colors.white,
              align: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: HeaderText(
              text: score,
              color: Colors.white,
              align: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getAllUsersScore() async {
    final db = DatabaseManager.db;
    var res = await db.getTop100Leaderboard();
    debugPrint(res.toString());

    return res;
  }
}
