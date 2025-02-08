import 'package:icons_plus/icons_plus.dart';
import 'package:sweet_chat/theme.dart';
import 'package:sweet_chat/utils/loading/src2/four_rotating_dots/four_rotating_dots.dart';
import 'package:sweet_chat/utils/urls.dart';

import '../utils/loading/loading_overlay_pro.dart';
import 'package:sweet_chat/utils/classlist.dart';
import 'package:sweet_chat/utils/decoration.dart';
import 'package:sweet_chat/utils/widgets.dart';
import 'package:flutter/material.dart';
// import 'package:icons_plus/icons_plus.dart';
// import 'package:show_up_animation/show_up_animation.dart';
// import 'package:sweet_chat/utils/widgets.dart';

// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnyUserProfil extends StatefulWidget {
  const AnyUserProfil({super.key, required this.user});
  final User user;

  @override
  State<AnyUserProfil> createState() => _AnyUserProfilState();
}

class _AnyUserProfilState extends State<AnyUserProfil> {


  bool loading = false;

  Future<void> chargement() async {
    //
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(seconds: 5));
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
    
    });
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
            ],
          ),
        ),
      ),
    );
  }

  Widget content() {
    return Column(
      children: [
      
        //
        //
        Column(
          children: [
            // Profil
            //
            //
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      child: Container(
                        height: 205,
                        width: 205,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: Border.all(
                                color: widget.user.stories.isNotEmpty
                                    ? theme.dred1
                                    : Colors.grey,
                                width: 3)),
                        padding: EdgeInsets.all(2),
                        child: widget.user.profile.img.isEmpty
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
                                      widget.user.profile.name
                                                  .split(' ')
                                                  .length >
                                              2
                                          ? widget.user.profile.name
                                              .split(' ')[0][0]
                                          : widget.user.profile.name
                                              .substring(0, 1),
                                      style: wtTitle(
                                          80, 1, Colors.white, true, false),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      widget.user.profile.name
                                                  .split(' ')
                                                  .length >
                                              2
                                          ? widget.user.profile.name
                                              .split(' ')[1][0]
                                          : widget.user.profile.name
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
                                    widget.user.profile.img,
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
                              Icons.security_outlined,
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
                    'Sweet Chat user since ${widget.user.profile.dateins}',
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
                    shape: BoxShape.circle, border: Border.all(color: theme.dred3)),
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
              subtitle: Text(
                widget.user.profile.name,
                style: wtTitle(16, 1, Colors.black, true, false),
              ),
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
                    shape: BoxShape.circle, border: Border.all(color: theme.dred3)),
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
              subtitle: Text(
                widget.user.profile.bio,
                style: wtTitle(16, 1, Colors.black, true, false),
              ),
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
                    shape: BoxShape.circle, border: Border.all(color: theme.dred3)),
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
              subtitle: Text(
                widget.user.profile.adress.isEmpty ? " - - - " : widget.user.profile.adress,
                style: wtTitle(16, 1, Colors.black, true, false),
              ),
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
                    shape: BoxShape.circle, border: Border.all(color: theme.dred3)),
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
              subtitle:
              InkWell(
                onTap : (){
                  cURLMail(widget.user.profile.email,
                                    'Hello ! I found You on Sweet Chat ...');
                },
              child : Text(
                widget.user.profile.email,
                style: wtTitle(16, 1, Colors.black, true, false),
              )),
              selectedTileColor: theme.dred1,
            ),
            // Number
            ListTile(
              onTap: () {
                //

                // customDiag(context, countryDiag());
              },
              leading:  Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.dred3)),
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.flag_outlined,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
              title: Text(
                "Phone Number",
                style: wtTitle(18, 1, Colors.black, true, false),
              ),
              subtitle: InkWell(
                onTap: () {
                  if(widget.user.profile.numero .isNotEmpty){
                    cURLPhoneCall('+${widget.user.profile.countcode}${widget.user.profile.numero}');
                  }
                },
                child: Text(
                  widget.user.profile.numero .isEmpty ? " - - - " : '+ ${widget.user.profile.countcode} ${widget.user.profile.numero}',
                  style: wtTitle(16, 1, Colors.black, true, false),
                ),
              ),
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
                    shape: BoxShape.circle, border: Border.all(color: theme.dred3)),
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
              subtitle:
                
                 widget.user.profile.facebook .isEmpty ? Text(
                   " - - - ",
                  style: wtTitle(16, 1, Colors.black, true, false),
                ) : cURLLink(widget.user.profile.facebook, Icon(BoxIcons.bxl_facebook)),
              
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
                    shape: BoxShape.circle, border: Border.all(color: theme.dred3)),
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
              subtitle: widget.user.profile.linkedin .isEmpty ? Text(
                   " - - - ",
                  style: wtTitle(16, 1, Colors.black, true, false),
                ) : cURLLink(widget.user.profile.linkedin, Icon(BoxIcons.bxl_linkedin)), 

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
                    shape: BoxShape.circle, border: Border.all(color: theme.dred3)),
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
              subtitle: widget.user.profile.instagram .isEmpty ? Text(
                   " - - - ",
                  style: wtTitle(16, 1, Colors.black, true, false),
                ) : cURLLink(widget.user.profile.instagram, Icon(BoxIcons.bxl_instagram)),  
              selectedTileColor: theme.dred1,
            ),

            SizedBox(
              height: 15,
            ),

          


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

}
