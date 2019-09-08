import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:restaurant_api/src/restaurant_card.dart';
import 'mixin/mixin_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'restaurant_card.dart';
import 'package:flutter/services.dart';
import '../models/restaurant.dart';
import 'secret.dart';
import 'package:location/location.dart';

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

  Future getRestaurantData(lat, lng, [bool byDistance = false]) async {
    Secret secret =
        await SecretLoader(secretPath: "assets/secrets.json").load();
    String queryType = byDistance ? 'real_distance' : 'rating';
    String url =
        'https://developers.zomato.com/api/v2.1/search?lat=$lat&lon=$lng&sort=$queryType&order=desc';
    var response =
        await http.get(url, headers: {'user-key': secret.zoomato_api});
    var restaurants = json.decode(response.body)['restaurants'];
    List<RestaurantModel> restoList = [];
    restaurants.forEach((resto) {
      RestaurantModel newResto = new RestaurantModel.fromJson(resto);
      restoList.add(newResto);
    });
    return restoList;
  }

  changestate(lat, lng, [bool byDistance = false]) async {
    var restaurantList = await getRestaurantData(lat, lng, byDistance);
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        RaisedButton(
          onPressed: () {
            if (formKey.currentState.validate()) {
              formKey.currentState.save();
            }
          },
          child: Text(
            'Search City',
            style: TextStyle(fontSize: 20),
          ),
        ),
        RaisedButton(
          onPressed: () async {
            var location = Location();
            try {
              var userLocation = await location.getLocation();
              setState(() {
                restaurants.clear();
              });
              changestate(userLocation.latitude, userLocation.longitude, true);
            } on Exception catch (e) {
              print('Could not get location: ${e.toString()}');
            }
          },
          child: Text(
            'Nearby',
            style: TextStyle(fontSize: 20),
          ),
        )
      ],
    );
  }
}
