import 'package:flutter/material.dart';
import 'package:violet_manager/page/util/upate.dart';
import 'package:violet_manager/page/util/version.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          CurrentVersionWidget(),
          LatestVersionWidget(),
          UpdateWidget(),
        ],
      ),
    );
  }
}