// import 'package:country_pickers/country.dart';
// import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sweet_chat/theme.dart';
// import 'package:google_fonts/google_fonts.dart';

OutlineInputBorder myenabledborder(BorderRadius radius, Color col2) {
  return OutlineInputBorder(
      borderRadius: radius, borderSide: BorderSide(color: col2, width: 1.8));
}

OutlineInputBorder myfocusborder(BorderRadius radius, Color col) {
  return OutlineInputBorder(
      borderRadius: radius, borderSide: BorderSide(color: col, width: 1.8));
}

OutlineInputBorder myerrorborder(BorderRadius radius) {
  return OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: Colors.redAccent, width: 1.8));
}

InputDecoration mydecoration(
    String labeltext,
    double tailleLabelText,
    double tailleLabelTextfloting,
    bool afficherpre,
    Widget prefixe,
    bool affichersuf,
    Widget suffixe,
    BorderRadius radius,
    {col,
    col2 }) {
  col = col ?? theme. dred1;
  col2 = col2 ?? theme . dred2;
  return InputDecoration(
    labelText: labeltext,
    labelStyle: wtTitle(tailleLabelText, 1, col, true, false),
    floatingLabelStyle: wtTitle(tailleLabelTextfloting, 1, col, true, false),
    // labelStyle: GoogleFonts.robotoSerif(
    //     color: const Color.fromARGB(133, 110, 110, 110),
    //     fontSize: tailleLabelText,
    //     fontWeight: FontWeight.bold),
    // floatingLabelStyle: GoogleFonts.robotoSerif(
    //     color: const Color.fromARGB(200, 110, 110, 110),
    //     fontSize: tailleLabelTextfloting,
    //     fontWeight: FontWeight.bold),
    enabledBorder: myenabledborder(radius, col2),
    disabledBorder: myenabledborder(radius, col2),
    focusedBorder: myfocusborder(radius, col),
    errorBorder: myerrorborder(radius),
    // focusColor: theme.dred22,
    focusedErrorBorder: myerrorborder(radius),
    prefixIcon: afficherpre == true ? prefixe : null,
    suffixIcon: affichersuf == true ? suffixe : null,
  );
}

// TextStyle? styleZoneSaisie(double fontsize, double letterspacing) {
//   return GoogleFonts.robotoSerif(
//       color: const Color.fromARGB(200, 44, 44, 44),
//       fontSize: fontsize,
//       height: 1.5,
//       letterSpacing: letterspacing,
//       fontWeight: FontWeight.bold);
// }

// TextStyle? styleZoneerreur(double fontsize, double letterspacing) {
//   return GoogleFonts.robotoSerif(
//       color: Color.fromARGB(199, 255, 0, 0),
//       fontSize: fontsize,
//       height: 1.5,
//       letterSpacing: letterspacing,
//       fontWeight: FontWeight.bold);
// }

class FormatTelph extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > oldValue.text.length) {
      //  print("Nouvelle saisie ${newValue.text}");
      //  print("Ancienne saisie ${oldValue.text}");
      final StringBuffer newText = StringBuffer();
      String newvaluex = newValue.text.toString().replaceAll(' ', '');
      //print(newvaluex);
      for (int i = 0; i < newvaluex.length; i++) {
        newText.write(newvaluex[i]);
        // print("la valeur de i : $i vaut $newText");
        if ((((i + 1) % 2) == 0) && (i != (newvaluex.length - 1))) {
          newText.write(' ');
          //  print("ok i : $i");
        }
        //  print("on a :  $newText");
      }
      return TextEditingValue(
        text: newText.toString(),
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
    return newValue;
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toLowerCase(), selection: newValue.selection);
  }
}

TextStyle wtTitle(
  double size,
  double wspacing,
  Color? color,
  bool bold,
  bool italic,
) =>
    TextStyle(
        fontSize: size,
        wordSpacing: wspacing,
        fontFamily: 'sgn',
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: color);

//         Color dred1 =  Color(0xffEE5366);
// Color dred2 =  Color(0xffff8aad);
// Color dred22 =  Color.fromARGB(179, 255, 138, 173) ;
// Color dred3 =  Color.fromARGB(131, 0, 0, 0);
// Color dred4 =  Colors.white;


// Color dred1 = !isDarkTheme ? Color(0xffEE5366) : dredd1;
// Color dred2 = !isDarkTheme ? Color(0xffff8aad) : dredd2;
// Color dred22 = !isDarkTheme ? Color.fromARGB(179, 255, 138, 173) : dredd22;
// Color dred3 = !isDarkTheme ? Color.fromARGB(131, 0, 0, 0) : dredd3;
// Color dred4 = !isDarkTheme ? Colors.white : dredd4;

// const Color dredd1 = Color.fromARGB(199, 29, 27, 37);
// const Color dredd2 = Colors.grey;
// const Color dredd22 = Color.fromARGB(136, 158, 158, 158);
// const Color dredd3 = Color.fromARGB(131, 0, 0, 0);
// const Color dredd4 = Colors.white;

//Color(0x003da0e9);

// MaterialColor? dred = MaterialColor(dred2.value, {0:dred2});

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintRed = Paint()
      ..color = Colors.red
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final paintGreen = Paint()
      ..color = Colors.green
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final paintBlue = Paint()
      ..color = Colors.blue
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    // final path = Path()
    //   ..moveTo(50, 50)
    //   ..quadraticBezierTo(100, 10, 150, 50);
    // final rect = Rect.fromCircle(center: Offset(50, 50), radius: 50);

    canvas.drawLine(Offset(50, 50), Offset(150, 50), paintRed);
    canvas.drawLine(Offset(150, 50), Offset(150, 150), paintGreen);
    canvas.drawLine(Offset(150, 150), Offset(50, 150), paintBlue);
    canvas.drawLine(Offset(50, 150), Offset(50, 50), paintRed);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
