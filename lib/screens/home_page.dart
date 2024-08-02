import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oxy_tech/screens/emergency.dart';
import 'package:oxy_tech/screens/heart_rate.dart';
import 'package:oxy_tech/screens/oxygen.dart';
import 'package:oxy_tech/screens/patient_history.dart';
import 'package:oxy_tech/screens/power.dart';
import 'package:oxy_tech/screens/settings.dart';
import 'package:oxy_tech/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<String> _fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          return snapshot.get('name');
        } else {
          return 'Unknown User';
        }
      } catch (e) {
        return 'Unknown User';
      }
    } else {
      return 'Unknown User';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showConnectingDialog();
    });
  }

  void _navigateToPage(int index) {
    final List<Widget> pages = [
      const HeartRate(),
      const PatientHistory(),
      const OxygenProduction(),
      const PowerConsumption(),
      const SettingsPage(),
      const Emergency(),
    ];

    if (index >= 0 && index < pages.length) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => pages[index]),
      );
    }
  }

  void _showConnectingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Connecting'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Connecting to the Raspberry Pi'),
              SizedBox(height: 20),
              CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context, rootNavigator: true).pop();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Connected'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 50),
                SizedBox(height: 20),
                Text('Connected successfully'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFA9C7C3),
              Color(0xFF5F998E),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: sizew(context) * 0.4,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(34),
                  bottomRight: Radius.circular(34),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 20),
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        'https://th.bing.com/th/id/OIP.PoS7waY4-VeqgNuBSxVUogAAAA?rs=1&pid=ImgDetMain',
                      ),
                    ),
                    const SizedBox(width: 20),
                    FutureBuilder<String>(
                      future: _fetchUserName(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text(
                            'Loading...',
                            style: TextStyle(color: Colors.black),
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.black),
                          );
                        } else {
                          return Text(
                            snapshot.data ?? 'Unknown User',
                            style: const TextStyle(color: Colors.black),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: sizeh(context) * 0.05,
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => _navigateToPage(index),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          image: DecorationImage(
                            image: AssetImage('assets/Grid${index + 1}.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
