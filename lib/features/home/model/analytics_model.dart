import 'package:equatable/equatable.dart';

///
class AnalyticsModel extends Equatable {
  ///
  const AnalyticsModel({
    required this.todayMorningMilk,
    required this.todayEveningMilk,
    required this.todayTotalMilk,
    required this.monthTotalMilk,
    required this.todayIncome,
    required this.monthIncome,
  });

  ///
  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) => (value as num?)?.toDouble() ?? 0.0;

    return AnalyticsModel(
      todayMorningMilk: toDouble(json['today_morning_milk']),
      todayEveningMilk: toDouble(json['today_evening_milk']),
      todayTotalMilk: toDouble(json['today_total_milk']),
      monthTotalMilk: toDouble(json['month_total_milk']),
      todayIncome: toDouble(json['today_income']),
      monthIncome: toDouble(json['month_income']),
    );
  }

  ///
  final double todayMorningMilk;

  ///
  final double todayEveningMilk;

  ///
  final double todayTotalMilk;

  ///
  final double monthTotalMilk;

  ///
  final double todayIncome;

  ///
  final double monthIncome;

  @override
  List<Object> get props => <Object>[
    todayMorningMilk,
    todayEveningMilk,
    todayTotalMilk,
    monthTotalMilk,
    todayIncome,
    monthIncome,
  ];
}
