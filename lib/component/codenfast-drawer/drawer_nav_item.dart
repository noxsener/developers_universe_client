import 'package:flutter/material.dart';

class DrawerNavItem extends StatelessWidget {
  final Icon icon;
  final String label;
  final double size;
  final Color color;
  final List<BoxShadow>? shadows;
  final Color background;

  const DrawerNavItem(
      {Key? key,
      required this.icon,
      this.label = "",
      this.size = 25.0,
      this.color = Colors.black54,
      this.shadows,
      this.background = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size)),
      color: background,
      type: MaterialType.button,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: label.isNotEmpty
              ? <Widget>[
                  Icon(icon.icon, size: size, color: color),
                  const SizedBox(width: 5),
                  Text(
                    label,
                    style: TextStyle(color: color, shadows: shadows),
                  ),
                ]
              : <Widget>[
                  Icon(icon.icon, size: size, color: color),
                ],
        ),
      ),
    );
  }
}

class NavButton extends StatelessWidget {
  final double position;
  final int length;
  final int index;
  final bool isEndDrawer;
  final double width;
  final Color color;
  final ValueChanged<int> onTap;
  final Icon icon;

  NavButton(
      {required this.onTap,
      required this.position,
      required this.length,
      required this.isEndDrawer,
      required this.width,
      required this.color,
      required this.index,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    final desiredPosition = 1.0 / length * index;
    final difference = (position - desiredPosition).abs();
    final verticalAlignment = 1 - length * difference;
    final opacity = length * difference;
    final directionMultiplier = isEndDrawer ? 1 : -1;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTap(index);
        },
        child: Container(
            width: width,
            child: Transform.translate(
              offset: Offset(
                  difference < 1.0 / length
                      ? verticalAlignment * directionMultiplier * 40
                      : 0,
                  0),
              child: Opacity(
                  opacity: difference < 1.0 / length * 0.99 ? opacity : 1.0,
                  child: Icon(
                    icon.icon,
                    color: color,
                  )),
            )),
      ),
    );
  }
}
