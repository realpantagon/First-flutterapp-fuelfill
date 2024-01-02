// ignore_for_file: sort_child_properties_last, must_be_immutable

// import 'package:flutter/foundation.dart';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fuelfill/models/catergoly_model.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fuelfill/pages/car.dart';
import 'package:fuelfill/pages/record.dart';
import 'package:fuelfill/services/database_helper.dart';
import 'package:fuelfill/models/model_Data.dart';
import 'package:intl/intl.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Catergorymodel> categories = [];

  void _getcategories() {
    categories = Catergorymodel.getCatergories();
  }

  @override
  void initState() {
    _getcategories();
  }

  @override
  Widget build(BuildContext context) {
    _getcategories();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: Column(
        children: [
          _categoriesSection(),
          // Text('hi')
          showrecord(),
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: const Color.fromARGB(255, 199, 197, 255),
        activeBackgroundColor: const Color.fromARGB(255, 117, 193, 255),
        overlayColor: Colors.black,
        overlayOpacity: 0.4,
        spacing: 20,
        spaceBetweenChildren: 20,
        children: [
          SpeedDialChild(
              backgroundColor: const Color.fromARGB(255, 207, 240, 255),
              child: const Icon(Icons.receipt_long_rounded),
              label: 'Add Record',
              onTap: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const recordScreen()))
                    .then((value) => setState(() {}));
              }),
          SpeedDialChild(
              backgroundColor: const Color.fromARGB(255, 207, 240, 255),
              child: const Icon(Icons.car_repair_rounded),
              label: 'Select Car',
              onTap: () {
                Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const car()))
                    .then((value) => setState(() {}));
              })
        ],
      ),
    );
  }

  Container showrecord() {
    return Container(
      height: 500,
      child: FutureBuilder(
        future: DatabaseHelper.getAllRecord(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the data is still loading, you can return a loading indicator.
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // If there's an error, you can display an error message.
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data == null ||
              (snapshot.data as List<Record>).isEmpty) {
            // If there is no data or the data is empty, display a message.
            return const ListTile(
              title: Text('No Records Yet'),
            );
          } else {
            // If there is data, display the ListView.
            List<Record> records = (snapshot.data as List<Record>);
            return Expanded(
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  Record record = records[index];
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: ListTile(
                      tileColor: Color.fromARGB(255, 255, 229, 249),
                      dense: true,
                      title: Text('ID: ${record.id}'),
                      subtitle: Text(
                          'Liter: ${record.liter}, Distance: ${record.distance}, Baht: ${record.baht}, DateTime: ${DateFormat('dd/MM/yyyy HH:mm').format(record.datetime)}'),
                    ),
                  );
                },
              ),
            );
          }
        }),
      ),
    );
  }

  Column _categoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _searchfield(),
        const SizedBox(
          height: 40,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                'Insights',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 150,
              // color: Color.fromARGB(255, 215, 255, 220),
              child: ListView.separated(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20, right: 20),
                separatorBuilder: (context, index) => const SizedBox(
                  width: 10,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    width: 90,
                    decoration: BoxDecoration(
                        color: categories[index].boxcolor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(categories[index].icon),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          categories[index].name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 10),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        )
      ],
    );
  }

  Container _searchfield() {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: const Color(0xff1D1617).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0.0)
      ]),
      child: TextField(
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(15),
            hintText: 'Search',
            hintStyle: const TextStyle(
                color: Color.fromARGB(255, 119, 119, 119), fontSize: 14),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset('assets/icons/search-svgrepo-com.svg'),
            ),
            suffixIcon: Container(
              width: 100,
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const VerticalDivider(
                      color: Colors.black,
                      indent: 10,
                      endIndent: 10,
                      thickness: 0.1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                          'assets/icons/filter-svgrepo-com.svg'),
                    ),
                  ],
                ),
              ),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none)),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Pantagon',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 197, 243),
    );
  }
}
