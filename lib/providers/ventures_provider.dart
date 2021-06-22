import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:venture_app/models/comment.dart';
import 'package:venture_app/models/filter_item.dart';
import 'package:venture_app/models/user.dart';
import 'package:venture_app/models/venture.dart';
import 'package:venture_app/models/venturelocation.dart';
import 'package:venture_app/models/venturetag.dart';

class VenturesProvider with ChangeNotifier {
  List<Venture> _list = [];

  List<Venture> get list {
    return [..._list];
  }

  Future<void> fetchAndSetVentures() async {
    try {
      final List<Venture> loadedVentures = [];
      var venturesData =
          await Firestore.instance.collection('ventures').getDocuments();

      venturesData.documents.forEach((element) {
        Map<String, dynamic> ventureData = element.data;
        String ventureId = element.documentID;

        List<dynamic> type = ventureData['type'];
        List<dynamic> tags =
            ventureData['tags'] != null ? ventureData['tags'] : [];
        List<dynamic> likes =
            ventureData['likes'] != null ? ventureData['likes'] : [];
        List<dynamic> comments =
            ventureData['comments'] != null ? ventureData['comments'] : [];
        List<String> images = ventureData['images'] != null
            ? List.from(ventureData['images'])
            : null;
        loadedVentures.add(
          Venture(
            id: ventureId,
            title: ventureData['title'],
            description: ventureData['description'],
            type: type
                .map(
                  (t) => FilterItem(
                    id: t['id'],
                    name: t['name'],
                    iconSrc: t['iconSrc'],
                    isActive: t['isActive'],
                  ),
                )
                .toList(),
            position: VentureLocation(
              address: ventureData['position']['address'],
              latLng: LatLng(
                ventureData['position']['latLng']['latitude'],
                ventureData['position']['latLng']['longitude'],
              ),
            ),
            images: images,
            timestamp: DateTime.parse(ventureData['timestamp']),
            creatorId: ventureData['creatorId'],
            tags: tags
                .map((t) => VentureTag(
                      id: t['id'],
                      name: t['name'],
                    ))
                .toList(),
            likes: likes.map((u) => User(uid: u['uid'])).toList(),
            comments: comments
                .map((c) => Comment(
                      id: c['id'],
                      text: c['text'],
                      time: DateTime.parse(c['time']),
                      userId: c['userId'],
                    ))
                .toList(),
          ),
        );
      });

      _list = loadedVentures;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addVenture(Venture venture) async {
    try {
      final response = await Firestore.instance.collection('ventures').add({
        'type': venture.type
            .map((t) => {
                  'id': t.id,
                  'name': t.name,
                  'isActive': t.isActive,
                  'iconSrc': t.iconSrc,
                })
            .toList(),
        'title': venture.title,
        'description': venture.description,
        'position': {
          'address': venture.position.address,
          'latLng': {
            'latitude': venture.position.latLng.latitude,
            'longitude': venture.position.latLng.longitude,
          },
        },
        'timestamp': venture.timestamp.toString(),
        'creatorId': venture.creatorId,
        'images': [],
        'tags': venture.tags
            .map((t) => {
                  'id': t.id,
                  'name': t.name,
                })
            .toList(),
        'likes': venture.likes.map((ul) => ul.toJson()).toList(),
        'comments': venture.comments
            .map((c) => {
                  'id': c.id,
                  'text': c.text,
                  'time': c.time.toString(),
                  'userId': c.userId,
                })
            .toList(),
      });

      List<String> uploadedImagesSrcs = await _uploadMultipleImages(
        imageArr: venture.images,
        imageIdentifier: venture.creatorId,
        folderIdentifier: response.documentID,
      );

      await Firestore.instance
          .collection('ventures')
          .document(response.documentID)
          .updateData({
        'images': uploadedImagesSrcs,
      });

      final Venture newUpdatedVenture = Venture(
          id: response.documentID,
          title: venture.title,
          description: venture.description,
          type: venture.type,
          position: venture.position,
          images: uploadedImagesSrcs,
          timestamp: venture.timestamp,
          creatorId: venture.creatorId,
          tags: venture.tags,
          likes: venture.likes,
          comments: venture.comments);

      _list.add(newUpdatedVenture);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateVenture(Venture venture) async {
    int currentVentureIndex = _list.indexWhere((v) => v.id == venture.id);
    if (currentVentureIndex >= 0) {
      try {
        await Firestore.instance
            .collection('ventures')
            .document(venture.id)
            .updateData({
          'id': venture.id,
          'type': venture.type
              .map((t) => {
                    'id': t.id,
                    'name': t.name,
                    'isActive': t.isActive,
                    'iconSrc': t.iconSrc,
                  })
              .toList(),
          'title': venture.title,
          'description': venture.description,
          'position': {
            'address': venture.position.address,
            'latLng': {
              'latitude': venture.position.latLng.latitude,
              'longitude': venture.position.latLng.longitude,
            },
          },
          'timestamp': venture.timestamp.toString(),
          'creatorId': venture.creatorId,
          'images': venture.images,
          'tags': venture.tags
              .map((t) => {
                    'id': t.id,
                    'name': t.name,
                  })
              .toList(),
          'likes': venture.likes.map((ul) => ul.toJson()).toList(),
          'comments': venture.comments
              .map((c) => {
                    'id': c.id,
                    'text': c.text,
                    'time': c.time.toString(),
                    'userId': c.userId,
                  })
              .toList(),
        });

        List<String> uploadedImagesSrcs = await _uploadMultipleImages(
          imageArr: venture.images,
          imageIdentifier: venture.creatorId,
          folderIdentifier: venture.id,
        );

        await Firestore.instance
            .collection('ventures')
            .document(venture.id)
            .updateData({
          'images': uploadedImagesSrcs,
        });

        final Venture newUpdatedVenture = Venture(
            id: venture.id,
            title: venture.title,
            description: venture.description,
            type: venture.type,
            position: venture.position,
            images: venture.images,
            timestamp: venture.timestamp,
            creatorId: venture.creatorId,
            tags: venture.tags,
            likes: venture.likes,
            comments: venture.comments);
        _list[currentVentureIndex] = newUpdatedVenture;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }

  Future<void> removeVenture(String ventureId) async {
    try {
      await Firestore.instance
          .collection('ventures')
          .document(ventureId)
          .delete();
      list.removeWhere((v) => v.id == ventureId);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<List<String>> _uploadMultipleImages({
    List<String> imageArr,
    String folderIdentifier,
    String imageIdentifier,
  }) async {
    for (var i = 0; i < imageArr.length; i++) {
      String url = imageArr[i];
      final ref = FirebaseStorage.instance
          .ref()
          .child('venture_image/' + folderIdentifier + '/')
          .child(imageIdentifier + i.toString() + '.jpg');
      await ref.putFile(File(url)).onComplete;
      final String downloadUrl = await ref.getDownloadURL();
      imageArr[i] = downloadUrl;
    }
    return imageArr;
  }

  void updateVentures(List<Venture> ventures) {
    _list = ventures;
    notifyListeners();
  }
}
