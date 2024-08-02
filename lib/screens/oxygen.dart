import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:oxy_tech/utils/constants.dart';

class OxygenProduction extends StatefulWidget {
  const OxygenProduction({super.key});

  @override
  State<OxygenProduction> createState() => _OxygenProductionState();
}

class _OxygenProductionState extends State<OxygenProduction> {
  final Random _random = Random();
  List<BarChartGroupData> _barGroups = [];
  double _minFlowRate = double.infinity;
  double _maxFlowRate = double.negativeInfinity;
  double _averageFlowRate = 0.0;
  List<double> _flowRateValues = [];

  @override
  void initState() {
    super.initState();
    _generateInitialData();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      _updateFlowRate();
    });
  }

  void _generateInitialData() {
    // Generate initial data for the chart
    for (int i = 0; i < 7; i++) {
      double flowRate = 1.7 + _random.nextDouble() * 0.3;
      _flowRateValues.add(flowRate);
      _updateStatistics(flowRate);
      _barGroups.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: flowRate * 10,
            color: const Color(0xff609c90),
            width: 30,
            borderRadius: BorderRadius.zero,
          ),
        ],
      ));
    }
  }

  void _updateFlowRate() {
    setState(() {
      double newFlowRate = 1.7 + _random.nextDouble() * 0.3;

      if (_barGroups.length >= 7) {
        double removedFlowRate = _barGroups.first.barRods.first.toY / 10;
        _barGroups.removeAt(0);
        _flowRateValues.removeAt(0);
        _updateStatistics(removedFlowRate, isAddition: false);
      }

      _flowRateValues.add(newFlowRate);
      _barGroups.add(BarChartGroupData(
        x: _barGroups.length,
        barRods: [
          BarChartRodData(
            toY: newFlowRate * 10,
            color: const Color(0xff609c90),
            width: 20,
            borderRadius: BorderRadius.zero,
          ),
        ],
      ));
      _updateStatistics(newFlowRate);
    });
  }

  void _updateStatistics(double flowRate, {bool isAddition = true}) {
    if (isAddition) {
      _flowRateValues.add(flowRate);
    } else {
      _flowRateValues.remove(flowRate);
    }

    if (_flowRateValues.isNotEmpty) {
      _minFlowRate = _flowRateValues.reduce((a, b) => a < b ? a : b);
      _maxFlowRate = _flowRateValues.reduce((a, b) => a > b ? a : b);
      _averageFlowRate =
          _flowRateValues.reduce((a, b) => a + b) / _flowRateValues.length;
    } else {
      _minFlowRate = double.infinity;
      _maxFlowRate = double.negativeInfinity;
      _averageFlowRate = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Oxygen Production',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: sizeh(context) * 0.18,
                    width: sizew(context) * 0.38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF689D93),
                          Color(0xFF35786A),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Flow rate',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: sizew(context) * 0.04),
                        ),
                        Text(
                          '${_flowRateValues.isEmpty ? '0.0' : _flowRateValues.last.toStringAsFixed(1)} ltr/hr',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: sizew(context) * 0.04),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: sizeh(context) * 0.18,
                    width: sizew(context) * 0.38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF689D93),
                          Color(0xFF35786A),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Purity',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: sizew(context) * 0.04),
                        ),
                        Text(
                          '99 %',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: sizew(context) * 0.04),
                        ),
                      ],
                    ),
                  ),
                ],
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
                child: BarChart(
                  BarChartData(
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
                            return Text((value / 10).toStringAsFixed(1),
                                style: style);
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
                    barGroups: _barGroups,
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
                        Text('${_minFlowRate.toStringAsFixed(1)}'),
                        const Text('Min'),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${_averageFlowRate.toStringAsFixed(1)}',
                        ),
                        const Text(
                          'Avg',
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${_maxFlowRate.toStringAsFixed(1)}',
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
