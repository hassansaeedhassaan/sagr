import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'package:sagr/features/payroll/payroll_service.dart';
import 'package:sagr/theme/app_theme.dart';
import 'package:sagr/widgets/skeletons/app_skeleton.dart';

/// "My dues": what the user earned per event, overtime included, and every
/// deduction (leaving the zone, overrunning a break, arriving late).
class MyDuesScreen extends StatefulWidget {
  const MyDuesScreen({super.key});

  @override
  State<MyDuesScreen> createState() => _MyDuesScreenState();
}

class _MyDuesScreenState extends State<MyDuesScreen> {
  final _service = PayrollService();
  PayrollReport? _report;
  bool _failed = false;

  String get _locale => Get.locale?.toString() ?? 'ar';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final report = await _service.myReport();
      if (!mounted) return;
      setState(() {
        _report = report;
        _failed = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _failed = true);
    }
  }

  String _money(double v) => '${NumberFormat('#,##0.00', 'en').format(v)} ${'SAR'.tr}';

  String _hours(int minutes) =>
      '${minutes ~/ 60}:${(minutes % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffold,
      appBar: AppBar(
        title: Text('My dues'.tr),
        backgroundColor: AppTheme.scaffold,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        color: AppTheme.brand,
        child: _body(),
      ),
    );
  }

  Widget _body() {
    final report = _report;

    if (report == null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 160),
          if (_failed)
            _empty(Icons.cloud_off_rounded, 'Could not load your dues.'.tr)
          else
            Center(child: AppLoader.inline(color: AppTheme.brand)),
        ],
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        _summary(report),
        const SizedBox(height: 16),
        if (report.events.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: _empty(Icons.account_balance_wallet_outlined,
                'No dues yet. They appear here once you work an event.'.tr),
          )
        else
          ...report.events.map(_eventCard),
      ],
    );
  }

  Widget _empty(IconData icon, String text) => Column(
        children: [
          Icon(icon, size: 44, color: AppTheme.textHint),
          const SizedBox(height: 10),
          Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 14)),
        ],
      );

  Widget _summary(PayrollReport r) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.brand, AppTheme.brandDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Net dues'.tr,
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 4),
          Text(_money(r.net),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          Row(
            children: [
              _summaryStat('Earned'.tr, _money(r.gross)),
              _summaryStat('Deductions'.tr, '- ${_money(r.deductions)}'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _summaryStat('Worked hours'.tr, _hours(r.workedMinutes)),
              _summaryStat('Overtime hours'.tr, _hours(r.overtimeMinutes)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryStat(String label, String value) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 2),
            Text(value,
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      );

  Widget _eventCard(PayrollEvent e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.line),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          title: Text(e.eventName,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textTitle,
                  fontSize: 15)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              e.missingRate
                  ? 'Hourly rate not set yet'.tr
                  : '${'Net'.tr}: ${_money(e.net)}',
              style: TextStyle(
                  color: e.missingRate ? AppTheme.warning : AppTheme.brand,
                  fontWeight: FontWeight.w700,
                  fontSize: 13),
            ),
          ),
          children: [
            _line('Days worked'.tr, '${e.days}'),
            _line(
                '${'Regular hours'.tr} (${_hours(e.regularMinutes)})',
                e.basicRate == null
                    ? '—'
                    : '${_money(e.regularPay)}'),
            if (e.overtimeMinutes > 0)
              _line('${'Overtime hours'.tr} (${_hours(e.overtimeMinutes)})',
                  _money(e.overtimePay),
                  color: AppTheme.warning),
            _line('Earned'.tr, _money(e.gross), bold: true),
            if (e.deductions.isNotEmpty) ...[
              const Divider(height: 20),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text('Deductions'.tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textTitle)),
              ),
              const SizedBox(height: 6),
              ...e.deductions.map(_deduction),
            ],
            const Divider(height: 20),
            _line('Net'.tr, _money(e.net), bold: true, color: AppTheme.brand),
          ],
        ),
      ),
    );
  }

  Widget _deduction(PayrollDeduction d) {
    final when = DateFormat('d MMM, h:mm a', _locale).format(d.at);
    final detail = d.excusedMinutes > 0
        ? '${'Break'.tr} ${d.excusedMinutes} ${'min'.tr} · ${'Over by'.tr} ${d.minutes} ${'min'.tr}'
        : '${d.minutes} ${'min'.tr}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d.label,
                    style: const TextStyle(
                        color: AppTheme.textBody, fontSize: 13.5)),
                Text('$when · $detail',
                    style: const TextStyle(
                        color: AppTheme.textMuted, fontSize: 12)),
              ],
            ),
          ),
          d.waived
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withOpacity(.12),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text('Waived'.tr,
                      style: const TextStyle(
                          color: AppTheme.success,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                )
              : Text('- ${_money(d.amount)}',
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(
                      color: AppTheme.danger, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _line(String label, String value,
      {bool bold = false, Color? color}) {
    final style = TextStyle(
      color: color ?? (bold ? AppTheme.textTitle : AppTheme.textBody),
      fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
      fontSize: 13.5,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, textDirection: TextDirection.ltr, style: style),
        ],
      ),
    );
  }
}
