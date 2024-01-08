import 'package:flutter/material.dart';
import 'package:violet_manager/page/util/settings.dart';

class SettingsPage extends StatefulWidget {

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  
  @override
  Widget build(BuildContext context){
    return Container(
      child:Wrap(
        spacing: 8.0,
        children: [
          ListView.builder(
            itemCount: 1,
            shrinkWrap: true,
            itemBuilder: (context, index) => TargetRepositorySettingsButton(),
          )
        ],
      )
    );
  }
}
