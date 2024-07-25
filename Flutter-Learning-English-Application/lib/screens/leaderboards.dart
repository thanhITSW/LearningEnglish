import 'package:application_learning_english/models/Achievement.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:application_learning_english/config.dart';
import "package:shared_preferences/shared_preferences.dart";
import '../utils/sessionUser.dart';

import '../user.dart';

class LeaderBoards extends StatefulWidget {
  @override
  _LeaderBoardsState createState() => _LeaderBoardsState();
}

class _LeaderBoardsState extends State<LeaderBoards> {
  final url_root = kIsWeb ? WEB_URL : ANDROID_URL;

  Future<List<Achievement>>? futureAchievement;
  late SharedPreferences prefs;
  User? user;

  @override
  void initState() {
    super.initState();
    loadUser();
    // futureAchievement = fetchAchievement();
  }

  loadUser() async {
    user = await getUserData();
    if (user != null) {
      futureAchievement = fetchAchievement();
    }
    setState(() {});
  }


  Future<List<Achievement>> fetchAchievement() async {
    final response = await http.get(Uri.parse('$url_root/achievements/personal-achivements/${user!.username}'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final List<dynamic> achievementJson = responseBody['data'];
      return achievementJson.map((json) => Achievement.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load topics');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Achievement', style: TextStyle(
          color: Colors.black, fontSize: 17
        )),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Achievement>>(
          future: futureAchievement,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Achievement> achievements = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  Achievement achievement = achievements[index];
                  return GestureDetector(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${achievement.topic.topicName}', style: TextStyle(color: Colors.black, fontSize: 17),),
                                SizedBox(height: 10,),
                                Text('Rank: ${achievement.rank}', style: TextStyle(color: Colors.black, fontSize: 17)),
                                SizedBox(height: 10,),
                                Text('Category: ${achievement.category}', style: TextStyle(color: Colors.black, fontSize: 17)),
                                SizedBox(height: 10,),
                                _buildCategoryText(achievement.category, achievement.achievement),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Close', style: TextStyle(color: Colors.red, fontSize: 14),))
                          ],
                        ));
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10, left: 10, top: 5),
                      child: Row(
                        children: [
                          Text('${index+1}', style: TextStyle(color: Colors.black, fontSize: 17),),
                          SizedBox(width: 10,),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              'assets/cup.png',
                              height: 60,
                              width: 60,
                            ),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${achievement.topic.topicName}', style: TextStyle(color: Colors.black, fontSize: 17),),
                                Text('Rank: ${achievement.rank}', style: TextStyle(color: Colors.black, fontSize: 17)),
                                Text('Category: ${achievement.category}', style: TextStyle(color: Colors.black, fontSize: 17)),
                              ],
                            ),
                          ),
                          SizedBox(width: 7,),
                          Align(
                            alignment: Alignment.centerRight,
                            child: _buildCategoryText(achievement.category, achievement.achievement),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}


Widget _buildCategoryText(String category, String achievement) {
  if (category == 'duration') {
    return Text(
        '$achievement seconds',
        style: TextStyle(color: Colors.black, fontSize: 17),
      );
  } else if(category == 'corrects'){
    return Text(
        '$achievement/5',
        style: TextStyle(color: Colors.black, fontSize: 17),
      );
  }
  else{
    return Text(
        '$achievement ',
        style: TextStyle(color: Colors.black, fontSize: 17),
      );
  }
}
