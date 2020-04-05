
import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  GlobalKey btnKey = GlobalKey();
  GlobalKey btnKey2 = GlobalKey();
  GlobalKey btnKey3 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
    return Scaffold(
      body: Container(
        alignment: Alignment.centerRight,
        child: Container(
          child: MaterialButton(
            key: btnKey2,
            height: 45.0,
            onPressed: customBackground,
            child: Text('Show Menu'),
          ),
        ),
      ),
    );
  }

  void customBackground() {
    PopupMenu menu = PopupMenu(
        // backgroundColor: Colors.teal,
        // lineColor: Colors.tealAccent,
        // maxColumn: 2,
        items: [
          MenuItem(title: 'Copy', image:  Icon(
                Icons.menu,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Home',
              // textStyle: TextStyle(fontSize: 10.0, color: Colors.tealAccent),
              image: Icon(
                Icons.home,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Mail',
              image: Icon(
                Icons.mail,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Power',
              image: Icon(
                Icons.power,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Setting',
              image: Icon(
                Icons.settings,
                color: Colors.white,
              )),
          MenuItem(
              title: 'PopupMenu',
              image: Icon(
                Icons.menu,
                color: Colors.white,
              ))
        ],
        onClickMenu: (_){},
        stateChanged: (_){},
        onDismiss: (){});
    menu.show(widgetKey: btnKey2);
  }
}