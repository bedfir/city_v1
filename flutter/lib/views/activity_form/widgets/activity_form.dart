import 'package:flutter/material.dart';
import 'package:flutter_chapitre13/providers/city_provider.dart';
import 'package:flutter_chapitre13/views/activity_form/widgets/activity_form_image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../../../models/activity_model.dart';
import '../../apis/google_api.dart';
import 'activity_form_autocomplete.dart';

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
  late FocusNode _urlFocusNode;
  late FocusNode _addressFocusNode;
  late Activity _newActivity;
  String? _nameInputAsync;
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;
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
      location: LocationActivity(
        address: null,
        latitude: null,
        longitude: null,
      ),
      status: ActivityStatus.ongoing,
    );
    // _priceFocusNode = FocusNode();
    _urlFocusNode = FocusNode();
    _addressFocusNode = FocusNode();
    _addressFocusNode.addListener(() async {
      if (_addressFocusNode.hasFocus) {
        var location = await showInputAutocomplete(context);
        _newActivity.location = location;

        setState(() {
          if (location != null) {
            _addressController.text = location.address!;
          }
        });
        _urlFocusNode.requestFocus();
      }
    });
    super.initState();
  }

  void _getCurrentLocation() async {
    try {
      LocationData userLocation = await Location().getLocation();
      String address = await getAddressFromLatLng(
        lat: userLocation.latitude!,
        lng: userLocation.longitude!,
      );
      _newActivity.location = LocationActivity(
        address: address,
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
      setState(() {
        _addressController.text = address;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    // _priceFocusNode.dispose();
    _urlFocusNode.dispose();
    _addressFocusNode.dispose();
    _urlController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    try {
      CityProvider cityProvider = Provider.of<CityProvider>(
        context,
        listen: false,
      );
      form.validate();
      _formKey.currentState!.save();
      setState(() => _isLoading = true);
      _nameInputAsync = await cityProvider.verifyIfActivityNameIsUnique(
        widget.cityName,
        _newActivity.name,
      );
      if (form.validate()) {
        await cityProvider.addActivityToCity(_newActivity);
        Navigator.pop(context);
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void updateUrlField(String url) {
    setState(() {
      _urlController.text = url;
    });
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
                } else if (_nameInputAsync != null) {
                  return _nameInputAsync;
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Nom',
              ),
              onSaved: (value) => _newActivity.name = value!,
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Remplissez le Prix';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Prix',
              ),
              onSaved: (value) => _newActivity.price = double.parse(value!),
            ),
            TextFormField(
              controller: _addressController,
              focusNode: _addressFocusNode,
              decoration: InputDecoration(
                hintText: 'Adresse',
              ),
              onSaved: (value) => _newActivity.location!.address = value!,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 10,
            ),
            TextButton.icon(
              onPressed: _getCurrentLocation,
              label: Text('Utillisez ma positin actuelle'),
              icon: Icon(Icons.gps_fixed),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              focusNode: _urlFocusNode,
              controller: _urlController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Remplissez l\'url';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Url Image',
              ),
              onSaved: (value) => _newActivity.image = value!,
            ),
            SizedBox(
              height: 30,
            ),
            ActivityFormImagePicker(updateUrl: updateUrlField),
            SizedBox(
              height: 30,
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
                  onPressed: _isLoading ? null : submitForm,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
