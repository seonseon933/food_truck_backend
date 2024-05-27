import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:http/http.dart' as http;
// 아래는 테스트하기 위한 import 파일.
import 'package:food_truck/api/testmap_model.dart';

class NaverMapApp extends StatefulWidget {
  const NaverMapApp({super.key});

  @override
  _NaverMapAppState createState() => _NaverMapAppState();

  static Future<void> init() async {
    await NaverMapSdk.instance.initialize(
        clientId: 'ujb8t157zt', // 클라이언트 ID 설정
        onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed"));
  }
}

class _NaverMapAppState extends State<NaverMapApp> {
  late NaverMapController _controller;
  final _searchController = TextEditingController();
  final String clientId = 'ujb8t157zt';
  final String clientSecret = 'TMdtyDoM6PImQk8pr16gUuzpTeFjr9AkO8Cm5n3d';

  //add
  final TestMap _testMap = TestMap();
  NLatLng? _selectedPosition;

  Future<NLatLng> getLatLngFromAddress(String address) async {
    final requestUrl = Uri.parse(
        'https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?query=$address');
    final response = await http.get(requestUrl, headers: {
      'X-NCP-APIGW-API-KEY-ID': clientId,
      'X-NCP-APIGW-API-KEY': clientSecret,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['addresses'].length > 0) {
        final lat = double.parse(data['addresses'][0]['y']); // 위도
        final lng = double.parse(data['addresses'][0]['x']); // 경도

        return NLatLng(lat, lng);
      }
    }

    throw Exception('주소를 좌표로 변환하는데 실패했습니다.');
  }

  void addMarkerAtAddress(String address) async {
    try {
      final latLng = await getLatLngFromAddress(address);
      address = address;

      _controller.updateCamera(NCameraUpdate.withParams(
        target: NLatLng(latLng.latitude, latLng.longitude),
      ));
    } catch (e) {
      print(e);
    }
  }

  // 정확X : firestore에서 받은 데이터에 해당하는 위치에 마커 표시.
  void addMarkersFirestoreData() async {
    List<Map<String, dynamic>> locations = await _testMap.getLocationData();
    for (var location in locations) {
      final latitude = location['latitude'];
      final longitude = location['longitude'];
      final marker = NMarker(
        id: 'marker_${latitude}_$longitude',
        position: NLatLng(latitude, longitude),
      );

      await _controller.addOverlay(marker);

      final infoWindow = NInfoWindow.onMarker(
        id: marker.info.id,
        text: "$latitude, $longitude",
      );

      marker.openInfoWindow(infoWindow);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            onSubmitted: (value) {
              addMarkerAtAddress(value);
            },
            decoration: const InputDecoration(
              hintText: '주소 검색',
            ),
          ),
        ),
        body: Stack(
          children: [
            NaverMap(
              onMapReady: (controller) {
                _controller = controller;
                addMarkersFirestoreData(); // 지도 준비가 완료된 후 Firestore 데이터로부터 마커를 추가합니다.
              },
              options: const NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                    target: NLatLng(35.139988984673806, 126.93423855903913),
                    zoom: 15,
                    bearing: 0,
                    tilt: 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
