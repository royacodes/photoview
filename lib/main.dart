import 'package:flutter/material.dart';

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
  final List<Offset> _imagePoints = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Long Press to Add Icons'),
      ),
      body: GestureDetector(
        onLongPressStart: (LongPressStartDetails details) {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final Offset localOffset = renderBox.globalToLocal(details.globalPosition);
          final Offset transformedOffset = _controller.toScene(localOffset);

          setState(() {
            _imagePoints.add(transformedOffset);
          });
        },
        child: InteractiveViewer(
          transformationController: _controller,
          boundaryMargin: EdgeInsets.all(100),
          minScale: 0.5,
          maxScale: 2,
          child: Stack(
            children: [
              Image.asset(
                'assets/testplan.png',
                fit: BoxFit.cover,
              ),
              for (final point in _imagePoints)
                Positioned(
                  left: point.dx - 24, // Adjust for half the width of the icon (48/2)
                  top: point.dy - 85, // Adjust for height of the icon (48)
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _imagePoints.clear();
          });
        },
        tooltip: 'Clear',
        child: Icon(Icons.clear),
      ),
    );
  }
}