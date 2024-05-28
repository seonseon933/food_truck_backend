import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String truckId;

  const DetailPage(
      {required this.truckId,
      required this.latitude,
      required this.longitude,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
      ),
      body: Center(
        child: Text(
            'truckId: $truckId, Latitude: $latitude, Longitude: $longitude'),
      ),
    );
  }
}
