import 'package:flutter/material.dart';

import 'app_config.dart';
import 'ripple.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double height;
  final double width;
  final Widget leading;
  final void Function() rippleOnTap;
  final List<Widget> actions;
  final Color backgroundColor;

  CustomAppBar(
      {@required this.height,
      @required this.width,
      this.leading = const Icon(Icons.arrow_back_rounded),
      this.rippleOnTap,
      this.actions,
      this.backgroundColor});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size(width, height);
}

class _CustomAppBarState extends State<CustomAppBar> {
  AppConfig _appConfig;
  List<Widget> actions;

  @override
  void initState() {
    actions = widget.actions ?? <Widget>[];
    super.initState();
  }

  @override
  void didUpdateWidget(CustomAppBar oldWidget) {
    actions = widget.actions ?? <Widget>[];
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    _appConfig = AppConfig(context);

    return Container(
      height: _appConfig.setHeightPadding(15),
      color: widget.backgroundColor ?? Colors.transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // leading element with ripple effect
              InkWell(
                onTap: widget.rippleOnTap ?? () => Navigator.pop(context),
                child: Ripple(
                  rippleCount: 3,
                  rippleColor: Colors.white, // color of ripple
                  radius: _appConfig.setHeightPadding(13),
                  backgroundCircleRadius: _appConfig.setHeightPadding(8.2),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: _appConfig.setHeightPadding(0.7),
                      top: _appConfig.setHeightPadding(0.7),
                    ),
                    child: Container(
                        height: _appConfig.setHeightPadding(4.9),
                        child: widget.leading),
                  ),
                ),
              ),
              // logo
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: _appConfig.setHeightPadding(3)),
            child: Container(
              // height: _appConfig.setHeightPadding(8),
              // width: _appConfig.setHeightPadding(8),
              // color: Colors.deepPurple,
              child: Text(
                "Custom App Bar",
                style: TextStyle(fontSize: _appConfig.setHeightPadding(3)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
