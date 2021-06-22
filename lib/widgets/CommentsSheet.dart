import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:venture_app/models/comment.dart';
import 'package:venture_app/models/user.dart';
import 'package:venture_app/models/venture.dart';
import 'package:venture_app/providers/user_provider.dart';
import 'package:venture_app/providers/ventures_provider.dart';
import 'package:venture_app/widgets/CircularImage.dart';
import 'package:venture_app/widgets/CommentCard.dart';

class CommentsSheet extends StatefulWidget {
  final Venture venture;
  CommentsSheet(this.venture);
  @override
  _CommentsSheetState createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  String _commentInputText = "";
  final _commentInputTextController = TextEditingController();

  _handleCommentAdd() {
    final userData = Provider.of<UserProvider>(context, listen: false);
    final venturesData = Provider.of<VenturesProvider>(context, listen: false);
    final List<Venture> ventures = venturesData.list;
    final User user = userData.item;
    Venture venture = ventures.firstWhere((v) => v.id == widget.venture.id);
    venture.comments.add(
      Comment(
        id: Uuid().v4(),
        text: _commentInputText,
        userId: user.uid,
        time: DateTime.now(),
      ),
    );
    venturesData.updateVenture(venture);
    setState(() {
      _commentInputText = "";
      _commentInputTextController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context, listen: false);
    final User user = userData.item;
    final Venture venture = widget.venture;
    final commentsList = venture.comments.map((c) => CommentCard(c)).toList();
    commentsList.sort((a, b) => a.comment.time.compareTo(b.comment.time));
    return Container(
      // margin: MediaQuery.of(context).viewInsets,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: 1.0, color: Colors.black.withOpacity(.1)),
                  ),
                  color: Colors.black.withOpacity(.1),
                ),
                padding: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Heebo',
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(.5),
                  ),
                ),
              ),
            ],
          ),
          venture.comments.length > 0
              ? Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [...commentsList],
                    ),
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: Text(
                        user != null ? 'Be the first one to say something about this venture.' : 'No one commented on this yet.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Heebo',
                          fontWeight: FontWeight.w300,
                          color: Colors.black.withOpacity(.5),
                        ),
                      ),
                    ),
                  ],
                ),
          user != null
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                              width: 1.0, color: Colors.black.withOpacity(.1)),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularImage(
                            imgSrc: user.profilePic,
                            margin: EdgeInsets.zero,
                            height: 45,
                            width: 45,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 10, right: 5),
                              height: 45,
                              child: TextField(
                                controller: _commentInputTextController,
                                onChanged: (val) {
                                  setState(() {
                                    _commentInputText = val;
                                  });
                                },
                                style: TextStyle(
                                  fontFamily: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .fontFamily,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(.75),
                                ),
                                decoration: InputDecoration(
                                  suffixIcon: _commentInputText.length > 0
                                      ? GestureDetector(
                                          onTap: _handleCommentAdd,
                                          child: Icon(
                                            Icons.send,
                                            size: 20,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                        )
                                      : Icon(
                                          Icons.send,
                                          size: 20,
                                          color: Colors.black.withAlpha(50),
                                        ),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 20),
                                  fillColor: Colors.white,
                                  filled: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  hintText: "What's on your mind?",
                                  hintStyle: TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .fontFamily,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                      color: Colors.black.withAlpha(75)),
                                  labelText: "What's on your mind?",
                                  labelStyle: TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .fontFamily,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                      color: Colors.black.withAlpha(75)),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        width: .5,
                                        color: Colors.black.withAlpha(75)),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        width: .5,
                                        color: Colors.black.withAlpha(75)),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
