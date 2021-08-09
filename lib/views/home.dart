import 'package:blog_app_new/controller/blog_controller.dart';
import 'package:blog_app_new/models/blog_model.dart';
import 'package:blog_app_new/services/blog_helper.dart';
import 'package:blog_app_new/views/add_blog.dart';
import 'package:blog_app_new/widgets/blog_tile.dart';
import 'package:blog_app_new/widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BlogController blogController = Get.put(BlogController());
  bool isLoading = true;
  String message = "";
  TextEditingController searchCon = TextEditingController();
  List<BlogModel> selectedBlogs = [];
  bool isSearching = false;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Blog App"),
        actions: [
          if (selectedBlogs.length > 0)
            GestureDetector(
                onTap: () {
                  selectedBlogs.forEach((element) {
                    blogController.allBlogs.remove(element);
                    BlogHelper().deleteBlog(element);
                    if (isSearching) {
                      blogController.filteredBlogs.remove(element);
                    }
                  });
                  setState(() {});
                },
                child: Icon(Icons.delete)),
          SizedBox(
            width: 12,
          ),
          if (selectedBlogs.length > 0)
            InkWell(
                onTap: () {
                  selectedBlogs = [];
                  setState(() {});
                },
                child: Icon(Icons.clear)),
          SizedBox(
            width: 12,
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        child: isLoading
            ? Expanded(child: Center(child: CircularProgressIndicator()))
            : message != ""
                ? Expanded(
                    child: Center(
                        child: Text(
                    message,
                    style: TextStyle(color: Colors.white),
                  )))
                : Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      InputField(
                        icon: Icons.search,
                        controller: searchCon,
                        hint: "search by title",
                        onChange: (val) {
                          if (val != "") {
                            blogController.filteredBlogs.clear();

                            blogController.filteredBlogs.addAll(blogController
                                .allBlogs
                                .where((blog) =>
                                    blog.title.contains(val) ||
                                    blog.body.contains(val))
                                .toList());

                            setState(() {
                              isSearching = true;
                            });
                          } else {
                            setState(() {
                              isSearching = false;
                            });
                          }
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Obx(
                          () => blogController.allBlogs.length == 0
                              ? Expanded(
                                  child: Center(
                                      child: Text(
                                  "No any blog added yet!",
                                  style: TextStyle(color: Colors.white),
                                )))
                              : Expanded(
                                  child: ListView.builder(
                                    itemCount: isSearching
                                        ? blogController.filteredBlogs.length
                                        : blogController.allBlogs.length,
                                    itemBuilder: (context, index) {
                                      BlogModel blogModel = BlogModel();
                                      if (isSearching) {
                                        blogModel =
                                            blogController.filteredBlogs[index];
                                        print("searched");
                                      } else {
                                        blogModel =
                                            blogController.allBlogs[index];
                                        print("not searched");
                                      }
                                      return InkWell(
                                        onLongPress: () {
                                          selectedBlogs.add(blogModel);
                                          setState(() {});
                                          print("selected");
                                        },
                                        child: Stack(
                                          children: [
                                            IgnorePointer(
                                              ignoring: selectedBlogs
                                                  .contains(blogModel),
                                              child: BlogTile(
                                                blogModel: blogModel,
                                              ),
                                            ),
                                            if (selectedBlogs
                                                .contains(blogModel))
                                              GestureDetector(
                                                onTap: () {
                                                  selectedBlogs
                                                      .remove(blogModel);
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      top: 12, left: 12),
                                                  child: CircleAvatar(
                                                      radius: 24,
                                                      backgroundColor:
                                                          Colors.red,
                                                      child: Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                      )),
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ),
                      )
                    ],
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddBlog());
        },
        backgroundColor: Colors.deepOrange[400],
        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    var response = await BlogHelper().getBlogs();
    if (response != null) {
      blogController.allBlogs.clear();
      blogController.allBlogs.addAll(response);
      if (blogController.allBlogs.isEmpty) {
        message = "You don't have add any blog!";
      }
    } else {
      message = "We're facing some problem!";
    }
    setState(() {
      isLoading = false;
    });
  }
}
