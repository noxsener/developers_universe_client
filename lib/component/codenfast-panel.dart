import 'package:flutter/material.dart';

class Panel extends StatelessWidget {
  String id;
  Widget content;
  bool? isvisible;
  bool? stillCollapsingArea;
  Function? onClick;

  Panel(
      {Key? key,
      required this.id,
      required this.content,
      this.isvisible,
      this.stillCollapsingArea,
      this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      maintainSize: stillCollapsingArea ?? true,
      maintainAnimation: stillCollapsingArea ?? true,
      maintainState: stillCollapsingArea ?? true,
      visible: isvisible ?? true,
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
    );
  }

  Hero getHero() {
    return Hero(
          tag: id,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: content,
          ),
        );
  }
}
