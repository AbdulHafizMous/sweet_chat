import 'package:flutter/material.dart';
import 'package:sweet_chat/theme.dart';
import '../utils/loading/loading_overlay_pro.dart';
import 'package:sweet_chat/utils/custom.dart';
import 'package:sweet_chat/utils/decoration.dart';
import 'package:sweet_chat/utils/rating/rating_bar.dart';
import 'package:sweet_chat/utils/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RateUs extends StatefulWidget {
  const RateUs({super.key});

  @override
  State<RateUs> createState() => _RateUsState();
}

class _RateUsState extends State<RateUs> {
  bool loading = false;

  //
  TextEditingController dateCtrl = TextEditingController();
  TextEditingController dureeCtrl = TextEditingController();
  TextEditingController detailCtrl = TextEditingController();
  TextEditingController comentCtrl = TextEditingController();
  TextEditingController qualiteCtrl = TextEditingController();

  var prix;
  double prixval = 4, qualiteval = 7, rate = 4.3;
  //
  List<Map> pricing = [
    {
      'level': '1',
      'prix': 'Badly Made',
      'color': Colors.red,
      'icon': Icons.sentiment_very_dissatisfied
    },
    {
      'level': '2',
      'prix': 'Too Easy',
      'color': Colors.redAccent,
      'icon': Icons.sentiment_dissatisfied
    },
    {
      'level': '3',
      'prix': 'Acceptable',
      'color': theme.dred1,
      'icon': Icons.sentiment_neutral
    },
    {
      'level': '4',
      'prix': 'Really Good',
      'color': Colors.greenAccent,
      'icon': Icons.sentiment_satisfied
    },
    {
      'level': '5',
      'prix': 'Excellent',
      'color': Colors.green,
      'icon': Icons.sentiment_very_satisfied
    }
  ];

  final keyform = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      qualiteCtrl.text = '7';
      comentCtrl.text = "No Comment";
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
            'Rate Us',
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
    return Column(children: [
      //
      Text(
        'Let us an appreciation !',
        style: wtTitle(25, 1, theme.dred1, true, false),
      ),

      SizedBox(
        height: 20,
      ),

      // Cards
      //

      // Qualité
      customCard(Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    children: [
                      Text(
                        'Work achievement on 10 ?',
                        style: wtTitle(18, 1, theme.dred3, true, false),
                      ),
                      Text(
                        '*',
                        style: wtTitle(20, 1, Colors.red, true, false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
           Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Divider(
              color: theme.dred2,
              height: 15,
              thickness: 2,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: 300,
            child: TextFormField(
              controller: qualiteCtrl,
              readOnly: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Required !';
                }
                return null;
              },
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              // inputFormatters: [FormatTelph()],
              style: wtTitle(18, 1, theme.dred3, true, false),
              decoration: mydecoration(
                  "Qualité",
                  15,
                  12,
                  true,
                  Container(
                      padding: EdgeInsets.only(left: 20),
                      width: 80,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (int.parse(qualiteCtrl.text) > 0) {
                                  qualiteCtrl.text =
                                      '${int.parse(qualiteCtrl.text) - 1}';
                                }
                              });
                            },
                            child: Icon(
                              Icons.remove_circle_outline_outlined,
                              color: theme.dred1,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 5),
                          SizedBox(
                              height: 30,
                              child: VerticalDivider(
                                color: theme.dred1,
                              )),
                        ],
                      )),
                  true,
                  Container(
                      padding: EdgeInsets.only(left: 20),
                      width: 80,
                      child: Row(
                        children: [
                          SizedBox(
                              height: 30,
                              child: VerticalDivider(
                                color: theme.dred1,
                              )),
                          SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (int.parse(qualiteCtrl.text) < 10) {
                                  qualiteCtrl.text =
                                      '${int.parse(qualiteCtrl.text) + 1}';
                                }
                              });
                            },
                            child: Icon(
                              Icons.add_circle_outline_outlined,
                              color: theme.dred1,
                              size: 30,
                            ),
                          ),
                        ],
                      )),
                  BorderRadius.all(Radius.circular(30))),
            ),
          ),
        ],
      )),

      /* // Qualité
          FB5Col(
            classNames: 'col-lg-6',
            child: customCard(Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Wrap(spacing: 8,
                          children: [
                            Text(
                              'Quelle est votre appréciation de la Qualité du Travail sur 10 ?',
                              style: wtTitle(18, 1, theme.dred3, true, false),
                            ),
                            Text(
                              '*',
                              style: wtTitle(20, 1, Colors.red, true, false),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Divider(
                    color: theme.dred2,
                    height: 15,
                    thickness: 2,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(flex: 0, child: Text('${qualiteval.floor()} / 10', style: wtTitle(16, 1, theme.dred3, true, false),)),
                    Expanded(flex: 1,
                      child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Slider(
                              min: 0,
                              max: 10,
                              divisions: 10,
                              value: qualiteval,
                              onChanged: (value) {
                                setState(() {
                                  qualiteval = value;
                                  //
                                });
                              },
                              activeColor: theme.dred1,
                              inactiveColor: theme.dred3,
                            ),
                          ),
                    ),
                  ],
                ),
                ],
            )),
          ),
        
           */

      // Design
      customCard(Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    children: [
                      Text(
                        'How you feel the Design ?',
                        style: wtTitle(18, 1, theme.dred3, true, false),
                      ),
                      Text(
                        '*',
                        style: wtTitle(20, 1, Colors.red, true, false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
           Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Divider(
              color: theme.dred2,
              height: 15,
              thickness: 2,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            pricing
                .firstWhere(
                    (e) => e['level'] == prixval.floor().toString())['prix']
                .toString(),
            style: wtTitle(
                16,
                1,
                pricing.firstWhere(
                    (e) => e['level'] == prixval.floor().toString())['color'],
                true,
                false),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: RatingBar.builder(
              initialRating: prixval,
              // ignoreGestures: true,
              minRating: 1,
              maxRating: 5,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Icon(
                    pricing[index]['icon'],
                    color: pricing[index]['color'],
                    size: 40,
                  ),
                );
              },
              updateOnDrag: true,
              // tapOnlyMode: true,
              onRatingUpdate: (rating) {
                print('prix : ${rating}');
                setState(() {
                  prixval = rating;
                });
              },
            ),

            // Slider(
            //   min: 0,
            //   max: 4,
            //   divisions: 4,
            //   value: prixval,
            //   onChanged: (value) {
            //     setState(() {
            //       prixval = value;
            //       //
            //     });
            //   },
            //   activeColor: pricing.firstWhere((e) =>
            //       e['level'] ==
            //       prixval.floor().toString())['color'], // theme.dred1,
            //   inactiveColor: theme.dred3,
            // ),
          ),
        ],
      )),

      // Comments
      customCard(Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    children: [
                      Text(
                        'Comments on our work ',
                        style: wtTitle(18, 1, theme.dred3, true, false),
                      ),
                      Text(
                        '*',
                        style: wtTitle(20, 1, Colors.red, true, false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
           Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Divider(
              color: theme.dred2,
              height: 15,
              thickness: 2,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: comentCtrl,
            maxLines: 4,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Required !';
              }
              return null;
            },
            textAlign: TextAlign.center,
            keyboardType: TextInputType.text,
            // inputFormatters: [FormatTelph()],
            style: wtTitle(18, 1, theme.dred3, true, false),
            decoration: mydecoration(
                "Commentaires",
                15,
                12,
                false,
                Container(
                    padding: EdgeInsets.only(left: 20),
                    width: 80,
                    child: Row(
                      children: [
                        Icon(
                          Icons.text_snippet_outlined,
                          color: theme.dred1,
                          size: 30,
                        ),
                        SizedBox(width: 5),
                        SizedBox(
                            height: 30,
                            child: VerticalDivider(
                              color: theme.dred1,
                            )),
                      ],
                    )),
                false,
                SizedBox(),
                BorderRadius.all(Radius.circular(30))),
          ),
        ],
      )),

      // Rating
      customCard(Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    children: [
                      Text(
                        'Final Rate',
                        style: wtTitle(18, 1, theme.dred3, true, false),
                      ),
                      Text(
                        '*',
                        style: wtTitle(20, 1, Colors.red, true, false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
           Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Divider(
              color: theme.dred2,
              height: 15,
              thickness: 2,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          //
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: [
              Text(
                '${rate.floor() < rate ? rate : rate.floor()} / 5',
                style: wtTitle(16, 1, theme.dred3, true, false),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: RatingBar.builder(
                  initialRating: rate,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      rate = rating;
                    });
                    print(rating);
                  },
                ),
              ),
            ],
          ),

          // Row(
          //   children: [
          //     Expanded(
          //       child: RatingBarIndicator(
          //         rating: rate,
          //         itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
          //         itemBuilder: (context, index) => Icon(
          //           Icons.star,
          //           color: Colors.amber,
          //         ),
          //         itemCount: 5,
          //         direction: Axis.horizontal,
          //       ),
          //     ),
          //   ],
          // ),
          //
        ],
      )),

      //

      //
      SizedBox(
        height: 20,
      ),

      Padding(
          padding: const EdgeInsets.only(top: 25),
          child: customButton(
              theme.dred1,
              Text(
                'Confirm',
                style: wtTitle(18, 1, theme.dred4, true, false),
              ),
              15, () async{
            //
            if (keyform.currentState!.validate()) {
              print('ok');
              // save();
              await FirebaseFirestore.instance
            .collection('avis')
            .doc(DateTime.now().microsecondsSinceEpoch.toString())
            .set({
              'quality': qualiteCtrl.text, 
              'design': prixval, 
              'comment':  comentCtrl.text,
              'final' : rate, 
              });
     
              customDiag(context, infoDiag());
            }
          }, -1, cp: EdgeInsets.symmetric(horizontal: 40, vertical: 15))),

      const SizedBox(
        height: 50,
      ),
    ]);
  }

  Widget infoDiag() {
    //
    String ttle = '', txt = '';
    Widget? icon;

    ttle = 'Thanks !';
    txt =
        'Mark Successfully Registered.'; // sur la plateforme et possiblement vous contacter pour bénéficier de vos prestations.\nBon Travail !';
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
