import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:venture_app/models/venture.dart';
import 'package:venture_app/providers/ventures_provider.dart';
import 'package:venture_app/widgets/VentureCard.dart';

class VentureScreen extends StatefulWidget {
  static const routeName = '/venture';
  @override
  _VentureScreenState createState() => _VentureScreenState();
}

class _VentureScreenState extends State<VentureScreen> {
  @override
  Widget build(BuildContext context) {
    final venturesData = Provider.of<VenturesProvider>(context);
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final List<Venture> ventures = venturesData.list;
    final String ventureId = routeArgs['ventureId'].toString();
    final int currentVentureIndex =
        ventures.indexWhere((v) => v.id == ventureId);
    final Venture venture = ventures[currentVentureIndex];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Container(
              height: 20,
              child: new Image.asset(
                "assets/images/chev-left.png",
                fit: BoxFit.contain,
              )),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Venture Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: Theme.of(context).textTheme.bodyText2.fontSize,
            fontWeight: FontWeight.w300,
          ),
        ),
        elevation: 0,
        bottom: PreferredSize(
            child: Container(
              color: Colors.black,
              height: 0.2,
            ),
            preferredSize: Size.fromHeight(0)),
      ),
      body: SingleChildScrollView(
        child: VentureCard(
          venture: venture,
          isExpanded: true,
        ),
      ),
    );
  }
}
