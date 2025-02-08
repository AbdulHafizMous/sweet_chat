import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sweet_chat/theme.dart';
import '../utils/loading/loading_overlay_pro.dart';
import 'package:sweet_chat/utils/custom.dart';
import 'package:sweet_chat/utils/decoration.dart';
import 'package:sweet_chat/utils/widgets.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  bool loading = false;
  final keyform = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayPro(
      isLoading: loading,
      progressIndicator: loadingAnimation(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'About Us',
            style: wtTitle(26, 1, theme.dred3, true, false),
          ),
          elevation: 0,
          backgroundColor: theme.dred2,
        ),
        body: SingleChildScrollView(
          // controller: 0
          child: Stack(
            children: [
              Container(
                height: 100,
                color: theme.dred2,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                child: Center(
                  child: Form(
                    key: keyform,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 30, left: 15, right: 15),
                          // height: MediaQuery.of(context).size.height*0.850,
                          child: content() ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  Widget content() {
    return Column(children: [
     
      //
      Text(
                          'Development Team !',
                          style: wtTitle(25, 1, theme.dred1, true, false),
                        ),
        
                        
      
      SizedBox(
        height: 8,
      ),
        
      // Cards
      //

      Text(
              "GROUPE 5 - ENEAM - 2025",
              style: TextStyle(
                fontSize: 16,
                // fontWeight: FontWeight.bold,
                color: Color(0xFFEE5366),
              ),
            ),

            SizedBox(
        height: 8,
      ),
           
            SizedBox(height: 380,
              
                child: ListView(
                  children: [
                    DeveloperCard(name: "MOUSTAPHA Hafiz", role: "Développeur", icon: FontAwesome.user_tie_solid),
                    DeveloperCard(name: "GODJO Jordy", role: "Développeur", icon: FontAwesome.laptop_code_solid),
                    DeveloperCard(name: "HOUNKPATIN Estelle", role: "Développeuse", icon: FontAwesome.paintbrush_solid),
                    DeveloperCard(name: "ALOFA Expéro", role: "Développeur", icon: FontAwesome.database_solid),
                    DeveloperCard(name: "DJIWANOU Prielle", role: "Développeuse", icon: FontAwesome.mobile_solid),
                  ],
                ),
              
            ),
            SizedBox(height: 15),
            Text(
              "A propos de Sweet Chat",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFEE5366),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Sweet Chat est une plateforme de messagerie instantanée conçue pour offrir une expérience fluide et immersive. Grɛce à son interface élégante et intuitive, elle permet des conversations rapides et sécurisées avec vos proches. Profitez d'une communication sans interruption avec un chiffrement avancé et des fonctionnalités innovantes telles que les discussions de groupe, les réactions aux messages et bien plus encore.",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          
    




      // 
     
       
       ]);
  }

   Widget infoDiag() {
    //
    String ttle = '', txt = '';
    Widget? icon;

    ttle = 'Merci !' ;
      txt = 'Note bien enregistrée.';// sur la plateforme et possiblement vous contacter pour bénéficier de vos prestations.\nBon Travail !';
      icon = Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: const Color.fromARGB(137, 139, 195, 74), width: 15)),
            child: Icon(
              Icons.check_circle_outline_outlined,
              color: Colors.green,
              size: 150,
            ),
          );
   

    //
    return StatefulBuilder(builder: (context, setStatex) {

      return Column(
        children: [
          //
          // Close
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  
                  fermer(context);
                  fermer(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.dred1,
                      )),
                  child: Icon(
                    Icons.close,
                    color: theme.dred1,
                  ),
                ),
              ),
            ],
          ),
          //
          // Title
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              ttle,
              style: wtTitle(18, 1, Colors.black, true, false),
              textAlign: TextAlign.center,
            ),
          ),
          // Icons
          icon!,
          // Texte2
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              txt,
              style: wtTitle(16, 1, Colors.black, true, false),
              textAlign: TextAlign.center,
            ),
          ),
          //
          
          // Boutons
          SizedBox(
            height: 8,
          ),
          
           customButton(
              theme.dred1,
              Text(
                'Ok',
                style: wtTitle(18, 1, theme.dred4, true, false),
              ),
              15, () {
            //
            fermer(context);
            fermer(context);
          }, -1, cp: EdgeInsets.symmetric(horizontal: 40, vertical: 10))
        ],
      );
    });
  }


}


class DeveloperCard extends StatelessWidget {
  final String name;
  final String role;
  // final List<String> contributions;
  final IconData icon;

  DeveloperCard({required this.name, required this.role, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Color(0xFFEE5366)),
                SizedBox(width: 10),
                Text(
                  name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              role,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey[700]),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // children: contributions.map((c) => Text("? $c")).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
