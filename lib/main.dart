import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('House Plan')),
        body: HousePlan(),
      ),
    );
  }
}

class HousePlan extends StatefulWidget {
  @override
  State<HousePlan> createState() => _HousePlanState();
}

class _HousePlanState extends State<HousePlan> {
  final TransformationController _controller = TransformationController();
  List<Offset> _tappedPoints = [];
  Offset? _selectedPoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tap to add icons'),
      ),
      body: InteractiveViewer(
        transformationController: _controller,
        boundaryMargin: EdgeInsets.all(100),
        minScale: 0.5,
        maxScale: 2,
        child: Stack(
          children: <Widget>[
            Image.asset(
              'assets/testplan.png',
              fit: BoxFit.cover,
            ),
            ..._tappedPoints.map(
                  (Offset point) => Positioned(
                left: point.dx,
                top: point.dy,
                child: Transform(
                  transform: Matrix4.inverted(_controller.value),
                  child: Icon(
                    Icons.location_on,
                    color: point == _selectedPoint ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTapDown: (TapDownDetails details) {
                setState(() {
                  _tappedPoints.add(details.localPosition);
                });
              },
              onLongPressStart: (LongPressStartDetails details) {
                setState(() {
                  _selectedPoint = details.localPosition;
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _tappedPoints.clear();
            _selectedPoint = null;
          });
        },
        tooltip: 'Clear',
        child: Icon(Icons.clear),
      ),
    );
  }
}