import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sagr/theme/app_theme.dart';

/// Building blocks for the complete-profile flow.
///
/// Everything here is platform-adaptive: pickers, sheets and check marks use
/// Cupertino on iOS and Material elsewhere, so the form reads as native on
/// both instead of a web-style card of mixed dropdown packages.

bool isCupertinoPlatform(BuildContext context) {
  final platform = Theme.of(context).platform;
  return platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
}

// ---------------------------------------------------------------------------
// Layout
// ---------------------------------------------------------------------------

/// Segmented progress bar with a "Step x of y" caption.
class ProfileStepProgress extends StatelessWidget {
  final int current;
  final int total;

  const ProfileStepProgress({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(total, (i) {
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                height: 4,
                margin: EdgeInsetsDirectional.only(end: i == total - 1 ? 0 : 6),
                decoration: BoxDecoration(
                  color: i <= current ? AppTheme.brand : AppTheme.line,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        Text(
          'Step @current of @total'.trParams({
            'current': '${current + 1}',
            'total': '$total',
          }),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.textMuted,
          ),
        ),
      ],
    );
  }
}

/// A grouped, inset card of related fields (like an iOS Settings group).
class FormSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? footer;
  final List<Widget> children;

  const FormSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 4, bottom: 8),
          child: Row(
            children: [
              Icon(icon, size: 16, color: AppTheme.textMuted),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textMuted,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            border: Border.all(color: AppTheme.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) const SizedBox(height: 16),
                children[i],
              ],
            ],
          ),
        ),
        if (footer != null)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(4, 8, 4, 0),
            child: Text(
              footer!,
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: AppTheme.textHint,
              ),
            ),
          ),
      ],
    );
  }
}

/// A field with its label sitting above it rather than floating inside.
class LabeledField extends StatelessWidget {
  final String label;
  final bool optional;
  final Widget child;

  const LabeledField({
    super.key,
    required this.label,
    required this.child,
    this.optional = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 2, bottom: 6),
          child: Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textBody,
                ),
              ),
              if (optional) ...[
                const SizedBox(width: 6),
                Text(
                  'Optional'.tr,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textHint,
                  ),
                ),
              ],
            ],
          ),
        ),
        child,
      ],
    );
  }
}

/// Filled, borderless input — the look every field in the flow shares.
InputDecoration profileInputDecoration({
  String? hint,
  Widget? prefixIcon,
  Widget? suffixIcon,
  String? errorText,
}) {
  OutlineInputBorder border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.radius),
        borderSide: BorderSide(color: color, width: width),
      );

  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppTheme.textHint, fontSize: 15),
    errorText: errorText,
    errorMaxLines: 2,
    filled: true,
    fillColor: AppTheme.field,
    isDense: true,
    prefixIcon: prefixIcon,
    prefixIconColor: AppTheme.textMuted,
    suffixIcon: suffixIcon,
    suffixIconColor: AppTheme.textMuted,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: border(Colors.transparent),
    enabledBorder: border(Colors.transparent),
    focusedBorder: border(AppTheme.brand, 1.5),
    errorBorder: border(AppTheme.danger),
    focusedErrorBorder: border(AppTheme.danger, 1.5),
  );
}

/// Sticky primary action at the bottom of the flow.
class ProfileBottomBar extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onPressed;

  const ProfileBottomBar({
    super.key,
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.line)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 52,
          width: double.infinity,
          child: FilledButton(
            onPressed: loading ? null : onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.brand,
              disabledBackgroundColor: AppTheme.brand.withValues(alpha: 0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: loading
                  ? const SizedBox(
                      key: ValueKey('loading'),
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator.adaptive(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        backgroundColor: Colors.white24,
                      ),
                    )
                  : Text(label,
                      key: ValueKey(label),
                      style: const TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Selection
// ---------------------------------------------------------------------------

/// Tappable field that opens a searchable native sheet to pick one item.
class SelectFormField<T> extends StatelessWidget {
  final String title;
  final String hint;
  final T? value;
  final List<T> items;
  final bool loading;
  final String Function(T) itemLabel;
  final Object? Function(T) itemKey;
  final ValueChanged<T> onChanged;
  final IconData? icon;
  final bool required;

  const SelectFormField({
    super.key,
    required this.title,
    required this.hint,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.itemKey,
    required this.onChanged,
    this.loading = false,
    this.icon,
    this.required = true,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: value,
      validator: (v) =>
          required && (v ?? value) == null ? 'Please choose one'.tr : null,
      builder: (field) {
        final current = field.value ?? value;
        return _PickerBox(
          text: current == null ? hint : itemLabel(current),
          isPlaceholder: current == null,
          icon: icon,
          loading: loading,
          errorText: field.errorText,
          onTap: loading
              ? null
              : () async {
                  FocusScope.of(context).unfocus();
                  final picked = await showSelectionSheet<T>(
                    context: context,
                    title: title,
                    items: items,
                    itemLabel: itemLabel,
                    itemKey: itemKey,
                    selected: current == null ? const [] : [current],
                  );
                  if (picked != null && picked.isNotEmpty) {
                    field.didChange(picked.first);
                    onChanged(picked.first);
                  }
                },
        );
      },
    );
  }
}

/// Like [SelectFormField] but lets the user tick several items.
class MultiSelectFormField<T> extends StatelessWidget {
  final String title;
  final String hint;
  final List<T> values;
  final List<T> items;
  final bool loading;
  final String Function(T) itemLabel;
  final Object? Function(T) itemKey;
  final ValueChanged<List<T>> onChanged;
  final IconData? icon;
  final String? requiredMessage;

  const MultiSelectFormField({
    super.key,
    required this.title,
    required this.hint,
    required this.values,
    required this.items,
    required this.itemLabel,
    required this.itemKey,
    required this.onChanged,
    this.loading = false,
    this.icon,
    this.requiredMessage,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<List<T>>(
      initialValue: values,
      validator: (v) => requiredMessage != null && (v ?? values).isEmpty
          ? requiredMessage
          : null,
      builder: (field) {
        final current = field.value ?? values;
        return _PickerBox(
          text: current.isEmpty ? hint : current.map(itemLabel).join('، '),
          isPlaceholder: current.isEmpty,
          icon: icon,
          loading: loading,
          errorText: field.errorText,
          onTap: loading
              ? null
              : () async {
                  FocusScope.of(context).unfocus();
                  final picked = await showSelectionSheet<T>(
                    context: context,
                    title: title,
                    items: items,
                    itemLabel: itemLabel,
                    itemKey: itemKey,
                    selected: current,
                    multiple: true,
                  );
                  if (picked != null) {
                    field.didChange(picked);
                    onChanged(picked);
                  }
                },
        );
      },
    );
  }
}

/// Read-only box that looks like an input and opens something on tap.
class _PickerBox extends StatelessWidget {
  final String text;
  final bool isPlaceholder;
  final IconData? icon;
  final bool loading;
  final String? errorText;
  final VoidCallback? onTap;

  const _PickerBox({
    required this.text,
    required this.isPlaceholder,
    required this.loading,
    required this.onTap,
    this.icon,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radius),
      child: InputDecorator(
        isEmpty: false,
        decoration: profileInputDecoration(
          errorText: errorText,
          prefixIcon: icon == null ? null : Icon(icon, size: 20),
          suffixIcon: loading
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                  ),
                )
              : const Icon(Icons.unfold_more_rounded, size: 20),
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15,
            color: isPlaceholder ? AppTheme.textHint : AppTheme.textTitle,
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet with search + list. Returns the chosen items, or null when
/// dismissed. Single-select closes on tap; multi-select closes on "Done".
Future<List<T>?> showSelectionSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> items,
  required String Function(T) itemLabel,
  required Object? Function(T) itemKey,
  List<T> selected = const [],
  bool multiple = false,
}) {
  return showModalBottomSheet<List<T>>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: AppTheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _SelectionSheet<T>(
      title: title,
      items: items,
      itemLabel: itemLabel,
      itemKey: itemKey,
      selected: selected,
      multiple: multiple,
    ),
  );
}

class _SelectionSheet<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final String Function(T) itemLabel;
  final Object? Function(T) itemKey;
  final List<T> selected;
  final bool multiple;

  const _SelectionSheet({
    required this.title,
    required this.items,
    required this.itemLabel,
    required this.itemKey,
    required this.selected,
    required this.multiple,
  });

  @override
  State<_SelectionSheet<T>> createState() => _SelectionSheetState<T>();
}

class _SelectionSheetState<T> extends State<_SelectionSheet<T>> {
  late final Set<Object?> _keys = widget.selected.map(widget.itemKey).toSet();
  String _query = '';

  bool get _searchable => widget.items.length > 7;

  List<T> get _visible {
    if (_query.isEmpty) return widget.items;
    final q = _query.toLowerCase();
    return widget.items
        .where((i) => widget.itemLabel(i).toLowerCase().contains(q))
        .toList();
  }

  void _tap(T item) {
    HapticFeedback.selectionClick();
    if (!widget.multiple) {
      Navigator.of(context).pop(<T>[item]);
      return;
    }
    setState(() {
      final key = widget.itemKey(item);
      _keys.contains(key) ? _keys.remove(key) : _keys.add(key);
    });
  }

  void _done() {
    Navigator.of(context).pop(
      widget.items.where((i) => _keys.contains(widget.itemKey(i))).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cupertino = isCupertinoPlatform(context);
    final visible = _visible;
    final maxHeight = MediaQuery.of(context).size.height * 0.75;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textTitle,
                      ),
                    ),
                  ),
                  if (widget.multiple)
                    TextButton(
                      onPressed: _done,
                      child: Text(
                        'Done'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.brand,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (_searchable)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: cupertino
                    ? CupertinoSearchTextField(
                        placeholder: 'Search'.tr,
                        onChanged: (v) => setState(() => _query = v.trim()),
                      )
                    : TextField(
                        onChanged: (v) => setState(() => _query = v.trim()),
                        decoration: profileInputDecoration(
                          hint: 'Search'.tr,
                          prefixIcon: const Icon(Icons.search_rounded),
                        ),
                      ),
              ),
            Flexible(
              child: visible.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        widget.items.isEmpty
                            ? 'Loading, please try again'.tr
                            : 'No results'.tr,
                        style: const TextStyle(color: AppTheme.textMuted),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: visible.length,
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        indent: 20,
                        endIndent: 20,
                        color: AppTheme.line,
                      ),
                      itemBuilder: (_, i) {
                        final item = visible[i];
                        final checked = _keys.contains(widget.itemKey(item));
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          title: Text(
                            widget.itemLabel(item),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  checked ? FontWeight.w600 : FontWeight.w400,
                              color: AppTheme.textTitle,
                            ),
                          ),
                          trailing: checked
                              ? Icon(
                                  cupertino
                                      ? CupertinoIcons.checkmark_alt
                                      : Icons.check_rounded,
                                  color: AppTheme.brand,
                                )
                              : null,
                          onTap: () => _tap(item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Date
// ---------------------------------------------------------------------------

/// Wheel picker in a sheet on iOS, calendar dialog on Android.
Future<DateTime?> showAdaptiveDatePicker({
  required BuildContext context,
  required DateTime initial,
  required DateTime first,
  required DateTime last,
}) async {
  if (!isCupertinoPlatform(context)) {
    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      initialDatePickerMode: DatePickerMode.year,
    );
  }

  var temp = initial;
  return showCupertinoModalPopup<DateTime>(
    context: context,
    builder: (sheetContext) => Container(
      height: 300,
      color: CupertinoColors.systemBackground.resolveFrom(sheetContext),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: Text('Cancel'.tr),
                  onPressed: () => Navigator.of(sheetContext).pop(),
                ),
                CupertinoButton(
                  child: Text(
                    'Done'.tr,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onPressed: () => Navigator.of(sheetContext).pop(temp),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: initial,
                minimumDate: first,
                maximumDate: last,
                onDateTimeChanged: (d) => temp = d,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Field that shows a date and opens [showAdaptiveDatePicker].
class DateFormField extends StatelessWidget {
  final DateTime? value;
  final String hint;
  final DateTime first;
  final DateTime last;
  final ValueChanged<DateTime> onChanged;
  final String requiredMessage;

  const DateFormField({
    super.key,
    required this.value,
    required this.hint,
    required this.first,
    required this.last,
    required this.onChanged,
    required this.requiredMessage,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: value,
      validator: (v) => (v ?? value) == null ? requiredMessage : null,
      builder: (field) {
        final current = field.value ?? value;
        return _PickerBox(
          text: current == null
              ? hint
              : MaterialLocalizations.of(context).formatMediumDate(current),
          isPlaceholder: current == null,
          icon: Icons.cake_outlined,
          loading: false,
          errorText: field.errorText,
          onTap: () async {
            FocusScope.of(context).unfocus();
            final picked = await showAdaptiveDatePicker(
              context: context,
              initial: current ?? DateTime(last.year - 7, 1, 1),
              first: first,
              last: last,
            );
            if (picked != null) {
              field.didChange(picked);
              onChanged(picked);
            }
          },
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Photo + documents
// ---------------------------------------------------------------------------

enum PhotoSource { camera, gallery, remove }

/// Native action sheet: take photo / choose from library / remove.
Future<PhotoSource?> showPhotoSourceSheet(BuildContext context,
    {required bool hasPhoto}) {
  if (isCupertinoPlatform(context)) {
    return showCupertinoModalPopup<PhotoSource>(
      context: context,
      builder: (c) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(c).pop(PhotoSource.camera),
            child: Text('Take photo'.tr),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(c).pop(PhotoSource.gallery),
            child: Text('Choose from library'.tr),
          ),
          if (hasPhoto)
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(c).pop(PhotoSource.remove),
              child: Text('Remove photo'.tr),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.of(c).pop(),
          child: Text('Cancel'.tr),
        ),
      ),
    );
  }

  return showModalBottomSheet<PhotoSource>(
    context: context,
    showDragHandle: true,
    useSafeArea: true,
    backgroundColor: AppTheme.surface,
    builder: (c) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: Text('Take photo'.tr),
            onTap: () => Navigator.of(c).pop(PhotoSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: Text('Choose from library'.tr),
            onTap: () => Navigator.of(c).pop(PhotoSource.gallery),
          ),
          if (hasPhoto)
            ListTile(
              leading:
                  const Icon(Icons.delete_outline, color: AppTheme.danger),
              title: Text('Remove photo'.tr,
                  style: const TextStyle(color: AppTheme.danger)),
              onTap: () => Navigator.of(c).pop(PhotoSource.remove),
            ),
        ],
      ),
    ),
  );
}

/// Circular profile photo with a camera badge; validates like a form field.
class AvatarFormField extends StatelessWidget {
  final String path;
  final VoidCallback onTap;
  final String requiredMessage;

  const AvatarFormField({
    super.key,
    required this.path,
    required this.onTap,
    required this.requiredMessage,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: path,
      validator: (_) => path.isEmpty ? requiredMessage : null,
      builder: (field) {
        final hasPhoto = path.isNotEmpty;
        final hasError = field.hasError && !hasPhoto;
        return Column(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.field,
                      border: Border.all(
                        color: hasError ? AppTheme.danger : AppTheme.surface,
                        width: 3,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                      image: hasPhoto
                          ? DecorationImage(
                              image: FileImage(File(path)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: hasPhoto
                        ? null
                        : const Icon(Icons.person_rounded,
                            size: 52, color: AppTheme.textHint),
                  ),
                  PositionedDirectional(
                    end: 0,
                    bottom: 2,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppTheme.brand,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.surface, width: 3),
                      ),
                      child: const Icon(Icons.photo_camera_rounded,
                          size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              hasPhoto ? 'Change photo'.tr : 'Profile photo'.tr,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.textTitle,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              hasError ? requiredMessage : 'Add a clear photo of your face'.tr,
              style: TextStyle(
                fontSize: 13,
                color: hasError ? AppTheme.danger : AppTheme.textMuted,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Document picker row: icon, title, file name or hint, Upload/Replace pill.
class DocumentFormField extends StatelessWidget {
  final String title;
  final String hint;
  final String path;
  final IconData icon;
  final VoidCallback onTap;
  final String requiredMessage;

  const DocumentFormField({
    super.key,
    required this.title,
    required this.hint,
    required this.path,
    required this.icon,
    required this.onTap,
    required this.requiredMessage,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: path,
      validator: (_) => path.isEmpty ? requiredMessage : null,
      builder: (field) {
        final done = path.isNotEmpty;
        final hasError = field.hasError && !done;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppTheme.radius),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.field,
                  borderRadius: BorderRadius.circular(AppTheme.radius),
                  border: Border.all(
                    color: hasError ? AppTheme.danger : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: done
                            ? AppTheme.success.withValues(alpha: 0.12)
                            : AppTheme.surface,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                      child: Icon(
                        done ? Icons.check_rounded : icon,
                        color: done ? AppTheme.success : AppTheme.brand,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textTitle,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            done ? path.split('/').last : hint,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.line),
                      ),
                      child: Text(
                        done ? 'Replace'.tr : 'Upload'.tr,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.brand,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 6, 12, 0),
                child: Text(
                  requiredMessage,
                  style: const TextStyle(fontSize: 12, color: AppTheme.danger),
                ),
              ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Formatters
// ---------------------------------------------------------------------------

/// Uppercases, strips anything but letters/digits, caps at 24 chars (Saudi
/// IBAN length) and groups by four for readability: "SA03 8000 0000 …".
class IbanInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var raw = newValue.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (raw.length > 24) raw = raw.substring(0, 24);
    final buffer = StringBuffer();
    for (var i = 0; i < raw.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(raw[i]);
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
