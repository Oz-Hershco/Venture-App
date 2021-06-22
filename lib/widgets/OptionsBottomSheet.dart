import 'package:flutter/material.dart';

class OptionsBottomSheet extends StatelessWidget {
  final List<Map<String, dynamic>> options;
  final Function onTap;
  OptionsBottomSheet({
    this.options,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Wrap(
        children: <Widget>[
          ...options.map((option) {
            String title = option['title'];
            String subtitle = option['subtitle'];
            String leadingSrc = option['leadingSrc'];
            bool active = option['active'] != null
                ? (option['active'].toString().toLowerCase() == 'true' ? true : false)
                : false;
            print("");
            print(option['active']);
            print("");
            return new ListTile(
              minVerticalPadding: 0,
              minLeadingWidth: 5,
              horizontalTitleGap: 10,
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: new Image.asset(
                      leadingSrc,
                      color: active
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                      height: 20,
                      width: 20,
                    ),
                  )
                ],
              ),
              title: new Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Heebo',
                  color: active ? Theme.of(context).primaryColor : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: new Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Heebo',
                  color: active
                      ? Theme.of(context).primaryColor
                      : Colors.black.withOpacity(.5),
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {
                onTap(title);
              },
            );
          }).toList()
        ],
      ),
    );
  }
}
