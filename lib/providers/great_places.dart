import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../models/place.dart';
import '../helpers/db_helpers.dart';
//import '../helpers//location_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<List> getLocationAddress(double latitude, double longitude) async {
    List<Placemark> placemark = await placemarkFromCoordinates(latitude, longitude);
    return placemark;
  }

  Place findById (String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  void addPlace(String title, File pickedImage, PlaceLocation pickedLocation) async {
    final addressData =
        await getLocationAddress(pickedLocation.latitude, pickedLocation.longitude);
    final String street = addressData[0].street;
    final String postalcode = addressData[0].postalCode;
    final String locality = addressData[0].locality;
    final String country = addressData[0].country;
    final String address = '$street, $postalcode, $locality, $country';
    final updatedLocation = PlaceLocation(
      latitude: pickedLocation.latitude,
      longitude: pickedLocation.longitude,
      address: address,
    );
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      location: updatedLocation,
      image: pickedImage,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location!.latitude,
      'loc_lng': newPlace.location!.longitude,
      'address': newPlace.location!.address!,
    });
  }

  Future<void> fetchPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map((item) => Place(
              id: item['id'],
              title: item['title'],
              location: PlaceLocation(latitude: item['loc_lat'], longitude: item['loc_lng'], address: item['address']),
              image: File(item['image']),
            ))
        .toList();
    notifyListeners();
  }
}
