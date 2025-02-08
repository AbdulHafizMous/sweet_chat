import 'package:flutter/material.dart';
import 'package:sweet_chat/auth_service.dart';
import 'package:sweet_chat/pages/menu.dart';
import 'package:sweet_chat/theme.dart';
import 'package:sweet_chat/utils/loading/loading_overlay_pro.dart';
import 'package:sweet_chat/utils/widgets.dart';
// import 'package:flutter_countries/flutter_countries.dart';
import '../utils/decoration.dart';
import '../utils/custom.dart';

class SignUp5 extends StatefulWidget {
  const SignUp5({super.key});

  @override
  State<SignUp5> createState() => _SignUp5State();
}

class _SignUp5State extends State<SignUp5> {
  TextEditingController fullname = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confpassword = TextEditingController();
  TextEditingController date = TextEditingController();

  var sex;

  bool cache = true, cache1 = true, loading = false;

  final keyform = GlobalKey<FormState>();
  final AuthService _authService =
      AuthService(); // Instance du service d'authentification

  saveDatas() async {
    setState(() => loading = true);

    // msgerreur(context, connectedUser.profile.toJson().toString());

    final user = await _authService.signUp();

    setState(() => loading = false);
    

    if (user != null) {
      setState(() {
        connectedUser.profile.id = user.uid;
      });
      // Rediriger vers la page des discussions après une connexion réussie
      fermer(context);
      fermer(context);
      fermer(context);
      ouvrirR(context, const ManuPage());
    } else {
      // Afficher une erreur si la connexion échoue
      showsnack(context,
          "Sign Up Error. Check your Internet and retry !");
    }
  }

  @override
  void initState() {
    loading = false;

    setState(() {});
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
            'Sign Up',
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
                              top: 45.0, left: 15, right: 15),
                          // height: MediaQuery.of(context).size.height*0.850,
                          child: Column(
                            children: [
                              Text(
                                'Personnal Details',
                                style: wtTitle(25, 1, theme.dred1, true, false),
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'We need some informations about you !',
                                  style:
                                      wtTitle(15, 1, theme.dred3, true, false),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              const SizedBox(
                                height: 25,
                              ),
                              // Full Name

                              TextFormField(
                                  controller: fullname,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Field Required !';
                                    } else if (value.length < 2) {
                                      return '2 characters at least';
                                    }
                                    return null;
                                  },
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.text,
                                  // inputFormatters: [FormatTelph()],
                                  style:
                                      wtTitle(18, 1, theme.dred3, true, false),
                                  decoration: mydecoration(
                                      "Full Name",
                                      18,
                                      18,
                                      true,
                                      Container(
                                          alignment: Alignment.center,
                                          width: 100,
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(
                                                Icons.person_4_outlined,
                                                color: Colors.black,
                                              ),
                                              Text('|',
                                                  style: wtTitle(
                                                      18,
                                                      1,
                                                      Colors.black,
                                                      true,
                                                      false))
                                            ],
                                          )),
                                      false,
                                      const SizedBox(
                                        width: 0,
                                      ),
                                      BorderRadius.circular(30))),

                              const SizedBox(
                                height: 15,
                              ),

                              // Sexe -- Date

                              // sex

                              DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField(
                                      value: sex,
                                      style: wtTitle(
                                          18, 1, theme.dred3, true, false),
                                      decoration: mydecoration(
                                          "Sex",
                                          18,
                                          18,
                                          true,
                                          Container(
                                              alignment: Alignment.center,
                                              width: 100,
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Icon(
                                                    Icons.transgender_outlined,
                                                    color: Colors.black,
                                                  ),
                                                  Text('|',
                                                      style: wtTitle(
                                                          18,
                                                          1,
                                                          Colors.black,
                                                          true,
                                                          false))
                                                ],
                                              )),
                                          false,
                                          const SizedBox(
                                            width: 0,
                                          ),
                                          BorderRadius.circular(30)),
                                      dropdownColor: Colors.white,
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Field Required';
                                        }
                                        return null;
                                      },
                                      isExpanded: true,
                                      onChanged: (value) {
                                        setState(() {
                                          sex = value;
                                        });
                                      },
                                      items: ['M', 'F', '-']
                                          .map((e) => DropdownMenuItem(
                                              value: e, child: Text(' $e ')))
                                          .toList())),

                              const SizedBox(
                                height: 15,
                              ),

                              //  Date

                              TextFormField(
                                controller: date,

                                readOnly: true,
                                onTap: () {
                                  setState(() {
                                    datepicker(context).then((value) => date
                                        .text = value.toString().split(' ')[0]);
                                  });
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Required !';
                                  }
                                  return null;
                                },
                                textAlign: TextAlign.center,
                                // keyboardType: TextInputType.emailAddress,
                                // inputFormatters: [FormatTelph()],
                                style: wtTitle(18, 1, theme.dred3, true, false),
                                decoration: mydecoration(
                                    "Born Date",
                                    18,
                                    18,
                                    true,
                                    Container(
                                        alignment: Alignment.center,
                                        width: 100,
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Icon(
                                              Icons.date_range_rounded,
                                              color: Colors.black,
                                            ),
                                            Text('|',
                                                style: wtTitle(18, 1,
                                                    Colors.black, true, false))
                                          ],
                                        )),
                                    false,
                                    const SizedBox(
                                      width: 0,
                                    ),
                                    BorderRadius.circular(30)),
                                // const InputDecoration(
                                //   hintText: '__ / __ / __',
                                //   border: InputBorder.none,
                                //   prefixIcon: Icon(Icons.date_range_rounded),

                                // )
                              ),

                              const SizedBox(
                                height: 15,
                              ),

                              // country

                              /*   Padding(
                                padding: const EdgeInsets.symmetric(vertical:8.0, horizontal: 10),
                                child: CountryPickerDropdown(
                                  decoration: InputDecoration(
                                    enabledBorder: myenabledborder(BorderRadius.circular(10), theme.dred2),
                                    disabledBorder: myenabledborder(BorderRadius.circular(10), theme.dred2),
                                    focusedBorder: myfocusborder(BorderRadius.circular(10), theme.dred2),
                                  ),
                                  initialValue: 'bj',
                                  isExpanded: true,
                                  radius: BorderRadius.all(Radius.circular(30)),
                                  padding: EdgeInsets.all(8),
                                  itemBuilder: buildDropdownItemForCountry,
                                  onValuePicked: ( countryS) async {
                                    // vindicatif = country.phoneCode;
                                    setState(() {
                                       country = countryS;
                                       phcode = country.phoneCode;
      
                                        
                                    });
      
      
                                    setState(() {
                                      
                                    });
                                  },
                                ),
                              ),
                      
                              const SizedBox(height: 15,),
                      
                            // phone
      
                              TextFormField(
                                controller: numero,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Number Required !';
                                  }
                                  return null;
                                },
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [FormatTelph()],
                                style: wtTitle(18, 1, theme.dred3, true, false),
                                decoration: mydecoration(
                                    "Phone Number",
                                    18,
                                    18,
                                    true,
                                    Container(
                                      alignment: Alignment.center,
                                      width: 100,
                                      padding: const EdgeInsets.only(left: 10, right: 10),
                                      child:  
                                      Text("+ ($phcode)  |  ", style: wtTitle(18, 1, Colors.black, true, false),),
                                    ), false, const SizedBox(width: 0,), BorderRadius.circular(30)
                                    )
                              ),
      
                               const SizedBox(height: 10,), 
      
                                         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
          child: Container(
            height: 1,
            color: const Color.fromARGB(255, 189, 189, 189),
            width: scrW(context),
          ),
        ),
      
                               const SizedBox(height: 10,),
      
                             // Pseudo
                      
                              TextFormField(
                                controller: pseudo,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Field Required !';
                                  }
                                  return null;
                                },
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.text,
                                // inputFormatters: [FormatTelph()],
                                style: wtTitle(18, 1, theme.dred3, true, false),
                                decoration: mydecoration(
                                    "Pseudo",
                                    18,
                                    18,
                                    true,
                                    Container(
                                      alignment: Alignment.center,
                                      width: 100,
                                      padding: const EdgeInsets.only(left: 10, right: 10),
                                      child:  
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                           Icon(Icons.smart_toy_outlined, color: Colors.black,),
                                           Text('|',  style: wtTitle(18, 1, Colors.black, true, false))
                                        ],
                                      )
                                       ), false, const SizedBox(width: 0,), BorderRadius.circular(30)
                                    )
                              ),
                      
                            */

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60, vertical: 8),
                                child: Container(
                                  height: 2,
                                  color:
                                      const Color.fromARGB(255, 189, 189, 189),
                                  width: scrW(context),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Now Set Up your Password !',
                                  style:
                                      wtTitle(15, 1, theme.dred3, true, false),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              TextFormField(
                                  obscureText: cache,
                                  controller: password,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Password Required !';
                                    } else if(!passRegex.hasMatch(value)){
                                      return "Invalid Format ! (At least 8 characters)";
                                    }
                                    return null;
                                  },
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.text,
                                  // inputFormatters: [FormatTelph()],
                                  style:
                                      wtTitle(18, 1, theme.dred3, true, false),
                                  decoration: mydecoration(
                                      "Password",
                                      18,
                                      18,
                                      true,
                                      Container(
                                          alignment: Alignment.center,
                                          width: 100,
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(
                                                Icons.password_outlined,
                                                color: Colors.black,
                                              ),
                                              Text('|',
                                                  style: wtTitle(
                                                      18,
                                                      1,
                                                      Colors.black,
                                                      true,
                                                      false))
                                            ],
                                          )),
                                      true,
                                      Container(
                                          alignment: Alignment.center,
                                          width: 100,
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text('|',
                                                  style: wtTitle(
                                                      18,
                                                      1,
                                                      Colors.black,
                                                      true,
                                                      false)),
                                              cache == true
                                                  ? IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          cache = false;
                                                        });
                                                      },
                                                      icon: Icon(Icons
                                                          .visibility_outlined),
                                                      color: Colors.black,
                                                    )
                                                  : IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          cache = true;
                                                        });
                                                      },
                                                      icon: Icon(Icons
                                                          .visibility_off_outlined),
                                                      color: Colors.black,
                                                    )
                                            ],
                                          )),
                                      BorderRadius.circular(30))),

                              const SizedBox(
                                height: 15,
                              ),

                              TextFormField(
                                  obscureText: cache1,
                                  controller: confpassword,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Required !';
                                    } else if (value.isNotEmpty &&
                                        password.text.isNotEmpty &&
                                        value != password.text) {
                                      return 'Incorrect Password !';
                                    }
                                    return null;
                                  },
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.text,
                                  // inputFormatters: [FormatTelph()],
                                  style:
                                      wtTitle(18, 1, theme.dred3, true, false),
                                  decoration: mydecoration(
                                      "Confirm ",
                                      18,
                                      18,
                                      true,
                                      Container(
                                          alignment: Alignment.center,
                                          width: 100,
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(
                                                Icons.password_outlined,
                                                color: Colors.black,
                                              ),
                                              Text('|',
                                                  style: wtTitle(
                                                      18,
                                                      1,
                                                      Colors.black,
                                                      true,
                                                      false))
                                            ],
                                          )),
                                      true,
                                      Container(
                                          alignment: Alignment.center,
                                          width: 100,
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text('|',
                                                  style: wtTitle(
                                                      18,
                                                      1,
                                                      Colors.black,
                                                      true,
                                                      false)),
                                              cache1 == true
                                                  ? IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          cache1 = false;
                                                        });
                                                      },
                                                      icon: Icon(Icons
                                                          .visibility_outlined),
                                                      color: Colors.black,
                                                    )
                                                  : IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          cache1 = true;
                                                        });
                                                      },
                                                      icon: Icon(Icons
                                                          .visibility_off_outlined),
                                                      color: Colors.black,
                                                    )
                                            ],
                                          )),
                                      BorderRadius.circular(30))),

                              const SizedBox(
                                height: 40,
                              ),

                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                child: TextButton(
                                  onPressed: () {
                                    if (keyform.currentState!.validate()) {
                                      setState(() {
                                        connectedUser.profile.name =
                                            fullname.text;
                                        connectedUser.profile.password =
                                            password.text;
                                        connectedUser.profile.date = date.text;
                                        connectedUser.profile.dateins =
                                            DateTime.now().toString();
                                        connectedUser.profile.sexe = sex;
                                      });
                                      saveDatas();
                                    }
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateColor.resolveWith(
                                              (states) => theme.dred2),
                                      shape: const WidgetStatePropertyAll(
                                          StadiumBorder())),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Finish',
                                          style: wtTitle(22, 1.5, theme.dred3,
                                              true, false),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: 20,
                                          color: theme.dred3,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 25,
                              ),
                            ],
                          ),
                        ),
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
}
