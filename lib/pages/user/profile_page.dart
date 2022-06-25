import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api/user_api.dart';
import '../../models/user.dart';
import '../../models/user_model.dart';
import '../utils/constantes.dart';
import 'package:select_dialog/select_dialog.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfile();
}

class _MyProfile extends State<MyProfile> {
  late Future<UserResponse> _userData;

  UserUpdatePhotoDto? userUpdatePhotoDto;
  bool _isLoading = false;
  int userId = 0;
  String? userPhoto;

  getFormatedDate(_date) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(_date);
    var outputFormat = DateFormat('dd/MM/yyyy');
    return outputFormat.format(inputDate);
  }

  void udpateUserPhoto(String photo) async {
    setState(() {
      _isLoading = true;
    });
    UserUpdatePhotoDto userRequest = UserUpdatePhotoDto();

    var response = await UserService.updateUserPhoto(userRequest, userId);
    print(response?.body);
    if (response?.statusCode == 201) {
      setState(() {
        _isLoading = false;
      });
      _showDialog('Foto atualizada com sucesso', '', false);
    } else if (response?.statusCode == 401) {
      setState(() {
        _isLoading = false;
      });
      _showDialog('Usuário e/ou senha incorretos',
          'Informe os dados corretamente', false);
    } else {
      print(response?.body);
      setState(() {
        _isLoading = false;
      });
      _showDialog('Não foi possível fazer o login',
          'Tente novamente mais tarde', false);
    }
  }

  void _showDialog(String title, String subtitle, bool success) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (BuildContext context) {
          return SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 20),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 8.2),
                    child: Text(
                      subtitle,
                      style:
                          const TextStyle(fontSize: 17, color: Colors.black54),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    genericButton(context),
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget genericButton(context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
        child: SizedBox(
          height: 55.0,
          child: TextButton(
            onPressed: () {
              setState(() {
                userProfile();
              });
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
                backgroundColor: const Color.fromRGBO(11, 122, 222, 1),
                fixedSize: const Size(150, 100),
                primary: Colors.blue[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            child: const Text(
              'Certo',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ));
  }

  List<UserAvatar> items = [
    UserAvatar(
        id: '1',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-01.png',
        photoName: 'Avatar 01'),
    UserAvatar(
        id: '2',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-02.png',
        photoName: 'Avatar 02'),
    UserAvatar(
        id: '3',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-03.png',
        photoName: 'Avatar 03'),
    UserAvatar(
        id: '4',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-04.png',
        photoName: 'Avatar 04'),
    UserAvatar(
        id: '5',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-05.png',
        photoName: 'Avatar 05'),
    UserAvatar(
        id: '6',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-06.png',
        photoName: 'Avatar 06'),
    UserAvatar(
        id: '7',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-07.png',
        photoName: 'Avatar 07'),
    UserAvatar(
        id: '8',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-08.png',
        photoName: 'Avatar 08'),
    UserAvatar(
        id: '9',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-09.png',
        photoName: 'Avatar 09'),
    UserAvatar(
        id: '10',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-10.png',
        photoName: 'Avatar 10'),
    UserAvatar(
        id: '11',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-11.png',
        photoName: 'Avatar 11'),
    UserAvatar(
        id: '12',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-12.png',
        photoName: 'Avatar 12'),
  ];

  void userProfile() async {
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
      height: 300.0,
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
          buttonPickAvatar(snapshot),
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

  Widget buttonPickAvatar(snapshot) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 9.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  SelectDialog.showModal<dynamic>(
                    context,
                    label: "Atualizar avatar",
                    items: items,
                    selectedValue: userUpdatePhotoDto,
                    itemBuilder: (context, dynamic item, bool isSelected) {
                      return Container(
                        decoration: !isSelected
                            ? null
                            : BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                border: Border.all(
                                    color: Theme.of(context).primaryColor),
                              ),
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundImage: item.photoUrl == null
                                  ? null
                                  : NetworkImage(item.photoUrl)),
                          selected: isSelected,
                          title: Text(item.photoName),
                          // subtitle: Text(item.photoName.toString()),
                        ),
                      );
                    },
                    onChange: (selected) async {
                      UserAvatar user = selected;
                      setState(() {
                        userPhoto = user.photoUrl;
                        // udpateUserPhoto(userPhoto!);
                      });
                    },
                  );
                },
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: MyCustomColors.hexColorCircleAvatar,
                  child: ClipOval(
                    child: Image.network(
                      snapshot!.data.photo,
                    ),
                  ),
                )),
          ],
        ));
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
