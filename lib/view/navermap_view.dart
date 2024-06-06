import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:http/http.dart' as http;
import '../controller/foodtruckcreate_controller.dart';

class CNaverMapApp extends StatefulWidget {
  final String juso;

  const CNaverMapApp({super.key, required this.juso});

  @override
  _NaverMapAppState createState() => _NaverMapAppState();

  static Future<void> init() async {
    await NaverMapSdk.instance.initialize(
        clientId: 'ujb8t157zt', // 클라이언트 ID 설정
        onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed"));
  }
}

class _NaverMapAppState extends State<CNaverMapApp> {
  final fcontroller = Get.find<FoodtruckcreateController>();
  late NaverMapController _controller;
  final String clientId = 'ujb8t157zt';
  final String clientSecret = 'TMdtyDoM6PImQk8pr16gUuzpTeFjr9AkO8Cm5n3d';
  NLatLng? _initialPosition; // 기본 위치 초기값을 null로 설정

  @override
  void initState() {
    super.initState();
  }

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

  Future<NLatLng> getPosition(String address) async {
    if (widget.juso == "") {
      return const NLatLng(35.139988984673806, 126.93423855903913);
    } else {
      final latLng = await getLatLngFromAddress(address);
      print(address);
      return NLatLng(latLng.latitude, latLng.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NLatLng>(
      future: getPosition(widget.juso),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(
              child: Text('지도를 자유롭게 이동하고 마커를 클릭하여 푸드트럭 위치를 지정하세요'));
        } else {
          _initialPosition = snapshot.data!;
          return Scaffold(
            body: NaverMap(
              onMapReady: (controller) {
                _controller = controller;
              },
              onCameraChange:
                  (NCameraUpdateReason reason, bool animated) async {
                final cameraPosition = await _controller.getCameraPosition();
                final centerMarker = NMarker(
                  id: 'center_marker',
                  position: cameraPosition.target,
                );
                centerMarker.setOnTapListener((NMarker marker) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: const Text("해당 위치로 지정하겠습니까?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              print("lat = ${cameraPosition.target.latitude}");
                              print("lng = ${cameraPosition.target.longitude}");
                              fcontroller.jlatitude =
                                  cameraPosition.target.latitude;
                              fcontroller.jlongitude =
                                  cameraPosition.target.longitude;
                              fcontroller.gocreateview();
                            },
                            child: const Text("네"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("아니요"),
                          ),
                        ],
                      );
                    },
                  );
                });

                _controller.addOverlay(centerMarker);
              },
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: _initialPosition!,
                  zoom: 15,
                  bearing: 0,
                  tilt: 0,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
