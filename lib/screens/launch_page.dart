import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:iitism_smartid_app/providers/launch_provider.dart';
import 'package:iitism_smartid_app/utils/index.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:vector_math/vector_math_64.dart' as vector_math;

class Launch extends StatefulWidget {
  @override
  _LaunchState createState() => _LaunchState();
}

class _LaunchState extends State<Launch> {
  PageController controller;
  int _currentPage;
  double progress;
  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
    _currentPage = 0;
    progress = 0;
    controller.addListener(_scrollListener);
    _loop(1);
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(_scrollListener);
  }

  _loop(int animateTo) async {
    Future.delayed(Duration(seconds: 3), () async {
      await controller.animateToPage(animateTo,
          duration: Duration(seconds: 1), curve: Curves.easeOutExpo);
      _loop(animateTo < 2 ? animateTo + 1 : 0);
    });
  }

  _scrollListener() {
    setState(() {
      progress = controller.offset / controller.position.maxScrollExtent;
    });
  }

  @override
  Widget build(BuildContext context) {
    double marginBottom = MediaQuery.of(context).size.height * 0.2;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          // Container(
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage('assets/images/widewall.jpg'),
          //       fit: BoxFit.fitHeight,
          //       alignment: Alignment(progress * 0.2, 0),
          //     ),
          //   ),
          // ),
          PageView(
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            controller: controller,
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/intro1.webp'),
                      fit: BoxFit.fitWidth),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/intro2.webp'),
                      fit: BoxFit.fitWidth),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/intro3.webp'),
                      fit: BoxFit.fitWidth),
                ),
              )
            ],
          ),

          Positioned(
            bottom: 20,
            right: 20,
            left: 20,
            child: Column(
              children: <Widget>[
                IntroProgress(
                  progress: progress,
                  currentPage: _currentPage,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(minWidth: MediaQuery.of(context).size.width,
                    elevation: 0,
                    color: Colors.black,
                    onPressed: () {
                      Provider.of<LaunchProvider>(context).introDone();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'GET STARTED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  vector_math.Vector3 getTranslation(double progress) {
    double offset = sin(progress * pi * 2) * 4;
    return vector_math.Vector3(progress, 0.0, 0.0);
  }
}

class IntroProgress extends StatelessWidget {
  const IntroProgress({
    Key key,
    @required this.progress,
    @required this.currentPage,
  }) : super(key: key);

  final double progress;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: 70,
        height: 20,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: progress * 50),
              child: SizedBox(
                width: 20,
                height: 10,
                child: Container(
                  decoration: ShapeDecoration(
                    shape: StadiumBorder(),
                    color: getAccentColor(),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ProgressDot(
                  currentPage: currentPage,
                  index: 0,
                ),
                ProgressDot(
                  currentPage: currentPage,
                  index: 1,
                ),
                ProgressDot(
                  currentPage: currentPage,
                  index: 2,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ProgressDot extends StatelessWidget {
  const ProgressDot({Key key, @required int currentPage, @required int index})
      : _currentPage = currentPage,
        _index = index,
        super(key: key);

  final int _currentPage;
  final int _index;

  @override
  Widget build(BuildContext context) {
    Color color = _currentPage == _index ? getAccentColor() : Colors.grey.shade200;
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class IntroText extends StatelessWidget {
  final String text;
  IntroText(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Text(
        text,
        style: TextStyle(
            color: Colors.black, fontSize: 28, fontWeight: FontWeight.w500),
      ),
    );
  }
}
