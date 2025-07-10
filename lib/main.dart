import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:mypractice_flutter/HexColor.dart';
import 'province.dart';

void main() => runApp(MainPage());

class MainPage extends StatefulWidget {
  @override
  Chathome createState() => Chathome();
}

class Chathome extends State<MainPage> {
  var logger = Logger();
  var provincelist = [
    "Alaminos",
    "Bay",
    "Calauan",
    "Cavinti",
    "Kalayaan",
    "Liliw",
    "Los Baños",
    "Luisiana",
    "Lumban",
    "Mabitac",
    "Magdalena",
    "Nagcarlan",
    "Paete",
    "Pagsanjan",
    "Pakil",
    "Pangil",
    "Pila",
    "Rizal",
    "Santa Cruz"
  ];
  List<Province> originalist = [];
  List<Province> searchlist = [];

  @override
  void initState() {
    super.initState();
    for (var name in provincelist) {
      originalist.add(Province(name));
      searchlist.add(Province(name));
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.d("Home chat!");
    return MaterialApp(
        home: Scaffold(
      backgroundColor: HexColor("#ffffff"),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: HexColor("#78B9B5"),
        title: const Text('Practice flutter',
            style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) {
                  _filterList(value);
                },
                decoration: const InputDecoration(
                    labelText: "Search",
                    labelStyle: TextStyle(color: Colors.black)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: originalist.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 24.0, horizontal: 16.0),
                          child: Text(
                            originalist[index].provincename,
                          ),
                        ),
                      ),
                      onTap: () => onTap(originalist[index].provincename),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  void onTap(item) {
    Fluttertoast.showToast(
        msg: "$item is selected",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: HexColor('#000000'),
        textColor: Colors.white,
        fontSize: 16.0);

    logger.d("$item is selected");
  }

  void _filterList(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        originalist = searchlist;
      } else {
        originalist = searchlist
            .where((element) => element.provincename
                .toLowerCase()
                .contains(searchText.toLowerCase()))
            .toList();
      }
    });
  }
}
