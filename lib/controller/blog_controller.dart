import 'package:blog_app_new/models/blog_model.dart';
import 'package:get/get.dart';

class BlogController extends GetxController {
  var allBlogs = <BlogModel>[].obs;
  var filteredBlogs = <BlogModel>[].obs;
}
