import 'package:flutter/material.dart';
import 'form.dart';
import 'package:screen/screen.dart';


class App extends StatelessWidget {

  Widget build(context){
    Screen.keepOn(true);
    return MaterialApp(
      title: 'Restaurant CloseBy',
      home: Scaffold(
        body: UserForm(),
      )
    );

  }
}