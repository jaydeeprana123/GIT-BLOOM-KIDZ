import 'package:get/get.dart';

class BottomNavigationController extends GetxController {
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    currentIndex.value = 0;
    super.onInit();
  }
}
