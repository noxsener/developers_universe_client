import 'package:flutter/cupertino.dart';

class MenuItem {
  String? label;
  String? description;
  bool? visible;
  IconData? icon;
  String? image;
  List<MenuItem>? items;
  Function? onClick;

  MenuItem({this.label, this.description, this.visible, this.icon, this.image, this.items, this.onClick});


}