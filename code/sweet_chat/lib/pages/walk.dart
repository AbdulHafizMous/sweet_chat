import 'package:flutter/material.dart';
import 'package:sweet_chat/theme.dart';
import '../utils/decoration.dart';
import 'sign.dart';

// import 'package:jobber/menu.dart';

class WalkThrough extends StatefulWidget {
  const WalkThrough({super.key});

  @override
  State<WalkThrough> createState() => _WalkThroughState();
}

class _WalkThroughState extends State<WalkThrough> {
  List pages = [
    {
      'img1': 'wt7.jpg',
      'img2': 'flogow.png',
      'title': ' . 😊 . ',
      'desc':
          'A Fully Built-In Chat App'
    },
    {
      'img1': 'wt10.jpg',
      'img2': 'wt13.jpg',
      'title': 'let\'s share more than simple messages !',
      'desc':
          'Texts - Records - Files and More'
    },
    {
      'img1': 'wt1.jpg',
      'img2': 'wt14.jpg',
      'title': 'WELCOME ON SWEETCHAT !',
      'desc':
          '. 😄 . 😉 . 🤩 . 😜 .'
    }
  ];

  PageController controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        itemCount: pages.length,
        scrollDirection: Axis.vertical,
        controller: controller,
        itemBuilder: (context, index) {
          return 
            Column(
              mainAxisAlignment : MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const SizedBox(height: 40,),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(55),
                              topLeft: Radius.circular(30)),
                          color: theme.dred2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    if (index != pages.length - 1) {
                                      controller.animateToPage(index + 1,
                                          duration: Duration(milliseconds: 800),
                                          curve: Curves.easeInOut);
                                    } else {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const Sign(),
                                          ));
                                    }
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(15),
                                      width: 150,
                                      // decoration: BoxDecoration(color: Color.fromARGB(255, 255, 166, 166),  borderRadius: BorderRadius.circular(20)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          index != pages.length - 1
                                              ? Text(
                                                  'Next',
                                                  style: wtTitle(
                                                      22, 1.5, theme.dred3, true, false),
                                                )
                                              : Text(
                                                  'Start',
                                                  style: wtTitle(
                                                      22, 1.5, theme.dred3, true, false),
                                                ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          index != pages.length - 1
                                              ? Icon(
                                                  Icons.arrow_forward_ios_outlined,
                                                  size: 20,
                                                  color: theme.dred3,
                                                )
                                              : Icon(Icons.stream_outlined,
                                                  size: 20, color: theme.dred3)
                                        ],
                                      )),
                                )),
                      
                            // Expanded(flex: 0,
                            //   child: LinearProgressIndicator()
                      
                            //   ),
                      
                            Expanded(
                              flex: 0,
                              child: Column(
                                  children: List.generate(
                                      pages.length,
                                      (indexdot) => InkWell(
                                            onTap: () {
                                              controller.animateToPage(indexdot,
                                                  duration:
                                                      Duration(milliseconds: 800),
                                                  curve: Curves.easeInOut);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: index == indexdot
                                                    ? theme.dred4
                                                    : theme.dred3,
                                              ),
                                              margin: EdgeInsets.only(
                                                  right: 20, top: 5),
                                              width: 10,
                                              height: index == indexdot ? 35 : 15,
                                            ),
                                          ))),
                            )
                          ],
                        ),
                      ),
                    
            
                    Stack(
                    children: [
                      Container(
                        height: 260 /* index%2==0? 400 :30 */,
                        color: theme.dred2,
                      ),
            
                      // index%2==0?
                      Container(
                        height: 260,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(55)),
                            color: Color.fromARGB(250, 255, 255, 255),
                            image: DecorationImage(
                                image:
                                    AssetImage('imgs/${pages[index]['img2']}'),
                                opacity: 0.8,
                                fit: BoxFit.cover)),
                        // child: Image.asset('imgs/${pages[index]['img2']}', ),
                      )
            
                      // :
            
                      // Container(height: 30,
                      //  decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(55)),
                      // color: Color.fromARGB(250, 255, 255, 255),
            
                      // ),
                      // // child: Image.asset('imgs/${pages[index]['img2']}', ),
                      // )
                    ],
                  ),
            
            
                    
                    ],
                  ),
            
                  
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin:
                        EdgeInsets.only(left: 10, top: index % 2 != 0 ? 20 : 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          pages[index]['title'].toString().toUpperCase(),
                          textAlign: TextAlign.center,
                          style: wtTitle(20, 2.5, Colors.black, true, false),
                        ),
                      ],
                    ),
                  ),
            
                  // SizedBox(
                  //   height: 10,
                  // ),
            
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 26),
                    child: Text(pages[index]['desc'],
                        textAlign: TextAlign.center,
                        style: wtTitle(18, 1.5, Colors.black, false, index == 2 ? false : true)),
                  ),
            
                  // SizedBox(
                  //   height: 10,
                  // ),
            
                  // index%2==0?
                  Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    height: 80,
                    child: TextButton(
                      onPressed: () {
                        if (index != pages.length - 1) {
                          controller.animateToPage(index + 1,
                              duration: Duration(milliseconds: 800),
                              curve: Curves.easeInOut);
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Sign(),
                              ));
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          index != pages.length - 1
                              ? Text(
                                  'Next',
                                  style: wtTitle(22, 1.5, theme.dred3, true, false),
                                )
                              : Text(
                                  'Start',
                                  style: wtTitle(22, 1.5, theme.dred3, true, false),
                                ),
                          const SizedBox(
                            width: 5,
                          ),
                          index != pages.length - 1
                              ? Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 20,
                                  color: theme.dred3,
                                )
                              : Icon(Icons.stream_outlined,
                                  size: 20, color: theme.dred3)
                        ],
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateColor.resolveWith((states) => theme.dred2),
                          shape: WidgetStatePropertyAll(StadiumBorder())),
                    ),
                  ),
                  // :
                  // const SizedBox()
                  // Container(color: theme.dred1, margin: EdgeInsets.all(20),
                  //   child: CustomPaint(
                  //           size: Size(100, 100),
                  //           painter: MyPainter(),
                  //           ),
                  // )
            
                  // SizedBox(
                  //   height: 8,
                  // ),
                ])
          ;
        },
      ),
    );
  }
}
