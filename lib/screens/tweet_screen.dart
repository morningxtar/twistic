
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twistic/database/database.dart';
import 'package:twistic/models/login.dart';
import 'package:twistic/models/twistic.dart';
import 'package:twistic/screens/home_screen.dart';

class TweetSreen extends StatefulWidget {
  final String title;

  @override
  _TweetSreen createState() => _TweetSreen();

  const TweetSreen({Key? key, required this.title}) : super(key: key);
}

class _TweetSreen extends State<TweetSreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  Login _login = Login();
  late SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();
    instancingSharedPref();
  }

  instancingSharedPref() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _login.email = _sharedPreferences.getString('email')!;
      _login.pseudo = _sharedPreferences.getString('pseudo')!;
      _login.urlPhoto = _sharedPreferences.getString('photoUrl')!;
    });
  }

  Widget tweetScreen() {
    return tweetForm();
  }

  Widget tweetForm() {

    Twistic twistic = Twistic(pseudo: _login.pseudo, urlPhoto: _login.urlPhoto);
    print(twistic);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const HomeSreen(
                    title: 'Twistic'))),),
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),

      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: const Color(0xfff5f5f5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            child: Image.network(twistic.urlPhoto,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.no_photography);
                              },),
                          ),
                        ),

                        Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(twistic.pseudo + ' :', style: const TextStyle(color: Colors.lightBlueAccent),),
                                ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxHeight: 300.0,
                                  ),
                                  child: TextFormField(
                                    maxLines: null,
                                    style: const TextStyle(
                                        color: Colors.black, fontFamily: 'SFUIDisplay'),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Champ obligatoire';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      twistic.contenu = value!;
                                    },
                                  ),
                                ),
                              ],
                            ),
                        ),
                      ],
                    ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Builder(
                  builder: (context) => MaterialButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        addTweet(twistic);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeSreen(
                                    title: 'Twistic')));
                      }
                    },
                    child: const Text(
                      'Tweet !',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'SFUIDisplay',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: Colors.blueGrey,
                    elevation: 0,
                    minWidth: 400,
                    height: 50,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey, body: tweetScreen());
  }
}
