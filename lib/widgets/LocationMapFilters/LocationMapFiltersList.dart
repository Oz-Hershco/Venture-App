import 'package:flutter/material.dart';
import 'package:venture_app/models/filter_item.dart';
import 'package:venture_app/widgets/LocationMapFilters/LocationMapFilterItem.dart';

class LocationMapFiltersList extends StatefulWidget {
  final EdgeInsets containerMargin;
  final double containerHeight;
  final Border itemsBorderStyle;
  final Function onChange;
  final bool isRadio;
  final List<FilterItem> initValues;

  LocationMapFiltersList({
    this.containerMargin,
    this.containerHeight = 30,
    this.itemsBorderStyle,
    this.onChange,
    this.isRadio = false,
    this.initValues,
  });

  @override
  _LocationMapFiltersListState createState() => _LocationMapFiltersListState();
}

class _LocationMapFiltersListState extends State<LocationMapFiltersList> {
  List<FilterItem> _locationMapFilterStates = [
    // FilterItem(
    //   id: '1',
    //   name: 'North',
    //   iconSrc: 'assets/images/compass_north_icon.png',
    //   isActive: false,
    // ),
    // FilterItem(
    //   id: '2',
    //   name: 'Center',
    //   iconSrc: 'assets/images/compass_center_icon.png',
    //   isActive: false,
    // ),
    // FilterItem(
    //   id: '3',
    //   name: 'South',
    //   iconSrc: 'assets/images/compass_south_icon.png',
    //   isActive: false,
    // ),
    FilterItem(
      id: '4',
      name: 'Trails',
      iconSrc: 'assets/images/trail_icon.png',
      isActive: false,
    ),
    FilterItem(
      id: '5',
      name: 'Camping',
      iconSrc: 'assets/images/camping_icon.png',
      isActive: false,
    ),
    FilterItem(
      id: '6',
      name: 'BBQ Sites',
      iconSrc: 'assets/images/bbq_icon.png',
      isActive: false,
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.initValues != null && widget.initValues.length >0){
      _locationMapFilterStates = widget.initValues;
    }
  }

  void _handleMapFilterTap(String id, bool currentState) {
    FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus.unfocus();
    }
    setState(() {
      if (widget.isRadio) {
        _locationMapFilterStates.forEach((element) {
          if (element.id == id) {
            element.isActive = true;
          } else {
            element.isActive = false;
          }
        });
      } else {
        _locationMapFilterStates.forEach((element) {
          if (element.id == id) {
            element.isActive = !currentState;
          }
        });
      }
      if (widget.onChange != null) {
        widget.onChange(_locationMapFilterStates);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.containerMargin,
      height: widget.containerHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          ..._locationMapFilterStates.map((e) => LocationMapFilterItem(
                id: e.id,
                name: e.name,
                iconSrc: e.iconSrc,
                isActive: e.isActive,
                handleItemtap: _handleMapFilterTap,
                borderStyle: widget.itemsBorderStyle,
              ))
        ],
      ),
    );
  }
}
