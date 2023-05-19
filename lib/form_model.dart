class ResponseForm {
  String? title;
  List<Fields>? fields;

  ResponseForm({this.title, this.fields});

  ResponseForm.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['fields'] != null) {
      fields = <Fields>[];
      json['fields'].forEach((v) {
        fields!.add(Fields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    if (fields != null) {
      data['fields'] = fields!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Fields {
  String? label;
  String? fieldType;
  List<Options>? options;

  Fields({
    this.label,
    this.fieldType,
    this.options,
  });

  Fields.fromJson(Map<String, dynamic> json) {
   
    label = json['label'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
    
    fieldType = json['fieldType'];
  
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    
    data['label'] = label;
  
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
   
    
    data['fieldType'] = fieldType;

    return data;
  }
}

class Options {
  String? color;
  bool? isFaulty;
  String? optionLabel;
  String? optionValue;

  Options({this.color, this.isFaulty, this.optionLabel, this.optionValue});

  Options.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    isFaulty = json['is_faulty'];
    optionLabel = json['optionLabel'];
    optionValue = json['optionValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['optionLabel'] = optionLabel;
    data['optionValue'] = optionValue;
    return data;
  }
}
