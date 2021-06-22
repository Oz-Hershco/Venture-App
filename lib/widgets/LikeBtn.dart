import 'package:flutter/material.dart';

class LikeBtn extends StatefulWidget {
  final Function onTap;
  final bool isActive;
  LikeBtn({this.onTap, @required this.isActive});
  @override
  _LikeBtnState createState() => _LikeBtnState();
}

class _LikeBtnState extends State<LikeBtn> {

  void _handleLike() {
    bool isActive = widget.isActive;
    if (widget.onTap != null) {
      widget.onTap(!isActive);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isActive = widget.isActive;
    return GestureDetector(
      onTap: _handleLike,
      child: Container(
        height: 50,
        width: 180,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 7),
              height: 16,
              child: new Image.asset(
                isActive
                    ? 'assets/images/fullheart_icon.png'
                    : 'assets/images/heart_icon.png',
                color: isActive
                    ? Theme.of(context).errorColor.withOpacity(.85)
                    : Colors.black.withOpacity(.5),
              ),
            ),
            Text(
              'Like',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Heebo',
                fontWeight: FontWeight.w400,
                color: isActive
                    ? Theme.of(context).errorColor.withOpacity(.85)
                    : Colors.black.withOpacity(.5),
              ),
            )
          ],
        ),
      ),
    );
  }
}
