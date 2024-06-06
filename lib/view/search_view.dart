import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/search_controller.dart';
import '../style/font_style.dart';

class SearchView extends GetView<Search_Controller> {
  const SearchView({super.key});
  @override
  Widget build(BuildContext context) {
    TextEditingController textsearch = TextEditingController(text: '');
    final Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: SizedBox(
        width: size.width * 0.8, //동적 크기조정필요
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textsearch,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: '주소 입력',
                      ),
                      onSubmitted: (String value) {
                        controller.searchAddress(textsearch.text);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white70,
                      foregroundColor: Colors.black,
                      shadowColor: Colors.black,
                    ),
                    onPressed: () {
                      //print(search.text);
                      controller.searchAddress(textsearch.text);
                    },
                    child: const Text("검색", style: CustomTextStyles.body),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (controller.address.length >= 100) ...[
                const Text('검색 결과가 너무 많습니다. 다시 입력해주세요. \n예) 필문대로 287번길',
                    style: CustomTextStyles.waringcaption),
                const SizedBox(height: 16),
              ],
              // if (controller.address.isEmpty) ...[
              //   Text(
              //     '현재 입력값이 없어요.',
              //
              //   ),
              //   const SizedBox(height: 16),
              // ],
              if (controller.address.isNotEmpty)
                ...controller.address
                    .map(
                      (e) => InkWell(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.roadAddr.trim(),
                                style: CustomTextStyles.subtitle),
                            Text(e.jibunAddr.trim(),
                                style: CustomTextStyles.body),
                            Text(e.engAddr.trim(),
                                style: CustomTextStyles.body),
                            const Text('[선택]',
                                style: CustomTextStyles.accentcaption),
                          ],
                        ),
                        onTap: () {
                          //controller.result.value = e.roadAddrPart1;
                          Get.back(result: e.roadAddrPart1);
                        },
                      ),
                    )
                    .toList()
                    .fold<List<Widget>>(
                  [],
                  (previousValue, element) => previousValue
                    ..add(element)
                    ..add(
                      const Divider(
                        height: 24,
                      ),
                    ),
                )..removeLast(),
            ],
          ),
        ),
      ),
    );
  }
}
