import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';

import '../models/place.dart';

class MapScreen extends StatefulWidget {
  //final LatLng initLocn;
  LatLng? initialLocation = LatLng(25.46816, 65.01236);
  final bool? isSelecting;

  MapScreen(
    this.initialLocation,
    { 
    this.isSelecting = false,
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickLocn;
  MapController? mapController;

  void _selectLocn(dynamic tapPosn, LatLng posn) {
    debugPrint('MapScreen:_selectLocn: $posn');
    setState(() {
      _pickLocn = posn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select place'),
        actions: [
          if (widget.isSelecting!)
            IconButton(
              onPressed: _pickLocn == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickLocn);
                    },
              icon: const Icon(Icons.check),
            )
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(widget.initialLocation!.latitude, widget.initialLocation!.longitude),
          zoom: 15.0,
          onTap: widget.isSelecting! ? _selectLocn : null,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://{s}.google.com/vt/lyrs=m&hl={hl}&x={x}&y={y}&z={z}',
            additionalOptions: const {'hl': 'en'},
            subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
          ),
          if (_pickLocn != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(_pickLocn!.latitude, _pickLocn!.longitude),
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
    );
  }
}
