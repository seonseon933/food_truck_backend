import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:food_truck/model/testmap_model.dart';
import 'package:http/http.dart' as http;

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

  //add : 클릭된 마커의 위도, 경도를 파이어베이스에 저장.
  void _saveLocation() async {
    if (_selectedPosition != null) {
      await _testMap.saveLocationToFirestore(
          _selectedPosition!.latitude, _selectedPosition!.longitude);
    } else {}
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
              },

              options: const NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                    target: NLatLng(35.139988984673806, 126.93423855903913),
                    zoom: 15,
                    bearing: 0,
                    tilt: 0),
              ),

              //클릭시 마커생성
              onMapTapped: (point, latLng) async {
                await _controller.clearOverlays();
                final marker = NMarker(
                  id: 'marker_${latLng.latitude}_${latLng.longitude}',
                  position: latLng,
                );

                await _controller.addOverlay(marker);

                final infoWindow = NInfoWindow.onMarker(
                  id: marker.info.id,
                  text: "${latLng.latitude}, ${latLng.longitude}",
                );

                marker.openInfoWindow(infoWindow);
                //add
                setState(() {
                  _selectedPosition = latLng;
                });
              },
            ),
            // 버튼 누르면 _saveLocation 함수 호출. (추가해야 할 점 : 마커 안 찍고 위치 지정 누르면 경고메시지 나오도록.)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 200, // 원하는 너비로 설정
                  child: ElevatedButton(
                    onPressed: _saveLocation,
                    child: const Text('위치 지정'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
