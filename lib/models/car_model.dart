class CarModel {
  CarModel(
      {required this.idCar,
      required this.id,
      required this.gmail,
      required this.carName,
      required this.description,
      required this.carbrand,
      required this.fuel,
      required this.kilometer,
      required this.seats,
      required this.price,
      required this.urlImage,
      required this.isActive});
  late String idCar;
  late String id;
  late String gmail;
  late String carName;
  late String description;
  late String carbrand;
  late String fuel;
  late double kilometer;
  late int seats;
  late double price;
  late String urlImage;
  late String isActive;

  CarModel.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    gmail = data["gmail"];
    carName = data["carName"];
    description = data["description"];
    carbrand = data["carbrand"];
    fuel = data["fuel"];
    kilometer = data["kilometer"];
    seats = data["seats"];
    price = data["price"];
    urlImage = data["urlImage"];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "gmail": gmail,
        "carName": carName,
        "description": description,
        "carbrand": carbrand,
        "fuel": fuel,
        "kilometer": kilometer,
        "seats": seats,
        "price": price,
        "urlImage": urlImage,
        "isActive": isActive,
      };
}
