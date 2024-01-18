import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselWithDots extends StatefulWidget {
  final List<String> imgList;
  const CarouselWithDots({super.key, required this.imgList});

  @override
  State<CarouselWithDots> createState() => _CarouselWithDotsState();
}

class _CarouselWithDotsState extends State<CarouselWithDots> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = widget.imgList
        .map(
          (item) => //Container(child:
              ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(50.0),
            ),
            child: Stack(
              children: [
                Image.asset(
                  item,
                  fit: BoxFit.fill,
                  width: 190,
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ),
        )
        .toList();

    return Column(
      children: [
        const Padding(padding: EdgeInsets.all(20)),
        CarouselSlider(
          items: imageSliders,
          options: CarouselOptions(
              autoPlay: false,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imgList.map((url) {
            int index = widget.imgList.indexOf(url);
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 3,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? const Color.fromRGBO(0, 0, 0, 0.9)
                    : const Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
