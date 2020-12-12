import 'package:delivery/widgets/map_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Delevery extends StatelessWidget {
  const Delevery({this.orderName, this.lat, this.long});

  final String orderName;
  final double lat;
  final double long;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            this.orderName,
            style: TextStyle(color: Colors.black),
          )),
      body: Stack(
        children: <Widget>[
          MapWidget(longitude: this.long, latitude: this.lat),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(15.0),
                      topRight: const Radius.circular(15.0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width / 1.5,
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
                                // controller: scrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return buildList(
                                      context, snapshot.data[index]);
                                });
                        }
                        return Center(
                          child: Text('error!!'),
                        );
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () => print('hello'),
                    child: new Container(
                      margin: EdgeInsets.all(10),
                      height: 60.0,
                      decoration: new BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Color(0xff61E4F3), Color(0xffE81EDB)]),

                        // border: new Border.all(color: Colors.white, width: 2.0),
                        borderRadius: new BorderRadius.circular(15.0),
                      ),
                      child: new Center(
                        child: new Text(
                          'done',
                          style: new TextStyle(
                              fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  getData() async {
    Response response = await Dio().get(
        "https://fakemyapi.com/api/fake?id=d8c80a29-0164-4b96-a809-070ee303f90b");

    return response.data["orders"];
  }
}

Widget buildList(BuildContext context, data) {
  return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.width / 2,
      decoration: new BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xffF36661), Color(0xffE87D1E)]),
          borderRadius: new BorderRadius.all(const Radius.circular(15))),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Image.network("http://lorempixel.com/640/480/food"),
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              data['customer']['current_balance'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          )
        ],
      ));
}
