import 'package:flutter/material.dart';
import 'package:food_truck/controller/foodtruckcreatemap_controller.dart';
import 'package:get/get.dart';
import '../view/search_view.dart';
import '../controller/search_controller.dart';
import '../style/font_style.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:http/http.dart' as http;

//
class FoodtruckcreatemapView extends GetView<FoodtruckcreatemapController> {
  const FoodtruckcreatemapView({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('푸드트럭 등록')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.02),
                Center(
                  child: InkWell(
                    // 누르면 버튼 효과
                    highlightColor: Colors.black12,
                    // Container와 동일한 Radius 설정
                    borderRadius: BorderRadius.circular(8.0),
                    onTap: () async {
                      Get.lazyPut<Search_Controller>(
                        () => Search_Controller(),
                      );
                      final juso = await Get.dialog(
                        Theme(
                          data: Theme.of(context),
                          child: const AlertDialog(
                            content: SearchView(),
                          ),
                        ),
                      );
                      controller.juso.value = juso;
                    },

                    child: Container(
                      width: size.width * 0.7,
                      padding: const EdgeInsets.all(8.0),
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(
                              Icons.search,
                              color: Color(0xff7d7d7d),
                              size: 20.0,
                            ),
                          ),
                          Obx(
                            () => Text(controller.juso.value,
                                style: CustomTextStyles.caption),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Center(
                  child: Container(
                    width: size.width * 0.9,
                    height: size.height * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Obx(() => CNaverMapApp(
                          juso: controller.juso.value,
                        )),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
  final fcontroller = Get.find<FoodtruckcreatemapController>();
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
