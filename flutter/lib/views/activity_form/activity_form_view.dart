import 'package:flutter/material.dart';
import '../../widgets/dyma_drawer.dart';
import 'widgets/activity_form.dart';

class ActivityFormView extends StatelessWidget {
  static const String routeName = '/activity_form';

  ActivityFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String cityName = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('ajouter une activité'),
      ),
      drawer: DymaDrawer(),
      body: SingleChildScrollView(
        child: ActivityForm(cityName: cityName),
      ),
    );
  }
}
