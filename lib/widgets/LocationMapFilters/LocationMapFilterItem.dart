import 'package:flutter/material.dart';

class LocationMapFilterItem extends StatelessWidget {
  const LocationMapFilterItem({
    this.id,
    this.name,
    this.iconSrc,
    this.isActive,
    this.handleItemtap,
    this.borderStyle,
  });

  final String id;
  final String iconSrc;
  final String name;
  final bool isActive;
  final Function handleItemtap;
  final Border borderStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        handleItemtap(id, isActive);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          border: borderStyle,
          borderRadius: BorderRadius.circular(100),
          color: isActive ? Theme.of(context).primaryColor : Colors.white,
        ),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 14,
              margin: EdgeInsets.only(right: 3),
              child: new Image.asset(
                iconSrc,
                color: isActive ? Colors.white : Colors.black,
              ),
            ),
            Text(
              name,
              style: TextStyle(
                  fontSize: 12, color: isActive ? Colors.white : Colors.black),
            )
          ],
        )),
      ),
    );
  }
}
