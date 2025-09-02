import 'package:equatable/equatable.dart';

class Page extends Equatable {
  final int? id;
  final String? title;
  final String? content;



  Page({
    required this.id,
    required this.content,
    this.title

  });

  @override
  List<Object?> get props => [
        id,
        title,
       content
      ];
}
