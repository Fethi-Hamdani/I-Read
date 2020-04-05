   import 'package:flutter/material.dart';

   ThemeData blue = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF298599),
    scaffoldBackgroundColor: Color(0xFF1EC5E8),
    fontFamily: 'Georgia',
    textTheme: TextTheme(
      headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ));
    
   ThemeData pink = new ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF298599),
    scaffoldBackgroundColor: Color(0xFFEC8AB2),
    fontFamily: 'Georgia',
    textTheme: TextTheme(
      headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ));
  
   ThemeData green = new ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF298599),
    scaffoldBackgroundColor: Color(0xFF09CBAE),
    fontFamily: 'Georgia',
    textTheme: TextTheme(
      headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ));

   ThemeData purple = new ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF298599),
    scaffoldBackgroundColor: Color(0xFF41278D),
    fontFamily: 'Georgia',
    textTheme: TextTheme(
      headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ));

   ThemeData grey = new ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF298599),
    scaffoldBackgroundColor: Color(0xFFE0E5EC),
    fontFamily: 'Georgia',
    textTheme: TextTheme(
      headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ));

   ThemeData yellow = new ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF298599),
    scaffoldBackgroundColor: Color(0xFFF5D00B),
    fontFamily: 'Georgia',
    textTheme: TextTheme(
      headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ));


// shadow BOXes : small , Med, Large , search

/*  Tasks

*** add bloc for shadow


headline1 for page title
headline2 for book title
headline3 for book inforrmation
headline4 for search




fetch for pdf files in Doc and Dow
get a list of files


14 book in my phone

first time :
save all files as 

  file path, favorite = 0, recent = 0, last page opend(initilzed by 0)
  size and date can be obtained from path

other times

  compare if file exist in DB already or not
  if not it get added

delete file from storage and DB

rename file in storage and update DB path

add to fav, update DB fav to 1

last page opened update each time to DB

when the file is opened it is auto added to recent 

favorite book from recent

search on theme change

re match first table update with the second table 
share file
favorite from recent
delete files that doesn't exist in device but exist in database
renaming update 
sign the app
loading books in every section
*** NOT DONE YET ***









problems:

pdf takes too long to load the page

save theme to shared prefrences

add more options to the app

use Bloc instead of setstate using RXDart plugin

*/