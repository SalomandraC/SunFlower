import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunflower/core/global_widgets/gradient_appbar.dart';

class SunflowerPage extends StatefulWidget {
  const SunflowerPage({super.key});

  @override
  State<SunflowerPage> createState() => _SunflowerPageState();
}

class _SunflowerPageState extends State<SunflowerPage> {
  int _nSeeds = 1000;
  double _angleDeg = 137.509;
  double _pointSize = 1.0;
  int _redCount = 0;
  int _blackCount = 0;
  final TransformationController _transformController =
      TransformationController();
  final GlobalKey _canvasKey = GlobalKey();
  double _controlPanelHeight = 200;
  bool _showControls = true;
  final TextEditingController _seedCountController = TextEditingController();
  final TextEditingController _angleController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings().then((_) {
      _updateControllers();
    });
  }

  @override
  void dispose() {
    _seedCountController.dispose();
    _angleController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nSeeds = prefs.getInt('nSeeds') ?? 1000;
      _angleDeg = prefs.getDouble('angleDeg') ?? 137.509;
      _pointSize = prefs.getDouble('pointSize') ?? 1.0;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('nSeeds', _nSeeds);
    await prefs.setDouble('angleDeg', _angleDeg);
    await prefs.setDouble('pointSize', _pointSize);
  }

  void _updateControllers() {
    _seedCountController.text = _nSeeds.toString();
    _angleController.text = _angleDeg.toStringAsFixed(2);
    _sizeController.text = _pointSize.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final points = _generateFibonacciPoints(_nSeeds, _angleDeg);
    final overlaps = _findOverlaps(points, _pointSize);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Фибоначчиев Подсолнух'),
        actions: [
          IconButton(
            icon: Icon(_showControls
                ? Icons.keyboard_arrow_down
                : Icons.keyboard_arrow_up),
            onPressed: () {
              setState(() {
                _showControls = !_showControls;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              transformationController: _transformController,
              minScale: 0.1,
              maxScale: 10.0,
              boundaryMargin: const EdgeInsets.all(double.infinity),
              child: Center(
                child: CustomPaint(
                  key: _canvasKey,
                  painter: _SunflowerPainter(
                    points: points,
                    overlaps: overlaps,
                    pointSize: _pointSize,
                    center: Offset(centerX, centerY),
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
          if (_showControls) ...[
            GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  _controlPanelHeight -= details.delta.dy;
                  _controlPanelHeight = _controlPanelHeight.clamp(150.0, 300.0);
                });
              },
              child: Container(
                height: _controlPanelHeight,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Подсолнух (n=$_nSeeds, угол=${_angleDeg.toStringAsFixed(3)}°, размер=${_pointSize.toStringAsFixed(2)})\n'
                        'Перекрывающиеся: $_redCount, Неперекрывающиеся: $_blackCount',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      _buildSeedCountSlider(),
                      _buildAngleSlider(),
                      _buildPointSizeSlider(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSeedCountSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Количество семян'),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85 - 80,
              child: Slider(
                value: _nSeeds.toDouble(),
                min: 100,
                max: 1000,
                label: _nSeeds.toString(),
                onChanged: (value) {
                  setState(() {
                    _nSeeds = value.round();
                    _seedCountController.text = _nSeeds.toString();
                    _saveSettings();
                  });
                },
              ),
            ),
            SizedBox(
              width: 80,
              child: TextField(
                controller: _seedCountController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                onSubmitted: (value) {
                  final newValue = int.tryParse(value) ?? _nSeeds;
                  setState(() {
                    _nSeeds = newValue.clamp(100, 1000);
                    _seedCountController.text = _nSeeds.toString();
                    _saveSettings();
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAngleSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Угол расхождения'),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85 - 80,
              child: Slider(
                value: _angleDeg,
                min: 100.0,
                max: 160.0,
                label: _angleDeg.toStringAsFixed(2),
                onChanged: (value) {
                  setState(() {
                    _angleDeg = value;
                    _angleController.text = _angleDeg.toStringAsFixed(2);
                    _saveSettings();
                  });
                },
              ),
            ),
            SizedBox(
              width: 80,
              child: TextField(
                controller: _angleController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                onSubmitted: (value) {
                  final newValue = double.tryParse(value) ?? _angleDeg;
                  setState(() {
                    _angleDeg = newValue.clamp(100.0, 160.0);
                    _angleController.text = _angleDeg.toStringAsFixed(2);
                    _saveSettings();
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPointSizeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Размер семян'),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.82 - 80,
              child: Slider(
                value: _pointSize,
                min: 0.3,
                max: 2.0,
                divisions: 17,
                label: _pointSize.toStringAsFixed(2),
                onChangeEnd: (value) {
                  _saveSettings();
                },
                onChanged: (value) {
                  setState(() {
                    _pointSize = value;
                    _sizeController.text = _pointSize.toStringAsFixed(2);
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 80,
              child: TextField(
                controller: _sizeController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                onSubmitted: (value) {
                  final newValue = double.tryParse(value) ?? _pointSize;
                  setState(() {
                    _pointSize = newValue.clamp(0.3, 2.0);
                    _sizeController.text = _pointSize.toStringAsFixed(2);
                    _saveSettings();
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Offset> _generateFibonacciPoints(int nSeeds, double angleDeg) {
    final goldenAngle = angleDeg * pi / 180;
    final points = <Offset>[];

    for (int i = 0; i < nSeeds; i++) {
      final radius = sqrt(i) * 2;
      final angle = i * goldenAngle;
      final x = radius * cos(angle);
      final y = radius * sin(angle);
      points.add(Offset(x, y));
    }

    return points;
  }

  Set<int> _findOverlaps(List<Offset> points, double pointSize) {
    final overlaps = <int>{};
    final pixelRadius = sqrt(pointSize) * 1.5;

    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        final distance = (points[i] - points[j]).distance;
        if (distance < 2 * pixelRadius) {
          overlaps.add(i);
          overlaps.add(j);
        }
      }
    }

    _redCount = overlaps.length;
    _blackCount = points.length - _redCount;

    return overlaps;
  }
}

class _SunflowerPainter extends CustomPainter {
  final List<Offset> points;
  final Set<int> overlaps;
  final double pointSize;
  final Offset center;

  _SunflowerPainter({
    required this.points,
    required this.overlaps,
    required this.pointSize,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 1.0;

    canvas.drawLine(
      Offset(center.dx - 150, center.dy),
      Offset(center.dx + 150, center.dy),
      axisPaint,
    );

    canvas.drawLine(
      Offset(center.dx, center.dy - 150),
      Offset(center.dx, center.dy + 150),
      axisPaint,
    );

    for (int i = 0; i < points.length; i++) {
      final paint = Paint()
        ..color = overlaps.contains(i) ? Colors.red : Colors.black
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(center.dx + points[i].dx, center.dy + points[i].dy),
        pointSize,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
