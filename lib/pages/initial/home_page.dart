import 'package:flutter/material.dart';
import 'package:flutter_application_1/api/user_api.dart';
import 'package:flutter_application_1/pages/initial/dashboard_page.dart';
import 'package:flutter_application_1/pages/initial/initial_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';
import '../clients/clientes_page.dart';
import '../services/services_page.dart';
import '../user/profile_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title})
      : super(
          key: key,
        );

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  int _selectedIndex = 1;
  late Future<UserResponse> _userLog;

  clearLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void getUserData() {
    setState(() {
      _userLog = UserService.userProfile();
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color.fromRGBO(42, 68, 171, 1),
      ),
      body: _getDrawerItem(_selectedIndex),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(42, 68, 171, 1),
              ),
              accountName: const Text(
                'Usuário',
                style: TextStyle(fontSize: 20),
              ),
              accountEmail: FutureBuilder<UserResponse>(
                future: _userLog,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data!.user_name,
                      style: const TextStyle(fontSize: 20),
                    );
                  } else if (snapshot.hasError) {
                    "_";
                  }
                  return const CircularProgressIndicator();
                },
              ),
              currentAccountPicture: const CircleAvatar(
                radius: 30.0,
                backgroundImage: AssetImage(
                  'assets/user.jpg',
                ),
                backgroundColor: Colors.transparent,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text(
                "Dashboard",
                style: TextStyle(fontSize: 17),
              ),
              selected: 1 == _selectedIndex,
              trailing: const Icon(Icons.arrow_right),
              onTap: () {
                _onSelectItem(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text(
                "Serviços",
                style: TextStyle(fontSize: 17),
              ),
              selected: 2 == _selectedIndex,
              trailing: const Icon(Icons.arrow_right),
              onTap: () {
                _onSelectItem(2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text(
                "Clientes",
                style: TextStyle(fontSize: 17),
              ),
              selected: 3 == _selectedIndex,
              trailing: const Icon(Icons.arrow_right),
              onTap: () {
                _onSelectItem(3);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(
                "Meu perfil",
                style: TextStyle(fontSize: 17),
              ),
              selected: 4 == _selectedIndex,
              trailing: const Icon(Icons.arrow_right),
              onTap: () {
                _onSelectItem(4);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                "Sair",
                style: TextStyle(fontSize: 17),
              ),
              trailing: const Icon(Icons.arrow_right),
              onTap: () {
                setState(() {
                  clearLocalStorage();
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InitialPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _getDrawerItem(int pos) {
    switch (pos) {
      case 1:
        return const Dashboard();
      case 2:
        return const ServicesPage();
      case 3:
        return const CLientesPage();
      case 4:
        return const MyProfile();
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedIndex = index);
    Navigator.of(context).pop();
  }
}
