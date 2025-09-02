import 'dart:convert';

class Setting {
  String? title;
  String? contact_phone;
  String? contact_email;
  String? facebook;
  String? twitter;
  String? instagram;
  String? aboutus;
  int? points_per_iraq_dinar;
  int? points_limit_reserved_gift;
  List? statistics;
  List? sliders;
  String? content;

  Setting(
      {this.title,
      this.contact_phone,
      this.contact_email,
      this.facebook,
      this.twitter,
      this.instagram,
      this.aboutus,
      this.points_per_iraq_dinar,
      this.points_limit_reserved_gift,
      this.statistics,
      this.content,
      this.sliders});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'contact_phone': contact_phone,
      'contact_email': contact_email,
      'face': facebook,
      'twitter': twitter,
      'instagram': instagram,
      'aboutus': aboutus,
      'content': content,
      'points_per_iraq_dinar': points_per_iraq_dinar,
      'points_limit_reserved_gift': points_limit_reserved_gift,
      'list': statistics,
      'sliders': sliders
    };
  }

  factory Setting.fromMap(Map<String, dynamic> map) {
    return Setting(
        title: map['title'] ?? '',
        contact_phone: map['contact_phone'] ?? '',
        contact_email: map['contact_email'] ?? '',
        facebook: map['facebook'] ?? '',
        twitter: map['twitter'] ?? '',
        instagram: map['instagram'] ?? '',
        aboutus: map['aboutus'] ?? '',
        content: map['content'],
        points_per_iraq_dinar: map['points_per_iraq_dinar'] ?? '100',
        points_limit_reserved_gift: map['points_limit_reserved_gift'] ?? '',
        statistics: map['statistics'],
        sliders: map['sliders']);
  }

  String toJson() => json.encode(toMap());

  factory Setting.fromJson(String source) =>
      Setting.fromMap(json.decode(source));
}
