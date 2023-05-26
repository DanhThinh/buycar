class DiscountModel {
  DiscountModel(
      {required this.name,
      required this.description,
      required this.image,
      required this.percent,
      required this.code});

  late String name;
  late String description;
  late String image;
  late String percent;
  late String code;

  DiscountModel.fromMap(Map<String, dynamic> data) {
    name = data["name"];
    description = data["description"];
    image = data["image"];
    percent = data["percent"];
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "image": image,
        "percent": percent
      };
}
