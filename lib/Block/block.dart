import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'Theme_overall.dart';


enum ThemeEvent {blue,pink,green,purple,grey, yellow}


class ThemeBloc extends Bloc<ThemeEvent, Theme_overall> {

  Theme_overall blue = Theme_overall(
  ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF298599),
    scaffoldBackgroundColor: Color(0xFF1EC5E8),
    splashColor: Colors.white,
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 22.0, color:Colors.white,fontFamily:"Heading1"),
      headline2: TextStyle(fontSize: 16.0, color:Colors.white,),
      headline3: TextStyle(fontSize: 12.0, color:Colors.black38,),
      headline4: TextStyle(fontSize: 18.0, color:Colors.black38,height:1.0,textBaseline: TextBaseline.alphabetic),
    )),
  [BoxShadow(blurRadius: 6,spreadRadius: 1,color:Colors.white.withOpacity(0.5) ,offset:Offset(-3, -3) ),
   BoxShadow(blurRadius: 6,spreadRadius: 2,color:Colors.black.withOpacity(0.15) ,offset:Offset(3, 3) )], 

    [BoxShadow(blurRadius:4,spreadRadius: 1,color:Colors.white.withOpacity(0.4) ,offset:Offset(-3, -3) ),
   BoxShadow(blurRadius: 6,spreadRadius: 0,color:Colors.black.withOpacity(0.2) ,offset:Offset(3, 3) )], 

    [BoxShadow(blurRadius: 4,spreadRadius: 1,color:Colors.white.withOpacity(0.4) ,offset:Offset(-3, -3) ),
   BoxShadow(blurRadius: 6,spreadRadius: 2,color:Colors.black.withOpacity(0.15) ,offset:Offset(3, 3) )], 
  );
 
  Theme_overall pink = Theme_overall(
  ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF298599),
    scaffoldBackgroundColor: Color(0xFFEC8AB2),
    splashColor: Colors.white,
    fontFamily: 'Georgia',
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 22.0, color:Colors.white,fontFamily:"Heading1"),
      headline2: TextStyle(fontSize: 16.0, color:Colors.white, ),
      headline3: TextStyle(fontSize: 12.0, color:Colors.black38,),
      headline4: TextStyle(fontSize: 18.0, color:Colors.black38,height:1.0,textBaseline: TextBaseline.alphabetic),
    )),
  [BoxShadow(blurRadius: 6,spreadRadius: 1,color:Colors.white.withOpacity(0.2) ,offset:Offset(-3, -3) ),
   BoxShadow(blurRadius: 6,spreadRadius: 1,color:Colors.black.withOpacity(0.15) ,offset:Offset(3, 3) )]

   ,
  [BoxShadow(blurRadius: 6,spreadRadius: 1,color:Colors.white.withOpacity(0.2) ,offset:Offset(-3, -3) ),
   BoxShadow(blurRadius: 6,spreadRadius: 1,color:Colors.black.withOpacity(0.15) ,offset:Offset(3, 3) )]  

   ,
  [BoxShadow(blurRadius: 6,spreadRadius: 1,color:Colors.white.withOpacity(0.2) ,offset:Offset(-3, -3) ),
   BoxShadow(blurRadius: 6,spreadRadius: 1,color:Colors.black.withOpacity(0.15) ,offset:Offset(3, 3) )]    
  );
 
  Theme_overall green = Theme_overall(
  ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF298599),
    scaffoldBackgroundColor: Color(0xFF09CBAE),
    splashColor: Colors.white,
    fontFamily: 'Georgia',
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 22.0, color:Colors.white,fontFamily:"Heading1"),
      headline2: TextStyle(fontSize: 16.0, color:Colors.white, ),
      headline3: TextStyle(fontSize: 12.0, color:Colors.black38,),
      headline4: TextStyle(fontSize: 18.0, color:Colors.black38,height:1.0,textBaseline: TextBaseline.alphabetic),
    )),
  [BoxShadow(blurRadius: 5,spreadRadius: 2,color:Colors.white.withOpacity(0.3) ,offset:Offset(-3, -3) ),
   BoxShadow(blurRadius: 6,spreadRadius: 1,color:Colors.black.withOpacity(0.2) ,offset:Offset(3, 3) )]  

   ,
  [BoxShadow(blurRadius: 5,spreadRadius: 2,color:Colors.white.withOpacity(0.3) ,offset:Offset(-3, -3) ),
   BoxShadow(blurRadius: 6,spreadRadius: 1,color:Colors.black.withOpacity(0.2) ,offset:Offset(3, 3) )]  

   ,
  [BoxShadow(blurRadius: 5,spreadRadius: 2,color:Colors.white.withOpacity(0.3) ,offset:Offset(-3, -3) ),
   BoxShadow(blurRadius: 6,spreadRadius: 1,color:Colors.black.withOpacity(0.2) ,offset:Offset(3, 3) )]  
  );
 
  Theme_overall purple = Theme_overall(
  ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF298599),
    scaffoldBackgroundColor: Color(0xFF41278D),
    splashColor: Colors.white,
    fontFamily: 'Georgia',
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 22.0, color:Colors.white,fontFamily:"Heading1"),
      headline2: TextStyle(fontSize: 16.0, color:Colors.white,fontFamily:"Heading1"),
      headline3: TextStyle(fontSize: 12.0, color:Colors.grey,),
      headline4: TextStyle(fontSize: 18.0, color:Colors.grey,height:1.0,textBaseline: TextBaseline.alphabetic,fontFamily:"Heading2"),
    )),
  [BoxShadow(blurRadius: 1,spreadRadius: 0,color:Colors.white.withOpacity(0.05) ,offset:Offset(-3, -3) ),
   BoxShadow(blurRadius: 2,spreadRadius: 1,color:Colors.black.withOpacity(0.15) ,offset:Offset(3, 3) )] 

   ,
  [BoxShadow(blurRadius: 3,spreadRadius: 0,color:Colors.white.withOpacity(0.08) ,offset:Offset(-3, -3) ),
   BoxShadow(blurRadius: 2,spreadRadius: 1,color:Colors.black.withOpacity(0.15) ,offset:Offset(3, 3) )] 

   ,
  [BoxShadow(blurRadius: 3,spreadRadius: 0,color:Colors.white.withOpacity(0.08) ,offset:Offset(-3, -3) ),
   BoxShadow(blurRadius: 2,spreadRadius: 1,color:Colors.black.withOpacity(0.15) ,offset:Offset(3, 3) )]  
  );
 
  Theme_overall grey = Theme_overall(
  ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueGrey[300],
    scaffoldBackgroundColor: Color(0xFFE0E5EC),
    splashColor: Color(0xFF298599),
    fontFamily: 'Georgia',
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 22.0, color:Color(0xFF298599),fontFamily:"Heading1"),
      headline2: TextStyle(fontSize: 16.0, color:Colors.black54, ),
      headline3: TextStyle(fontSize: 12.0, color:Colors.black26,),
      headline4: TextStyle(fontSize: 18.0, color:Colors.black38,height:1.0,textBaseline: TextBaseline.alphabetic),
    )),
  [BoxShadow(blurRadius: 2,spreadRadius: 1,color:Colors.white.withOpacity(0.35) ,offset:Offset(-3, -3) ),
   BoxShadow(blurRadius: 2,spreadRadius: 1,color:Colors.black.withOpacity(0.15) ,offset:Offset(3, 3) )]

   ,
  [BoxShadow(blurRadius: 2,spreadRadius: 1,color:Colors.white.withOpacity(0.40) ,offset:Offset(-3, -3) ),
   BoxShadow(blurRadius: 2,spreadRadius: 1,color:Colors.black.withOpacity(0.15) ,offset:Offset(3, 3) )]  

   ,
  [BoxShadow(blurRadius: 2,spreadRadius: 1,color:Colors.white.withOpacity(0.45) ,offset:Offset(-3, -3) ),
   BoxShadow(blurRadius: 2,spreadRadius: 1,color:Colors.black.withOpacity(0.15) ,offset:Offset(3, 3) )]    
  );
 
  Theme_overall yellow = Theme_overall(
  ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF298599),
    scaffoldBackgroundColor: Color(0xFFF5D00B),
    splashColor: Colors.white,
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 22.0, color:Colors.white,fontFamily:"Heading1"),
      headline2: TextStyle(fontSize: 16.0, color:Colors.black54, ),
      headline3: TextStyle(fontSize: 12.0, color:Colors.black38,),
      headline4: TextStyle(fontSize: 18.0, color:Colors.black38,height:1.0,textBaseline: TextBaseline.alphabetic),
    )),
  [BoxShadow(blurRadius: 6,spreadRadius: 2,color:Colors.white.withOpacity(0.40) ,offset:Offset(-3, -3) ),
   BoxShadow(blurRadius: 6,spreadRadius: 2,color:Colors.black.withOpacity(0.15) ,offset:Offset(3, 3) )]  

   ,
  [BoxShadow(blurRadius: 6,spreadRadius: 2,color:Colors.white.withOpacity(0.42) ,offset:Offset(-3, -3) ),
   BoxShadow(blurRadius: 6,spreadRadius: 2,color:Colors.black.withOpacity(0.15) ,offset:Offset(3, 3) )] 

   ,
  [BoxShadow(blurRadius: 6,spreadRadius: 2,color:Colors.white.withOpacity(0.45) ,offset:Offset(-3, -3) ),
   BoxShadow(blurRadius: 6,spreadRadius: 2,color:Colors.black.withOpacity(0.15) ,offset:Offset(3, 3) )] 
  );
 
  @override
  Theme_overall get initialState => grey;

  @override
  Stream<Theme_overall> mapEventToState(ThemeEvent event) async* {
    switch (event) {
        case ThemeEvent.blue:
        yield blue;
        break;
        case ThemeEvent.pink:
        yield pink;
        break;
        case ThemeEvent.green:
        yield green;
        break;
        case ThemeEvent.yellow:
        yield yellow;
        break;
        case ThemeEvent.purple:
        yield purple;
        break;
        case ThemeEvent.grey:
        yield grey;
        break;
    }
  }

}