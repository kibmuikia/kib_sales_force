import 'package:flutter/material.dart';
import 'package:kib_flutter_utils/kib_flutter_utils.dart';
import 'package:kib_sales_force/core/constants/app_constants.dart' show appName;
import 'package:kib_sales_force/presentation/screens/initial_my_home_page.dart'
    show MyHomePage;

class KibSalesForce extends StatefulWidgetK {
  KibSalesForce({super.key, super.tag = 'KibSalesForce'});

  @override
  StateK<KibSalesForce> createState() => _KibSalesForceState();
}

class _KibSalesForceState extends StateK<KibSalesForce> {
  @override
  void initState() {
    super.initState();
    // TODO: Initialize the app
  }

  @override
  Widget buildWithTheme(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: appName),
    );
  }

  //
}
