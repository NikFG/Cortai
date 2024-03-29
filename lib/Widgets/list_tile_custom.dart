import 'package:flutter/material.dart';

class ListTileCustom extends StatelessWidget {
  final GestureTapCallback onTap;
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final GestureLongPressCallback? onLongPress;
  final Color color;

  ListTileCustom(
      {required this.leading,
      required this.title,
      required this.onTap,
      this.subtitle,
      this.trailing,
      this.onLongPress,
      this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5),
      height: 120,
      child: Card(
          color: color,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey[300]!, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Align(
            alignment: Alignment.center,
            child: ListTile(
              onTap: onTap,
              onLongPress: onLongPress,
              leading: leading,
              title: title,
              subtitle: subtitle,
              trailing: trailing,
            ),
          )),
    );
  }
}
