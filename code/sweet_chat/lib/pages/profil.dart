import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sweet_chat/auth_service.dart';
import 'package:sweet_chat/theme.dart';
import 'package:sweet_chat/utils/loading/src2/four_rotating_dots/four_rotating_dots.dart';

import '../utils/loading/loading_overlay_pro.dart';
import 'package:sweet_chat/biblio/countries/countries.dart';
import 'package:sweet_chat/utils/decoration.dart';
import 'package:sweet_chat/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sweet_chat/utils/custom.dart';
// import 'package:icons_plus/icons_plus.dart';
// import 'package:show_up_animation/show_up_animation.dart';
// import 'package:sweet_chat/utils/widgets.dart';

// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class UserProfil extends StatefulWidget {
  const UserProfil({super.key});

  @override
  State<UserProfil> createState() => _UserProfilState();
}

class _UserProfilState extends State<UserProfil> {
  TextEditingController namectrl = TextEditingController();
  TextEditingController bioctrl = TextEditingController();
  TextEditingController adressctrl = TextEditingController();
  TextEditingController numctrl = TextEditingController();
  TextEditingController mailctrl = TextEditingController();
  TextEditingController fbctrl = TextEditingController();
  TextEditingController linctrl = TextEditingController();
  TextEditingController instctrl = TextEditingController();
  int status = 1;

  // Stream<DocumentSnapshot<Map<String, dynamic>>> mainStream = FirebaseFirestore
  //     .instance
  //     .collection('user')
  //     .doc(connectedUser.profile.id)
  //     .snapshots();

  // Contacter
  final keyform = GlobalKey<FormState>();

  bool loading = false;
  var phcode;
  late Country country;
  FirebaseFirestore fins = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    setState(() {
      namectrl.text = connectedUser.profile.name;
      bioctrl.text = connectedUser.profile.bio;
      adressctrl.text = connectedUser.profile.adress;
      mailctrl.text = connectedUser.profile.email;
      numctrl.text = connectedUser.profile.numero;
      fbctrl.text = connectedUser.profile.facebook;
      instctrl.text = connectedUser.profile.instagram;
      linctrl.text = connectedUser.profile.linkedin;
      phcode = connectedUser.profile.countcode;
      if (phcode.isNotEmpty) {
        country = countryList.firstWhere(
          (c) => c.phoneCode == phcode,
        );
      }
    });

    // mainStream.listen(
    //   onDone: () {
    //     print('finished Listening');
    //   },
    //   (event) {
    //     // chargementUser();
    //     setState(() {});
    //   },
    // );
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
            'Profil',
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
                                top: 20, left: 15, right: 15),
                            // height: MediaQuery.of(context).size.height*0.850,
                            child: content()),
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
    return Column(
      children: [
        Column(
          children: [
            // Profil
            //
            //
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Positioned(
                      child: Container(
                        alignment: Alignment.center,
                        height: 205,
                        width: 205,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: Border.all(
                                color: connectedUser.stories.isNotEmpty
                                    ? theme.dred1
                                    : Colors.grey,
                                width: 3)),
                        padding: EdgeInsets.all(2),
                        child: connectedUser.profile.img.isEmpty
                            ? Container(
                                // margin: EdgeInsets.only(left: 10),
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.dred1,
                                ),
                                // padding: EdgeInsets.all(80),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      connectedUser.profile.name
                                                  .split(' ')
                                                  .length >
                                              2
                                          ? connectedUser.profile.name
                                              .split(' ')[0][0]
                                          : connectedUser.profile.name
                                              .substring(0, 1),
                                      style: wtTitle(
                                          80, 1, Colors.white, true, false),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      connectedUser.profile.name
                                                  .split(' ')
                                                  .length >
                                              2
                                          ? connectedUser.profile.name
                                              .split(' ')[1][0]
                                          : connectedUser.profile.name
                                              .substring(1, 2),
                                      style: wtTitle(
                                          130, 1, Colors.white, true, false),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ))
                            :

                            // Container(
                            //     margin: EdgeInsets.only(left: 10),
                            //     height: 200,
                            //     width: 200,
                            //     decoration: BoxDecoration(
                            //         shape: BoxShape.circle,
                            //         color: theme.dred1,
                            //         image: DecorationImage(
                            //             image: NetworkImage(
                            //                 connectedUser.profile.img)
                            //                 )),
                            //   )

                            ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Pour des coins arrondis (facultatif)
                                  child: Image.network(
                                    connectedUser.profile.img,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        // Si l'image est complètement chargée, on l'affiche directement
                                        return child;
                                      }
                                      // Pendant le chargement, on affiche un indicateur de chargement
                                      return Center(
                                          child: FourRotatingDots(
                                              color: Colors.black, size: 100)
                                          // CircularProgressIndicator(
                                          //   value: loadingProgress.expectedTotalBytes != null
                                          //       ? loadingProgress.cumulativeBytesLoaded /
                                          //           (loadingProgress.expectedTotalBytes ?? 1)
                                          //       : null,
                                          // ),
                                          );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      // Si l'image ne peut pas être chargée, afficher l'image par défaut depuis le backend
                                      return Container(
                                          height: 65,
                                          width: 65,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: theme.dred22,
                                          ),
                                          // padding: EdgeInsets.all(80),
                                          child: Icon(
                                            Icons.person,
                                            size: 50,
                                            color: Colors.white,
                                          ));
                                    },
                                  ),
                                )),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 30,
                        child: InkWell(
                          onTap: () async {
                            //

                            final f = await selectFile();

                            if (f != null) {
                              setState(() {
                                loading = true;
                              });
                              String id = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();
                              String url = await uploadFile(f!.path, id);
                              print("Lien fiak !: $url");
                              await fins
                                  .collection('profile')
                                  .doc(connectedUser.profile.id)
                                  .update({
                                'img': url,
                              });
                              print('susccess');
                              // Reload
                await chargementUser();
                
                              setState(() {
                                loading = false;
                              });
                            } //
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.dred4,
                                border: Border.all(color: Colors.black)),
                            padding: EdgeInsets.all(5),
                            child:
                                // Container(
                                //   decoration: BoxDecoration(
                                //       shape: BoxShape.circle,
                                //       color: Colors.greenAccent),
                                // )
                                const Icon(
                              Icons.cameraswitch_outlined,
                              color: Colors.black,
                              size: 25,
                            ),
                          ),
                        ))
                  ],
                ),
                // */
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                   connectedUser.profile.dateins.isEmpty ? '' : 'Sweet Chat user since ${connectedUser.profile.dateins}',
                    style: wtTitle(15, 1, Colors.black, true, false),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),

            //

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Row(
                children: [
                  Text(
                    'Identity',
                    style: wtTitle(22, 1, Colors.black, true, false),
                  ),
                ],
              ),
            ),
            //
            // Name
            ListTile(
              onTap: () {
                //
              },
              leading: Container(
                // height: 90, width: 90,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.dred3)),
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.person_outlined,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              title: Text(
                "Name",
                style: wtTitle(18, 1, Colors.black, true, false),
              ),
              subtitle: TextFormField(
                  controller: namectrl,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Field Required !';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: 'John Doe',
                      isCollapsed: true,
                      suffix: Icon(
                        Icons.edit,
                        size: 22,
                      ),
                      border: InputBorder.none)),
              selectedTileColor: theme.dred1,
            ),
            //
            // Bio
            ListTile(
              onTap: () {
                //
              },
              leading: Container(
                // height: 90, width: 90,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.dred3)),
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.description_outlined,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              title: Text(
                "Bio",
                style: wtTitle(18, 1, Colors.black, true, false),
              ),
              subtitle: TextFormField(
                  controller: bioctrl,
                  minLines: 1,
                  maxLines: 2,
                  maxLength: 200,
                  decoration: InputDecoration(
                      hintText: 'FullStack Dev ...',
                      isCollapsed: true,
                      suffix: Icon(
                        Icons.edit,
                        size: 22,
                      ),
                      border: InputBorder.none)),
              selectedTileColor: theme.dred1,
            ),

            // Adress
            ListTile(
              onTap: () {
                //
              },
              leading: Container(
                // height: 90, width: 90,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.dred3)),
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.location_on_outlined,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              title: Text(
                "Adress",
                style: wtTitle(18, 1, Colors.black, true, false),
              ),
              subtitle: TextFormField(
                  controller: adressctrl,
                  minLines: 1,
                  decoration: InputDecoration(
                      hintText: 'Cotonou Bénin ...',
                      isCollapsed: true,
                      suffix: Icon(
                        Icons.edit,
                        size: 22,
                      ),
                      border: InputBorder.none)),
              selectedTileColor: theme.dred1,
            ),

            // Contacts
            //
            SizedBox(
              height: 15,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Row(
                children: [
                  Text(
                    'Contacts',
                    style: wtTitle(22, 1, Colors.black, true, false),
                  ),
                ],
              ),
            ),
            //
            // Mail
            ListTile(
              onTap: () {
                //
              },
              leading: Container(
                // height: 90, width: 90,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.dred3)),
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.mail_outlined,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              title: Text(
                "Mail",
                style: wtTitle(18, 1, Colors.black, true, false),
              ),
              subtitle: TextFormField(
                controller: mailctrl,
                minLines: 1,
                enabled: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Field Required !';
                  } else if (emailRegex.hasMatch(value) == false) {
                    return 'Invalid Format !';
                  }
                  return null;
                },
                decoration:
                    InputDecoration.collapsed(hintText: 'johndoe@gmail.com'),
              ),
              selectedTileColor: theme.dred1,
            ),
            // Number
            ListTile(
              onTap: () {
                //

                customDiag(context, countryDiag());
              },
              leading: phcode.isEmpty
                  ? Container(
                      // height: 25,
                      // width: 25,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.dred3)),
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.flag_outlined,
                        color: Colors.black,
                        size: 20,
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(5),
                      decoration: phcode.isNotEmpty
                          ? BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 3, color: Colors.green))
                          : BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 3,
                                  color:
                                      const Color.fromARGB(42, 76, 175, 79))),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            8.0), // Pour des coins arrondis (facultatif)
                        child: Image.asset(
                          CountryPickerUtils.getFlagImageAssetPath(
                              country.iso3Code),
                          width: 25.0,
                          height: 25.0,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Si l'image ne peut pas être chargée, afficher l'image par défaut depuis le backend
                            return Container(
                              // height: 25,
                              // width: 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              // padding: EdgeInsets.all(80),
                              child: Icon(
                                Icons.flag_outlined,
                                color: Colors.black,
                                size: 20,
                              ),
                            );
                          },
                        ),
                      )

                      //  Container(
                      //   height: 25,
                      //   width: 25,
                      //   child: CountryPickerUtils.getDefaultFlagImage(country),
                      //   // decoration: BoxDecoration(
                      //   //     shape: BoxShape.circle,
                      //   //     image: DecorationImage(
                      //   //       image: AssetImage(
                      //   //        CountryPickerUtils.getFlagImageAssetPath(country.iso3Code)  ,
                      //   //       ),
                      //   //       fit: BoxFit.cover,
                      //   //     )),
                      // )

                      ),
              title: Text(
                "Phone Number",
                style: wtTitle(18, 1, Colors.black, true, false),
              ),
              subtitle: TextFormField(
                  controller: numctrl,
                  keyboardType: TextInputType.number,
                  // minLines: 1,
                  decoration: InputDecoration(
                      prefix: Text("+ ($phcode)  |  "),
                      isCollapsed: true,
                      hintText: '0140170107...',
                      border: InputBorder.none)),
              selectedTileColor: theme.dred1,
            ),

            // Facebook
            ListTile(
              onTap: () {
                //
              },
              leading: Container(
                // height: 90, width: 90,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.dred3)),
                padding: EdgeInsets.all(5),
                child: Icon(
                  BoxIcons.bxl_facebook,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              title: Text(
                "Facebook",
                style: wtTitle(18, 1, Colors.black, true, false),
              ),
              subtitle: TextFormField(
                controller: fbctrl,
                minLines: 1,
                validator: (value) {
                  if (value!.isNotEmpty && fbkRegex.hasMatch(value) == false) {
                    return 'Invalid Format !';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: 'https://faceb...',
                    isCollapsed: true,
                    suffix: Icon(
                      Icons.edit,
                      size: 22,
                    ),
                    border: InputBorder.none),
              ),
              selectedTileColor: theme.dred1,
            ),
            // LinkedIn
            ListTile(
              onTap: () {
                //
              },
              leading: Container(
                // height: 90, width: 90,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.dred3)),
                padding: EdgeInsets.all(5),
                child: Icon(
                  BoxIcons.bxl_linkedin,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              title: Text(
                "LinkedIn",
                style: wtTitle(18, 1, Colors.black, true, false),
              ),
              subtitle: TextFormField(
                controller: linctrl,
                minLines: 1,
                validator: (value) {
                  if (value!.isNotEmpty && linRegex.hasMatch(value) == false) {
                    return 'Invalid Format !';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: 'https://link...',
                    isCollapsed: true,
                    suffix: Icon(
                      Icons.edit,
                      size: 22,
                    ),
                    border: InputBorder.none),
              ),
              selectedTileColor: theme.dred1,
            ),
            // Instagram
            ListTile(
              onTap: () {
                //
              },
              leading: Container(
                // height: 90, width: 90,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.dred3)),
                padding: EdgeInsets.all(5),
                child: Icon(
                  BoxIcons.bxl_instagram,
                  color: Colors.black,
                  size: 20,
                ),
              ),
              title: Text(
                "Instagram",
                style: wtTitle(18, 1, Colors.black, true, false),
              ),
              subtitle: TextFormField(
                controller: instctrl,
                minLines: 1,
                validator: (value) {
                  if (value!.isNotEmpty &&
                      instaRegex.hasMatch(value) == false) {
                    return 'Invalid Format !';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: 'https://insta...',
                    isCollapsed: true,
                    suffix: Icon(
                      Icons.edit,
                      size: 22,
                    ),
                    border: InputBorder.none),
              ),
              selectedTileColor: theme.dred1,
            ),

            SizedBox(
              height: 15,
            ),

            Padding(
                padding: const EdgeInsets.only(top: 25),
                child: customButton(
                    theme.dred1,
                    Text(
                      'Save Changes',
                      style: wtTitle(16, 1, theme.dred4, true, false),
                    ),
                    15, () {
                  //
                  if (keyform.currentState!.validate()) {
                    // ok enregistrer et recharger profile
                    customDiag(context, confirmDiag());
                  }
                }, -1, cp: EdgeInsets.symmetric(horizontal: 40, vertical: 15))),

            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ],
    );
  }

//
  //
  //

  Widget countryDiag() {
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
              "Choose Your Country",
              style: wtTitle(18, 1, Colors.black, true, false),
              textAlign: TextAlign.center,
            ),
          ),
          // Icons
          SizedBox(
            height: 15,
          ),
          // Texte2
          Column(
            children: countryList.map(
              (e) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      country = e;
                      phcode = e.phoneCode;
                      print(CountryPickerUtils.getFlagImageAssetPath(
                          country.iso3Code));
                      fermer(context);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: buildDropdownItemForCountry(e),
                  ),
                );
              },
            ).toList(),
          ),
          //

          // Boutons
          SizedBox(
            height: 8,
          ),
        ],
      );
    });
  }

  Widget infoDiag() {
    //
    String ttle = '', txt = '';
    Widget? icon;

    if (status == 0) {
      ttle = 'Votre Compte est désactivé';
      txt = 'Désolé Ohh !';
      icon = Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                Border.all(color: Color.fromARGB(136, 195, 74, 74), width: 15)),
        child: Icon(
          Icons.info_outline_rounded,
          color: Colors.redAccent,
          size: 150,
        ),
      );
    }
    if (status == 1) {
      ttle = 'Votre Compte est activé';
      txt =
          'Les Employeur pourront désormais vous retrouver pour tous vos domaines validés.'; // sur la plateforme et possiblement vous contacter pour bénéficier de vos prestations.\nBon Travail !';
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
    }

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
          }, -1, cp: EdgeInsets.symmetric(horizontal: 40, vertical: 10))
        ],
      );
    });
  }

  Widget confirmDiag() {
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
              'Are you sure to save changes ? ',
              style: wtTitle(18, 1, Colors.black, true, false),
              textAlign: TextAlign.center,
            ),
          ),
          // Icons
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Color.fromARGB(135, 74, 78, 195), width: 15)),
            child: Icon(
              Icons.question_mark_outlined,
              color: const Color.fromARGB(255, 94, 82, 255),
              size: 100,
            ),
          ),
          // Texte2
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Actual Datas will be the new ones !',
              style: wtTitle(16, 1, Colors.black, true, false),
              textAlign: TextAlign.center,
            ),
          ),
          //

          // Boutons
          SizedBox(
            height: 8,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              customButton(
                  theme.dred1,
                  Text(
                    'Cancel',
                    style: wtTitle(18, 1, theme.dred4, true, false),
                  ),
                  15, () {
                //

                fermer(context);
              }, -1, cp: EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
              //
              customButton(
                  theme.dred1,
                  Text(
                    'Confirm',
                    style: wtTitle(18, 1, theme.dred4, true, false),
                  ),
                  15, () async {
                //
                setState(() {
                  loading = true;
                });

//
                if (namectrl.text.isNotEmpty) {
                  print('updating');
                  await fins
                      .collection('profile')
                      .doc(connectedUser.profile.id)
                      .update({
                    'name': namectrl.text,
                  });
                }
                //
                // **** Même chose pour les autres champs ***
                if (bioctrl.text.isNotEmpty) {
                  print('updating');
                  await fins
                      .collection('profile')
                      .doc(connectedUser.profile.id)
                      .update({
                    'bio': bioctrl.text,
                  });
                }
                // 
                if (adressctrl.text.isNotEmpty) {
                  print('updating');
                  await fins
                      .collection('profile')
                      .doc(connectedUser.profile.id)
                      .update({
                    'adress': adressctrl.text,
                  });
                }
                // 
                if (numctrl.text.isNotEmpty) {
                  print('updating');
                  await fins
                      .collection('profile')
                      .doc(connectedUser.profile.id)
                      .update({
                    'numero': numctrl.text,
                    'countcode' : phcode
                  });
                }
                // 
                if (fbctrl.text.isNotEmpty) {
                  print('updating');
                  await fins
                      .collection('profile')
                      .doc(connectedUser.profile.id)
                      .update({
                    'facebook': fbctrl.text,
                  });
                }
                // 
                if (linctrl.text.isNotEmpty) {
                  print('updating');
                  await fins
                      .collection('profile')
                      .doc(connectedUser.profile.id)
                      .update({
                    'linkedin': linctrl.text,
                  });
                }
                //
                if (instctrl.text.isNotEmpty) {
                  print('updating');
                  await fins
                      .collection('profile')
                      .doc(connectedUser.profile.id)
                      .update({
                    'instagram': instctrl.text,
                  });
                }
                //  Enregistrer au moins 1 selected

                // Reload
                await chargementUser();

                setState(() {
                  loading = false;
                });
                setStatex(() {
                  fermer(context);
                });
              }, -1, cp: EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
            ],
          )
        ],
      );
    });
  }

  //
  /*    void _selectFile() async {
    //
    setState(() {
      loading = true;
    });
    var bytes;
    //
    final file = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
      allowMultiple: false,
    );
    if (file != null) {
      setState(() {
        // final file1 = file.files.single;
        // String filename = file1.name;
        bytes = file.files.single.bytes;
        var typfich = file.files.single.extension!;
        print('uploading');
        _uploadFile(typfich, bytes);
      });
    }
    setState(() {
      loading = false;
    });
  }

  void _uploadFile( var typfich, var bytes) async {
    String lienfinal = '';
    try {
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(bytes,
            filename: 'user__.$typfich')
      });

      Response response = await Dio()
          .post("$urlserveur/upload.php", data: formData, queryParameters: {
        "chemin": "upload/user_${connectedUser.profile.id}/pics/",
      });
      // print(response.statusCode);
      if (response.statusCode == 200) {
        print("File upload response: $response");
        var datainfo = json.decode(response.data);
        // print(datainfo);
        if (datainfo["status"] == true) {
          setState(() {
            lienfinal =
                "upload/user_${connectedUser.profile.id}/pics/dom_.$typfich";
            print("chemin: $urlserveur/$lienfinal");

            //
          });

          //
          // Enregistrer le lien dans la base de données

          var url2 = "$urlserveur/domaines.php";
          Dio dio = Dio();
          var fromdata = FormData.fromMap({
            'vartraitement': '3',
            'iduser': connectedUser.profile.id,
            'iddom': e.id,
            'img': lienfinal,
          });
          Response response = await dio.post(url2, data: fromdata);
          print(response.data);

          if (response.statusCode == 200) {
            var resultat = json.decode(response.data);
            // print(resultat);
            if (resultat == true) {
              // connectedUser.dom
              //           .firstWhere((d) =>
              //               d.id == iddom ).services.clear();

              await chargement();

              setState(() {
                // isLoaded = false;
                if (uploadcount < 9) {
                  uploadcount++;
                } else {
                  uploadcount = 0;
                }
              });
              print('succes fin');
            } else {
              print('echec');
            }
          } else {
            // isLoaded = false;
            print('echec total');
          }

          //
          //

          //
        }
      }

      //_showSnackBarMsg(response.data['message']);
    } catch (e) {
      print("expectation Caugch: $e");
    }
    //

    //
  }
 */
  //
}
