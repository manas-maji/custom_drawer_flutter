import 'package:flutter/material.dart';

class DrawerMenu extends StatefulWidget {
  final Size screenSize;
  final double topPadding;

  const DrawerMenu({Key key, this.screenSize, @required this.topPadding})
      : super(key: key);
  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.screenSize.height,
      width: widget.screenSize.width,
      color: Colors.red,
      child: Padding(
        padding: EdgeInsets.only(left: 20),
        child: Center(
          child: ListView(
            children: List.generate(
                20,
                (index) => ListTile(
                      leading: CircleAvatar(
                        child: Text("$index"),
                      ),
                      title: Text("User$index"),
                    )),
          ),
        ),
      ),
    );
  }
}
