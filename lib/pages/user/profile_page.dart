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
        alignment: Alignment.center,
        child: FutureBuilder<UserResponse>(
          future: _userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  _showContainer(snapshot),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return _loadingDialog();
          },
        ),
      ),
    );
  }

  Widget _showCard(snapshot) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // showImage()
            ListTile(
              title: const Text("Nome"),
              subtitle: Text(snapshot.data!.user_name ?? 'Não defino'),
            ),
            ListTile(
              title: const Text("Email"),
              subtitle: Text(snapshot.data!.email),
            ),
            ListTile(
              title: const Text("Data de criação da conta"),
              subtitle: Text(getFormatedDate(snapshot.data!.creation_date)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadingDialog() {
    return AlertDialog(
      content: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: CircularProgressIndicator(),
          ),
          // const CircularProgressIndicator(),
          const Text('Processando...'),
        ],
      ),
    );
  }

  
Widget circleImage(snapshot) {
    return Center(
      child : Container(
      width: 190.0,
      height: 190.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(snapshot!.data.photo)
            )
        ),
     ),
   );
  } 

  Widget _showContainer(snapshot) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [circleImage(snapshot), _showCard(snapshot)],
      ),
    );
  }
}