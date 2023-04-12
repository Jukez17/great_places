import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/place.dart';
import '../screens/map.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final lat = place.location.latitude;
    final lng = place.location.longitude;
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Column(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 300,
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black54,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Text(
              place.location.address,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => MapScreen(
                    location: place.location,
                    isSelecting: false,
                  ),
                ),
              );
            },
            child: SizedBox(
              height: 250,
              width: double.infinity,
              child: FlutterMap(
                options: MapOptions(
                  interactiveFlags: InteractiveFlag.none,
                  center: LatLng(lat, lng),
                  zoom: 15.0,
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
                        point: LatLng(
                          lat,
                          lng,
                        ),
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
          ),
        ],
      ),
    );
  }
}