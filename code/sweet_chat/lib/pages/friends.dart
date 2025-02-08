import 'package:flutter/material.dart';
import 'package:sweet_chat/theme.dart';
import 'package:sweet_chat/utils/provider/provider.dart';
import 'package:sweet_chat/utils/decoration.dart';
import 'package:sweet_chat/utils/fab/src/action_button_builder.dart';
import 'package:sweet_chat/utils/fab/src/expandable_fab.dart';
import '../utils/loading/loading_overlay_pro.dart';
import 'package:sweet_chat/pages/friends0requests.dart';
import 'package:sweet_chat/pages/friends1yourfriend.dart';
import 'package:sweet_chat/pages/friends2people.dart';
import 'package:sweet_chat/utils/widgets.dart';
import 'package:sweet_chat/utils/simple_ripple_animation.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key, required this.menu});
  final Widget menu;
  @override
  State<FriendsPage> createState() => FriendsPageState();
}

bool isSearching = false;
TextEditingController searchctrl = TextEditingController();

class FriendsPageState extends State<FriendsPage> {
  bool loading = false;
  //  TextEditingController searchctrl = TextEditingController();

  String title = "Friend Requests";
  Widget currentPage = FriendsRequests();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchctrl.text = '';
  }

  final _key = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    return LoadingOverlayPro(
      isLoading: loading,
      progressIndicator: loadingAnimation(),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: 

           
          
          ExpandableFab(
            key: _key,
            // duration: const Duration(milliseconds: 500),
            distance: 70,
            type: ExpandableFabType.up,
            // pos: ExpandableFabPos.left,
            // childrenOffset: const Offset(0, 20),
            // childrenAnimation: ExpandableFabAnimation.none,
            // fanAngle: 40,
            openButtonBuilder: RotateFloatingActionButtonBuilder(
              child: 
              RippleAnimation(
                                    delay: Duration(seconds: 0),
                                    duration: Duration(seconds : 2),
                                    repeat : true,
                                    minRadius: 22,
                                    ripplesCount: 2,
                                    color: context.watch<AppTheme>().themeclass.dred2,
                                    child:
               Icon(Icons.filter_list_outlined),
                ),
              fabSize: ExpandableFabSize.regular,
              foregroundColor: context.watch<AppTheme>().themeclass.dred1,
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
              angle: 3.14 * 2,
            ),
            closeButtonBuilder: FloatingActionButtonBuilder(
              size: 56,
              builder: (BuildContext context, void Function()? onPressed,
                  Animation<double> progress) {
                return IconButton(
                  onPressed: onPressed,
                  icon: const Icon(
                    Icons.close,
                    size: 40,
                    color: Colors.white,
                  ),
                );
              },
            ),
            overlayStyle: ExpandableFabOverlayStyle(
              color: const Color.fromARGB(88, 0, 0, 0),
              blur: 5,
            ),
            onOpen: () {
              debugPrint('onOpen');
            },
            afterOpen: () {
              debugPrint('afterOpen');
            },
            onClose: () {
              debugPrint('onClose');
            },
            afterClose: () {
              debugPrint('afterClose');
            },
            children: [
              Tooltip(
                message: "View Friend Requests",
                waitDuration: Duration(microseconds: 200),
                preferBelow: false,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Friend Requests',
                      style: wtTitle(15, 1, Colors.white, true, false),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    FloatingActionButton(
                      shape: const CircleBorder(),
                      heroTag: null,
                      child: Icon(Icons.group_add_outlined),
                      foregroundColor:
                          context.watch<AppTheme>().themeclass.dred1,
                      backgroundColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          title = "Friend Requests";
                          currentPage = FriendsRequests();
                          _key.currentState!.toggle();
                        });
                      },
                    ),
                  ],
                ),
              ),
              Tooltip(
                message: "Your Firend List",
                waitDuration: Duration(microseconds: 200),
                preferBelow: false,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Your Friends',
                      style: wtTitle(15, 1, Colors.white, true, false),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    FloatingActionButton(
                      shape: const CircleBorder(),
                      heroTag: null,
                      child: Icon(Icons.contacts_outlined),
                      foregroundColor:
                          context.watch<AppTheme>().themeclass.dred1,
                      backgroundColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          title = "Your Friends";
                          currentPage = YourFriends();
                          _key.currentState!.toggle();
                        });
                      },
                    ),
                  ],
                ),
              ),
              Tooltip(
                message: "All Registered Users",
                waitDuration: Duration(microseconds: 200),
                preferBelow: false,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // FadeIn
                    Text(
                      'People',
                      style: wtTitle(15, 1, Colors.white, true, false),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    FloatingActionButton(
                      shape: const CircleBorder(),
                      heroTag: null,
                      child: Icon(Icons.groups_2_outlined),
                      foregroundColor:
                          context.watch<AppTheme>().themeclass.dred1,
                      backgroundColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          title = "People";
                          currentPage = PeoplePage();
                          _key.currentState!.toggle();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          )
          
          
          
          ,



          // floatingActionButton: Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     FloatingActionButton.small(
          //       shape: const CircleBorder(),
          //       heroTag: null,
          //       child: Icon(Icons.group_add_outlined),
          //       foregroundColor: context.watch<AppTheme>().themeclass.dred1,
          //       backgroundColor: Colors.white,
          //       onPressed: () {
          //         setState(() {
          //           title = "Friend Requests";
          //           currentPage =  FriendsRequests();
          //         });
          //       },
          //     ),
          //     FloatingActionButton.small(
          //       shape: const CircleBorder(),
          //       heroTag: null,
          //       child: Icon(Icons.contacts_outlined),
          //       foregroundColor: context.watch<AppTheme>().themeclass.dred1,
          //       backgroundColor: Colors.white,
          //       onPressed: () {
          //         setState(() {
          //           title = "Your Friends";
          //           currentPage =  YourFriends();
          //         });
          //       },
          //     ),
          //     FloatingActionButton.small(
          //       shape: const CircleBorder(),
          //       heroTag: null,
          //       child: Icon(Icons.groups_2_outlined),
          //       foregroundColor: context.watch<AppTheme>().themeclass.dred1,
          //       backgroundColor: Colors.white,
          //       onPressed: () {
          //         setState(() {
          //           title = "People";
          //           currentPage =  PeoplePage();
          //         });
          //       },
          //     ),
          //   ],
          // ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 0, child: widget.menu),
                        Expanded(
                          flex: 1,
                          child: Text(
                            " $title",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                            flex: 0,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // InkWell(
                                //     onTap: () {
                                //       //
                                //       setState(() {
                                //         isSearching = !isSearching;
                                //         searchctrl.text = '';
                                //       });
                                //     },
                                //     child: Icon(
                                //       isSearching
                                //           ? Icons.clear_outlined
                                //           : Icons.search_outlined,
                                //       size: 30,
                                //     )),
                              ],
                            )),
                      ],
                    ),
                    !isSearching
                        ? SizedBox()
                        : Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                    controller: searchctrl,
                                    textAlign: TextAlign.center,
                                    onChanged: (value) {
                                      setState(() {
                                        // domaineslst.clear();
                                        // domaineslst.addAll(domaineslstori.where((e) => e
                                        //     .nom
                                        //     .toLowerCase()
                                        //     .contains(searchctrl.text.toLowerCase())));
                                      });
                                    },
                                    onTapOutside: (event) {
                                      // setState(() {
                                      //   srchanim = false;
                                      // });
                                    },
                                    decoration: mydecoration(
                                        "",
                                        18,
                                        15,
                                        true,
                                        Container(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            width: 60,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.search,
                                                  color: Colors.black,
                                                  size: 25,
                                                ),
                                                SizedBox(width: 5),
                                                SizedBox(
                                                    height: 20,
                                                    child: VerticalDivider(
                                                      color: theme.dred1,
                                                    )),
                                              ],
                                            )),
                                        false,
                                        SizedBox(),
                                        const BorderRadius.all(
                                            Radius.circular(50)))),
                              ),
                              //
                            ],
                          )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: currentPage,
              )
            ],
          ),
        ),
      ),
    );
  }
}
