import 'package:flutter/material.dart';
import 'package:venture_app/widgets/VentureCard.dart';

class ActivityTabs extends StatefulWidget {
  ActivityTabs({this.myfeedcardlist, this.mysavedcardlist});
  final List<VentureCard> myfeedcardlist;
  final List<VentureCard> mysavedcardlist;
  @override
  _ActivityTabsState createState() => _ActivityTabsState();
}

class _ActivityTabsState extends State<ActivityTabs> {
  int currentTabIndex = 0;

  void handleTabSelect(index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Expanded(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              TabBar(
                onTap: handleTabSelect,
                indicatorWeight: 1.2,
                indicatorColor: Theme.of(context).primaryColor,
                labelColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(fontSize: 10),
                unselectedLabelColor: Colors.black.withOpacity(.5),
                tabs: [
                  Tab(
                    text: 'MY VENTURES',
                    icon: Container(
                      height: 20,
                      child: currentTabIndex == 0
                          ? Image.asset(
                              'assets/images/feed_nav_icon.png',
                              color: Theme.of(context).primaryColor,
                            )
                          : Image.asset(
                              'assets/images/feed_nav_icon.png',
                              color: Colors.black.withOpacity(.5),
                            ),
                    ),
                  ),
                  Tab(
                    text: 'SAVED LIST',
                    icon: Container(
                      height: 20,
                      child: currentTabIndex == 1
                          ? Image.asset(
                              'assets/images/bookmark_icon.png',
                              color: Theme.of(context).primaryColor,
                            )
                          : Image.asset(
                              'assets/images/bookmark_icon.png',
                              color: Colors.black.withOpacity(.5),
                            ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    SingleChildScrollView(
                      child: widget.myfeedcardlist.length > 0
                          ? Column(
                              children: widget.myfeedcardlist,
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.35,
                              padding: EdgeInsets.symmetric(horizontal:40),
                              child: Center(
                                child: Text(
                                  "No ventures to show. Go on a venture and share with the community!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Heebo',
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black.withOpacity(.5)),
                                ),
                              ),
                            ),
                    ),
                    SingleChildScrollView(
                      child: widget.mysavedcardlist.length > 0
                          ? Column(
                              children: widget.mysavedcardlist,
                            )
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.35,
                              child: Center(
                                child: Text(
                                  "You haven't saved any ventures yet.",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Heebo',
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black.withOpacity(.5)),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
