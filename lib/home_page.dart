import 'dart:math';

import 'package:custom_drawer/app_config.dart';
import 'package:custom_drawer/appbar_without_ripple.dart';
import 'package:custom_drawer/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ripple_menu_animation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double appBarHeight;
  double bottomNavBarHeight;
  double bodyHeight;
  AppConfig _appConfig;
  GlobalKey<RippleMenuAnimationState> rippleMenuKey = GlobalKey();
  bool isDrawerActive;

  @override
  void initState() {
    isDrawerActive = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _appConfig = AppConfig(context);
    appBarHeight = _appConfig.setHeightPadding(15);
    bottomNavBarHeight = _appConfig.setHeightPadding(10);
    bodyHeight =
        _appConfig.setHeightPadding(100) - (appBarHeight + bottomNavBarHeight);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //Remove StatusBar from top of Screen
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWithoutRipple(
          rippleOnTap: () {
            print("Tapped on menu");
            onRippleMenuTap();
          },
          height: appBarHeight,
          width: _appConfig.setWidthPadding(100),
          backgroundColor: Colors.transparent,
          leading: Icon(
            Icons.home,
            color: Colors.red,
          ), // color of app bar
        ),
        body: Stack(
          fit: StackFit.passthrough,
          children: [
            Container(
              height: bodyHeight,
              alignment: Alignment.topCenter,
              color: Colors.blue,
              child: Center(
                child: Text("Dashboard body"),
              ),
            ),
            Container(
              height: bodyHeight,
              width: _appConfig.setWidthPadding(100),
              child: RippleMenuAnimation(
                key: rippleMenuKey,
                color: Colors.yellow,
                forwardDuration: Duration(milliseconds: 1200),
                maxRadius: sqrt(pow(2 * _appConfig.setWidthPadding(100), 2) +
                    pow(2 * _appConfig.setHeightPadding(100), 2)),
                topPadding: appBarHeight,
                screenSize: Size(
                    _appConfig.setWidthPadding(100), appBarHeight + bodyHeight),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: bottomNavBarHeight,
          child: BottomNavigationBar(items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_box), label: "Account"),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_grocery_store), label: "My Cart"),
          ]),
        ),
      ),
    );
  }

  void onRippleMenuTap() {
    if (rippleMenuKey.currentState.controller.status ==
        AnimationStatus.dismissed) {
      rippleMenuKey.currentState.controller.forward();
    } else if (rippleMenuKey.currentState.controller.status ==
        AnimationStatus.completed) {
      rippleMenuKey.currentState.controller.reverse();
    }
  }
}
