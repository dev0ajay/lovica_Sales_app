
import 'dart:convert';

TermsAndConditionResponse termsAndConditionResponseFromJson(String str) => TermsAndConditionResponse.fromJson(json.decode(str));

String termsAndConditionResponseToJson(TermsAndConditionResponse data) => json.encode(data.toJson());

class TermsAndConditionResponse {
  final String cmsManagementId;
  final String headingEn;
  final String headingAr;
  final String contentEn;
  final String contentAr;

  TermsAndConditionResponse({
    required this.cmsManagementId,
    required this.headingEn,
    required this.headingAr,
    required this.contentEn,
    required this.contentAr,
  });

  factory TermsAndConditionResponse.fromJson(Map<String, dynamic> json) => TermsAndConditionResponse(
    cmsManagementId: json["cms_management_id"],
    headingEn: json["heading_en"],
    headingAr: json["heading_ar"],
    contentEn: json["content_en"],
    contentAr: json["content_ar"],
  );

  Map<String, dynamic> toJson() => {
    "cms_management_id": cmsManagementId,
    "heading_en": headingEn,
    "heading_ar": headingAr,
    "content_en": contentEn,
    "content_ar": contentAr,
  };
}
