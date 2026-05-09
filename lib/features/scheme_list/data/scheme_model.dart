import 'package:equatable/equatable.dart';

class SchemeModel extends Equatable {
  final int schemeCode;
  final String schemeName;

  const SchemeModel({
    required this.schemeCode,
    required this.schemeName,
  });

  factory SchemeModel.fromJson(Map<String, dynamic> json) {
    return SchemeModel(
      schemeCode: json['schemeCode'] as int,
      schemeName: json['schemeName'] as String,
    );
  }

  @override
  List<Object?> get props => [schemeCode, schemeName];
}
