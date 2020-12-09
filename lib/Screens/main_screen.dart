import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter_3/Screens/createmoods_screen.dart';
import 'package:learn_flutter_3/Screens/userdisplayname_screen.dart';
import 'package:learn_flutter_3/Screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String imgProfile =
      'https://www.pngkey.com/png/detail/230-2301779_best-classified-apps-default-user-profile.png';
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  dynamic userDisplayName = 'User';
  String namaHero = 'superheroname';
  String moodsHero = '.....';
  var _firebaseFirestore = FirebaseFirestore.instance.collection('moods');

  void streamFirestoreData() {
    _firebaseFirestore.doc(loggedInUser.email).snapshots().listen((event) {
      if (event.data() != null){
        setState(() {
          namaHero = event.data()['namahero'];
          imgProfile = event.data()['urlHero'];
          moodsHero = event.data()['moodstext'];
        });
      }
    });
  }

  void deleteMoods() async {
    await _firebaseFirestore.doc(loggedInUser.email).delete();
  }

  void initState() {
    super.initState();
    getCurrentUser();
    streamFirestoreData();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      if (loggedInUser.displayName != null) {
        userDisplayName = loggedInUser.displayName;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 80.0,
                      backgroundImage: NetworkImage(imgProfile),
                    ),

                    Text(
                      'Hello $userDisplayName, \n you are $namaHero!',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    Text(
                      'Moods: $moodsHero',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    RaisedButton(
                      onPressed: (){
                        deleteMoods();
                        setState(() {
                          imgProfile = 'https://www.pngkey.com/png/detail/230-2301779_best-classified-apps-default-user-profile.png';
                          namaHero = 'superheroname';
                          moodsHero = '.....';
                        });
                      },
                      child: Text('Delete Moods'),
                    ),

                    Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.settings),
                              iconSize: 35.0,
                              tooltip: 'Set Profile Name',
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  UserNameDisplayScreen.id,
                                ).whenComplete(
                                    () => setState(() => {getCurrentUser()}));
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.person_add),
                              iconSize: 35.0,
                              tooltip: 'Moods',
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, CreateMoodsScreen.id)
                                    .whenComplete(
                                        () => {streamFirestoreData()}
                                    );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.power_settings_new),
                              iconSize: 35.0,
                              tooltip: 'Log Out',
                              onPressed: () {
                                _auth.signOut();
                                Navigator.pushReplacementNamed(
                                    context, WelcomeScreen.id);
                              },
                            ),
                          ]),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
