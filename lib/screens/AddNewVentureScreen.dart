import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:venture_app/constants/functions.dart';
import 'package:venture_app/models/filter_item.dart';
import 'package:venture_app/models/user.dart';
import 'package:venture_app/models/venture.dart';
import 'package:venture_app/models/venturelocation.dart';
import 'package:venture_app/models/venturetag.dart';
import 'package:venture_app/providers/user_provider.dart';
import 'package:venture_app/providers/venture_provider.dart';
import 'package:venture_app/providers/ventures_provider.dart';
import 'package:venture_app/widgets/AddImagesBtn.dart';
import 'package:venture_app/widgets/ImageGridView.dart';
import 'package:venture_app/widgets/LocationMapFilters/LocationMapFiltersList.dart';
import 'package:venture_app/widgets/LocationSearch.dart';
import 'package:venture_app/widgets/LocationTagsControl/LocationTagsControl.dart';
import 'package:venture_app/widgets/Spinner.dart';

class AddNewVentureScreen extends StatefulWidget {
  static const routeName = '/add-new-venture';

  AddNewVentureScreen({
    Key key,
  }) : super(key: key);
  @override
  _AddNewVentureScreenState createState() => _AddNewVentureScreenState();
}

class _AddNewVentureScreenState extends State<AddNewVentureScreen> {
  bool _isLoadingInProgress = false;

  final siteNameTextController = TextEditingController();
  final siteDetailsTextController = TextEditingController();
  String addressText;
  LatLng addressLatLng;
  List<FilterItem> locationMapFilterStates = [];
  List<VentureTag> tagNames;
  final ImagePicker picker = ImagePicker();
  List<String> images = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      final ventureData = Provider.of<VentureProvider>(context, listen: false);
      final Venture venture = ventureData.item;
      siteNameTextController.text = venture.title;
      siteDetailsTextController.text = venture.description;
      addressText = venture.position != null ? venture.position.address : "";
      addressLatLng = venture.position != null ? venture.position.latLng : null;

      if (venture.type != null) {
        locationMapFilterStates = venture.type;
      }

      tagNames = venture.tags;
      images = venture.images;
    });
  }

  void _handleLocationSelection(BuildContext context) async {
    Navigator.pop(context);
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final VentureLocation result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationSearch(),
      ),
    );

    setState(() {
      addressText = result.address != null ? result.address : null;
      addressLatLng = result.latLng != null ? result.latLng : null;
    });
  }

  void _handleCurrentLocationSelect() {
    if (!_isLoadingInProgress) {
      Navigator.pop(context);
      setState(() {
        _isLoadingInProgress = true;
      });
      getUserLocationAddress().then((location) {
        setState(() {
          addressText = location.address;
          addressLatLng = location.latLng;
          _isLoadingInProgress = false;
        });
      });
    }
  }

  void _showLocationPicker(context) {
    if (!_isLoadingInProgress) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: new Wrap(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 7, top: 3),
                          child: Text("Add Location",
                              style: TextStyle(
                                fontFamily: 'Heebo',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.black.withOpacity(0.4);
                                return Colors
                                    .black; // Defer to the widget's default.
                              },
                            ),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.transparent;
                                return null; // Defer to the widget's default.
                              },
                            ),
                          ),
                          onPressed: () {
                            _handleLocationSelection(context);
                          },
                          child: Text(
                            'Search for location',
                            style: TextStyle(
                              fontFamily: 'Heebo',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.disabled))
                                    return Colors.black.withOpacity(0.25);
                                  return Theme.of(context)
                                      .primaryColorLight; // Defer to the widget's default.
                                },
                              ),
                              elevation: MaterialStateProperty.all(0)),
                          onPressed: _handleCurrentLocationSelect,
                          child: Text(
                            'Use current location',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          });
    }
  }

  void _handleLocationFilterSelection(
      List<FilterItem> selectedLocationMapFilterStates) {
    setState(() {
      locationMapFilterStates = selectedLocationMapFilterStates;
    });
  }

  void _handleTagSelection(List<VentureTag> tags) {
    setState(() {
      tagNames = tags;
    });
  }

  _publishValidation() {
    if (siteNameTextController.text.length > 0 &&
        siteDetailsTextController.text.length > 0 &&
        addressText != null &&
        addressLatLng != null &&
        locationMapFilterStates.where((f) => f.isActive).length > 0 &&
        images.length > 0 &&
        !_isLoading) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _handlePublishNewSite() async {
    setState(() {
      _isLoading = true;
    });
    final venturesData = Provider.of<VenturesProvider>(context, listen: false);
    final ventureData = Provider.of<VentureProvider>(context, listen: false);
    final userData = Provider.of<UserProvider>(context, listen: false);
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final isEditMode = routeArgs['isEditMode'];

    final Venture venture = ventureData.item;

    final Venture newVenture = Venture(
      id: isEditMode ? venture.id : "",
      type: locationMapFilterStates,
      title: siteNameTextController.text,
      description: siteDetailsTextController.text,
      position: VentureLocation(
        address: addressText,
        latLng: addressLatLng,
      ),
      timestamp: isEditMode ? venture.timestamp : DateTime.now(),
      creatorId: userData.item.uid,
      images: [...images],
      tags: tagNames,
      likes: isEditMode ? venture.likes : [],
      comments: isEditMode ? venture.comments : [],
    );
    try {
      if (isEditMode) {
        await venturesData.updateVenture(newVenture);
      } else {
        await venturesData.addVenture(newVenture);
      }
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occured!'),
          content: Text('Something went wrong, please try again later.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Center(
                child: Text('Ok'),
              ),
            )
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final isEditMode = routeArgs['isEditMode'];
    final ventureData = Provider.of<VentureProvider>(context);


    return Scaffold(
      backgroundColor: Colors.white,
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: .5, color: Colors.black.withAlpha(75)),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 100),
            child: Container(
              width: 150,
              height: 45,
              margin: EdgeInsets.symmetric(vertical: 15),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled))
                          return Colors.black.withOpacity(0.25);
                        return Theme.of(context)
                            .accentColor; // Defer to the widget's default.
                      },
                    ),
                    elevation: MaterialStateProperty.all(0)),
                onPressed: _publishValidation() ? _handlePublishNewSite : null,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 20,
                        margin: EdgeInsets.only(right: 10),
                        child: new Image.asset(
                          'assets/images/feed_nav_icon.png',
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        isEditMode ? 'UPDATE' : 'PUBLISH',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Heebo',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
          isEditMode ? 'Edit Venture' : 'Add New Venture',
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
      body: _isLoading
          ? Spinner(
              color: Theme.of(context).accentColor,
              sizeWidth: 40,
              sizeHeight: 40,
              circleStrokeWidth: 4,
            )
          : SingleChildScrollView(
              child: Container(
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 90),
                child: Column(
                  children: [
                    TextField(
                      controller: siteNameTextController,
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.bodyText1.fontFamily,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                        fillColor: Colors.white,
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintText: "Site Name *",
                        alignLabelWithHint: true,
                        hintStyle: TextStyle(
                            fontFamily: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .fontFamily,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.black.withAlpha(75)),
                        labelText: 'Site Name *',
                        labelStyle: TextStyle(
                            fontFamily: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .fontFamily,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.black.withAlpha(75)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: new BorderSide(
                            style: BorderStyle.none,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: new BorderSide(
                            style: BorderStyle.none,
                          ),
                        ),
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(3),
                            borderSide: new BorderSide(
                              style: BorderStyle.none,
                            )),
                      ),
                    ),
                    TextField(
                      controller: siteDetailsTextController,
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      maxLines: null,
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.bodyText1.fontFamily,
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15),
                        fillColor: Colors.white,
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintText: "Add details about this site *",
                        alignLabelWithHint: true,
                        hintStyle: TextStyle(
                            fontFamily: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .fontFamily,
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                            color: Colors.black.withAlpha(75)),
                        labelText: 'Add details about this site *',
                        labelStyle: TextStyle(
                            fontFamily: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .fontFamily,
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                            color: Colors.black.withAlpha(75)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: new BorderSide(
                              width: .5, color: Colors.black.withAlpha(75)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: new BorderSide(
                              width: .5, color: Colors.black.withAlpha(75)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 13),
                        ),
                        onPressed: () {
                          _showLocationPicker(context);
                        },
                        child: _isLoadingInProgress
                            ? Container(
                                child: Spinner(
                                  color: Theme.of(context).primaryColorLight,
                                  sizeWidth: 15,
                                  sizeHeight: 15,
                                  circlePadding: 0,
                                  circleStrokeWidth: 2,
                                ),
                              )
                            : Row(children: <Widget>[
                                Container(
                                  height: 22,
                                  margin: EdgeInsets.only(left: 5, right: 10),
                                  child: new Image.asset(
                                    'assets/images/pin_icon.png',
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Container(
                                  width: 250,
                                  child: Wrap(
                                    children: [
                                      Text(
                                        addressText.length > 0
                                            ? addressText
                                            : 'Add location',
                                        style: TextStyle(
                                          fontFamily: 'Heebo',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                      ),
                    ),
                    LocationMapFiltersList(
                      isRadio: true,
                      itemsBorderStyle: Border.all(
                        width: .25,
                        color: Colors.black.withOpacity(.5),
                      ),
                      containerMargin: EdgeInsets.only(top: 20),
                      onChange: _handleLocationFilterSelection,
                      initValues: locationMapFilterStates,
                    ),
                    LocationTagsControl(
                      onChange: _handleTagSelection,
                      initValues: tagNames,
                    ),
                    // Container(
                    //   height: 400,
                    //   child: GridView.count(
                    //     crossAxisCount: 2,
                    //     crossAxisSpacing: 5,
                    //     mainAxisSpacing: 5,
                    //     children: [
                    //       Image.network(
                    //         'https://loveincorporated.blob.core.windows.net/contentimages/gallery/32cfa085-5a31-48c2-bec8-46b887ac9428-views_great_wall_china.jpg',
                    //         fit: BoxFit.cover,
                    //       ),
                    //       Image.network(
                    //         'https://loveincorporated.blob.core.windows.net/contentimages/gallery/32cfa085-5a31-48c2-bec8-46b887ac9428-views_great_wall_china.jpg',
                    //         fit: BoxFit.cover,
                    //       ),
                    //       Image.network(
                    //         'https://loveincorporated.blob.core.windows.net/contentimages/gallery/32cfa085-5a31-48c2-bec8-46b887ac9428-views_great_wall_china.jpg',
                    //         fit: BoxFit.cover,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    if (images.length > 0)
                      ImageGridView(
                        ventureId: ventureData.item.id,
                        images: images,
                        providerType: 'venture',
                        includeEditOptions: true,
                        galleryType: 'grid',
                      ),
                    Row(
                      children: [AddImagesBtn(images: images)],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    final ventureData = Provider.of<VentureProvider>(context, listen: false);
    ventureData.updateSingleVenture(Venture(
      id: Uuid().v4().toString(),
      type: null,
      title: "",
      description: "",
      position: null,
      timestamp: null,
      creatorId: "",
      images: [],
      tags: [],
      likes: [],
      comments: [],
    ));
  }
}
