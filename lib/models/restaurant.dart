class RestaurantModel{
  String name;
  String thumbnail;
  String address;
  int price;
  RestaurantModel(this.name, this.thumbnail, this.address, this.price);

  RestaurantModel.fromJson(Map<String, dynamic> parsedJson){
    name = parsedJson['restaurant']['name'];
    price = parsedJson['restaurant']['price_range'];
    thumbnail = parsedJson['restaurant']['thumb'];
    address = parsedJson['restaurant']['location']['address'];
  }
}