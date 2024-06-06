import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:http/http.dart' as http;
import 'search_view.dart';
import 'package:get/get.dart';
import 'package:food_truck/controller/home_controller.dart';
import '../controller/search_controller.dart';
import '../style/font_style.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // 여기서 SingleChildScrollView로 감쌈
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
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
                    print("search = $juso");
                  },

                  child: Container(
                    width: size.width * 0.7,
                    padding: const EdgeInsets.all(8.0),
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            Icons.search,
                            color: Color(0xff7d7d7d),
                            size: 20.0,
                          ),
                        ),
                        Text("주소를 입력하세요", style: CustomTextStyles.caption)
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.005,
                ),
                Obx(
                  () => SizedBox(
                      width: size.width * 0.9,
                      height: size.height * 0.7,
                      child: NaverMapApp(
                        juso: controller.juso.value,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NaverMapApp extends StatefulWidget {
  final String juso;

  const NaverMapApp({super.key, required this.juso});

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
  final String clientId = 'ujb8t157zt';
  final String clientSecret = 'TMdtyDoM6PImQk8pr16gUuzpTeFjr9AkO8Cm5n3d';

  final HomeController _homeController = HomeController();
  NLatLng? _initialPosition;
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
            return const Center(child: Text('위치 정보를 불러오는데 실패했습니다.'));
          } else {
            _initialPosition = snapshot.data!;
            return Scaffold(
              body: Stack(
                children: [
                  NaverMap(
                    onMapReady: (controller) {
                      _controller = controller;
                      addMarkersFirestoreData();
                      // 지도 준비가 완료된 후 Firestore 데이터로부터 마커를 추가.
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
                    options: NaverMapViewOptions(
                      initialCameraPosition: NCameraPosition(
                        target: _initialPosition!,
                        zoom: 15,
                        bearing: 0,
                        tilt: 0,
                      ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
            );
          }
        });
  }
}
