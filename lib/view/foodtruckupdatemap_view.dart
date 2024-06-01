import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:food_truck/api/detailtest.dart';
import 'package:food_truck/controller/foodtruckupdatemap_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// 아래는 테스트하기 위한 import 파일.
import 'package:food_truck/api/testmap_model.dart';

class FoodtruckupdatemapView extends GetView<FoodtruckupdatemapController> {
  const FoodtruckupdatemapView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map arguments = Get.arguments as Map;
    final String foodtruckid = arguments['foodtruck_id'];
    controller.setFoodTruckId(foodtruckid);
    final Size size = MediaQuery.of(context).size;
    return const Scaffold(
      // 기존 SafeArea 뺌. (test위해)
      body: NaverMapApp(),
    );
  }
}

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
  late NaverMapController _navercontroller;
  final _searchController = TextEditingController();
  final String clientId = 'ujb8t157zt';
  final String clientSecret = 'TMdtyDoM6PImQk8pr16gUuzpTeFjr9AkO8Cm5n3d';

  final FoodtruckupdatemapController _updatemapController = Get.find();

  NLatLng? _selectedPosition;

  // 푸드트럭 상세 페이지에 넘길 Map 데이터
  Map<String, dynamic>? foodtruck;

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
        final lat = double.parse(data['addresses'][0]['y']);
        final lng = double.parse(data['addresses'][0]['x']);
        return NLatLng(lat, lng);
      }
    }

    throw Exception('주소를 좌표로 변환하는데 실패했습니다.');
  }

  void addMarkerAtAddress(String address) async {
    try {
      final latLng = await getLatLngFromAddress(address);
      _navercontroller.updateCamera(
        NCameraUpdate.withParams(
          target: NLatLng(latLng.latitude, latLng.longitude),
        ),
      );
    } catch (e) {
      print(e);
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
                _navercontroller = controller;
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
                await _navercontroller.clearOverlays();
                final marker = NMarker(
                  id: 'marker_${latLng.latitude}_${latLng.longitude}',
                  position: latLng,
                );

                await _navercontroller.addOverlay(marker);

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
            //(추가해야 할 점 : 마커 안 찍고 위치 지정 누르면 경고메시지 나오도록.)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 200, // 원하는 너비로 설정
                  child: ElevatedButton(
                    onPressed: () {
                      final id = _updatemapController.foodtruckid.value;
                      final latitude = _selectedPosition!.latitude;
                      final longitude = _selectedPosition!.longitude;
                      _updatemapController.goUpdate(id, latitude, longitude);
                      print('id : $id, la : $latitude, lo : $longitude');
                    },
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
