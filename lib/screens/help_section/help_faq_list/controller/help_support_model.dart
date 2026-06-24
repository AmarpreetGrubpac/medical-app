// class HelpSupportModel {
//   bool? success;
//   int? code;
//   HelpModel? data;
//
//   HelpSupportModel({this.success, this.code, this.data});
//
//   HelpSupportModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     code = json['code'];
//     data = json['data'] != null ? new HelpModel.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['success'] = this.success;
//     data['code'] = this.code;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class HelpModel {
//   List<FaqCategories>? faqCategories;
//   int? count;
//
//   HelpModel({this.faqCategories, this.count});
//
//   HelpModel.fromJson(Map<String, dynamic> json) {
//     if (json['faq_categories'] != null) {
//       faqCategories = <FaqCategories>[];
//       json['faq_categories'].forEach((v) {
//         faqCategories!.add(new FaqCategories.fromJson(v));
//       });
//     }
//     count = json['count'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.faqCategories != null) {
//       data['faq_categories'] =
//           this.faqCategories!.map((v) => v.toJson()).toList();
//     }
//     data['count'] = this.count;
//     return data;
//   }
// }
//
// class FaqCategories {
//   String? id;
//   String? name;
//   String? iconId;
//   String? verticalId;
//   Null? description;
//   String? status;
//   int? index;
//   String? createdAt;
//   String? updatedAt;
//   Vertical? vertical;
//   Icon? icon;
//   Count? cCount;
//
//   FaqCategories(
//       {this.id,
//         this.name,
//         this.iconId,
//         this.verticalId,
//         this.description,
//         this.status,
//         this.index,
//         this.createdAt,
//         this.updatedAt,
//         this.vertical,
//         this.icon,
//         this.cCount});
//
//   FaqCategories.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     iconId = json['icon_id'];
//     verticalId = json['vertical_id'];
//     description = json['description'];
//     status = json['status'];
//     index = json['index'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     vertical = json['vertical'] != null
//         ? new Vertical.fromJson(json['vertical'])
//         : null;
//     icon = json['icon'] != null ? new Icon.fromJson(json['icon']) : null;
//     cCount = json['_count'] != null ? new Count.fromJson(json['_count']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['icon_id'] = this.iconId;
//     data['vertical_id'] = this.verticalId;
//     data['description'] = this.description;
//     data['status'] = this.status;
//     data['index'] = this.index;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     if (this.vertical != null) {
//       data['vertical'] = this.vertical!.toJson();
//     }
//     if (this.icon != null) {
//       data['icon'] = this.icon!.toJson();
//     }
//     if (this.cCount != null) {
//       data['_count'] = this.cCount!.toJson();
//     }
//     return data;
//   }
// }
//
// class Vertical {
//   String? id;
//   String? name;
//   String? createdAt;
//   String? updatedAt;
//
//   Vertical({this.id, this.name, this.createdAt, this.updatedAt});
//
//   Vertical.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }
//
// class Icon {
//   String? id;
//   String? name;
//   String? bucketKey;
//   String? createdAt;
//   String? updatedAt;
//
//   Icon({this.id, this.name, this.bucketKey, this.createdAt, this.updatedAt});
//
//   Icon.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     bucketKey = json['bucket_key'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['bucket_key'] = this.bucketKey;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }
//
// class Count {
//   int? questions;
//
//   Count({this.questions});
//
//   Count.fromJson(Map<String, dynamic> json) {
//     questions = json['questions'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['questions'] = this.questions;
//     return data;
//   }
// }
class HelpSupportResponse {
  bool? success;
  int? code;
  HelpSupportData? data;

  HelpSupportResponse({this.success, this.code, this.data});

  HelpSupportResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    data =
    json['data'] != null ? HelpSupportData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['success'] = success;
    dataMap['code'] = code;
    if (data != null) {
      dataMap['data'] = data!.toJson();
    }
    return dataMap;
  }
}

class HelpSupportData {
  List<Faq>? faqs;
  List<FaqCategory>? faqCategories;
  int? count;

  HelpSupportData({this.faqs, this.faqCategories, this.count});

  HelpSupportData.fromJson(Map<String, dynamic> json) {
    if (json['faqs'] != null) {
      faqs = (json['faqs'] as List)
          .map((e) => Faq.fromJson(e))
          .toList();
    }

    if (json['faq_categories'] != null) {
      faqCategories = (json['faq_categories'] as List)
          .map((e) => FaqCategory.fromJson(e))
          .toList();
    }

    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};

    if (faqs != null) {
      dataMap['faqs'] = faqs!.map((e) => e.toJson()).toList();
    }

    if (faqCategories != null) {
      dataMap['faq_categories'] =
          faqCategories!.map((e) => e.toJson()).toList();
    }

    dataMap['count'] = count;
    return dataMap;
  }
}

class Faq {
  String? id;
  String? question;
  String? answer;
  String? publishingStatus;
  String? status;
  List<dynamic>? attachments;
  String? createdAt;
  String? updatedAt;
  List<QuestionCategory>? categories;

  Faq({
    this.id,
    this.question,
    this.answer,
    this.publishingStatus,
    this.status,
    this.attachments,
    this.createdAt,
    this.updatedAt,
    this.categories,
  });

  Faq.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    publishingStatus = json['publishing_status'];
    status = json['status'];
    attachments = json['attachments'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

    if (json['categories'] != null) {
      categories = (json['categories'] as List)
          .map((e) => QuestionCategory.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['id'] = id;
    dataMap['question'] = question;
    dataMap['answer'] = answer;
    dataMap['publishing_status'] = publishingStatus;
    dataMap['status'] = status;
    dataMap['attachments'] = attachments;
    dataMap['created_at'] = createdAt;
    dataMap['updated_at'] = updatedAt;

    if (categories != null) {
      dataMap['categories'] =
          categories!.map((e) => e.toJson()).toList();
    }

    return dataMap;
  }
}

class QuestionCategory {
  String? id;
  String? questionId;
  String? categoryId;
  String? createdAt;
  String? updatedAt;
  FaqCategory? category;

  QuestionCategory({
    this.id,
    this.questionId,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  QuestionCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionId = json['question_id'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    category = json['category'] != null
        ? FaqCategory.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['id'] = id;
    dataMap['question_id'] = questionId;
    dataMap['category_id'] = categoryId;
    dataMap['created_at'] = createdAt;
    dataMap['updated_at'] = updatedAt;
    if (category != null) {
      dataMap['category'] = category!.toJson();
    }
    return dataMap;
  }
}

class FaqCategory {
  String? id;
  String? name;
  String? iconId;
  String? verticalId;
  String? description;
  String? status;
  int? index;
  String? createdAt;
  String? updatedAt;
  Vertical? vertical;
  AppIcon? icon;
  Count? count;

  FaqCategory({
    this.id,
    this.name,
    this.iconId,
    this.verticalId,
    this.description,
    this.status,
    this.index,
    this.createdAt,
    this.updatedAt,
    this.vertical,
    this.icon,
    this.count,
  });

  FaqCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    iconId = json['icon_id'];
    verticalId = json['vertical_id'];
    description = json['description'];
    status = json['status'];
    index = json['index'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    vertical =
    json['vertical'] != null ? Vertical.fromJson(json['vertical']) : null;
    icon = json['icon'] != null ? AppIcon.fromJson(json['icon']) : null;
    count =
    json['_count'] != null ? Count.fromJson(json['_count']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};
    dataMap['id'] = id;
    dataMap['name'] = name;
    dataMap['icon_id'] = iconId;
    dataMap['vertical_id'] = verticalId;
    dataMap['description'] = description;
    dataMap['status'] = status;
    dataMap['index'] = index;
    dataMap['created_at'] = createdAt;
    dataMap['updated_at'] = updatedAt;

    if (vertical != null) {
      dataMap['vertical'] = vertical!.toJson();
    }
    if (icon != null) {
      dataMap['icon'] = icon!.toJson();
    }
    if (count != null) {
      dataMap['_count'] = count!.toJson();
    }

    return dataMap;
  }
}

class Vertical {
  String? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Vertical({this.id, this.name, this.createdAt, this.updatedAt});

  Vertical.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class AppIcon {
  String? id;
  String? name;
  String? bucketKey;
  String? createdAt;
  String? updatedAt;

  AppIcon({this.id, this.name, this.bucketKey, this.createdAt, this.updatedAt});

  AppIcon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    bucketKey = json['bucket_key'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bucket_key': bucketKey,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Count {
  int? questions;

  Count({this.questions});

  Count.fromJson(Map<String, dynamic> json) {
    questions = json['questions'];
  }

  Map<String, dynamic> toJson() {
    return {'questions': questions};
  }
}
