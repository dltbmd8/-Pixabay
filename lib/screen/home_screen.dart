// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:my_app/services/api_services.dart';
import 'package:my_app/model/photo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  List<Photo> _photos = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPhotos();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMorePhotos();
      }
    });
  }

  //fetchPhotos method
  Future<void> _fetchPhotos() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newPhotos = await ApiService.fetchPhotos(page: _currentPage);

      setState(() {
        _photos.addAll(newPhotos);
        _currentPage++;
      });
    } catch (e) {
      print('error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose(){
    // todo implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMorePhotos() {
    _fetchPhotos();
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: Stack(
      children: [

        /// Masonry Grid
        _photos.isEmpty
            ? Center(child: CircularProgressIndicator())
            : MasonryGridView.builder(
                controller: _scrollController,
                gridDelegate:
                    SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                itemCount: _photos.length,
                itemBuilder: (context, index) {
                  final photo = _photos[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Hero(
                      tag: photo.id,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          photo.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder:
                              (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;

                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),

        /// Up panel
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                /// ring icon
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.notifications,
                      color: Colors.white, size: 22),
                ),

                /// Explore button
               Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  "Explore",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white,
                 ),
              ),
              ),


                /// For you pill
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    "For you",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),

                /// Search icon
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.search,
                      color: Colors.white, size: 22),
                ),
              ],
            ),
          ),
        ),
      ],
    ),


    /// Bottom panel
    bottomNavigationBar: BottomAppBar(
  color: Colors.black,
  child: SizedBox(
    height: 70,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.home, color: Colors.red),
            Text("Home", style: TextStyle(color: Colors.red)),
          ],
        ),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.grid_view, color: Colors.white),
            Text("Boards", style: TextStyle(color: Colors.white)),
          ],
        ),

        /// Center circle
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.add, color: Colors.white, size: 26),
        ),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline, color: Colors.white),
            Text("Messages", style: TextStyle(color: Colors.white)),
          ],
        ),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person, color: Colors.white),
            Text("Profile", style: TextStyle(color: Colors.white)),
          ],
        ),
      ],
    ),
  ),
),
  );
}
  }
  