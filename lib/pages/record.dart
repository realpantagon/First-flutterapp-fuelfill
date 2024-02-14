import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuelfill/models/model_Data.dart';
import 'package:fuelfill/services/database_helper.dart';
import 'package:flutter/cupertino.dart';

// ignore: camel_case_types
class recordScreen extends StatefulWidget {
  final Record? record;
  const recordScreen({Key? key, this.record}) : super(key: key);

  @override
  State<recordScreen> createState() => _recordState();
}

// ignore: camel_case_types
class _recordState extends State<recordScreen> {
  final moneyController = TextEditingController();
  final literController = TextEditingController();
  final priceController = TextEditingController();
  final distanceController = TextEditingController();
  late DateTime dateTime = DateTime.now();

  late DateTime date = DateTime.now();
  late DateTime time = DateTime.now();
  
  @override
  void initState() {
    super.initState();

    if (widget.record != null) {
      moneyController.text = widget.record!.baht.toString();
      literController.text = widget.record!.liter.toString();
      priceController.text = calculateOilPrice(
        widget.record!.baht,
        widget.record!.liter,
      ).toString();
      distanceController.text = widget.record!.distance.toString();
      dateTime = widget.record!.datetime;
    } else {
      dateTime = DateTime.now();
    }
  }


  String calculateOilAmount(double oilprice, double baht) {
    if (oilprice != 0) {
      double amount = baht/oilprice;
      return amount.toStringAsFixed(2);
    } else {
      return "0.0";
    }
  }

  String calculateOilPrice(double baht, double liter) {
    if (liter != 0) {
      double oilPrice = baht / liter;
      return oilPrice.toStringAsFixed(2);
    } else {
      return "0.0";
    }
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 255, 255, 255),
      appBar: recordbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [datetime(), input(), addbut()],
        ),
      ),
    );
  }



  Container addbut() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Align(
        alignment: Alignment.topCenter,
        child: ElevatedButton(
          onPressed: () async {
            if (widget.record != null) {
              final updateRecord = Record(
                  id: widget.record!.id,
                  liter: double.parse(literController.text),
                  distance: double.parse(distanceController.text),
                  baht: double.parse(moneyController.text),
                  datetime: dateTime);
              await DatabaseHelper.updateRecord(updateRecord)
                  .then((value) => {setState(() {})});
              Navigator.pop(context, true);
            } else {
              final addnewReocrd = Record(
                  id: new DateTime.now().millisecondsSinceEpoch,
                  liter: double.parse(literController.value.text),
                  distance: double.parse(distanceController.value.text),
                  baht: double.parse(moneyController.value.text),
                  datetime: dateTime);
              await DatabaseHelper.addRecord(addnewReocrd)
                  .then((value) => {setState(() {})});

              Navigator.pop(context, true);
            }
          },
          child: const Text('Add Record'),
        ),
      ),
    );
  }

  Widget buildInputRow({
    required String label,
    required TextEditingController controller,
    String? suffixText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(label),
          ),
          const SizedBox(width: 3),
          Expanded(
            flex: 2,
            child: TextFormField(
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: InputDecoration(
                // labelText: label,
                suffixText: suffixText,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 3, color: Color.fromARGB(255, 167, 167, 167)),
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
              ],
              onChanged: (value) {
                print('Money = ${moneyController.text}');
                print('Price = ${priceController.text}');
                print('Liter = ${literController.text}');
                print('Distance = ${distanceController.text}');
                // print('DateTime = ${dateTimeController.text}');
              },
              controller: controller,
            ),
          ),
          const Padding(padding: EdgeInsets.only(right: 20))
        ],
      ),
    );
  }

  Container input() {
    return Container(
      padding: const EdgeInsets.only(left: 30, top: 5),
      child: Column(
        children: [
          buildInputRow(
            label: 'Amount of money',
            controller: moneyController,
            suffixText: ' Baht  ',
          ),
          buildInputRow(
            label: 'Amount',
            controller: literController,
            suffixText: ' Liter  ',
          ),
          buildInputRow(
            label: 'oil price',
            controller: priceController,
            suffixText: 'Baht/Liter  ',
          ),
          buildInputRow(
            label: 'Distance',
            controller: distanceController,
            suffixText: 'Km  ',
          ),
          const SizedBox(height: 32.0),
        ],
      ),
    );
  }

  Container datetime() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoButton(
                // color: Color.fromARGB(255, 167, 171, 255),
                child: Text(
                  '${date.day}-${date.month}-${date.year}',
                  style: const TextStyle(fontSize: 14),
                ),
                onPressed: () => _showDialog(
                      CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        use24hFormat: true,
                        showDayOfWeek: true,
                        initialDateTime: date,
                        onDateTimeChanged: (DateTime newDate) {
                          setState(() => date = newDate);
                        },
                      ),
                    )),
            CupertinoButton(
              // color: Color.fromARGB(255, 167, 171, 255),
              child: Text(
                '${time.hour}-${time.minute}',
                style: const TextStyle(fontSize: 14),
              ),
              onPressed: () => _showDialog(
                CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: true,
                  showDayOfWeek: true,
                  initialDateTime: time,
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() => time = newDate);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar recordbar() {
    return AppBar(
      title: const Text(
        'record bar',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }
}
