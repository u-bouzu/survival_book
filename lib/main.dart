import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_messaging/firebase_messaging.dart';

import 'play_help.dart';

void main() {
  runApp(SurvivalBook());
}

class SurvivalBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: "ducument", icon: Icon(Icons.insert_drive_file)),
                Tab(text: "news", icon: Icon(Icons.event_note)),
                Tab(text: "signal", icon: Icon(Icons.signal_cellular_4_bar)),
                Tab(text: "flow", icon: Icon(Icons.forward)),
              ],
            ),
            title: Text('Survival Book'),
          ),
          body: TabBarView(
            children: [
              Genres(),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
              ExampleApp(),
              // Flows(),
            ],
          ),
        ),
      ),
    );
  }
}

class Genres extends StatefulWidget {
  @override
  GenresState createState() => new GenresState();
}

class GenresState extends State<Genres> {
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage:" "$message");
        var msg = message["sokuhou"];
        print(msg);
        _buildDialog(context, "$msg");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _buildDialog(context, "onLaunch");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _buildDialog(context, "onResume");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
    });
    _firebaseMessaging.subscribeToTopic("/topics/all");
  }

  // ダイアログを表示するメソッド
  void _buildDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            content: new Text("Message: $message"),
            actions: <Widget>[
              new FlatButton(
                child: const Text('CLOSE'),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              new FlatButton(
                child: const Text('SHOW'),
                onPressed: () {
                  Navigator.pop(context, true);
                  Navigator.of(context).push(
                    new MaterialPageRoute(
                      builder: (BuildContext context) {
                        return new Scaffold(
                          appBar: new AppBar(
                            title: const Text('地震対策'),
                          ),
                          body: Text(
                              "\n1. 【発災直後の安全確保】\n発災直後は、自分の身の安全の確保が必要です。落下物に気を付けつつ、大きな什器等から離れて机の下等に隠れて様子を見守りましょう。\n\n2. 【津波からの避難】\n津波の危険性がある場合には、早急に高台等の指定避難場所に避難することが必要です。特に津波の危険性が指摘されている地域では、大きな揺れを感じたら素早く避難を開始することが求められます。津波は第２波や第３波が最大波高となる場合が多く、一旦津波が引いた場合でも沿岸部や浸水地域には近づかないようにしましょう。\n\n 3.  【２つの安全確認】\n　安全な場所に避難するかどうかは、建物の被災状況と共に、土砂災害や堤防決壊等による影響も踏まえて判断するようにしましょう。"),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          );
        });
  }

  final _suggestions = ["ファーストエイド", "料理", "天気の予測"];
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _suggestions.length,
        itemBuilder: (context, i) {
          return _buildRow(_suggestions[i]);
        });
  }

  Widget _buildRow(String gener) {
    return Container(
        child: ListTile(
          title: Text(
            gener,
            style: _biggerFont,
          ),
          onTap: () {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (BuildContext context) {
                  return new Scaffold(
                    appBar: new AppBar(
                      title: Text(gener),
                    ),
                    body: Actions(),
                  );
                },
              ),
            );
          },
        ),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(color: Colors.black26),
        )));
  }
}

//
class Actions extends StatefulWidget {
  @override
  ActionsState createState() => new ActionsState();
}

class ActionsState extends State<Actions> {
  final _suggestions = [
    "外傷の手当",
    "腕の怪我の手当",
    "休ませる姿勢",
    "捻挫の手当",
    "頭部の怪我の手当",
    "直接圧迫止血法"
  ];
  final _saved = new Set<String>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _suggestions.length,
        itemBuilder: (context, i) {
          return _buildRow(_suggestions[i]);
        });
  }

  Widget _buildRow(String title) {
    final bool alreadySaved = _saved.contains(title);
    return Container(
        child: ListTile(
          title: Text(
            title,
            style: _biggerFont,
          ),
          trailing: new Icon(
            alreadySaved ? Icons.check_circle : Icons.check_circle_outline,
            color: alreadySaved ? Colors.red : null,
          ),
          onTap: () {
            String title;
            String content;
            Map<String, dynamic> document = json.decode(
                ' { "gener": "ファーストエイド", "title": "外傷の手当", "content": "1.綺麗な流水傷口を洗う2.消毒液で傷口を消毒する3.傷の具合に応じてガーゼ、包帯、救急絆創膏で手当をする4.出血が激しい時は、心臓より傷口を高く上げて保持する","img":""}');
            title = document['title'];
            content = document['content'];
            content =
                "\nこちらのページでは擦り傷や擦り傷などの外傷の手当てを紹介します。\n\n\n1.綺麗な流水傷口を洗う\n\n2.消毒液で傷口を消毒する\n\n3.傷の具合に応じてガーゼ、包帯、救急絆創膏で手当をする\n\n4.出血が激しい時は、心臓より傷口を高く上げて保持する";

            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (BuildContext context) {
                  return new Scaffold(
                    appBar: new AppBar(
                      title: Text(title),
                    ),
                    body: Text(content,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  );
                },
              ),
            );
          },
        ),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(color: Colors.black26),
        )));
  }
}
