//import 'package:food_truck/controller/app_id.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const dataApiKey = "devU01TX0FVVEgyMDI0MDUyMjAyMjI0MjExNDc4Mzc=";
typedef Address = ({
  String admCd,
  String bdKdcd,
  String bdMgtSn,
  String bdNm,
  String buldMnnm,
  String buldSlno,
  String currentPage,
  String currentPerPage,
  String detBdNmList,
  String emdNm,
  String emdNo,
  String engAddr,
  String errorCode,
  String errorMessage,
  String hemdNm,
  String jibunAddr,
  String liNm,
  String lnbrMnnm,
  String lnbrSlno,
  String mtYn,
  String rn,
  String rnMgtSn,
  String roadAddr,
  String roadAddrPart1,
  String roadAddrPart2,
  String relJibun,
  String sggNm,
  String siNm,
  String hstryYn,
  String totalCount,
  String udrtYn,
  String zipNo,
});

class Search_Controller extends GetxController {
  RxString result = ''.obs;
  RxList<Address> address = <Address>[].obs;

  void parseAddress(Map<String, dynamic> result) {
    final totalCount =
        int.parse(result['results']['common']['totalCount'].toString());
    for (int i = 0; i < totalCount; i++) {
      if (i >= 100) break;
      final common = result['results']['common'];
      final juso = result['results']['juso'][i];

      address.add((
        admCd: juso['admCd'] ?? '',
        bdKdcd: juso['bdKdcd'] ?? '',
        bdMgtSn: juso['bdMgtSn'] ?? '',
        bdNm: juso['bdNm'] ?? '',
        buldMnnm: juso['buldMnnm'] ?? '',
        buldSlno: juso['buldSlno'] ?? '',
        currentPage: common['currentPage'] ?? '',
        currentPerPage: common['currentPerPage'] ?? '',
        detBdNmList: juso['detBdNmList'] ?? '',
        emdNm: juso['emdNm'] ?? '',
        emdNo: juso['emdNo'] ?? '',
        engAddr: juso['engAddr'] ?? '',
        errorCode: common['errorCode'] ?? '',
        errorMessage: common['errorMessage'] ?? '',
        hemdNm: juso['hemdNm'] ?? '',
        jibunAddr: juso['jibunAddr'] ?? '',
        liNm: juso['liNm'] ?? '',
        lnbrMnnm: juso['lnbrMnnm'] ?? '',
        lnbrSlno: juso['lnbrSlno'] ?? '',
        mtYn: juso['mtYn'] ?? '',
        rn: juso['rn'] ?? '',
        rnMgtSn: juso['rnMgtSn'] ?? '',
        roadAddr: juso['roadAddr'] ?? '',
        roadAddrPart1: juso['roadAddrPart1'] ?? '',
        roadAddrPart2: juso['roadAddrPart2'] ?? '',
        relJibun: juso['relJibun'] ?? '',
        sggNm: juso['sggNm'] ?? '',
        siNm: juso['siNm'] ?? '',
        hstryYn: juso['hstryYn'] ?? '',
        totalCount: common['totalCount'] ?? '',
        udrtYn: juso['udrtYn'] ?? '',
        zipNo: juso['zipNo'] ?? '',
      ));
    }
    //print(address);
  }

  searchAddress([String? value]) async {
    //if (address != null) address = <Address>[];
    String queryUrl =
        "https://business.juso.go.kr/addrlink/addrLinkApi.do?currentPage=1&countPerPage=200&keyword=$value&confmKey=$dataApiKey&hstryYn=Y&resultType=json&firstSort=location";

    final http.Response res = await http.get(
      Uri.parse(queryUrl),
    );

    if (res.statusCode == 200) {
      final Map<String, dynamic> result = json.decode(res.body);
      parseAddress(result);
    }
  }
}
