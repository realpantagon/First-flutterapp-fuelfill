class Record {
  final int id;
  final double liter;
  final double distance;
  final double baht;
  final DateTime datetime; // Change to DateTime

  const Record({
    required this.id,
    required this.liter,
    required this.distance,
    required this.baht,
    required this.datetime,
  });

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        id: json['id'],
        liter: json['liter'],
        distance: json['distance'],
        baht: json['baht'],
        datetime: DateTime.parse(json['datetime']), // Adjust based on your date format
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'liter': liter,
      'distance': distance,
      'baht': baht,
      'datetime': datetime.toIso8601String(), // Serialize DateTime to string
    };
  }
}

class Car {
  final String name;
  final String oiltype;
  final num miles; // Use num for numeric values

  const Car({
    required this.name,
    required this.oiltype,
    required this.miles,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
        name: json['name'],
        oiltype: json['oiltype'],
        miles: json['miles'],
      );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'oiltype': oiltype,
      'miles': miles,
    };
  }
}
