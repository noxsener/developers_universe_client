library card_scroll_widget;

import 'dart:math';

import 'package:flutter/material.dart';

class CardScrollWidget extends StatelessWidget {
  int currentPage;
  double padding = 16.0;
  double verticalInset = 24.0;
  double cardAspectRatio = 12.0 / 16.0;
  double widgetAspectRatio = (12.0 / 16.0)/* cardAspectRatio */ * 1.2;
  List<String> images = [];

  CardScrollWidget(this.currentPage, this.images);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, constraints) {
        var width = constraints.maxWidth;
        var height = constraints.maxHeight;

        var safeWidth = width - 2 * padding;
        var safeheight = height - 2 * padding;

        var heightOfPrimaryCard = safeheight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = [];

        for (int i = 0; i < images.length; i++) {
          var delta = i - currentPage;
          bool isOnRight = delta > 0;
          var start =
              padding + max(primaryCardLeft -
                  horizontalInset * -delta * (isOnRight ? 15 : 1), 0.0);
          var cardItem = Positioned.directional(
              top: padding + verticalInset * max(-delta, 0.0),
              bottom: padding + verticalInset * max(-delta, 0.0),
              start: start,
              textDirection: TextDirection.rtl,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(color: Colors.black12,
                        offset: Offset(3.0, 6.0),
                        blurRadius: 10.0)
                  ]),
                  child: AspectRatio(
                    aspectRatio: cardAspectRatio,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.asset(
                          images[i],
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 2,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 16.0),
                              Row(
                                children: <Widget>[
                                  SizedBox(width: padding +
                                      verticalInset * max(-delta, 0.0)),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xFFffffffff),
                                        borderRadius: BorderRadius.circular(
                                            20.0)),
                                    child: Center(
                                      child: Padding(
                                        padding:
                                        EdgeInsets.symmetric(
                                            horizontal: 22.0, vertical: 6.0),
                                        child: Text(
                                          "Design",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "Product_Sans_Regular",
                                              fontSize: 12.0,
                                              height: 1.4),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 16.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Basics of \nColour theory",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 32.0,
                                        fontFamily: "Product_Sans_Bold"),
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  ClipOval(
                                    child: Image.asset(
                                      "images/three.jpg",
                                      fit: BoxFit.cover,
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                        EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 0.0),
                                        child: Text(
                                          "Raj Krishnan",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                              fontFamily: "Product_Sans_Regular"),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 0.0),
                                        child: Text(
                                          "6 min ago",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.0,
                                              fontFamily: "Product_Sans_Regular"),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ));
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
  }
}