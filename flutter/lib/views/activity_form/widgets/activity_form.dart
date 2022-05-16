import 'package:flutter/material.dart';
import 'package:flutter_chapitre13/providers/city_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/activity_model.dart';

class ActivityForm extends StatefulWidget {
  final String cityName;
  const ActivityForm({
    Key? key,
    required this.cityName,
  }) : super(key: key);

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // late FocusNode _priceFocusNode;
  // late FocusNode _urlFocusNode;
  late Activity _newActivity;
  FormState get form {
    return _formKey.currentState!;
  }

  @override
  void initState() {
    _newActivity = Activity(
        city: widget.cityName,
        name: '',
        price: 0,
        image: '',
        status: ActivityStatus.ongoing);
    // _priceFocusNode = FocusNode();
    // _urlFocusNode = FocusNode();
    super.initState();
  }

  // @override
  // void dispose() {
  //   _priceFocusNode.dispose();
  //   _urlFocusNode.dispose();
  //   super.dispose();
  // }

  Future<void> submitForm() async {
    try {
      if (form.validate()) {
        _formKey.currentState!.save();
        await Provider.of<CityProvider>(
          context,
          listen: false,
        ).addActivityToCity(_newActivity);
        Navigator.pop(context);
      }
    } catch (e) {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Remplissez le nom';
                }
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Nom',
              ),
              onSaved: (value) => _newActivity.name = value!,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Remplissez le Prix';
                }
              },
              decoration: InputDecoration(
                hintText: 'Prix',
              ),
              onSaved: (value) => _newActivity.price = double.parse(value!),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Remplissez l\'Url';
                }
              },
              decoration: InputDecoration(
                hintText: 'Url Image',
              ),
              onSaved: (value) => _newActivity.image = value!,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: Text('annuler'),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: Text('sauvegarder'),
                  onPressed: submitForm,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
