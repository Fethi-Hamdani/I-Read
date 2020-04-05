import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:i_read/Block/Theme_overall.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:share_extend/share_extend.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Alerts.dart';
import '../Block/block.dart';
import '../book.dart';
import '../database.dart';
import '../pdf_reader.dart';

class CounterPage extends StatefulWidget {
 
  CounterPage(this.small, this.medium, this.large);
  final List<BoxShadow> small;
  final List<BoxShadow> medium;
  final List<BoxShadow> large;

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  TextEditingController _controller = new TextEditingController();
  List<Widget> items = new List(), favorite= new List(), recent= new List();
  PageController controller = PageController();
  int page_index=0;
  String page = "My Library";
  int f = 0;
  String id = '';
  var focusNode = new FocusNode();
  bool focused = true, share = false, feedback = false;
  List<BoxShadow> small , medium, large;
  List<Book> books, recent_books;
  DatabaseHelper databaseHelper = DatabaseHelper();

  Widget replacment = CircularProgressIndicator();

   @override
   void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    small = widget.small;
    medium = widget.medium;
    large = widget.large;
    load_database();
    load_recent();
  }
   void load_recent(){
      recent_books = new List();
       final Future<Database> dbFuture = databaseHelper.initializeDatabase();
      dbFuture.then((databse) async {
      Future<List<Book>> predictionList = databaseHelper.get_Recent_BookofList();
      await predictionList.then((pre) async {
        print(" recent table length is :"+pre.length.toString()); 
        recent_books = pre.reversed.toList();
      });
      });
      
    }

   void load_database(){
      final Future<Database> dbFuture = databaseHelper.initializeDatabase();
      dbFuture.then((databse) async {
      Future<List<Book>> predictionListFuture = databaseHelper.getBookofList();
      await predictionListFuture.then((pre) async {
        print(" books table length is :"+pre.length.toString()); 
        load_pdf_files(pre);
      });
      });
      
   }    
   
   void load_pdf_files(List<Book> books_from_DB){
     books_from_DB.forEach((element) async { 
       if(! await File(element.path).exists())
       {
         databaseHelper.deleteBook(element.id);
         books_from_DB.remove(element);
       }
       recent_books.forEach((element) async {
          if(! await File(element.path).exists())
          {
            databaseHelper.delete_Recent_Book(element.id);
            recent_books.remove(element);
          }
        });
     }); 
     books = new List();
     List<String> path_obtained = new List();
     books_from_DB.forEach((element) { 
       path_obtained.add(element.path);
     });
      bool externalStoragePermissionOkay = false;
         if (Platform.isAndroid) {
    SimplePermissions
          .checkPermission(Permission.WriteExternalStorage)
          .then((checkOkay) async {
        if (!checkOkay) {
          SimplePermissions
              .requestPermission(Permission.WriteExternalStorage)
              .then((okDone) {
            if (okDone == PermissionStatus.authorized){
                debugPrint("${okDone}");
                externalStoragePermissionOkay = true;
                debugPrint('Refresh UI');
                setState(() {
                });
            }
          });
        } else {
      externalStoragePermissionOkay = checkOkay;
        }

        if(externalStoragePermissionOkay)
        {
            Directory extDir = Directory("/storage/emulated/0/");
            List<FileSystemEntity> _files;
            _files = extDir.listSync(recursive: true, followLinks: false);
            print("PDF files has been loaded succefully");   
            print("Books fro database lkength is : "+books_from_DB.length.toString()); 
           _files.forEach((element) { 
            if(element.path.endsWith("pdf")){
               print("books length is :"+books.length.toString());
               if(books_from_DB.length==0)
               { 
               print("inserting n:"+_files.indexOf(element).toString());
               databaseHelper.insertBook(new Book.withdata(element.path, '0','0'));
               books.add(new Book.withdata(element.path, '0','0'));
               }
               else
               {
                 if(path_obtained.contains(element.path))
                 {
                  books.add(books_from_DB[path_obtained.indexOf(element.path)]);
                 }
                 else{
                    databaseHelper.insertBook(new Book.withdata(element.path, '0', '0'));
                    books.add(new Book.withdata(element.path, '0', '0'));
                 }
               }
            } 
            });  
            setState(() {
              focused = false;
            });
        }
      });

    }
   
   }
   
   void search(String f) {
    
     items = new List();
     favorite = new List();
     if(page_index ==2) 
     {recent = new List();
     print('updating recent');
       recent_books.forEach((element) { 
         if(element.title.toLowerCase().contains(f.toLowerCase())) 
            recent.add(Book_widget(element));
       });
       replacment =  Text("no recent books");
     }
     else
     books.forEach((element) {
       switch(page_index){
         case 0: if(element.title.toLowerCase().contains(f.toLowerCase())) 
            items.add(Book_widget(element)); break;
         case 1: if(element.title.toLowerCase().contains(f.toLowerCase()) && element.favorite=="1") 
            favorite.add(Book_widget(element));break;
         default:break;    
                   }
    });

    setState(() {
     if(page_index ==2 && recent.length<=0)
     replacment =  Text("no recent books", style:Theme.of(context).textTheme.headline3,);
     if(page_index ==0 && books.length<=0)
     replacment =  Text("no books found yet!", style:Theme.of(context).textTheme.headline3,);
     if(page_index ==1 && favorite.length<=0)
     replacment =  Text("no favorite books", style:Theme.of(context).textTheme.headline3,);
    });
    
  }
  
   Widget Book_widget(Book book){
      GlobalKey btnKey = new GlobalKey();
      return Container(
        decoration: BoxDecoration
        (color:Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: id == book.title ? null : medium,
        ),
        margin: EdgeInsets.only(top:10,bottom: 10,left: 15,right: 15),
        width: double.infinity,
        height:MediaQuery.of(context).size.height*0.1,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: (){setState(() {
                      id = book.title;
                    });
                          Future.delayed(Duration(milliseconds: 45),(){
                           setState(() {
                                id = '';
                                    });
                            }).whenComplete((){
                    Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => pdf_reader(book,(){
                        load_recent();
                      }))
                    ).whenComplete((){
                      print("out of pdf");
                      setState(() {
                      search('');
                      });
                      });
                            });
                  },
                              child: Container(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.01),
                  height: MediaQuery.of(context).size.height*0.1,
                  child: Center(child: Image.asset("assets/img.png",fit: BoxFit.fill,)),),
              )),
            Expanded(
              flex: 6,
                child: GestureDetector
                (
                  onTap: (){
                   setState(() {
                      id = book.title;
                    });
                          Future.delayed(Duration(milliseconds: 45),(){
                           setState(() {
                                id = '';
                                    });
                            }).whenComplete((){
                               Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => pdf_reader(book,(){
                        load_recent();
                      }))
                    ).whenComplete((){
                      print("out of pdf");
                      setState(() {
                      search('');
                      });
                      });
                            });
                   
                
                  },
                  child: Container(
                    padding: EdgeInsets.only
                    (top:MediaQuery.of(context).size.height*0.01, bottom:MediaQuery.of(context).size.height*0.01 ),
                    color: Colors.transparent,
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("${book.title}",style:Theme.of(context).textTheme.headline2,overflow: TextOverflow.ellipsis,),
                    Container(
                      width: MediaQuery.of(context).size.width*0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("${book.location}",style:TextStyle(fontSize: 12,color:Theme.of(context).textTheme.headline4.color,fontFamily: Theme.of(context).textTheme.headline4.fontFamily)),
                          Text("${book.size}",style:Theme.of(context).textTheme.headline3,),
                      ],),
                    )
                  ],
              ),
                                  ),
                ),
            ), 
            Expanded(
              flex: 1,
              child: GestureDetector(
                key: btnKey,
                onTap: (){menu_list(btnKey,book);},
                child: Container(
                  alignment: Alignment.center,
                  child: RichText(                    
                             overflow: TextOverflow.visible, // Never clip.
                             text: TextSpan(
                             text: String.fromCharCode(Icons.more_vert .codePoint ),
                             style: TextStyle(
                             inherit: false,
                             color: Theme.of(context).primaryColor,
                   fontSize: MediaQuery.of(context).size.width*0.08,
                   fontFamily: Icons.more_vert .fontFamily,
                    package:Icons.more_vert .fontPackage,
                    ),
                   ),
                   ),
                ),
              ),)
          ],
        ),
      );
    }
  
   void Rename(BuildContext context, Book book) async {

  TextEditingController text = new TextEditingController(text:book.title );
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
          Text(book.title,
              style: 
                Theme.of(context).textTheme.headline1
              ),
                
                Container(
                  margin: EdgeInsets.only(top:MediaQuery.of(context).size.width*0.09 ),
                  height: MediaQuery.of(context).size.width*0.09,
                  child: TextField(
                  maxLines: 1,
                  controller: text,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top:2,bottom:2),
                          hintText: 'enter a new name...',hintStyle: Theme.of(context).textTheme.headline4,
                        ),  
            ),
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
              print(text);
                if(text !=null && !text.text.contains("/")){
                    int index = books.indexOf(book);
                   if(page_index == 2)
                   {
                   books.forEach((element) { 
                   if(element.title == book.title){
                   index = books.indexOf(element);
                   }
                   }); 
                   String oldpath = book.path;
                   book.update_title(text.text);
                   books[index].update_title(text.text);
                   recent_books[recent_books.indexOf(book)]= book;
                   databaseHelper.updateBook(books[index]);
                   databaseHelper.update_Recent_Book(book);
                   File(oldpath).rename(book.path);
              }

              else{
                String oldpath = book.path;
                book.update_title(text.text);
                books[index].update_title(text.text);
                databaseHelper.updateBook(books[index]);
                recent_books.forEach((element) {
                  if(element.title == book.title)
                  {
                    element.update_title(text.text);
                    databaseHelper.update_Recent_Book(element);
                  }
                 });
                File(oldpath).rename(book.path);
              }   
              search('');
                 
                print(book.path);
                Navigator.pop(context);
                
                }}
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

   void Delete(BuildContext context, Book book) async {

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
          Text("Are You sure you want to delete "+book.title,
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
            
                  setState(() { 
                File(book.path).delete();
                databaseHelper.deleteBook(book.id);
                databaseHelper.delete_Recent_Book(book.id);
                books.remove(book);    
                Navigator.pop(context);
                  });
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
   
   void menu_list(GlobalKey btnkey, Book book) {
    String favorite =  book.favorite;
    int index = books.indexOf(book);
    if(page_index == 2)
    {
      books.forEach((element) { 
        if(element.title == book.title){
        favorite = element.favorite;
          index = books.indexOf(element);
        }
      });
    }
     
    PopupMenu menu = PopupMenu(
        // backgroundColor: Colors.teal,
        // lineColor: Colors.tealAccent,
        maxColumn: 4,
        items: [
          MenuItem(title: 'Rename', image:  Icon(
                Icons.edit,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Favorite',
              // textStyle: TextStyle(fontSize: 10.0, color: Colors.tealAccent),
              image: Icon(
                favorite =='0' ? Icons.favorite_border : Icons.favorite,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Delete',
              image: Icon(
                Icons.delete_forever,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Share',
              image: Icon(
                Icons.share,
                color: Colors.white,
              )),
        ],
        onClickMenu: (option) async {
  
            switch(option.menuTitle){
  
              case 'Rename': Rename(context, book); break;
  
              case 'Favorite': 
              setState(() {
              print(book.favorite);
              if(page_index == 2)
              {
              books[index].favorite = books[index].favorite == '1'  ? '0' :'1';
              recent_books[recent_books.indexOf(book)] = book;
              }
              else   
              book.favorite = book.favorite == '1'  ? '0' :'1';
              print(book.favorite);
              databaseHelper.updateBook(books[index]);
              databaseHelper.update_Recent_Book(books[index]);
              search('');
              });
              break;
              case 'Delete': Delete(context, book); break;
  
              case 'Share': 
              File testFile = new File(book.path);
              ShareExtend.share(testFile.path,book.title);
              break;
  
            }
          },
        );
    menu.show(widgetKey: btnkey);
  }

   Widget Button_page(IconData c, int val){
    bool on = page_index == val;
    double size = MediaQuery.of(context).size.width*0.13;
    return GestureDetector(
        onTap: (){
          controller.animateToPage(val, duration: Duration(milliseconds: 200),curve: Curves.easeIn);
          setState(() {
            page = val ==0 ? "My Library" : val == 1 ? "Favorite" : val == 2 ? "Recent" : "Settings";
          });
        },
        child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: size, height: size,
        alignment: Alignment(0, 0),
        child: Icon(c,size: 30,color:on ? Theme.of(context).splashColor : Theme.of(context).primaryColor,),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: on ? null:small,
        ),
      ),
    );
  }

   Widget button(Color c, ThemeEvent s, Theme_overall k){
    bool on = Theme.of(context).scaffoldBackgroundColor == c ;
    return !on ? GestureDetector(
      onTap: ()  {
        context.bloc<ThemeBloc>().add(s); 
      
        setState((){
        small = k.small;
        medium = k.medium;
        large = k.large;
        items = new List();
        favorite = new List();
        recent = new List();

      });},
          child: Container(
          margin: EdgeInsets.only(top:10,bottom: 10),
                       width: MediaQuery.of(context).size.width*0.1,
                       height:MediaQuery.of(context).size.width*0.1,
                       decoration: BoxDecoration
                       (color:c,
                         borderRadius: BorderRadius.circular(15),
                         boxShadow: small,
                         border: Border.all(color:Colors.white)
                       ),
      ),
    ): NeuCard(width: MediaQuery.of(context).size.width*0.1,
               height:MediaQuery.of(context).size.width*0.1,
               bevel: 15,
               curveType: CurveType.emboss,
               decoration: NeumorphicDecoration(
                    color:Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(15)),
               );
  }

  @override
  Widget build(BuildContext context) { 
    PopupMenu.context = context;
    if(!focused){ 
      search('');
    }
    Future.delayed(Duration(milliseconds: 3500),(){
      search('');
    });
    return WillPopScope(
      onWillPop: (){
        if(page_index == 0)
            Exit(context);
        else{
          controller.animateToPage(0, duration: Duration(milliseconds: 200),curve: Curves.easeIn);
          setState(() {
            page ="My Library";
          });
        }
      },
          child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                  child: Row(
                    mainAxisAlignment: page_index !=3 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                    children: [Container(
                      height: MediaQuery.of(context).size.width*0.1,
                      child: Center(child: Text(page,style:Theme.of(context).textTheme.headline1,))),
                      page_index !=3 ? NeuCard(
                      bevel: 18,
                      padding: EdgeInsets.only(left: 5),
                      curveType: CurveType.emboss,
                      decoration: NeumorphicDecoration(
                      color:Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(18)),
                      height: MediaQuery.of(context).size.width*0.09,
                      width: MediaQuery.of(context).size.width*0.52,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.width*0.09,
                            width: MediaQuery.of(context).size.width*0.3,
                            child: TextField(controller: _controller,
                              onTap: (){setState(() {
                                focused  = true;
                              });},
                              onChanged: (value){
                                setState(() {
                                  search(value);
                                });
                              } ,
                              focusNode: focusNode,
                            decoration: InputDecoration(
                             border: InputBorder.none,
                              
                              hintText: 'search...',hintStyle: Theme.of(context).textTheme.headline4,
                            ),      
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                            setState(() {
                              if(focused)
                              {
                              _controller.clear();
                              FocusScope.of(context).unfocus();
                              search('');
                              }
                              else
                              FocusScope.of(context).requestFocus(focusNode);
                              focused  = !focused;
                            });
                          },
                            child: Container(
                              height: MediaQuery.of(context).size.width*0.09,
                              width: MediaQuery.of(context).size.width*0.09,
                              child: Center(
                         child: RichText(
                               overflow: TextOverflow.visible, // Never clip.
                               text: TextSpan(
                               text: String.fromCharCode(focused ? Icons.clear.codePoint : Icons.search.codePoint ),
                               style: TextStyle(
                               inherit: false,
                               color: Theme.of(context).textTheme.headline4.color,
                     fontSize: MediaQuery.of(context).size.width*0.06,
                     fontFamily: Icons.clear_all.fontFamily,
                      package: focused ? Icons.clear.fontPackage : Icons.search.fontPackage,
                      ),
                     ),
                     ),
                       ),
                            ),
                          ),
                          
                        ],
                      ),
                    ) : Container(),
                    ]))),
              Expanded(
                flex: 8,
                child: PageView(
                  controller: controller,
          children: <Widget>[
            Container(
              child: Center(
                child:items.length>0 ? NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (overscroll) {
                                 overscroll.disallowGlow();
                           },
                                child: ListView(children: items,
              ),
                ): replacment),
            ),
            Container(
              child: Center(
                child:favorite.length>0 ? NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (overscroll) {
                                 overscroll.disallowGlow();
                           },
                                child: ListView(children: favorite,
              ),
                ):replacment),
            ),
            Container(
              child:  Container(
              child: Center(
                child:recent.length>0 ? NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (overscroll) {
                                 overscroll.disallowGlow();
                           },
                                child: ListView(children: recent,
              ),
                ):replacment),
            ),
            ),
            Container(
              child: Center(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[

                    Container(
                         margin: EdgeInsets.only(top:10,bottom: 10,left: 15,right: 15),
                         padding: EdgeInsets.only(top:5,bottom: 5),
                         width: double.infinity,
                         height: MediaQuery.of(context).size.height*0.15,
                         decoration: BoxDecoration
                         (color:Theme.of(context).scaffoldBackgroundColor,
                           borderRadius: BorderRadius.circular(15),
                           boxShadow:large,
                         ),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: <Widget>[
                           Text("Theme Color",style: Theme.of(context).textTheme.headline2),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceAround,
                             children: <Widget>[
                                button(Color(0xFF1EC5E8), ThemeEvent.blue,BlocProvider.of<ThemeBloc>(context).blue),
                                button(Color(0xFFEC8AB2), ThemeEvent.pink,BlocProvider.of<ThemeBloc>(context).pink),
                                button(Color(0xFF09CBAE), ThemeEvent.green,BlocProvider.of<ThemeBloc>(context).green),
                                button(Color(0xFF41278D), ThemeEvent.purple,BlocProvider.of<ThemeBloc>(context).purple),
                                button(Color(0xFFE0E5EC), ThemeEvent.grey,BlocProvider.of<ThemeBloc>(context).grey),
                                button(Color(0xFFF5D00B), ThemeEvent.yellow,BlocProvider.of<ThemeBloc>(context).yellow),
                             ],
                           )
                         ],),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                     GestureDetector(
                       onTap:  (){
                        setState(() {
                            feedback = true;
                           });
                          Future.delayed(Duration(milliseconds: 45),(){
                           setState(() {
                               feedback = false;
                                    });
                            }).whenComplete(() async {
                              const url = "https://mail.google.com/mail/u/0/?view=cm&fs=1&to=fethinvrfail@gmail.com";
                             if (await canLaunch(url)) {
                                 await launch(url);
                               } else {
                                 throw 'Could not launch $url';
                             }
                            });
                      },
                                            child: Container(
                         margin: EdgeInsets.only(top:10,bottom: 10,left: 15,right: 15),
                         padding: EdgeInsets.only(top:5,bottom: 5),
                         width: double.infinity,
                         height: MediaQuery.of(context).size.height*0.1,
                         decoration: BoxDecoration
                         (color:Theme.of(context).scaffoldBackgroundColor,
                           borderRadius: BorderRadius.circular(15),
                           boxShadow: feedback ? null : medium,
                         ),
                         child: Center(child: Text("Send Feedback",style: Theme.of(context).textTheme.headline2,)),
                    ),
                     ),
                      
                  Container(
                       margin: EdgeInsets.only(top:10,bottom: 10,left: 15,right: 15),
                       padding: EdgeInsets.only(top:5,bottom: 5),
                       width: double.infinity,
                       height: MediaQuery.of(context).size.height*0.16,
                       child: Center(child: Column(
                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                         children: <Widget>[
                           Text("My socials:",style: Theme.of(context).textTheme.headline1),
     Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                      ),
                      GestureDetector(
                        onTap: () async {
                          const url = "https://www.linkedin.com/in/-fethi/";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                               color:Theme.of(context).scaffoldBackgroundColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(360)),
                                boxShadow: large),
                            width: 40,
                            height: 40,
                            child: Image.asset(
                              'assets/linkedin.png',
                              fit: BoxFit.contain,
                            )),
                      ),
                      GestureDetector(
                        onTap: () async {
                          const url = "https://github.com/Fethi1";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color:Theme.of(context).scaffoldBackgroundColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(360)),
                                boxShadow:large),
                            width: 40,
                            height: 40,
                            child: Image.asset(
                              'assets/github.png',
                              fit: BoxFit.contain,
                            )),
                      ),
                      GestureDetector(
                        onTap: () async {
                          const url = "https://www.facebook.com/fethi.psy.3/";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color:Theme.of(context).scaffoldBackgroundColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(360)),
                                boxShadow:large),
                            width: 40,
                            height: 40,
                            child: Image.asset(
                              'assets/facebook.png',
                              fit: BoxFit.contain,
                            )),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                      ),
                    ],
                  ),
             
                         ],
                       )),
                    ),

                  ],
                )),
            )
          ],
          physics: BouncingScrollPhysics(),
            onPageChanged: (num){
              setState(() {
                page = num ==0 ? "My Library" : num == 1 ? "Favorite" : num == 2 ? "Recent" : "Settings";
                page_index = num;
              });}
        ),),
              Expanded(flex: 1,
                          child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Button_page(Icons.home,0),
                    Button_page(Icons.favorite,1),
                    Button_page(Icons.history,2),
                    Button_page(Icons.settings,3),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

