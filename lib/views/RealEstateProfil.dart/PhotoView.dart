// ignore_for_file: file_names, require_trailing_commas, void_checks

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:photo_view/photo_view.dart';

class Photoview extends StatefulWidget {
  const Photoview({
    Key key,
    this.images,
  }) : super(key: key);

  final List images;

  @override
  _PhotoviewState createState() => _PhotoviewState();
}

class _PhotoviewState extends State<Photoview> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: CarouselSlider.builder(
                itemCount: widget.images.length,
                options: CarouselOptions(
                    enlargeCenterPage: true,
                    onPageChanged: (int index, CarouselPageChangedReason reason) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    viewportFraction: 1.0,
                    height: size.height),
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return PhotoView(
                    enableRotation: true,
                    minScale: 0.4,
                    maxScale: 2.0,
                    imageProvider: CachedNetworkImageProvider(
                      "$serverImage/${widget.images[index]['destination']}-big.webp",
                      errorListener: () {
                        return const Icon(Icons.error_outline, color: Colors.white);
                      },
                    ),
                    tightMode: true,
                    errorBuilder: (context, url, error) => const Icon(Icons.error_outline),
                    loadingBuilder: (context, url) => Center(child: spinKit()),
                  );
                },
              ),
            ),
            Positioned(
                bottom: 0,
                child: SizedBox(
                  height: 50,
                  width: size.width,
                  child: Center(
                    child: ListView.builder(
                      itemCount: widget.images.length,
                      shrinkWrap: true, //widget.images.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: size.width * 0.025,
                          height: size.width * 0.025,
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: index == selectedIndex ? kPrimaryColor : Colors.white),
                        );
                      },
                    ),
                  ),
                )),
            Positioned(
              right: 20.0,
              top: 20.0,
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(CupertinoIcons.xmark_circle, color: Colors.white, size: 40)),
            ),
          ],
        ),
      ),
    );
  }
}
