import 'package:flutter/material.dart';

import 'Pub.dart';

class MyPubCard extends StatelessWidget {
  final Pub pub;
  final Function() onTap;
  final bool isHighlighted;

  const MyPubCard({
    Key? key,
    required this.pub,
    required this.onTap,
    this.isHighlighted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: isHighlighted
                ? Theme.of(context).accentColor
                : Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: new Border.all(color: Colors.white, width: 2),
                ),
                child: Stack(
                  children: [
//photo
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: pub.images.isEmpty
                          ? Container(
                        color: Theme.of(context).primaryColor,
                        child: Center(child: Icon(Icons.deck_rounded, size: 80,)),)
                          : Image.network(pub.images[0].url, fit: BoxFit.fill),
                    ),

//name
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            width: double.infinity,
                            height: 44,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(16),
                                    bottomLeft: Radius.circular(16)),
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(1),
                                      Colors.black.withOpacity(0),
                                    ])),
                            child: Center(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Text(
                                pub.name,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ))))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
