import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';

import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  const LocationInput(this.onSelectPlace, {super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  LatLng? mapPointCoords;
  late final MapController mapController;

  @override
  void initState() {
    mapController = MapController();
    super.initState();
  }

  Future<void> _getLocn() async {
    final currLocn = await Location().getLocation();
    setState(() {
      mapPointCoords = LatLng(currLocn.latitude!, currLocn.longitude!);
      Future.delayed(const Duration(milliseconds: 50), () {
        mapController.move(mapPointCoords!, 17.0);
      });
    });
    widget.onSelectPlace(currLocn.latitude!, currLocn.longitude!);
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => const MapScreen(
              isSelecting: true,
            ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    setState(() {
      mapPointCoords = selectedLocation;
      Future.delayed(const Duration(milliseconds: 50), () {
        mapController.move(mapPointCoords!, 17.0);
      });
    });
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
        height: 170,
        width: double.infinity,
        child: mapPointCoords == null
            ? const Center(child: Text('No Location'))
            : FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  interactiveFlags: InteractiveFlag.none,
                  center: LatLng(
                      mapPointCoords!.latitude, mapPointCoords!.longitude),
                  zoom: 13.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.google.com/vt/lyrs=m&hl={hl}&x={x}&y={y}&z={z}',
                    additionalOptions: const {'hl': 'en'},
                    subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: mapPointCoords!,
                        builder: (context) => const Icon(
                          Icons.location_on,
                          size: 25,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextButton.icon(
          onPressed: _getLocn,
          icon: const Icon(Icons.location_on),
          label: const Text('Current Location'),
        ),
        TextButton.icon(
          onPressed: _selectOnMap,
          icon: const Icon(Icons.map),
          label: const Text('Select on Map'),
        ),
      ]),
    ]);
  }
}
