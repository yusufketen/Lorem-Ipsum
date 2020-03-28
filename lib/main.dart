import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAppHome(),
    );
  }
}

class MyAppHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppHomeState();
  }
}

class _MyAppHomeState extends State<MyAppHome> {
  String userName = '';
  int score = 0;
  String lorem =
      '                                                      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque quis dolor tortor. Pellentesque ac quam a libero cursus varius lobortis nec ligula. Maecenas vehicula odio quis elit efficitur, ut suscipit ligula convallis. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Proin ut pharetra leo. Donec quis lacus felis. Proin sagittis ante sit amet laoreet consectetur. Integer sit amet neque est. Etiam in nulla vestibulum, efficitur risus sed, posuere est.'
          .toLowerCase()
          .replaceAll(',', '')
          .replaceAll('.', '');

  int step = 0;
  int lastTypedAt;

  void updateLastTypedAt() {
    this.lastTypedAt = DateTime.now().millisecondsSinceEpoch;
  }

  void playAgain() {
    setState(() {
      this.step = 0;
      this.score = 0;
      updateLastTypedAt();
    });
  }

  void onType(String value) {
    updateLastTypedAt();
    String trimmedValue = lorem.trimLeft();
    setState(() {
      if (trimmedValue.indexOf(value) != 0) {
        step = 2;
      } else {
        score = value.length;
      }
    });
  }

  void onUserNameType(String value) {
    setState(() {
      this.userName = value;
    });
  }

  void onStartClick() {
    setState(() {
      updateLastTypedAt();
      step++;
    });
    var timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      int now = DateTime.now().millisecondsSinceEpoch;

      // GAME OVER

      setState(() {
        if (step == 1 && now - lastTypedAt > 4000) {
          step++;
        }
        if (step != 1) {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var shownWidget;

    if (step == 0)
      shownWidget = <Widget>[
        Text('Oyuna hos geldin, coronadan kacmaya hazir misin'),
        Container(
          padding: EdgeInsets.all(20),
          child: TextField(
            onChanged: onUserNameType,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ismin nedir?',
            ),
          ),
        ),
        Container(
          child: RaisedButton(
            child: Text('BASLA!'),
            onPressed: userName.length == 0 ? null : onStartClick,
          ),
        )
      ];
    else if (step == 1)
      shownWidget = <Widget>[
        Text('$score'),
        Container(
          margin: EdgeInsets.only(left: 0),
          height: 40,
          child: Marquee(
            text: lorem,
            style: TextStyle(fontSize: 24, letterSpacing: 2),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 20.0,
            velocity: 125,
            startPadding: 0,
            accelerationDuration: Duration(seconds: 20),
            accelerationCurve: Curves.ease,
            decelerationDuration: Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
          child: TextField(
            autofocus: true,
            onChanged: onType,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Yaz bakalim:',
            ),
          ),
        )
      ];
    else
      shownWidget = <Widget>[
        Text('Coronadan kacamadin, skorun: $score'),
        RaisedButton(
          child: Text('Tekrar Dene!'),
          onPressed: playAgain,
        ),
      ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Lorem Ipsum Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: shownWidget,
        ),
      ),
    );
  }
}
