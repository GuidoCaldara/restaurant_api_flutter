import 'package:flutter/material.dart';
import 'package:restaurant_api/models/restaurant.dart';
import '../models/restaurant.dart';

class RestaurantList extends StatelessWidget {
  final List<RestaurantModel> restaurants;
  RestaurantList(this.restaurants);

  Widget build(context) {
    final width = MediaQuery.of(context).size.width;
    return Flexible(
      child: ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (context, int index) {
        return buildRestaurant(restaurants[index], width);
      },
    ));
  }

  buildRestaurant(RestaurantModel restaurant, double width) {
    double photoWidth = (width - 20.00) * 0.25;
    double infoContainerWidth = (width - 20.00) * 0.65;
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Image.network(
                  restaurant.thumbnail,
                  height: photoWidth,
                  width:  photoWidth,
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: infoContainerWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: infoContainerWidth * 0.7,
                            child: Text(
                              restaurant.name,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: infoContainerWidth * 0.3,
                            child: Row(
                              children: priceIndicator(restaurant.price),
                            ),
                          )
                        ],
                      ),
              
                    ),
                    marginBottom(15.00),
                    Container(
                      width: infoContainerWidth,
                      child: Text(
                        restaurant.address,
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    marginBottom(10.00),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                padding: EdgeInsets.only(left: 20),
              ),
            ],
          ),
          marginBottom(20.00)
        ],
      ),
    );
  }

  marginBottom(value) {
    return Container(
      color: Colors.grey[300],
      height: 1.0,
      margin: EdgeInsets.only(bottom: value),
    );
  }

  List<Icon> priceIndicator(price) {
    List<Icon> stars = [];
    for (int i = 0; i < price; i++) {
      stars.add(Icon(
        IconData(59686, fontFamily: 'MaterialIcons'),
        size: 10.0,
        color: Colors.blue[700],
      ));
    }
    for (int i = 0; i < 5 - price; i++) {
      stars.add(Icon(
        IconData(59686, fontFamily: 'MaterialIcons'),
        size: 10.0,
        color: Colors.blue[300],
      ));
    }
    return stars;
  }
}
