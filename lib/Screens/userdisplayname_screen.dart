import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserNameDisplayScreen extends StatefulWidget {
  static const String id = 'userdisplayname_screen';

  @override
  _UserNameDisplayScreenState createState() => _UserNameDisplayScreenState();
}

class _UserNameDisplayScreenState extends State<UserNameDisplayScreen> {
  /*User _activeUser;
  final _auth = FirebaseAuth.instance;
  dynamic _setDisplayName;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      _activeUser = user;
    }
  }*/
  final _activeUser = FirebaseAuth.instance.currentUser;
  String _setDisplayName;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Set Your Profile Name',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                onChanged: (value) {
                  _setDisplayName = value;
                },
                decoration: InputDecoration(
                  labelText: 'Display Name',
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Back'),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      try {
                        await _activeUser.updateProfile(
                            displayName: _setDisplayName);
                        if (_setDisplayName != null) {
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
