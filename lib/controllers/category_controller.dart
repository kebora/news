import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CategoryController extends GetxController {
  var text = ''.obs;

  void onChanged(value) async {
    text.value = value;
    await GetStorage().write("category", value);
  }
}
