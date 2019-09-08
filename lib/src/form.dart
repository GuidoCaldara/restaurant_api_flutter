import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:restaurant_api/src/restaurant_card.dart';
import 'mixin/mixin_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'restaurant_card.dart';
import '../models/restaurant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserFormState();
  }
}

class UserFormState extends State<UserForm> with MixinValidator {
  final formKey = GlobalKey<FormState>();
  String location = '';
  List<RestaurantModel> restaurants = new List();
  double latitude;
  double longitude;

  Widget build(context) {
    return Container(
      padding: EdgeInsets.only(top: 40, bottom: 40, left: 10, right: 10),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            inputField(),
            formButton(),
            RestaurantList(restaurants)
          ],
        ),
      ),
    );
  }

  void getCoordinates(location) async {
    setState(() {
      restaurants.clear();
    });

    var addresses = await Geocoder.local.findAddressesFromQuery(location);
    var first = addresses.first;
    setState(() {
      latitude = first.coordinates.latitude;
      longitude = first.coordinates.longitude;
    });
    changestate(latitude, longitude);
  }

  Future getRestaurantData(lat, lng) async {
    String url =
        'https://developers.zomato.com/api/v2.1/search?lat=$lat&lon=$lng&sort=rating&order=desc';
    var response = await http
        .get(url, headers: {'user-key': '55b999fc85f2826feadca8e1d2a52a83'});
    var restaurants = json.decode(response.body)['restaurants'];
    List<RestaurantModel> restoList = [];
    restaurants.forEach((resto) {
      RestaurantModel newResto = new RestaurantModel.fromJson(resto);
      restoList.add(newResto);
    });
    return restoList;
  }

  changestate(lat, lng) async {
    var restaurantList = await getRestaurantData(lat, lng);
    setState(() {
      restaurants.addAll(restaurantList);
    });
  }

  inputField() {
    return TextFormField(
        keyboardType: TextInputType.text,
        validator: validateInput,
        onSaved: (String value) {
          setState(() {
            location = value;
          });
          getCoordinates(location);
        },
        decoration: InputDecoration(
          hintText: 'ex: London',
          icon: Icon(
            IconData(57779, fontFamily: 'MaterialIcons'),
          ),
        ));
  }

  formButton() {
    return RaisedButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
          }
        },
        child: Text('Search City', style: TextStyle(fontSize: 20)));
  }
}
