import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twistic/database/database.dart';
import 'package:twistic/models/login.dart';
import 'package:twistic/models/twistic.dart';
import 'package:twistic/screens/tweet_screen.dart';
import 'package:twistic/services/services.dart';
import 'drawer.dart';

class HomeSreen extends StatefulWidget {
  final String title;

  @override
  _HomeSreen createState() => new _HomeSreen();

  const HomeSreen({Key? key, required this.title}) : super(key: key);
}

class _HomeSreen extends State<HomeSreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late SharedPreferences _sharedPreferences;
  final Login _login = Login();

  @override
  void initState() {
    // TODO: implement initState
    instancingSharedPref();
    super.initState();
  }

  //instancie une sharedpreference
  instancingSharedPref() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _login.email = _sharedPreferences.getString('email')!;
      _login.pseudo = _sharedPreferences.getString('pseudo')!;
      _login.urlPhoto = _sharedPreferences.getString('photoUrl')!;
    });
  }

  Widget homeScreen(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: getTweetsStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    Twistic twistic = Twistic();
                    twistic.pseudo = snapshot.data!.docs[index]['pseudo'];
                    twistic.contenu = snapshot.data!.docs[index]['contenu'];
                    twistic.urlPhoto = snapshot.data!.docs[index]['urlPhoto'];
                    //twistic.writtenDate = snapshot.data!.docs[index]['writtenDate'];
                    return Column(
                      children: <Widget>[
                        // Widget to display the list of project
                        Container(
                          color: Colors.blue,
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 10),
                          width: MediaQuery.of(context).size.width,
                          child: InkWell(
                            // onTap: (){
                            //
                            //   (place.access == true) ?  showDialog(
                            //       context: context,
                            //       builder: (BuildContext context) {
                            //         return AlertDialog(
                            //           backgroundColor: (place.access == true) ? Colors.green : Colors.red,
                            //           content: Container(),
                            //         );
                            //       }) : Container();
                            // },
                            child: tweet(context,twistic),
                          ),
                        )
                      ],
                    );
                  });
            }
          } else if (snapshot.hasError) {
            print("${snapshot.error}");
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blue,
      drawer: drawer(context, _login),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueGrey,
      ),
      body: homeScreen(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const TweetSreen(title: 'Tweet')));
        },

        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.message_rounded),
      ),
    );
  }
}

Widget tweet(BuildContext context, Twistic twistic) {
  double cWidth = MediaQuery.of(context).size.width*0.75;
  return Card(
    elevation: 5,
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            child: Image.network(
              twistic.urlPhoto,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.no_photography);
              },
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              twistic.pseudo,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
                width: cWidth,
                child: Text(twistic.contenu)),
          ],
        ),
      ],
    ),
  );
}
