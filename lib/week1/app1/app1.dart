import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class App1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Writing your first app",
      debugShowCheckedModeBanner: false,
      home: RandomWords(),
    );
  }
}

class App1Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome to Flutter"),
        actions: [IconButton(icon: Icon(Icons.filter), onPressed: () {})],
      ),
      body: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final wordPairs = <WordPair>[];
  final _biggerFont = TextStyle(fontSize: 18);
  final savedPair = <WordPair>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome to Flutter"),
        actions: [
          IconButton(
              icon: Icon(Icons.filter),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text('Saved Suggestions'),
                    ),
                    body: ListView.separated(
                      itemCount: savedPair.length,
                      itemBuilder: (context, index) {
                        final pair = savedPair[index];
                        return ListTile(
                          title: Text(
                            pair.asPascalCase,
                            style: _biggerFont,
                          ),
                        );
                      },
                      separatorBuilder: (_, ___) => Divider(),
                    ),
                  );
                }));
              })
        ],
      ),
      body: ListView.builder(itemBuilder: (context, i) {
        if (i.isOdd) {
          return Divider();
        }
        final index = i ~/ 2;
        print("index $index");
        if (index >= wordPairs.length) {
          wordPairs.addAll(generateWordPairs().take(10));
        }
        final pair = wordPairs[index];
        final alreadySaved = savedPair.contains(pair);
        return ListTile(
          onTap: () {
            setState(() {
              if (alreadySaved) {
                savedPair.remove(pair);
              } else {
                savedPair.add(pair);
              }
            });
          },
          title: Text(pair.asPascalCase),
          trailing: Icon(
            alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null,
          ),
        );
      }),
    );
  }
}
