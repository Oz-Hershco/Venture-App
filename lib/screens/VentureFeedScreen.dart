import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:venture_app/models/filter_item.dart';
import 'package:venture_app/models/venture.dart';
import 'package:venture_app/providers/user_provider.dart';
import 'package:venture_app/providers/ventures_provider.dart';
import 'package:venture_app/screens/AddNewVentureScreen.dart';
import 'package:venture_app/widgets/LocationMapFilters/LocationMapFiltersList.dart';
import 'package:venture_app/widgets/VentureCard.dart';

class VentureFeedScreen extends StatefulWidget {
  static const routeName = '/ventures-feed';
  @override
  _VentureFeedScreenState createState() => _VentureFeedScreenState();
}

class _VentureFeedScreenState extends State<VentureFeedScreen> {
  List<FilterItem> ventureFilterStates = [];

  void _handleLocationFilterSelect(List<FilterItem> locationMapFilterStates) {
    setState(() {
      ventureFilterStates = locationMapFilterStates;
    });
  }

  // Future<void> _refreshVentures(BuildContext context) async {
  //   Provider.of<VenturesProvider>(context, listen: false).fetchAndSetVentures();
  // }

  @override
  Widget build(BuildContext context) {
    final venturesData = Provider.of<VenturesProvider>(context);
    final userData = Provider.of<UserProvider>(context);
    final ventures = venturesData.list;
    final user = userData.item;

    List<FilterItem> activeLocationFilters =
        ventureFilterStates.where((l) => l.isActive).toList();

    List<Venture> filteredVentures = ventures
        .where((v) => (activeLocationFilters.length > 0)
            ? activeLocationFilters
                    .where((f) =>
                        v.type.where((l) => l.isActive).toList()[0].id == f.id)
                    .toList()
                    .length >
                0
            : true)
        .toList();

    final filteredVenturesCards = filteredVentures.map((venture) {
      return VentureCard(venture: venture);
    }).toList();
    filteredVenturesCards
        .sort((a, b) => b.venture.timestamp.compareTo(a.venture.timestamp));
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: Container(
          height: 50,
          child: user != null
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      AddNewVentureScreen.routeName,
                      arguments: {'isEditMode': false},
                    );
                  },
                  child: Container(
                    height: 25,
                    child: new Image.asset(
                      'assets/images/feed_nav_icon.png',
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Theme.of(context).accentColor,
                  elevation: 3,
                )
              : null,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  child: Column(
                    children: [
                      LocationMapFiltersList(
                        onChange: _handleLocationFilterSelect,
                        containerMargin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        itemsBorderStyle: Border.all(
                          width: .25,
                          color: Colors.black.withOpacity(.5),
                        ),
                      ),
                      Container(
                        color: Colors.black.withOpacity(.75),
                        height: .25,
                      )
                    ],
                  ),
                ),
              ),
              if (filteredVentures.length > 0) ...filteredVenturesCards,
              if (filteredVentures.length == 0)
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Center(
                    child: Text(
                      "No ventures to show under this filtering...",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Heebo',
                          fontWeight: FontWeight.w300,
                          color: Colors.black.withOpacity(.5)),
                    ),
                  ),
                )
            ],
          ),
        ));
  }
}
