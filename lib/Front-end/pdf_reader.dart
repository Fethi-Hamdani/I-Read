import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Back-end/prefrences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Back-end/book.dart';
import '../Back-end/database.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:sqflite/sqflite.dart';

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
  bool tap = true, horizantal;
 TextEditingController _controller = TextEditingController();
    DatabaseHelper databaseHelper = DatabaseHelper();
    
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
       SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
   
    _actualPageNumber = int.parse(widget.book.last_page_opened);
    print(_actualPageNumber);
    pageController = PageController(
    initialPage: _actualPageNumber-1,);
    _controller.text = _actualPageNumber.toString();
    load_pdf();
  }

  Future<void> load_pdf() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
       horizantal = prefs.getBool(scrolling_vertical);
       print('Horizantal scrolling is $horizantal');
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
      Future.delayed(const Duration(milliseconds: 2500), () {
      setState(() {
        tap = false;
        opacity = 0;
     });
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
            tap = !tap;
          });
        },
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                      child: PDFView(
            scrollDirection:horizantal ? Axis.horizontal : Axis.vertical ,
            document: snapshot.data,
            controller: pageController,
            onPageChanged: (page) {
              setState(() {
                opacity = 1;
                _actualPageNumber = page;
                _controller.text = page.toString();
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
                    height: tap ? MediaQuery.of(context).size.height*0.1 : 0,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        tap ? Expanded(
                          flex: 1,
                          child: IconButton(icon: Icon(Icons.arrow_left,size: 40,color: Theme.of(context).scaffoldBackgroundColor,), onPressed: (){Navigator.pop(context);})) : Container(),
                        Expanded(
                          flex: 4,
                          child: Container(child: Center(child: Text(widget.book.title,style: TextStyle(fontSize: 22), overflow: TextOverflow.ellipsis,)))),
                        tap ? Expanded(
                          flex: 2,
                          child:Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Container(
            width: 70.0,
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                color: Theme.of(context).scaffoldBackgroundColor,
                width: 2.0,
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    controller: _controller,
                    onEditingComplete: (){
                      if(int.parse(_controller.text)>= 1 && int.parse(_controller.text)<=snapshot.data.pagesCount){
                         switch_page(int.parse(_controller.text));
                         FocusScope.of(context).unfocus();
                      }
                    },
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                                  child: Container(
                    height: 38.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: InkWell(
                            child: Icon(
                              Icons.arrow_drop_up,
                              size: 18.0,
                            ),
                            onTap: () {
                              int currentValue = int.parse(_controller.text);
                              setState(() {
                                if(currentValue<snapshot.data.pagesCount){
                                currentValue++;
                                switch_page(currentValue);
                                _controller.text = (currentValue)
                                    .toString();} // incrementing value
                              });
                            },
                          ),
                        ),
                        InkWell(
                          child: Icon(
                            Icons.arrow_drop_down,
                            size: 18.0,
                          ),
                          onTap: () {
                            int currentValue = int.parse(_controller.text);
                            setState(() {
                              if(currentValue>1){
                              currentValue--;
                              switch_page(currentValue);
                              _controller.text =
                                  (currentValue > 0 ? currentValue : 0)
                                      .toString();} // decrementing value
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
    ))
   : Container(),
                       
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
         ,
       
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
  void switch_page(int index){
    pageController.jumpToPage(index-1);
  }
  Future<PDFDocument> _getDocument() async {
    if (_document != null) {
      return _document;
    }
      return _document = await PDFDocument.openFile(widget.book.path);
  }
}


class NumberInputWithIncrementDecrement extends StatefulWidget {
  final void Function(int) switch_page;
  final int current_page;
  final int max_page;

  const NumberInputWithIncrementDecrement( this.switch_page, this.current_page, this.max_page);

  
  @override
  _NumberInputWithIncrementDecrementState createState() =>
      _NumberInputWithIncrementDecrementState();
}

class _NumberInputWithIncrementDecrementState
    extends State<NumberInputWithIncrementDecrement> {
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller.text = widget.current_page.toString(); // Setting the initial value for the field.
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Container(
            width: 70.0,
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                color: Theme.of(context).scaffoldBackgroundColor,
                width: 2.0,
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    controller: _controller,
                    onEditingComplete: (){
                      if(int.parse(_controller.text)>= 1 && int.parse(_controller.text)<=widget.max_page){
                         widget.switch_page(int.parse(_controller.text));
                      }
                    },
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                                  child: Container(
                    height: 38.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: InkWell(
                            child: Icon(
                              Icons.arrow_drop_up,
                              size: 18.0,
                            ),
                            onTap: () {
                              int currentValue = int.parse(_controller.text);
                              setState(() {
                                if(currentValue<widget.max_page){
                                currentValue++;
                                widget.switch_page(currentValue);
                                _controller.text = (currentValue)
                                    .toString();} // incrementing value
                              });
                            },
                          ),
                        ),
                        InkWell(
                          child: Icon(
                            Icons.arrow_drop_down,
                            size: 18.0,
                          ),
                          onTap: () {
                            int currentValue = int.parse(_controller.text);
                            setState(() {
                              if(currentValue>1){
                              currentValue--;
                              widget.switch_page(currentValue);
                              _controller.text =
                                  (currentValue > 0 ? currentValue : 0)
                                      .toString();} // decrementing value
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  
  }
}