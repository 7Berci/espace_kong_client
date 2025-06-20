import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espace_kong/auth_folder/enter_number.dart';
import 'package:espace_kong/home_folder/home.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../auth_folder/auth_page.dart';
import '../auth_folder/function.dart';
import 'about_us.dart';

class MyNavigationDrawer extends StatefulWidget {
  const MyNavigationDrawer({super.key});

  @override
  State<MyNavigationDrawer> createState() => _MyNavigationDrawerState();
}

class _MyNavigationDrawerState extends State<MyNavigationDrawer> {
  String? phone;
  String? lienplaystore;

  @override
  void initState() {
    super.initState();
    fetchftkFile();
  }

  Future<void> fetchftkFile() async {
    // Suppose que tu as un seul document dans la collection 'ftkcontact'
    final snapshot =
        await FirebaseFirestore.instance.collection('ftk_files').limit(1).get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        phone = snapshot.docs.first['phone'];
        lienplaystore = snapshot.docs.first['lienplaystore'];
      });
    }
  }

  void callUs() {
    if (phone != null) {
      launchUrl(Uri.parse("tel://$phone"));
    }
  }

  @override
  Widget build(BuildContext context) => Drawer(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[buildHeader(context), buildMenuItems(context)],
      ),
    ),
  );

  Widget buildHeader(BuildContext context) => Material(
    color: ftkColor,
    child: InkWell(
      onTap: () {
        //Navigator.pop(context);
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => EnterNumber()));
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 24 + MediaQuery.of(context).padding.top,
          bottom: 24,
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 52,
              child: Image.asset('assets/images/profile.png'),
              //   backgroundImage: NetworkImage(
              //       'https://scontent.fabj3-1.fna.fbcdn.net/v/t39.30808-6/273582338_4350604611707023_8961482379211974165_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=_loKFW11z_wAX_WA10T&_nc_ht=scontent.fabj3-1.fna&oh=00_AT_XCaxzAaLAsBe47Y7duG3hTOzoNCk4XBbeJ_rTss1paA&oe=62F58C1F'),
            ),
            const SizedBox(height: 12),
            // Text(
            //   'Berci Djélé',
            //   style: const TextStyle(fontSize: 28, color: Colors.white),
            // ),
            Text(
              // ignore: prefer_interpolation_to_compose_strings
              "" + (user?.phoneNumber ?? ""), //i could put text in first quotes
              // 'aaronberci@yahoo.fr', //if that was the email printed
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              user?.email ?? "",
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    ),
  );

  Widget buildMenuItems(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    child: Wrap(
      runSpacing: 16, //vertical spacing
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Modifier mes informations'),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => EnterNumber()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.ios_share_rounded),
          title: const Text('Inviter un ami à Pressing FTK'),
          onTap: () => Share.share('download fromplaystore $lienplaystore'),
        ),
        ListTile(
          leading: const Icon(Icons.call),
          title: const Text('Appeler le service client'),
          onTap: callUs,
        ),
        ListTile(
          leading: const Icon(Icons.shopping_cart),
          title: const Text('Passer une commande'),
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Home()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Qui sommes-nous ?'),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => const AboutUs()));
          },
        ),
        const Divider(color: Colors.black12),
        ListTile(
          leading: const Icon(Icons.output_rounded),
          title: const Text('Se déconnecter'),
          onTap: () async {
            // final prefs = await SharedPreferences.getInstance();
            // prefs.setBool('showHome', false);
            await logOut();
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (builder) => const AuthPage()),
            );
          },
        ),
      ],
    ),
  );
}

Widget toShowPicture(String image) {
  return Container(
    width: 40.0,
    height: 40.0,
    decoration: BoxDecoration(
      color: ftkColor,
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Center(
      child: Container(
        width: 38.0,
        height: 38.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.scaleDown,
            image: AssetImage(image),
          ),
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
    ),
  );
}
