import 'package:delivery/screens/delevery_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../widgets/map_widget.dart';

class Home_page extends StatelessWidget {
  Home_page({Key key}) : super(key: key);

  getData() async {
    Response response = await Dio().get(
        "https://fakemyapi.com/api/fake?id=d8c80a29-0164-4b96-a809-070ee303f90b");
    return response.data["orders"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 130),
            child: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('error! No Internet Connection'),
                  );
                }

                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(
                      child: Text('No Internet Connection'),
                    );
                  case ConnectionState.active:
                    return Center(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  case ConnectionState.waiting:
                    return Center(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  case ConnectionState.done:
                    if (snapshot.data.isEmpty) {
                      return Center(
                        child: Text("no data"),
                      );
                    }

                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return buildList(context, snapshot.data[index]);
                        });
                }
                return Center(
                  child: Text('error!!'),
                );
              },
            ),
          ),
          Container(
            height: 130,
            color: Colors.white,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Image(
                      image: AssetImage('assets/down_arrow.png'),
                    ),
                    Expanded(
                      child: Text('Current Location',
                          style: TextStyle(fontSize: 15)),
                    ),
                    Image(
                      image: AssetImage('assets/help.png'),
                    ),
                    Text('Help!', style: TextStyle(fontSize: 15)),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Material(
                          color: Colors.grey[100],
                          elevation: 0,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: TextField(
                            cursorColor: Theme.of(context).primaryColor,
                            decoration: InputDecoration(
                                hintText: "search",
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                suffixIcon: Material(
                                  elevation: 0.0,
                                  color: Colors.grey[100],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  child: Icon(Icons.search),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 13)),
                          ),
                        ),
                      ),
                    ),
                    Image(
                      image: AssetImage('assets/settings.png'),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget buildList(BuildContext context, data) {
  return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Delevery(
                  orderName: data['customer']['username'],
                  lat: double.parse(data['shipping_address']['latitude']),
                  long: double.parse(data['shipping_address']['longitude'])),
            ));
      },
      child: Container(
          margin: EdgeInsets.all(10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                MapWidget(
                    longitude:
                        double.parse(data['shipping_address']['longitude']),
                    latitude:
                        double.parse(data['shipping_address']['latitude'])),
                Container(
                    child: Column(children: [
                      Expanded(
                        child: Container(),
                        flex: 2,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage:
                                      NetworkImage(data['customer']['avatar']),
                                  backgroundColor: Colors.grey,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      data['customer']['name'],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      data['customer']['email'],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      data['customer']['phone'],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        flex: 1,
                      ),
                    ]),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0x00FFFFFF), Color(0xBDE81EDB)])))
              ],
            ),
          )));
}
