import 'package:equatable/equatable.dart';

class NavModel extends Equatable {
  final String date;
  final String nav;

  const NavModel({
    required this.date,
    required this.nav,
  });

  factory NavModel.fromJson(Map<String, dynamic> json) {
    return NavModel(
      date: json['date'] as String,
      nav: json['nav'] as String,
    );
  }

  double get navAsDouble => double.tryParse(nav) ?? 0.0;

  @override
  List<Object?> get props => [date, nav];
}

class SchemeDetailModel extends Equatable {
  final int schemeCode;
  final String schemeName;
  final String fundHouse;
  final String schemeType;
  final String schemeCategory;
  final List<NavModel> data;

  const SchemeDetailModel({
    required this.schemeCode,
    required this.schemeName,
    required this.fundHouse,
    required this.schemeType,
    required this.schemeCategory,
    required this.data,
  });

  factory SchemeDetailModel.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    final dataList = json['data'] as List? ?? [];
    
    return SchemeDetailModel(
      schemeCode: meta['scheme_code'] as int? ?? 0,
      schemeName: meta['scheme_name'] as String? ?? 'Unknown',
      fundHouse: meta['fund_house'] as String? ?? 'Unknown',
      schemeType: meta['scheme_type'] as String? ?? 'Unknown',
      schemeCategory: meta['scheme_category'] as String? ?? 'Unknown',
      data: dataList.map((e) => NavModel.fromJson(e)).toList(),
    );
  }

  @override
  List<Object?> get props => [schemeCode, schemeName, fundHouse, schemeType, schemeCategory, data];
}
