import 'package:flutter/material.dart';

class MyRestaurantCard extends StatelessWidget {
  final Function() onTap;
  final String title;
  final bool isHighlighted;

  const MyRestaurantCard({
    Key? key,
    required this.onTap,
    required this.title,
    this.isHighlighted = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: isHighlighted ? Theme.of(context).accentColor : Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                child: Stack(
                  children: [
//photo
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(16)),
                    ),

//name
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            width: double.infinity,
                            height: 44,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16)),
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(1),
                                      Colors.black.withOpacity(0),
                                    ])),
                            child: Center(
                                child: Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline2,
                            ))))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
