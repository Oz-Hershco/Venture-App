import 'dart:io';

import 'package:flutter/material.dart';
import 'package:venture_app/widgets/ImageGallery.dart';
import 'package:venture_app/widgets/VentureImage.dart';

class ImageGridView extends StatefulWidget {
  final String ventureId;
  final List<String> images;
  final String providerType;
  final bool includeEditOptions;
  final String galleryType;
  ImageGridView({
    this.ventureId,
    this.images,
    this.providerType,
    this.includeEditOptions,
    this.galleryType,
  });

  @override
  _ImageGridViewState createState() => _ImageGridViewState();
}

class _ImageGridViewState extends State<ImageGridView> {
  Widget gridWidget() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: widget.images.length <= 2
          ? (Row(
              children: [
                ...widget.images.map((src) => Expanded(
                      child: VentureImage(
                        type: src.contains('http') ? 'network' : 'file',
                        src: src,
                        file: File(src),
                        fit: BoxFit.cover,
                        imageContainerHeight: widget.images.length == 1 ? 250 : 130,
                      ),
                    ))
              ],
            ))
          : Column(
              children: [
                (Row(
                  children: [
                    ...widget.images.sublist(0, 2).map((src) => Expanded(
                          child: VentureImage(
                            type: src.contains('http') ? 'network' : 'file',
                            src: src,
                            file: File(src),
                            imageContainerHeight: 130,
                            fit: BoxFit.cover,
                          ),
                        ))
                  ],
                )),
                Row(
                  children: [
                    Expanded(
                      child: VentureImage(
                        type: widget.images[2].contains('http')
                            ? 'network'
                            : 'file',
                        src: widget.images[2],
                        file: File(widget.images[2]),
                        imageContainerHeight: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (widget.images.length == 4)
                      Expanded(
                        child: VentureImage(
                          type: widget.images[3].contains('http')
                              ? 'network'
                              : 'file',
                          src: widget.images[3],
                          file: File(widget.images[3]),
                          imageContainerHeight: 130,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (widget.images.length > 4)
                      Expanded(
                        child: Stack(
                          fit: StackFit.passthrough,
                          children: <Widget>[
                            VentureImage(
                              type: widget.images[3].contains('http')
                                  ? 'network'
                                  : 'file',
                              src: widget.images[3],
                              file: File(widget.images[3]),
                              imageContainerHeight: 130,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              height: 130,
                              alignment: Alignment.center,
                              color: Colors.black.withOpacity(.75),
                              child: Text(
                                '+' + (widget.images.length - 4).toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      )
                  ],
                )
              ],
            ),
    );
  }

  Widget columnWidget() {
    return SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ...widget.images.map(
              (src) => Padding(
                padding: const EdgeInsets.only(bottom:10.0),
                child: VentureImage(
                  type: src.contains('http') ? 'network' : 'file',
                  src: src,
                  file: File(src),
                  fit: BoxFit.fitWidth,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String galleryType = widget.galleryType;
    Widget activeWidget;
    switch (galleryType) {
      case 'grid':
        activeWidget = gridWidget();
        break;
      case 'column':
        activeWidget = columnWidget();
        break;
      default:
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          ImageGallery.routeName,
          arguments: {
            'providerType': widget.providerType,
            'ventureId': widget.ventureId,
            'includeEditOptions': widget.includeEditOptions,
          },
        );
      },
      child: activeWidget,
    );
  }
}
