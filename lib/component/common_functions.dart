import 'package:flutter/material.dart';

import '../services/common-service.dart';

Visibility generateVisibleWidget(Widget widget, bool isShow, bool stillCollapsingArea) {
  return Visibility(
    child: widget,
    maintainSize: stillCollapsingArea,
    maintainAnimation: stillCollapsingArea,
    maintainState: stillCollapsingArea,
    visible: isShow,
  );
}

Future<void> selectDate(BuildContext context, onFinish(DateTime), {DateTime? selectedDate, DateTime? firstDate, DateTime? lastDate}) async {
  final DateTime? picked = await showDatePicker(
    context: context, locale: locale,
    initialDate: selectedDate ?? DateUtils.dateOnly(DateTime.now()),
    firstDate: firstDate ?? DateTime.now().add(const Duration(days: -366)),
    lastDate: lastDate ?? DateTime.now().add(const Duration(days: 366)),
  );
  onFinish(picked);
}