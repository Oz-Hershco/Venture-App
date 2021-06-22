import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:venture_app/models/venturetag.dart';
import 'package:venture_app/widgets/LocationTagsControl/LocationTag.dart';

class LocationTagsControl extends StatefulWidget {
  final Function onChange;
  final List<VentureTag> initValues;
  LocationTagsControl({
    this.onChange,
    this.initValues,
  });
  @override
  _LocationTagsControlState createState() => _LocationTagsControlState();
}

class _LocationTagsControlState extends State<LocationTagsControl> {
  String tagInput = '';
  List<VentureTag> tagNames = [];
  TextEditingController tagsInputTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.initValues != null && widget.initValues.length > 0) {
      tagNames = widget.initValues;
    }
  }

  void _handleAddTag() {
    String uuid = Uuid().v4().toString();
    setState(() {
      tagNames.add(VentureTag(id: uuid, name: tagInput));
      widget.onChange(tagNames);
    });
    tagsInputTextController.text = '';
  }

  void _handleRemoveTag(String id) {
    setState(() {
      tagNames.removeWhere((e) => e.id == id);
      widget.onChange(tagNames);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        TextField(
          controller: tagsInputTextController,
          onChanged: (val) {
            setState(() {
              tagInput = val;
            });
          },
          onEditingComplete: _handleAddTag,
          style: TextStyle(
            fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
            fontWeight: FontWeight.w300,
            fontSize: 13,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            fillColor: Colors.white,
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            hintText: "Add relevant tags(optional)",
            alignLabelWithHint: true,
            hintStyle: TextStyle(
                fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
                fontWeight: FontWeight.w300,
                fontSize: 15,
                color: Colors.black.withAlpha(75)),
            labelText: 'Add relevant tags(optional)',
            labelStyle: TextStyle(
                fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
                fontWeight: FontWeight.w300,
                fontSize: 15,
                color: Colors.black.withAlpha(75)),
            enabledBorder: UnderlineInputBorder(
              borderSide:
                  new BorderSide(width: .5, color: Colors.black.withAlpha(75)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  new BorderSide(width: .5, color: Colors.black.withAlpha(75)),
            ),
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Wrap(
            direction: Axis.horizontal,
            children: tagNames
                .map((val) => LocationTag(
                      id: val.id,
                      name: val.name,
                      onDelete: _handleRemoveTag,
                    ))
                .toList(),
          ),
        )
      ],
    ));
  }
}
