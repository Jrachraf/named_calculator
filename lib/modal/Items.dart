class Item {
  final int id;
  final String name;
  final double value;
  final DateTime saveDate;

  Item({
    required this.id,
    required this.name,
    required this.value,
    DateTime? saveDate,
  }) : saveDate = DateTime.now();


}
