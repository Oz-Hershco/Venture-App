import 'package:flutter/material.dart';

class LocationTag extends StatelessWidget {
  final String id;
  final String name;
  final Function onDelete;
  LocationTag({@required this.id, @required this.name, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        alignment: FractionalOffset.center,
        margin: EdgeInsets.only(top: 10, right: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(.05),
            border: Border.all(
              width: .5,
              color: Colors.black.withOpacity(.5),
            ),
            borderRadius: BorderRadius.circular(100)),
        child: Row(children: [
          Text(
            name,
            style: TextStyle(
              color: Colors.black.withOpacity(.5),
              fontFamily: 'Heebo',
              fontSize: 12,
            ),
          ),
          if (onDelete != null)
            GestureDetector(
              onTap: () {
                onDelete(id);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  'X',
                  style: TextStyle(
                      color: Colors.black.withOpacity(.5),
                      fontFamily: 'Heebo',
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
              ),
            )
        ]),
      ),
    );
  }
}
