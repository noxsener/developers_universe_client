import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/common-model.dart';
import '../services/common-service.dart';
import '../services/translate-pipe.dart';

class Table extends StatefulWidget {
  Key? key;
  Widget? caption;
  Widget? header;
  Widget? columns;
  FutureBuilder rows;
  Widget? footer;
  Widget? summary;

  Function getRequestGrid;
  Function getTotalRowCount;
  Function onPageChange;

  @override
  State<Table> createState() => _TableState();

  Table(
      {
        this.key,
        this.caption,
      this.header,
      this.columns,
      required this.rows,
      this.footer,
      this.summary,
      required this.getRequestGrid, required this.getTotalRowCount, required this.onPageChange}) : super(key: key);

  static List<Widget> getErrorTemplate(Object? error) {
    return <Widget>[
      const Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 60,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text(
          error != null ? error.toString() : transform('error'),
          style: theme.normalCrossColor(),
        ),
      )
    ];
  }

  static List<Widget> getPleaseWait() {
    return <Widget>[
      const SizedBox(
        width: 60,
        height: 60,
        child: CircularProgressIndicator(),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text(transform('pleaseWait')),
      )
    ];
  }

  static List<Widget> getNoData() {
    return <Widget>[
      Icon(FontAwesomeIcons.exclamationTriangle,
          color: Colors.red[600], size: 48),
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text(
          transform('noRecord'),
          style: theme.labelCrossColor(),
        ),
      )
    ];
  }
}

class _TableState extends State<Table> {

  _TableState();

  void nextPage() {
    RequestGrid requestGrid = widget.getRequestGrid();
    int rowCount = widget.getTotalRowCount();

    if((requestGrid.page! + requestGrid.pageSize!) >= rowCount ) {
      return;
    }

    setState(() {
      if (requestGrid.page == null) {
        requestGrid = RequestGrid.getDefault();
      }
      requestGrid.page = requestGrid.page! + requestGrid.pageSize!;
      widget.onPageChange();
    });
  }

  void previousPage() {
    setState(() {
      RequestGrid requestGrid = widget.getRequestGrid();
      if (requestGrid.page == null) {
        requestGrid = RequestGrid.getDefault();
      }
      if (requestGrid.page! <= 0) {
        return;
      }
      requestGrid.page = requestGrid.page! - requestGrid.pageSize!;
      widget.onPageChange();
    });
  }

  void reset() {
    setState(() {
      RequestGrid requestGrid = widget.getRequestGrid();
      requestGrid.page = 0;
      widget.onPageChange();
    });
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    RequestGrid requestGrid = widget.getRequestGrid();
    int rowCount = widget.getTotalRowCount() ?? requestGrid.pageSize! * 2;

    bool lastPage = (requestGrid.page! + requestGrid.pageSize!) >= rowCount;
    bool firsPage = requestGrid.page! < 1;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(children: [
        if (widget.caption != null) widget.caption!,
        if (widget.header != null) widget.header!,
        if (widget.header != null) const Divider(thickness: 2,),
        if (widget.columns != null) widget.columns!,
        widget.rows,
        if (widget.footer != null) widget.footer!,
        if (widget.summary != null) widget.summary!,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Colors.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Ink(
                      decoration: ShapeDecoration(
                        color: firsPage ? Colors.grey : Colors.lightBlue,
                        shape: CircleBorder(),
                          shadows: theme.shadow()
                      ),
                      child: IconButton(
                        splashColor: const Color(0x9903A9F4),
                        icon: const Icon(Icons.arrow_left,),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            previousPage();
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              (((widget.getRequestGrid() as RequestGrid).page! / (widget.getRequestGrid() as RequestGrid).pageSize!).toInt() + 1).toString() + "/"+((((widget.getTotalRowCount() ?? (widget.getRequestGrid() as RequestGrid).pageSize! * 2) / (widget.getRequestGrid() as RequestGrid).pageSize) as double).toInt() + 1).toString(),
              style: theme.labelCrossColor(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Colors.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Ink(
                      decoration: ShapeDecoration(
                          color: lastPage ? Colors.grey : Colors.lightBlue,
                        shape: CircleBorder(),
                          shadows: theme.shadow()
                      ),
                      child: IconButton(
                        splashColor: const Color(0x9903A9F4),
                        icon: const Icon(Icons.arrow_right),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            nextPage();
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
