import 'package:flutter/material.dart';
import 'package:twistic/models/login.dart';
import 'package:twistic/services/services.dart';
import 'login_screen.dart';


Widget drawer(BuildContext context, Login login) {
  return SizedBox(
    width: 300,
    child: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blueGrey,
            ),
            accountEmail: Text(login.email),
            accountName: Text(login.pseudo),

            currentAccountPicture:  Image.network(login.urlPhoto,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.no_photography);
              },),
          ),
          Visibility(
            visible: true,
            child: ListTile(
              title: const Text(
                'Déconnexion',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                    color: Color.fromRGBO(75, 75, 75, 0.8)),
              ),
              onTap: () {
                logout(context);
              },
              leading: const Icon(
                Icons.subdirectory_arrow_left,
                color: Color.fromRGBO(71, 71, 70, 0.8),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

logout(BuildContext context) async {
  logoutApp();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginSreen(title: 'Login',)),
  );
}