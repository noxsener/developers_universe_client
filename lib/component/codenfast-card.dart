import 'package:flutter/material.dart';

import '../services/common-service.dart';

class Card extends StatelessWidget {
  String title;
  String? subText;
  Widget? icon;
  bool? isvisible;
  bool? stillCollapsingArea;
  Function? onClick;

  Card(
      {Key? key,
      required this.title,
      this.subText,
      this.icon,
      this.isvisible,
      this.stillCollapsingArea,
      this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: InkWell(
          onTap: () {
            if (onClick != null) {
              onClick!();
            }
          },
          child: getHero(),
        ),
      ),
      maintainSize: stillCollapsingArea ?? true,
      maintainAnimation: stillCollapsingArea ?? true,
      maintainState: stillCollapsingArea ?? true,
      visible: isvisible ?? true,
    );
  }

  Hero getHero() {
    return Hero(
          tag: title,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Material(
              child: ListTile(
                leading: icon,
                title: Text(
                  title,
                  style: theme.cardHeader(),
                ),
                subtitle: Text(
                  subText ?? '',
                  style: theme.cardSubText(),
                ),
                isThreeLine: subText != null && subText!.isNotEmpty,
              ),
            ),
          ),
        );
  }
}
