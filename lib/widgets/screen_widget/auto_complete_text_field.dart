import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';

class AutoCompleteTextField extends StatelessWidget {
  const AutoCompleteTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _textEditingController = TextEditingController();
    const countriesList = [
      "Cambodia",
      "Thai",
      "Male",
    ];

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: white,
        appBar: null,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
          child: Container(
            color: rabbit,
            height: MediaQuery.of(context).size.height / 100 * 7,
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: TypeAheadFormField(
              suggestionsCallback: (pattern) => countriesList.where((item) => item.toLowerCase().contains(pattern.toLowerCase())),
              itemBuilder: (_, String item) => ListTile(title: Text(item),),
              onSuggestionSelected: (String val){
                _textEditingController.text = val;
              },
              getImmediateSuggestions: true,
              hideSuggestionsOnKeyboardHide: false,
              hideOnEmpty: false,
              noItemsFoundBuilder: (context) => const Padding(
                padding: EdgeInsets.all(8),
                child: Text('No item found'),
              ),
              textFieldConfiguration: TextFieldConfiguration(
                decoration: const InputDecoration(
                  hintText: "type your country",
                  border: OutlineInputBorder(),
                ),
                controller: _textEditingController,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
