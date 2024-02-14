import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fuelfill/pages/car.dart';
import 'package:fuelfill/pages/record.dart';
import 'package:fuelfill/services/database_helper.dart';
import 'package:fuelfill/models/model_Data.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // _getcategories();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: Column(
        children: [status(), showrecord()],
      ),
      floatingActionButton: Menu(context),
    );
  }

  SpeedDial Menu(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: Colors.white,
      activeBackgroundColor: const Color.fromARGB(255, 242, 242, 242),
      overlayColor: Colors.black,
      overlayOpacity: 0.4,
      spacing: 20,
      spaceBetweenChildren: 20,
      children: [
        SpeedDialChild(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          child: const Icon(Icons.receipt_long_rounded),
          label: 'Add Record',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const recordScreen(),
              ),
            ).then(
              (value) => setState(() {}),
            );
          },
        ),
        // SpeedDialChild(
        //     backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        //     child: const Icon(Icons.car_repair_rounded),
        //     label: 'Select Car',
        //     onTap: () {
        //       Navigator.push(context,
        //               MaterialPageRoute(builder: (context) => const car()))
        //           .then((value) => setState(() {}));
        //     })
      ],
    );
  }

  Widget showrecord() {
    return FutureBuilder(
      future: DatabaseHelper.getAllRecord(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == null ||
            (snapshot.data as List<Record>).isEmpty) {
          return const ListTile(
            title: Text('No Records Yet'),
          );
        } else {
          List<Record> records = (snapshot.data as List<Record>);
          records.sort(
            (a, b) => b.datetime.compareTo(a.datetime),
          );
          return Expanded(
            child: ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                Record record = records[index];
                return Padding(
                  padding: const EdgeInsets.all(2),
                  child: ListTile(
                    tileColor: Color.fromARGB(255, 251, 251, 251),
                    dense: true,
                    title: Text(
                      'Liter: ${record.liter}, Distance: ${record.distance}, Baht: ${record.baht}',
                    ),
                    subtitle: Text(
                      'DateTime: ${DateFormat('dd/MM/yyyy HH:mm').format(record.datetime)}',
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => recordScreen(
                                    record: record,
                                  ),
                                ),
                              );
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.edit_note_outlined,
                              color: Colors.lightBlue.shade400,
                            ),
                          ),
                          IconButton(
                            onPressed: () async => {
                              if (Platform.isIOS)
                                {
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CupertinoAlertDialog(
                                          title: const Text('Confirm Delete'),
                                          content:
                                              const Text('Delete this record'),
                                          actions: <Widget>[
                                            CupertinoDialogAction(
                                                child: const Text('No'),
                                                onPressed: () => {
                                                      Navigator.of(context)
                                                          .pop()
                                                    }),
                                            CupertinoDialogAction(
                                              isDestructiveAction: true,
                                              child: const Text('Delete'),
                                              onPressed: () {
                                                DatabaseHelper.deleteRecord(
                                                        record)
                                                    .then((value) =>
                                                        setState(() {}))
                                                    .then((value) =>
                                                        Navigator.of(context)
                                                            .pop());
                                              },
                                            ),
                                          ],
                                        );
                                      })
                                }
                              else
                                {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('confirm Delete'),
                                          content: const Text(
                                              'Are you sure you want to delete this record?'),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () => {
                                                      Navigator.of(context)
                                                          .pop()
                                                    },
                                                child: const Text('No')),
                                            TextButton(
                                                onPressed: () {
                                                  DatabaseHelper.deleteRecord(
                                                          record)
                                                      .then((value) =>
                                                          setState(() {}))
                                                      .then((value) =>
                                                          Navigator.of(context)
                                                              .pop());
                                                },
                                                style: TextButton.styleFrom(
                                                  foregroundColor:Colors.red.shade500 
                                                ),
                                                child: const Text('Delete'),)
                                          ],
                                        );
                                      })
                                }
                            },
                            icon: Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.red.shade300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }

  Expanded showinsight(String label, String type) {
    return Expanded(
      child: FutureBuilder(
        future: DatabaseHelper.getsum(type),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            double total = snapshot.data ?? 0.00;
            return Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(total.toStringAsFixed(2)),
                  const SizedBox(height: 15),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Container status() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox(width: 5),
              showinsight('Baht/Liter', 'BpL'),
              const SizedBox(width: 5),
              showinsight('Baht/Km', 'BpD'),
              const SizedBox(width: 5),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox(width: 5),
              showinsight('Total Expense', 'Money'),
              const SizedBox(width: 5),
              showinsight('Total Distance', 'Distance'),
              const SizedBox(width: 5),
            ],
          ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Pantagon Fuel Fill',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }
}
