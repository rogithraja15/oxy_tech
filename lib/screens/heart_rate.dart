import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:oxy_tech/utils/constants.dart';

class HeartRate extends StatefulWidget {
  const HeartRate({super.key});

  @override
  State<HeartRate> createState() => _HeartRateState();
}

class _HeartRateState extends State<HeartRate> {
  final Random _random = Random();
  final List<FlSpot> _spots = [];
  int _bpm = 0;
  double _lastX = 0.0;

  double _minBPM = double.infinity;
  double _maxBPM = double.negativeInfinity;
  double _averageBPM = 0.0;
  int _totalReadings = 0;
  int _sumBPM = 0;

  @override
  void initState() {
    super.initState();
    _generateInitialData();
    Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      _updateHeartRate();
    });
  }

  void _generateInitialData() {
    for (int i = 0; i < 10; i++) {
      double bpm = _random.nextInt(20) + 60.0;
      _spots.add(FlSpot(i.toDouble(), bpm));
      _updateStatistics(bpm);
    }
  }

  void _updateHeartRate() {
    setState(() {
      _bpm = 60 + _random.nextInt(40);

      if (_spots.length >= 10) {
        double removedBPM = _spots.first.y;
        _spots.removeAt(0);
        _updateStatistics(removedBPM, isAddition: false);
      }
      _spots.add(FlSpot(
        _lastX += 0.5,
        _bpm.toDouble(),
      ));
      _updateStatistics(_bpm.toDouble());
    });
  }

  void _updateStatistics(double bpm, {bool isAddition = true}) {
    if (isAddition) {
      _totalReadings++;
      _sumBPM += bpm.toInt();
      if (bpm < _minBPM) _minBPM = bpm;
      if (bpm > _maxBPM) _maxBPM = bpm;
    } else {
      _totalReadings--;
      _sumBPM -= bpm.toInt();
      if (_spots.isEmpty) {
        _minBPM = double.infinity;
        _maxBPM = double.negativeInfinity;
        for (var spot in _spots) {
          if (spot.y < _minBPM) _minBPM = spot.y;
          if (spot.y > _maxBPM) _maxBPM = spot.y;
        }
      }
    }
    _averageBPM = _totalReadings > 0 ? _sumBPM / _totalReadings : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Heart Rate',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFA9C7C3),
              Color.fromRGBO(125, 168, 160, 0.7),
              Color(0xFFEDEDED),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.47, 1.0],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 100.0, vertical: 20),
                child: Stack(
                  alignment: Alignment.lerp(
                      Alignment.center, Alignment.bottomCenter, 0.7)!,
                  children: [
                    Text(
                      '$_bpm BPM',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Image.asset('assets/heart_rate.png'),
                  ],
                ),
              ),
              SizedBox(
                height: sizeh(context) * 0.05,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                height: sizeh(context) * 0.3,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const style = TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                            );
                            return Text(value.toInt().toString(), style: style);
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const style = TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                            );
                            return Text(value.toInt().toString(), style: style);
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(
                        show: true, border: Border.all(color: Colors.black)),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _spots,
                        isCurved: false,
                        color: Colors.red,
                        barWidth: 2,
                        belowBarData: BarAreaData(show: false),
                        dotData: const FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: sizeh(context) * 0.1,
              ),
              Container(
                width: double.infinity,
                height: sizeh(context) * 0.12,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_minBPM.toStringAsFixed(1)),
                        const Text('Min'),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _averageBPM.toStringAsFixed(1),
                        ),
                        const Text(
                          'Avg',
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _maxBPM.toStringAsFixed(1),
                        ),
                        Text(
                          'Max',
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
