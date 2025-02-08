import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}

Future<void> cURLWebView(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
    throw Exception('Could not launch $url');
  }
}

Future<void> launchAsInAppWebViewWithCustomHeaders(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.inAppWebView,
    webViewConfiguration: const WebViewConfiguration(
        headers: <String, String>{'my_header_key': 'my_header_value'}),
  )) {
    throw Exception('Could not launch $url');
  }
}

Future<void> launchInWebViewWithoutJavaScript(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.inAppWebView,
    webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
  )) {
    throw Exception('Could not launch $url');
  }
}

Future<void> launchInWebViewWithoutDomStorage(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.inAppWebView,
    webViewConfiguration: const WebViewConfiguration(enableDomStorage: false),
  )) {
    throw Exception('Could not launch $url');
  }
}

Future<void> launchUniversalLinkIOS(Uri url) async {
  final bool nativeAppLaunchSucceeded = await launchUrl(
    url,
    mode: LaunchMode.externalNonBrowserApplication,
  );
  if (!nativeAppLaunchSucceeded) {
    await launchUrl(url, mode: LaunchMode.inAppWebView //inAppBrowserView,
        );
  }
}

Widget launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
  if (snapshot.hasError) {
    return Text('Error: ${snapshot.error}');
  } else {
    return const Text('');
  }
}

Future<void> cURLPhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

Future<void> cURLMail(String email, String subject) async {
  final Uri launchUri = Uri(
    scheme: 'mailto',
    path: '$email',
    query: encodeQueryParameters(<String, String>{
      'subject': '$subject',
    }),
  );
  await launchUrl(launchUri);
}

Widget cURLLink(String linktoreach, Icon icon) {
  return Link(
    uri: Uri.parse(linktoreach
        // 'https://pub.dev/documentation/url_launcher/latest/link/link-library.html'
        ),
    target: LinkTarget.blank,
    builder: (BuildContext ctx, FollowLink? openLink) {
      return TextButton(
        onPressed: openLink,
        child: Text(linktoreach.length < 30
            ? linktoreach
            : '${linktoreach.substring(0, 25)}....', ),//${linktoreach.substring(linktoreach.length - 15)}', ),
        // icon: icon,
      );
    },
  );
}
