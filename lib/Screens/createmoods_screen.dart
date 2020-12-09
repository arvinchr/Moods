import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:learn_flutter_3/Models/hero.dart';
import 'package:learn_flutter_3/Services/heroapi_connection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateMoodsScreen extends StatefulWidget {
  static const String id = 'createmoods_screen';

  @override
  _CreateMoodsScreenState createState() => _CreateMoodsScreenState();
}

class _CreateMoodsScreenState extends State<CreateMoodsScreen> {
  String heroNameToSearch;
  var getHeroData;
  String namaHero;
  String imgHero;
  int selectedIndex = -1;
  String moodsText;
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
              Card(
                child: TextField(
                    onChanged: (value) {
                  heroNameToSearch = value;
                  setState(() {
                    getHeroData =
                        HeroApiConnection(heroName: heroNameToSearch).getData();
                  });
                }),
              ),
              Expanded(
                child: FutureBuilder(
                  future: getHeroData,
                  builder: (context, AsyncSnapshot<HeroData> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data.results.length,
                        itemBuilder: (BuildContext context, int index) {
                          var heroesData = snapshot.data.results[index];
                          return Column(children: [
                            InkWell(
                              child: Card(
                                shape: (selectedIndex == index)
                                    ? RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.blueAccent))
                                    : null,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.network(heroesData.img),
                                      Text(
                                        heroesData.name,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                  height: 300.0,
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  selectedIndex = index;
                                  namaHero = heroesData.name;
                                  imgHero = heroesData.img;
                                });
                              },
                            ),
                          ]);
                        },
                      );
                    } else {
                      return Text('Search your hero first');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Card(
        child: ListTile(
          leading: Text(
            'Moods',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          title: TextField(onChanged: (value) {
            moodsText = value;
          }),
          trailing: IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              var loggedInUser = FirebaseAuth.instance.currentUser;
              await firestoreInstance
                  .collection('moods')
                  .doc(loggedInUser.email)
                  .set({
                    'namahero': '$namaHero',
                    'urlHero': '$imgHero',
                    'moodstext': '$moodsText',
                  })
                  .then((value) => print(
                      '${loggedInUser.displayName} berhasil menambahkan moods'))
                  .catchError(
                      (error) => print('Gagal menambahkan moods ke database'));
            },
          ),
        ),
      ),
    );
  }
}
