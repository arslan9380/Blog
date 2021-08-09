import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:blog_app_new/controller/blog_controller.dart';
import 'package:blog_app_new/models/blog_model.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class BlogHelper {
  // db configuration
  final _dbName = 'Blog.db';
  final _dbVersion = 1;
  final _tableName = 'myBlog';

  // column names
  final _colId = 'blog_id';
  final _colTitle = 'blog_title';
  final _colDescription = 'blog_body';
  final _colImage = 'blog_Image';
  final _colTimeOfBlog = 'blog_time';

  // DownloadController downloadedController = Get.put(DownloadController());
  BlogController blogController = Get.put(BlogController());

  // singleton object
  BlogHelper._privateConstructor();

  static BlogHelper _instance = BlogHelper._privateConstructor();

  factory BlogHelper() {
    return _instance;
  }

  // initialize db
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();

    return _database;
  }

  _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();

    String path = join(directory.path, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE $_tableName '
          '($_colId TEXT PRIMARY KEY, '
          '$_colTitle TEXT, '
          '$_colDescription TEXT ,'
          '$_colImage TEXT, '
          '$_colTimeOfBlog TEXT) ',
        );
      },
    );
  }

  ///-----------Add Method--------------

  Future<dynamic> addBlog(BlogModel blog) async {
    try {
      Database db = await database;
      File imagePath;

      //---------Saving Product Image in local directory--------------

      if (blog.image != "" && blog.image != null) {
        imagePath = File(
            '${(await getApplicationDocumentsDirectory()).path}/${"blogImages"}/${blog.id + ".jpg"}');
        imagePath = await imagePath.create(recursive: true);
        // var response = await get(product.imageUrl);
        imagePath.writeAsBytesSync(Uint8List.fromList(blog.image));
        print(imagePath);
      }

      ///--------------------Inserting in local database---------------

      int val = await db.insert(
        _tableName,
        {
          _colId: '${blog.id}',
          _colTitle: '${blog.title}',
          _colDescription: '${blog.body}',
          _colImage: imagePath.path,
          _colTimeOfBlog: '${blog.timeOfBlog.toIso8601String()}',
        },
      );

      ///-------------------Fetching data from local storage----------

      BlogModel savedBlog = BlogModel(
          title: blog.title,
          body: blog.body,
          timeOfBlog: blog.timeOfBlog,
          id: blog.id,
          image: imagePath.path);

      ///---Inserting data in downloadsList of user for realtime changing-----
      blogController.allBlogs.insert(0, savedBlog);
      return blog;
    } catch (e) {
      print('error in inserting download: $e');
      return -1;
    }
  }

  ///--------------Get All Blogs-------------------

  Future<List<BlogModel>> getBlogs() async {
    try {
      Database db = await database;
      var result = await db.query(_tableName);
      if (result.length == 0) return [];

      List<BlogModel> allBlogs = [];

      for (var map in result) {
        var product = BlogModel(
          id: map[_colId],
          title: map[_colTitle],
          body: map[_colDescription],
          image: map[_colImage],
          timeOfBlog: DateTime.tryParse(map[_colTimeOfBlog]),
        );

        allBlogs.add(product);
      }
      return allBlogs;
    } catch (e) {
      print('error in reading download: $e');
      return null;
    }
  }

  ///--------------Delete Blog-------------------

  Future<int> deleteBlog(BlogModel blog) async {
    try {
      Database db = await database;

      var delRowId =
          await db.delete(_tableName, where: '$_colId=?', whereArgs: [blog.id]);

      if (blog.image != '') {
        File('${(await getApplicationDocumentsDirectory()).path}/${"blogImages"}/${blog.id + "jpg"}')
            .delete(recursive: true);
      }

      print(delRowId);
      print("-------------------");
      return delRowId;
    } catch (e) {
      print('error in deleting download: $e');
      return -1;
    }
  }

  ///-------------- Update Blog----------------------

  Future<int> updateBlog(BlogModel blog, bool isImageUpdated) async {
    try {
      Database db = await database;
      File imagePath;
      String newId = blog.id;
      if (isImageUpdated) {
        File('${(await getApplicationDocumentsDirectory()).path}/${"blogImages"}/${blog.id + ".jpg"}')
            .delete(recursive: true);

        newId = DateTime.now().toIso8601String();
        imagePath = File(
            '${(await getApplicationDocumentsDirectory()).path}/${"blogImages"}/${newId + ".jpg"}');
        imagePath = await imagePath.create(recursive: true);
        imagePath.writeAsBytesSync(Uint8List.fromList(blog.image));
        blog.image = imagePath.path;
        print(blog.image);
      }

      var map = {
        _colId: '$newId',
        _colTitle: '${blog.title}',
        _colDescription: '${blog.body}',
        _colImage: isImageUpdated ? imagePath.path : blog.image,
        _colTimeOfBlog: '${blog.timeOfBlog.toIso8601String()}',
      };

      int val = await db
          .update(_tableName, map, where: '$_colId=?', whereArgs: [blog.id]);

      int index = blogController.allBlogs
          .indexWhere((element) => element.id == blog.id);
      blogController.allBlogs[index] = blog;
      int i = blogController.filteredBlogs
          .indexWhere((element) => element.id == blog.id);
      if (i != -1) {
        blogController.filteredBlogs[index] = blog;
      }
      print(val);
      return val;
    } catch (e) {
      print('error in reading download: $e');
      return null;
    }
  }
}
