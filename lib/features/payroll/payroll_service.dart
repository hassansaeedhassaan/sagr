import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sagr/helper/base_url.dart';

double _num(Object? v) => v is num ? v.toDouble() : double.tryParse('$v') ?? 0;
int _int(Object? v) => v is num ? v.toInt() : int.tryParse('$v') ?? 0;

/// One deduction: leaving the zone, overrunning a break, or arriving late.
class PayrollDeduction {
  final String type;
  final String label;
  final DateTime at;
  final int minutes;
  final int excusedMinutes;
  final double amount;
  final bool waived;
  final bool ongoing;

  const PayrollDeduction({
    required this.type,
    required this.label,
    required this.at,
    required this.minutes,
    required this.excusedMinutes,
    required this.amount,
    required this.waived,
    required this.ongoing,
  });

  factory PayrollDeduction.fromJson(Map<String, dynamic> json) =>
      PayrollDeduction(
        type: json['type']?.toString() ?? '',
        label: json['label']?.toString() ?? '',
        at: DateTime.tryParse('${json['at']}'.replaceFirst(' ', 'T')) ??
            DateTime.now(),
        minutes: _int(json['minutes']),
        excusedMinutes: _int(json['excused_minutes']),
        amount: _num(json['amount']),
        waived: json['waived'] == true,
        ongoing: json['ongoing'] == true,
      );
}

/// What the user earned on one event (`/payroll/my-report`).
class PayrollEvent {
  final int eventId;
  final String eventName;
  final int days;
  final int regularMinutes;
  final int overtimeMinutes;
  final double? basicRate;
  final double? overtimeRate;
  final double regularPay;
  final double overtimePay;
  final double gross;
  final double deductionsTotal;
  final double net;
  final bool missingRate;
  final List<PayrollDeduction> deductions;

  const PayrollEvent({
    required this.eventId,
    required this.eventName,
    required this.days,
    required this.regularMinutes,
    required this.overtimeMinutes,
    required this.basicRate,
    required this.overtimeRate,
    required this.regularPay,
    required this.overtimePay,
    required this.gross,
    required this.deductionsTotal,
    required this.net,
    required this.missingRate,
    required this.deductions,
  });

  factory PayrollEvent.fromJson(Map<String, dynamic> json) {
    final event = json['event'] is Map
        ? Map<String, dynamic>.from(json['event'] as Map)
        : <String, dynamic>{};
    return PayrollEvent(
      eventId: _int(event['id']),
      eventName: event['name']?.toString() ?? '',
      days: _int(json['days_count']),
      regularMinutes: _int(json['regular_minutes']),
      overtimeMinutes: _int(json['overtime_minutes']),
      basicRate: json['basic_rate'] == null ? null : _num(json['basic_rate']),
      overtimeRate:
          json['overtime_rate'] == null ? null : _num(json['overtime_rate']),
      regularPay: _num(json['regular_pay']),
      overtimePay: _num(json['overtime_pay']),
      gross: _num(json['gross']),
      deductionsTotal: _num(json['deductions_total']),
      net: _num(json['net']),
      missingRate: json['missing_rate'] == true,
      deductions: (json['deductions'] is List ? json['deductions'] as List : [])
          .whereType<Map>()
          .map((e) => PayrollDeduction.fromJson(Map<String, dynamic>.from(e)))
          // Exits too short for any tier are not worth a line.
          .where((d) => d.amount > 0 || d.waived)
          .toList(),
    );
  }
}

class PayrollReport {
  final int workedMinutes;
  final int overtimeMinutes;
  final double gross;
  final double deductions;
  final double net;
  final List<PayrollEvent> events;

  const PayrollReport({
    required this.workedMinutes,
    required this.overtimeMinutes,
    required this.gross,
    required this.deductions,
    required this.net,
    required this.events,
  });
}

/// `GET /payroll/my-report`: the user's pay, overtime and deductions.
class PayrollService {
  PayrollService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 20),
            ));

  final Dio _dio;
  final _storage = GetStorage();

  Future<PayrollReport> myReport({String? from, String? to}) async {
    final response = await _dio.get(
      '$BASEURL/payroll/my-report',
      queryParameters: {
        if (from != null) 'from': from,
        if (to != null) 'to': to,
      },
      options: Options(headers: {
        'Authorization': 'Bearer ${_storage.read('access_token')}',
        'Accept': 'application/json',
      }),
    );

    final body = response.data is Map
        ? Map<String, dynamic>.from(response.data as Map)
        : <String, dynamic>{};
    final data = body['data'] is Map
        ? Map<String, dynamic>.from(body['data'] as Map)
        : <String, dynamic>{};
    final totals = data['totals'] is Map
        ? Map<String, dynamic>.from(data['totals'] as Map)
        : <String, dynamic>{};

    return PayrollReport(
      workedMinutes: _int(totals['worked_minutes']),
      overtimeMinutes: _int(totals['overtime_minutes']),
      gross: _num(totals['gross']),
      deductions: _num(totals['deductions']),
      net: _num(totals['net']),
      events: (data['events'] is List ? data['events'] as List : [])
          .whereType<Map>()
          .map((e) => PayrollEvent.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}
