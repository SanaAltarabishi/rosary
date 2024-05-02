
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
    final double circleSize = MediaQuery.of(context).size.width;
    final double buttonSize = MediaQuery.of(context).size.width * 0.01;
    final double containerSize = MediaQuery.of(context).size.width * 0.1;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height:   MediaQuery.of(context).size.height * 0.01,),
              Text('target :$topIndexCont'),
              Text('remaining :$remaining'),
              SizedBox(
                height:
                 MediaQuery.of(context).size.height * 0.35,
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
                        margin: EdgeInsets.all(circleSize * 0.05),
                        width: circleSize * 0.85,
                        height: circleSize * 0.85,
                        child: ValueListenableBuilder(
                          valueListenable: start,
                          builder: (context, started, _) {
                            return CustomPaint(
                              painter: CirclePainter(
                                containerCount: indexList.length,
                                containerColor: Colors.transparent,
                                containerRadius: containerSize * 0.1,
                                containerTextSize: circleSize * 0.04,
                                scrollPosition: scrollPosition,
                                circleSize: circleSize * 0.85,
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
                      width: buttonSize * 65,
                      height: buttonSize * 65,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 216, 194, 169),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: circleSize * 0.5,
                          height: circleSize * 0.5,
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
                      width: buttonSize * 10,
                      height: buttonSize * 10,
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
                            //dialog
                            // _showDialog();
                          } else if (remaining > 0) {
                            remaining--;
                            setState(() {});
                          }
                        },
                        child: Center(
                          child: Text(
                            'انقر',
                            style: TextStyle(fontSize: circleSize * 0.04),
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
    final double diff = targetAngle - scrollPosition;

    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        scrollPosition += diff.sign * 0.1;
        if ((scrollPosition - targetAngle).abs() < 0.1) {
          scrollPosition = targetAngle;
          timer.cancel();
          final double topAngle = (-math.pi / 3) - scrollPosition;
          final double containerAngle = topAngle - (math.pi / indexList.length);
          final double indexDouble =
              containerAngle / (2 * math.pi / indexList.length);
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
