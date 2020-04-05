import 'dart:io';

import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';

import 'book.dart';
import 'database.dart';

void Display_info(BuildContext context) async {
  Color Primary = Colors.black45,
      Secondry = Color(0xEEFFD700),
      text = Colors.black45;
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        actionsPadding: EdgeInsets.all(2),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: SingleChildScrollView(
            child: Column(children: <Widget>[
          Text('No predictions yet',
              style: new TextStyle(
                color: Secondry,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              )),
        ])),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Close',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.red.withOpacity(0.6),
                  shadows: [
                    BoxShadow(
                        blurRadius: 1,
                        color: Colors.black12,
                        offset: Offset(1, 1))
                  ]),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


void Exit(BuildContext context) async {

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actionsPadding: EdgeInsets.all(2),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: SingleChildScrollView(
            child: Column(children: <Widget>[
          Text("Are you sure you want to exit?",
              style: 
                Theme.of(context).textTheme.headline1
              ),

        ])),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Confirm',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue.withOpacity(0.8),
                  shadows: [
                    BoxShadow(
                        blurRadius: 1,
                        color: Colors.black12,
                        offset: Offset(1, 1))
                  ]),
            ),
            onPressed: (){
                  exit(0);
                }
          ),
          FlatButton(
            child: Text(
              'Close',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.red.withOpacity(0.8),
                  shadows: [
                    BoxShadow(
                        blurRadius: 1,
                        color: Colors.black12,
                        offset: Offset(1, 1))
                  ]),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
