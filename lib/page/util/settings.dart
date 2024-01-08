import 'package:flutter/material.dart';
import 'package:violet_manager/util/settings.dart';

class TargetRepositorySettingsButton extends StatefulWidget {
  const TargetRepositorySettingsButton({super.key});

  @override
  State<TargetRepositorySettingsButton> createState() => TargetRepositorySettingsButtonState();
}

class TargetRepositorySettingsButtonState extends State<TargetRepositorySettingsButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await buildDialog(context);
      },
      child: const Text('Target Repository')
    );
  }
  buildDialog(BuildContext context) async {
    await Settings.init();
    TextEditingController repositoryController = TextEditingController(text: Settings.releaseChannel);
    TextField repositoryTextField = TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Owner/Build_Channel_Repository'
      ),
      controller: repositoryController,
    );
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Target Repository'),
          content: Wrap(
            children: [
              repositoryTextField
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
              onPressed: () async {
                Settings.setReleaseChannel(repositoryController.text);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}