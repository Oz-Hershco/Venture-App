import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:venture_app/models/comment.dart';
import 'package:venture_app/models/user.dart';
import 'package:venture_app/providers/users_provider.dart';
import 'package:venture_app/widgets/CircularImage.dart';
import 'package:venture_app/widgets/Spinner.dart';

class CommentCard extends StatefulWidget {
  final Comment comment;
  CommentCard(this.comment);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;

    return FutureBuilder(
        future: Firestore.instance
            .collection('users')
            .document(comment.userId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Spinner(
              color: Theme.of(context).primaryColor,
              sizeWidth: 40,
              sizeHeight: 40,
              circleStrokeWidth: 4,
            );
          }
          return Container(
            padding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 15,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom:
                    BorderSide(width: .25, color: Colors.black.withOpacity(.5)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularImage(
                      imgSrc: snapshot.data['profilePic'],
                      height: 35,
                      width: 35,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data['username'],
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Heebo',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            Moment.fromDate(comment.time)
                                .format("MMMM dd yyy, HH:mm"),
                            style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'Heebo',
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(.5)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text(
                        comment.text,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Heebo',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }
}
