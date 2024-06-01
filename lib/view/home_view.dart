import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:http/http.dart' as http;
//import 'search_view.dart';
import 'package:get/get.dart';
import 'package:food_truck/controller/home_controller.dart';
//import '../controller/search_controller.dart';
//import '../style/font_style.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
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
  late NaverMapController _controller;
  final _searchController = TextEditingController();
  final String clientId = 'ujb8t157zt';
  final String clientSecret = 'TMdtyDoM6PImQk8pr16gUuzpTeFjr9AkO8Cm5n3d';

  final HomeController _homeController = HomeController();

  NLatLng? _selectedPosition;

  String? _selectedTruckId;
  double? _selectedLatitude;
  double? _selectedLongitude;
  String? _selectedTruckame;
  String? _selectedTruckDescription;
  double? _selectedRating;
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
      _controller.updateCamera(
        NCameraUpdate.withParams(
          target: NLatLng(latLng.latitude, latLng.longitude),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  void addMarkersFirestoreData() async {
    List<Map<String, dynamic>> locations =
        await _homeController.getFoodTruckData();
    for (var location in locations) {
      final latitude = location['truck_latitude'];
      final longitude = location['truck_longitude'];
      final truckId = location['foodtruck_id'];
      final testname = location['truck_name'];
      final testdes = location['truck_description'];
      final rating = location['truck_avgrating'] is int
          ? (location['truck_avgrating'] as int).toDouble()
          : location['truck_avgrating'];

      final marker = NMarker(
        id: 'marker_${latitude}_$longitude',
        position: NLatLng(latitude, longitude),
      );

      await _controller.addOverlay(marker);

      marker.setOnTapListener((marker) {
        setState(() {
          foodtruck = location;
          _selectedTruckId = truckId;
          _selectedLatitude = latitude;
          _selectedLongitude = longitude;
          _selectedTruckame = testname;
          _selectedTruckDescription = testdes;
          _selectedRating = rating;
        });
      });
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
                addMarkersFirestoreData(); // 지도 준비가 완료된 후 Firestore 데이터로부터 마커를 추가.
              },
              onMapTapped: (point, latLng) {
                setState(() {
                  _selectedTruckId = null;
                  _selectedLatitude = null;
                  _selectedLongitude = null;
                  _selectedTruckame = null;
                  _selectedTruckDescription = null;
                  _selectedRating = null;
                  foodtruck = null;
                });
              },
              options: const NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                    target: NLatLng(35.139988984673806, 126.93423855903913),
                    zoom: 15,
                    bearing: 0,
                    tilt: 0),
              ),
            ),
            // 마커 클릭하면 상태가 바뀌니 작은 창 나옴.
            if (_selectedTruckId != null)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Builder(
                  builder: (BuildContext newContext) {
                    return Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text('$_selectedTruckame '),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('별점 : $_selectedRating'),
                                Text(
                                  '$_selectedTruckDescription',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                          ButtonBar(
                            children: [
                              TextButton(
                                // Map형식의 데이터를 넘겨야 함.
                                onPressed: () {
                                  _homeController.goDetail(foodtruck);
                                  print('$foodtruck');
                                },
                                child: const Text('이동'),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
