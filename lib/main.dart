import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

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
              // Flows(),
            ],
          ),
        ),
      ),
    );
  }
}

/*
class Flows extends StatelessWidget {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>(); // Add this line.
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
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;

          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        "山で遭難した場合",
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.check_circle : Icons.check_circle_outline,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (BuildContext context) {
              final Iterable<ListTile> tiles = _saved.map(
                (WordPair pair) {
                  return new ListTile(
                    title: new Text(
                      pair.asPascalCase,
                      style: _biggerFont,
                    ),
                  );
                },
              );
              final List<Widget> divided = ListTile.divideTiles(
                context: context,
                tiles: tiles,
              ).toList();

              return new Scaffold(
                appBar: new AppBar(
                  title: const Text('応急処置'),
                ),
                body: Actions(),
              );
            },
          ),
        );
      },
    );
  }
}
*/
class Genres extends StatefulWidget {
  @override
  GenresState createState() => new GenresState();
}

class GenresState extends State<Genres> {
  @override
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>(); // Add this line.
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;

          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        "ファーストエイド",
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.check_circle : Icons.check_circle_outline,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (BuildContext context) {
              final Iterable<ListTile> tiles = _saved.map(
                (WordPair pair) {
                  return new ListTile(
                    title: new Text(
                      pair.asPascalCase,
                      style: _biggerFont,
                    ),
                  );
                },
              );
              final List<Widget> divided = ListTile.divideTiles(
                context: context,
                tiles: tiles,
              ).toList();

              return new Scaffold(
                appBar: new AppBar(
                  title: const Text('ファーストエイド'),
                ),
                body: Actions(),
              );
            },
          ),
        );
      },
    );
  }
}

//
class Actions extends StatefulWidget {
  @override
  ActionsState createState() => new ActionsState();
}

class ActionsState extends State<Actions> {
  @override
  final Set<WordPair> _saved = new Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  String title = "";

  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;

          /*
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          */
          return _buildRow();
        });
  }

  Widget _buildRow() {
    // final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        "外傷の手当",
        style: _biggerFont,
      ),
      /*
      trailing: new Icon(
        alreadySaved ? Icons.check_circle : Icons.check_circle_outline,
        color: alreadySaved ? Colors.red : null,
      ),
      */
      onTap: () {
        String title;
        String content;
        String gener;
        String img;
        /*
        Directory appDocDir =  getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;
        */

        // var document =
        //  new File('gaisyou.json').readAsString().then((fileContents) {
        Map<String, dynamic> document = json.decode(
            ' { "gener": "ファーストエイド", "title": "外傷の手当", "content": "1.綺麗な流水傷口を洗う2.消毒液で傷口を消毒する3.傷の具合に応じてガーゼ、包帯、救急絆創膏で手当をする4.出血が激しい時は、心臓より傷口を高く上げて保持する","img":""}');
        // var fileContents = rootBundle.loadString('gaisyou.json');
        // Map<String, dynamic> document = json.decode(fileContents.toString());
        // debugPrint(Directory.current.toString());
        title = document['title'];
        debugPrint(title);
        content = document['content'];
        debugPrint(content);
        gener = document['gener'];
        img = document['img'];
        // return document;
        // });

        Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (BuildContext context) {
              return new Scaffold(
                appBar: new AppBar(
                  title: Text(title),
                ),
                body: Text(content),
              );
            },
          ),
        );
        /*
        Navigator.of(context).pus(
          new MaterialPageRoute(
            builder: (BuildContext context) {
              var document = new File('public/text/gaisyou.json')
                  .readAsString()
                  .then((fileContents) {
                Map<String, dynamic> document = json.decode(fileContents);
                return document;
              });
  
              return new Scaffold(
                appBar: new AppBar(
                  title: Text(document['title']),
                ),
                body: Text(document['content']),
              );
            },
          ),
        );
        */
      },
    );
  }
}
