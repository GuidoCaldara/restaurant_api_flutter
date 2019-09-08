import 'package:flutter/material.dart';
import 'form.dart';

class App extends StatelessWidget {
  Widget build(context){
    return MaterialApp(
      title: 'Restaurant CloseBy',
      home: Scaffold(
        body: UserForm(),
      )
    );

  }
}