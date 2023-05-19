import 'dart:convert';

import 'package:flutter/material.dart';

import 'form_model.dart';

class DynamicForm extends StatefulWidget {
  const DynamicForm({super.key});

  @override
  State<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  List<ResponseForm> formResponse = [];
  bool isLoading = true;
  var dropdownvalue;
  var dateController = TextEditingController();
  bool switchValue = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getFromJson();
    });
  }

  getFromJson() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/json/short_form.json");
    final jsonResult = jsonDecode(data);

    setState(() {
      jsonResult.forEach(
          (element) => formResponse.add(ResponseForm.fromJson(element)));

      isLoading = false;
    });

    print(formResponse.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dynamic Form"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: formResponse.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formResponse[index].title!,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        myFormType(index)
                      ],
                    );
                  }),
            ),
    );
  }

  myFormType(index) {
    return ListView.separated(
      itemCount: formResponse[index].fields!.length,
      shrinkWrap: true,
      itemBuilder: (context, innerIndex) {
        return formResponse[index].fields![innerIndex].fieldType ==
                "DatetimePicker"
            ? myDatePicker()
            : formResponse[index].fields![innerIndex].fieldType == "TextInput"
                ? TextField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: formResponse[index].fields![innerIndex].label,
                    ),
                  )
                : formResponse[index].fields![innerIndex].fieldType ==
                        "SelectList"
                    ? dropDownWidget(
                        formResponse[index].fields![innerIndex].options)
                    : formResponse[index].fields![innerIndex].fieldType ==
                            "SwitchInput"
                        ? SwitchListTile(
                            value: switchValue,
                            title: Text(
                                formResponse[index].fields![innerIndex].label!),
                            onChanged: (value) {
                              setState(() {
                                switchValue = !switchValue;
                              });
                            })
                        : const Text("Other type");
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10);
      },
    );
  }

  Widget myDatePicker() {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          _selectDate(context);
        },
        child: AbsorbPointer(
          child: TextFormField(
            onChanged: (value) {},
            controller: dateController,
            obscureText: false,
            cursorColor: Theme.of(context).primaryColor,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 14.0,
            ),
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
              focusColor: Theme.of(context).primaryColor,
              filled: true,
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              labelText: "Date select",
              prefixIcon: const Icon(
                Icons.calendar_today,
                size: 18,
              ),
            ),
          ),
        ));
  }

  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1970),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        var date = DateTime.parse(picked.toString());
        var formatted = "${date.year}-${date.month}-${date.day}";
        dateController = TextEditingController();
        dateController = TextEditingController(text: formatted.toString());
      });
    }
  }

  dropDownWidget(List<Options>? items) {
    return DropdownButtonFormField<Options>(
      // Initial Value
      value: dropdownvalue,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        filled: true,
        hintStyle: TextStyle(color: Colors.grey[800]),
        hintText: items!.first.optionLabel!,
      ),
      borderRadius: BorderRadius.circular(10),
      // hint: Text(items.first.optionLabel!),

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: items.map((Options items) {
        return DropdownMenuItem<Options>(
          value: items,
          child: Text(items.optionValue!),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (newValue) {
        setState(() {
          dropdownvalue = newValue!;
        });
      },
    );
  }
}
