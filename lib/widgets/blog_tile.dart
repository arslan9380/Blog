import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:blog_app_new/controller/blog_controller.dart';
import 'package:blog_app_new/models/blog_model.dart';
import 'package:blog_app_new/services/blog_helper.dart';
import 'package:blog_app_new/views/add_blog.dart';
import 'package:blog_app_new/views/blog_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogTile extends StatelessWidget {
  final BlogModel blogModel;

  BlogTile({this.blogModel});

  final BlogController blogController = Get.find<BlogController>();

  @override
  Widget build(BuildContext context) {
    print(blogModel.image);
    return InkWell(
      onTap: () {
        Get.to(() => BlogDetailView(
              blogModel: blogModel,
            ));
      },
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            color: Colors.deepOrange[400],
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 3),
                  borderRadius: BorderRadius.circular(8)),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Hero(
                      tag: blogModel.id,
                      child: Image.file(
                        File(blogModel.image),
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                        height: 200,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, right: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              Share.shareFiles([blogModel.image],
                                  text: blogModel.body,
                                  subject: blogModel.title);
                            },
                            child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.deepOrange[400],
                                child: Icon(
                                  Icons.share,
                                  size: 20,
                                  color: Colors.white,
                                )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => AddBlog(
                                    blogModel: blogModel,
                                  ));
                            },
                            child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.deepOrange[400],
                                child: Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Colors.white,
                                )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              blogController.allBlogs.removeWhere(
                                  (element) => element.id == blogModel.id);
                              BlogHelper().deleteBlog(blogModel);
                            },
                            child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.deepOrange[400],
                                child: Icon(
                                  Icons.delete,
                                  size: 20,
                                  color: Colors.white,
                                )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AutoSizeText(
                    blogModel.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  DateFormat("d-MMM-y").format(blogModel.timeOfBlog),
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 2),
          ],
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
