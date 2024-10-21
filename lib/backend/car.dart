class Car {
  final String key;
  final String code;
  final String brand;
  final String model;
  final String type;
  final int seats;
  final int doors;
  final double acceleration;
  final String image;
  final String tag;

  Car({
    required this.key,
    required this.code,
    required this.brand,
    required this.model,
    required this.type,
    required this.seats,
    required this.doors,
    required this.acceleration,
    required this.image,
    required this.tag,
  });

  @override
  String toString() {
    return 'Car($brand $model, $type, $seats seats, $doors doors)';
  }
}
