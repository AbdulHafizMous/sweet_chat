import 'package:flutter/material.dart';
import 'package:sweet_chat/theme.dart';
import 'package:pinput/pinput.dart';
// import 'package:sweet_chat/utils/pinput/src/pinput.dart';
import '../utils/decoration.dart';
import '../signup/signup3.dart';
import '../signup/signup5.dart';

import '../utils/custom.dart';
// import 'signup1.dart';
// import '../custom.dart';
// import '../menu.dart';

class SignUp4 extends StatefulWidget {
  const SignUp4({super.key});

  @override
  State<SignUp4> createState() => _SignUp4State();
}

class _SignUp4State extends State<SignUp4> {

  String codeenv = '', codesaisi = '';




  // 
    final defaultPinTheme = PinTheme(
    width: 70,
    height: 70,
    textStyle: const TextStyle(
                fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: theme.dred1),
    ),
  );
  
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final keyform = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      codeenv = connectedUser.profile.confcode;
    print('CodeEnv : $codeenv');
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Sign Up', style: wtTitle(26, 1, theme.dred3, true, false),),
      elevation: 0,
      backgroundColor: theme.dred2 ,
      ),
      body:  SingleChildScrollView(
        // controller: 0
        child: Stack(
          children: [
            
            Container(height: 100, color: theme.dred2,),

            Container(
              
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))),
              child: Center(
                child: Column(
                  
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top:45.0, left: 15, right: 15),
                      // height: MediaQuery.of(context).size.height*0.850,
                      child: Column(
                        children: [
                      // Text('Welcome Back !', style: wtTitle(25, 1, theme.dred1, true, false),),
                    
                      // const SizedBox(height: 5,),
                    
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Kindly Check your e-mail inbox !', 
                        style: wtTitle(15, 1, theme.dred3, true, false),
                        textAlign: TextAlign.center,),
                      ),
                
                      const SizedBox(height: 10,),
                
                      Container(
                  height: 200,
                  // height: MediaQuery.of(context).size.height*0.4,
                  width: 200,
                  // width: double.maxFinite,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dred1),
                    boxShadow: [BoxShadow(color: theme.dred1, blurRadius: 50, blurStyle: BlurStyle.outer, spreadRadius: -10 )],
                    shape: BoxShape.circle, 
                    image: DecorationImage(
                      alignment: Alignment.center,
                      image: AssetImage('imgs/wt3.jpg'))),
                ),
                const SizedBox(height: 15,),
                
                      Text('E-mail Checking', style: wtTitle(25, 1, theme.dred1, true, false),),
                              
                const SizedBox(height: 10,),
                              
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('We\'ve sent a confirmation code to ${obscur(email.text, 3, email.text.indexOf('@'), '*')}', 
                  style: wtTitle(15, 1, theme.dred3, true, false),
                  textAlign: TextAlign.center,),
                ),
                
                      const SizedBox(height: 40,),
                
                      Form(key: keyform,
                        child: Pinput(
                            // length: 5,
                        controller: pinController,
                        focusNode: focusNode,
                        
                        // androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
                        // listenForMultipleSmsOnAndroid: true,
                        defaultPinTheme: defaultPinTheme,
                        errorTextStyle: wtTitle(18, 1, Colors.red, false, false),
                        onCompleted: (value) {
                          if (value.toString() == codeenv) {
                          ouvrirO(context, const SignUp5());
                          }
                          
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter the Code';
                          }
                          if(value.toString() != codeenv){
                            return 'Incorrect Code!';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          codesaisi = value.toString();
                          // print(value);
                        },
                                              ),
                      ),
                
                 
                
                      const SizedBox(height: 60,),
                
                
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        child: TextButton(onPressed: () {
                
                          if (keyform.currentState!.validate()) {
                        setState(() {
                        });
                         ouvrirO(context, const SignUp5());
                      }
                
                           
                      
                          }, child:  Padding(
                            padding:  EdgeInsets.all(10.0),
                            child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                  Text('Next', style: wtTitle(22, 1.5, theme.dred3 , true, false),),
                                  const SizedBox(width: 5,),
                                  Icon(Icons.arrow_forward_ios_outlined, size: 20, color:theme.dred3 ,)
                                ],),
                          ) 
                          , style: ButtonStyle(backgroundColor: WidgetStateColor.resolveWith((states) => theme.dred2),
                            shape: WidgetStatePropertyAll(StadiumBorder())),),
                      ),
                
                
                
                    
                    
                        ],
                      ),
                    ),
                            
                           ],
                ),
              ),
            ),
          ],
        ),
      ),
    
      
    );
  }








}

