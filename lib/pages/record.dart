import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuelfill/models/model_Data.dart';
import 'package:fuelfill/services/database_helper.dart';
import 'package:flutter/cupertino.dart';

class recordScreen extends StatefulWidget {
  final Record? record;
  const recordScreen({Key? key, this.record}) : super(key: key);

  @override
  State<recordScreen> createState() => _recordState();
}

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
    // Initialize date and time with the current date and time
    date = DateTime.now();
    time = DateTime.now();
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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: recordbar(),
      body: Column(
        children: [datetime(), Input(), addbut()],
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
            final liter = double.parse(literController.value.text);
            final distance = double.parse(distanceController.value.text);
            final money = double.parse(moneyController.value.text);
            final id = new DateTime.now().millisecondsSinceEpoch;

            final DateTime combinedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );


            final Record model = Record(
                id: id,
                liter: liter,
                distance: distance,
                datetime: combinedDateTime,
                baht: money);
            await DatabaseHelper.addRecord(model);

            print(
                '${date.day},${date.month},${date.year},${date.hour},${date.minute}');
            Navigator.pop(context);
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
              onTapOutside: (Event){
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: InputDecoration(
                // labelText: label,
                suffixText: suffixText,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 3,
                      color: Color.fromARGB(255, 167, 167, 167)),
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

  Container Input() {
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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
    );
  }
}
