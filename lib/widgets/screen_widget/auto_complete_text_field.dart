import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:loy_eat/models/location_model.dart';
import 'package:loy_eat/widgets/layout_widget/color.dart';
import 'package:loy_eat/widgets/layout_widget/icon_widget.dart';
import 'package:loy_eat/widgets/layout_widget/text_widget.dart';
import 'package:loy_eat/widgets/layout_widget/title_appbar_widget.dart';

class AutoCompleteTextField extends StatelessWidget {
  const AutoCompleteTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _textEditingController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
          elevation: 0,
          titleSpacing: 0,
          centerTitle: true,
          leading: InkWell(
            onTap: () => Get.back(),
            child: const IconWidget(
              icon: Icons.clear,
              color: black,
              size: 24,
            ),
          ),
          title: const TitleAppBarWidget(
            text: "District",
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Container(
            color: white,
            height: 40,
            child: TypeAheadFormField(
              suggestionsCallback: (pattern) => menuDistrictItems.where((item) => item.toLowerCase().contains(pattern.toLowerCase())),
              suggestionsBoxDecoration: const SuggestionsBoxDecoration(
                color: white,
                clipBehavior: Clip.hardEdge,
              ),
              itemBuilder: (_, String item) => Container(
                padding: const EdgeInsets.all(10),
                child: TextWidget(
                  text: item,
                  size: 14,
                ),
              ),
              onSuggestionSelected: (String val){
                _textEditingController.text = val;
              },
              getImmediateSuggestions: true,
              hideSuggestionsOnKeyboardHide: false,
              hideOnEmpty: false,
              noItemsFoundBuilder: (context) => Container(
                padding: const EdgeInsets.all(10),
                child: const TextWidget(
                  text: "No district found",
                  size: 14,
                ),
              ),
              textFieldConfiguration: TextFieldConfiguration(
                autofocus: true,
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: "Please select your district",
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: silver,
                  ),
                  contentPadding: const EdgeInsets.only(left: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}