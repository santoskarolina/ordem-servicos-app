import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api/user_api.dart';
import '../../models/user.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfile();
}

class _MyProfile extends State<MyProfile> {
  late Future<UserResponse> _userData;

  getFormatedDate(_date) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(_date);
    var outputFormat = DateFormat('dd/MM/yyyy');
    return outputFormat.format(inputDate);
  }

  void userProfile() {
    setState(() {
      _userData = UserService.userProfile();
    });
  }

  @override
  void initState() {
    super.initState();
    userProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        // width: double.maxFinite,
        alignment: Alignment.center,
        child: FutureBuilder<UserResponse>(
          future: _userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  _showContainer(snapshot),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return _fetchData();
          },
        ),
      ),
    );
  }

  Widget _fetchData() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 16,
      backgroundColor: Colors.white,
      child: Container(
        width: 180,
        height: 180,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(
              height: 20,
            ),
            Text('Carregando...')
          ],
        ),
      ),
    );
  }

  Widget nameUser(snapshot) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.black38,
        width: 0.9,
      ))),
      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                  child: Icon(
                    Icons.email_sharp,
                    color: Colors.grey,
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: TextStyle(color: Colors.grey[600], fontSize: 20),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      snapshot!.data.email,
                      style: TextStyle(color: Colors.grey[700], fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget creation_dateUser(snapshot) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.black38,
        width: 0.9,
      ))),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                  child: Icon(
                    Icons.calendar_month,
                    color: Colors.grey,
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data de criação da conta',
                    style: TextStyle(color: Colors.grey[600], fontSize: 20),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      getFormatedDate(snapshot!.data.creation_date),
                      style: TextStyle(color: Colors.grey[700], fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget circleImage(snapshot) {
    return Container(
      width: double.infinity,
      height: 290.0,
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromRGBO(42, 68, 171, 1),
            // Color.fromRGBO(42, 70, 171, 1),
            Color.fromRGBO(42, 170, 171, 1),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 170.0,
              height: 170.0,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(snapshot!.data.photo),
                // backgroundImage: AssetImage('assets/cliente.jpg'),
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            snapshot.data!.user_name,
            style: const TextStyle(color: Colors.white, fontSize: 28),
          ),
          const SizedBox(height: 10),
          Text(
            snapshot.data!.occupation_area,
            style: const TextStyle(color: Colors.white, fontSize: 22),
          )
        ],
      ),
    );
  }

  Widget _showContainer(snapshot) {
    return Container(
      alignment: Alignment.center,
      // padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          circleImage(snapshot),
          nameUser(snapshot),
          creation_dateUser(snapshot)
        ],
      ),
    );
  }
}
