import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Circle extends StatefulWidget {
  const Circle({Key? key}) : super(key: key);

  @override
  _CircleState createState() => _CircleState();
}

List<int> indexList = [10, 8, 5, 12, 4, 50, 6, 9, 8, 9];

class _CircleState extends State<Circle> {
  final start = ValueNotifier(false);
  double scrollPosition = 0.0;
  int topIndex = 0;
  int topIndexCont = 0;
  int remaining = 0;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double innerContainerSize = screenWidth * 0.01;
    final double containerSize = screenWidth * 0.1;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Text('target :$topIndexCont'),
              Text('remaining :$remaining'),
              SizedBox(
                height: screenHeight * 0.35,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onVerticalDragStart: (details) {
                      if (remaining == 0) {
                        _startScroll();
                      } else {
                        start.value = !start.value;
                      }
                    },
                    onHorizontalDragStart: (details) {
                      if (remaining == 0) {
                        _startScroll();
                      } else {
                        start.value = !start.value;
                      }
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xffFFF8C7),
                          shape: BoxShape.circle,
                        ),
                        margin: EdgeInsets.all(screenWidth * 0.05),
                        width: screenWidth * 0.85,
                        height: screenWidth * 0.85,
                        child: ValueListenableBuilder(
                          valueListenable: start,
                          builder: (context, started, _) {
                            return CustomPaint(
                              painter: CirclePainter(
                                containerCount: indexList.length,
                                containerColor: Colors.transparent,
                                containerRadius: containerSize * 0.1,
                                containerTextSize: screenWidth * 0.04,
                                scrollPosition: scrollPosition,
                                circleSize: screenWidth * 0.85,
                              ),
                            )
                                .animate(
                                  target: started ? 1 : 0,
                                  onPlay: (controller) => controller.reverse(),
                                  onComplete: (controller) =>
                                      debugPrint('complet'),
                                )
                                .shake(hz: 3);
                          },
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: innerContainerSize * 65,
                      height: innerContainerSize * 65,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 216, 194, 169),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: screenWidth * 0.5,
                          height: screenWidth * 0.5,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/mandela.png"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: innerContainerSize * 12,
                      height: innerContainerSize * 12,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 2,
                            blurRadius: 2,
                          )
                        ],
                        color: Color(0xffFFF8C7),
                        shape: BoxShape.circle,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (remaining == 0) {
                            //dialog, you complete the target
                            // _showDialog();
                          } else if (remaining > 0) {
                            remaining--;
                            setState(() {});
                          }
                        },
                        child: Center(
                          child: Text(
                            'انقر',
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //! the inkwell of each continer , we don't need it
                  //  ...List.generate(indexList.length, (index) {
                  //     final angle = (2 * math.pi * index) / indexList.length +
                  //         scrollPosition;
                  //     final double innerRadius =
                  //         (circleSize - 2 * containerSize) / 3;
                  //     final double outerRadius = innerRadius + containerSize;
                  //     final double x = outerRadius * math.cos(angle);
                  //     final double y = outerRadius * math.sin(angle);

                  //     final double containerX =
                  //         circleSize / 2 + x - containerSize / 50;
                  //     final double containerY =
                  //         circleSize / 2 + y - containerSize / 50;

                  //     return Positioned(
                  //       left: containerX,
                  //       top: containerY,
                  //       child: GestureDetector(
                  //         onTap: () {
                  //           print('${indexList[index]}');
                  //         },
                  //         child: Container(
                  //           width: containerSize,
                  //           height: containerSize,
                  //           decoration: const BoxDecoration(
                  //             color: Colors.red,
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startScroll() {
    final random = math.Random();
    final double targetAngle = math.pi * 2 * random.nextDouble();
    //? the fun nextDouble: generate double between 0 and 1, when multip with 2*pi will by in range (0 to 2π)
    final double diff = targetAngle - scrollPosition;
    //? this diff will be used to determine how much the scroll position will change
    //? تايمر دوري :
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        scrollPosition += diff.sign * 0.1;//? creates a smooth scrolling effect
        if ((scrollPosition - targetAngle).abs() < 0.1) {
            //? if its ture the animation considered complete, that why we cancel
          scrollPosition = targetAngle;//? to ensure it reaches exaclty
          timer.cancel();
          final double topAngle = (-math.pi / 3) - scrollPosition;//?60- scroll, to idntified(item) regardless of the current scroll position
          final double containerAngle = topAngle - (math.pi / indexList.length);
          final double indexDouble =
              containerAngle / (2 * math.pi / indexList.length);//? to calculates the angle between each item in the circle.
          topIndex =
              (indexDouble.round() + indexList.length) % indexList.length;
          topIndexCont = indexList[topIndex];
          remaining = topIndexCont;

          print("Index of top container after scroll: $topIndex");
          print("the content of the $topIndex is $topIndexCont");
        }
      });
    });
  }
}

class CirclePainter extends CustomPainter {
  final int containerCount;
  final Color containerColor;
  final double containerRadius;
  final double containerTextSize;
  final double scrollPosition;
  final double circleSize;

  CirclePainter({
    required this.containerCount,
    required this.containerColor,
    required this.containerRadius,
    required this.containerTextSize,
    required this.scrollPosition,
    required this.circleSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(circleSize / 2, circleSize / 2);
    final radius = circleSize / 2.2;

    final paint = Paint()..color = containerColor;

    for (int index = 0; index < containerCount; index++) {
      final double angle =
          (2 * math.pi * index) / containerCount + scrollPosition;

      final double itemX = radius * math.cos(angle);
      final double itemY = radius * math.sin(angle);

      final itemCenter = center.translate(itemX, itemY);

      Rect.fromCircle(
        center: itemCenter,
        radius: containerRadius,
      );

      canvas.drawCircle(itemCenter, containerRadius, paint);

      final textPainter = TextPainter(
        text: TextSpan(
          text: '${indexList[index]}',
          style: TextStyle(
            fontSize: containerTextSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      final textOffset = Offset(
        itemCenter.dx - textPainter.width / 2,
        itemCenter.dy - textPainter.height / 2,
      );
      textPainter.paint(canvas, textOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
