import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_read/ui/home_page.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:sqflite/sqflite.dart';
import 'book.dart';
import 'database.dart';

class pdf_reader extends StatefulWidget {

  final Book book;
  final void Function() callback;
  pdf_reader(this.book, this.callback);
  @override
  _pdf_readerState createState() => _pdf_readerState();
}

class _pdf_readerState extends State<pdf_reader> {

  bool app_bar = true;
  int _actualPageNumber;
  PageController pageController ;
  PDFDocument _document;
  double opacity = 1;
  bool tap = true;

    DatabaseHelper databaseHelper = DatabaseHelper();
    
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
       SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    _actualPageNumber = int.parse(widget.book.last_page_opened);
    pageController = PageController(
    initialPage: _actualPageNumber-1,);
    load_pdf();
  }

  void load_pdf(){
      final Future<Database> dbFuture = databaseHelper.initializeDatabase();
      dbFuture.then((databse) async {
      Future<List<Book>> predictionList = databaseHelper.get_Recent_BookofList();
      await predictionList.then((pre) async {
          print("database length is "+pre.length.toString());
       pre.forEach((element) async { 
          print("element and title are "+widget.book.title+" and "+element.title);
          if(element.title == widget.book.title)
           { 
               Book b =  widget.book;
               await databaseHelper.delete_Recent_Book(element.id).whenComplete((){
               print('book has been deleted');
          });
          }
        });
          databaseHelper.insertBook_to_recent(widget.book);
          print('book has been inserted to recent');
      });
      }).whenComplete((){widget.callback();});
      
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
       SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        tap = false;
        opacity = 0;
     });
    });
  }
  @override
  Widget build(BuildContext context) {
   
    if(tap){
     Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        tap = false;
     });
    });
    }
    return Scaffold(
     backgroundColor: Colors.grey[200],
      body: FutureBuilder<PDFDocument>(
          initialData: _document,
          future: _getDocument(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: <Widget>[
      GestureDetector(
        onTap: (){
          setState(() {
            if(!tap)
            tap = true;
          });
        },
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                      child: PDFView(
            scrollDirection: Axis.vertical ,
            document: snapshot.data,
            controller: pageController,
            onPageChanged: (page) {
              setState(() {
                opacity = 1;
                _actualPageNumber = page;
                print(widget.book.last_page_opened);
                widget.book.last_page_opened = '$page';
                print(widget.book.last_page_opened);
                databaseHelper.updateBook(widget.book);
                databaseHelper.update_Recent_Book(widget.book);
              });   Future.delayed(const Duration(milliseconds: 1000), () {
                setState(() {
                opacity = 0;

              }); 
               });
            },
        ),
          ),
      ),      
       Positioned(
          top: MediaQuery.of(context).padding.top,
          child:  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    color: Colors.black.withOpacity(0.7),
                    height: tap ? MediaQuery.of(context).size.height*0.12 : 0,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        tap ? Expanded(
                          flex: 1,
                          child: IconButton(icon: Icon(Icons.arrow_left,size: 30,), onPressed: (){Navigator.pop(context);})) : Container(),
                        Expanded(
                          flex: 6,
                          child: Container(child: Center(child: Text(widget.book.title,overflow: TextOverflow.ellipsis,)))),
                         ],
                    ),
                  ),),
       Positioned(
            right: 5,
            bottom:5 ,
            child: AnimatedOpacity(
              opacity: opacity,
              duration:
              Duration(milliseconds: 200),
              child: Container(
                margin: EdgeInsets.only(top:5),
                padding: EdgeInsets.only(left: 5,right: 5),
                color: Colors.black38,
                child: Text(
              '$_actualPageNumber/${snapshot.data.pagesCount}',
              style: TextStyle(fontSize: 18,),
            ),
              ),
            ),
          )
                ],
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
      'PDF Rendering does not '
      'support on the system of this version',
                ),
              );
            
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
    );
  }
  
  Future<PDFDocument> _getDocument() async {
    if (_document != null) {
      return _document;
    }
      return _document = await PDFDocument.openFile(widget.book.path);
  }
}