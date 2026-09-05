import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sagr/theme/app_theme.dart';

/// Professional International Phone Number Input Widget
/// Supports RTL/LTR, country selection, and custom validation
class IntlPhoneNumberInput extends StatefulWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(PhoneNumber)? onValidated;
  final String? initialCountryCode;
  final TextDirection textDirection;
  final InputDecoration? decoration;
  final bool enabled;
  final String? errorText;

  const IntlPhoneNumberInput({
    Key? key,
    this.controller,
    this.onChanged,
    this.onValidated,
    this.initialCountryCode = 'SA',
    this.textDirection = TextDirection.ltr,
    this.decoration,
    this.enabled = true,
    this.errorText,
  }) : super(key: key);

  @override
  State<IntlPhoneNumberInput> createState() => _IntlPhoneNumberInputState();
}

class _IntlPhoneNumberInputState extends State<IntlPhoneNumberInput> {
  late TextEditingController _controller;
  late Country _selectedCountry;
  String? _validationError;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _selectedCountry = countries.firstWhere(
      (c) => c.code == widget.initialCountryCode,
      orElse: () => countries.first,
    );
    _controller.addListener(_handlePhoneNumberChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_handlePhoneNumberChange);
    }
    super.dispose();
  }

  void _handlePhoneNumberChange() {
    final phone = _controller.text;
    final validation = _validatePhone(phone);
    
    setState(() {
      _validationError = validation;
    });

    if (validation == null && widget.onValidated != null) {
      widget.onValidated!(PhoneNumber(
        countryCode: _selectedCountry.dialCode,
        phoneNumber: phone,
        fullNumber: '${_selectedCountry.dialCode}$phone',
        country: _selectedCountry,
      ));
    }

    widget.onChanged?.call(phone);
  }

  String? _validatePhone(String phone) {
    if (phone.isEmpty) return null;

    // Remove any spaces or special characters
    phone = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Saudi Arabia specific validation
    if (_selectedCountry.code == 'SA') {
      if (phone.length != 9) {
        return widget.textDirection == TextDirection.rtl
            ? 'يجب أن يكون الرقم 9 أرقام'
            : 'Phone number must be 9 digits';
      }
      if (!phone.startsWith('5')) {
        return widget.textDirection == TextDirection.rtl
            ? 'يجب أن يبدأ الرقم بـ 5'
            : 'Phone number must start with 5';
      }
    } else {
      // Generic validation for other countries
      if (phone.length < _selectedCountry.minLength ||
          phone.length > _selectedCountry.maxLength) {
        return widget.textDirection == TextDirection.rtl
            ? 'رقم هاتف غير صحيح'
            : 'Invalid phone number';
      }
    }

    return null;
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CountryPickerSheet(
        selectedCountry: _selectedCountry,
        textDirection: widget.textDirection,
        onSelect: (country) {
          setState(() {
            _selectedCountry = country;
            _controller.clear();
            _validationError = null;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = widget.textDirection == TextDirection.rtl;
    final theme = Theme.of(context);
    
    return Directionality(
      // textDirection: widget.textDirection,
        textDirection: TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: widget.enabled
                  ? AppTheme.field
                  : AppTheme.field.withOpacity(0.6),
              borderRadius: BorderRadius.circular(AppTheme.radius),
              border: Border.all(
                color: _validationError != null
                    ? AppTheme.danger
                    : _isFocused
                        ? AppTheme.brand
                        : Colors.transparent,
                width: (_validationError != null || _isFocused) ? 1.4 : 1,
              ),
            ),
            child: Row(
              children: [
                // Country Selector
                InkWell(
                  onTap: widget.enabled ? _showCountryPicker : null,
                  // borderRadius: BorderRadius.horizontal(
                  //   left: isRTL ? Radius.zero : const Radius.circular(12),
                  //   right: isRTL ? const Radius.circular(12) : Radius.zero,
                  // ),

                  borderRadius: BorderRadius.horizontal(
                    left: !isRTL ? Radius.zero : const Radius.circular(12),
                    right: !isRTL ? const Radius.circular(12) : Radius.zero,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical:2),
                    decoration: BoxDecoration(
                      // color: SAGR_PRIMARY,
                      borderRadius: BorderRadius.horizontal(
                        left: isRTL ? Radius.zero : const Radius.circular(12),
                        right: isRTL ? const Radius.circular(12) : Radius.zero,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedCountry.flag,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _selectedCountry.dialCode,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            // color: WHITE_COLOR,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_drop_down,
                          color: theme.colorScheme.onSurface,
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Divider
                Container(
                  height: 24,
                  width: 1,
                  color: AppTheme.line,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
                
                // Phone Number Input
                Expanded(
                  child: Focus(
                    onFocusChange: (focused) {
                      setState(() {
                        _isFocused = focused;
                      });
                    },
                    child: TextField(
                      controller: _controller,
                      enabled: widget.enabled,
                      textDirection: TextDirection.ltr,
                      keyboardType: TextInputType.phone,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(_selectedCountry.maxLength),
                        // PhoneNumberFormatter(),
                      ],
                      decoration: InputDecoration(
                        hintText: _selectedCountry.placeholder,
                        hintStyle: const TextStyle(
                          color: AppTheme.textHint,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1,
                        ),
                        // Override the global inputDecorationTheme so the inner
                        // field has no fill/border of its own (the parent
                        // container provides those).
                        filled: false,
                        isCollapsed: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        counterText: '',
                      ),
                      maxLength: _selectedCountry.maxLength,
                    ),
                  ),
                ),
                
                // Clear Button
                if (_controller.text.isNotEmpty && widget.enabled)
                  IconButton(
                    icon: const Icon(Icons.cancel, size: 18),
                    color: AppTheme.textHint,
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        _validationError = null;
                      });
                    },
                  ),
              ],
            ),
          ),
          
          // Error Message or Helper Text
          if (_validationError != null || widget.errorText != null)
             Directionality(
               textDirection: TextDirection.rtl,
              child: Padding(
              padding: const EdgeInsets.only(top: 4, left: 12, right: 12, bottom: 10),
              child: Row(

                children: [
                  // Icon(
                  //   Icons.error_outline,
                  //   size: 16,
                  //   color: theme.colorScheme.error,
                  // ),
                  // const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _validationError ?? widget.errorText ?? '',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ))
          // else if (_controller.text.isNotEmpty && _validationError == null)
          //   Directionality(
          //      textDirection: TextDirection.rtl,
          //     child: Padding(
          //       padding: const EdgeInsets.only(top: 5, left: 12, right: 12, bottom: 12),
          //       child: Row(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Icon(
          //             Icons.check_circle_outline,
          //             size: 16,
          //             color: Colors.green[600],
          //           ),
          //           const SizedBox(width: 4),
          //           Text(
          //             isRTL ? 'رقم صحيح' : 'Valid number',
          //             style: theme.textTheme.bodySmall?.copyWith(
          //               color: Colors.green[600],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}

/// Country Picker Bottom Sheet
class CountryPickerSheet extends StatefulWidget {
  final Country selectedCountry;
  final TextDirection textDirection;
  final Function(Country) onSelect;

  const CountryPickerSheet({
    Key? key,
    required this.selectedCountry,
    required this.textDirection,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<CountryPickerSheet> {
  late List<Country> _filteredCountries;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCountries = countries;
  }

  void _filterCountries(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCountries = countries;
      } else {
        _filteredCountries = countries.where((country) {
          return country.name.toLowerCase().contains(query.toLowerCase()) ||
              country.nameAr.contains(query) ||
              country.dialCode.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = widget.textDirection == TextDirection.rtl;
    final theme = Theme.of(context);

    return Directionality(
      textDirection: widget.textDirection,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                isRTL ? 'اختر الدولة' : 'Select Country',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                onChanged: _filterCountries,
                textDirection: widget.textDirection,
                decoration: InputDecoration(
                  hintText: isRTL ? 'البحث...' : 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterCountries('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Country List
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCountries.length,
                itemBuilder: (context, index) {
                  final country = _filteredCountries[index];
                  final isSelected = country.code == widget.selectedCountry.code;
                  
                  return ListTile(
                    leading: Text(
                      country.flag,
                      style: const TextStyle(fontSize: 28),
                    ),
                    title: Text(
                      isRTL ? country.nameAr : country.name,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: Text(
                      country.dialCode,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: theme.colorScheme.primaryContainer,
                    onTap: () => widget.onSelect(country),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

/// Phone Number Formatter
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    if (text.isEmpty) return newValue;

    // Add space every 3 digits for better readability
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 3 == 0 && i + 1 != text.length) {
        buffer.write(' ');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Country Model
class Country {
  final String name;
  final String nameAr;
  final String code;
  final String dialCode;
  final String flag;
  final String placeholder;
  final int minLength;
  final int maxLength;

  const Country({
    required this.name,
    required this.nameAr,
    required this.code,
    required this.dialCode,
    required this.flag,
    required this.placeholder,
    required this.minLength,
    required this.maxLength,
  });
}

/// Phone Number Result
class PhoneNumber {
  final String countryCode;
  final String phoneNumber;
  final String fullNumber;
  final Country country;

  const PhoneNumber({
    required this.countryCode,
    required this.phoneNumber,
    required this.fullNumber,
    required this.country,
  });

  @override
  String toString() => fullNumber;
}

/// Predefined Countries
const List<Country> countries = [
  Country(
    name: 'Saudi Arabia',
    nameAr: 'السعودية',
    code: 'SA',
    dialCode: '+966',
    flag: '🇸🇦',
    placeholder: '5XX XXX XXX',
    minLength: 9,
    maxLength: 9,
  ),
  Country(
    name: 'United Arab Emirates',
    nameAr: 'الإمارات',
    code: 'AE',
    dialCode: '+971',
    flag: '🇦🇪',
    placeholder: '5X XXX XXXX',
    minLength: 9,
    maxLength: 9,
  ),
  Country(
    name: 'Egypt',
    nameAr: 'مصر',
    code: 'EG',
    dialCode: '+20',
    flag: '🇪🇬',
    placeholder: '1XX XXX XXXX',
    minLength: 10,
    maxLength: 10,
  ),
  Country(
    name: 'Kuwait',
    nameAr: 'الكويت',
    code: 'KW',
    dialCode: '+965',
    flag: '🇰🇼',
    placeholder: 'XXXX XXXX',
    minLength: 8,
    maxLength: 8,
  ),
  Country(
    name: 'Qatar',
    nameAr: 'قطر',
    code: 'QA',
    dialCode: '+974',
    flag: '🇶🇦',
    placeholder: 'XXXX XXXX',
    minLength: 8,
    maxLength: 8,
  ),
  Country(
    name: 'Bahrain',
    nameAr: 'البحرين',
    code: 'BH',
    dialCode: '+973',
    flag: '🇧🇭',
    placeholder: 'XXXX XXXX',
    minLength: 8,
    maxLength: 8,
  ),
  Country(
    name: 'Oman',
    nameAr: 'عمان',
    code: 'OM',
    dialCode: '+968',
    flag: '🇴🇲',
    placeholder: 'XXXX XXXX',
    minLength: 8,
    maxLength: 8,
  ),
  Country(
    name: 'Jordan',
    nameAr: 'الأردن',
    code: 'JO',
    dialCode: '+962',
    flag: '🇯🇴',
    placeholder: '7X XXX XXXX',
    minLength: 9,
    maxLength: 9,
  ),
  Country(
    name: 'Lebanon',
    nameAr: 'لبنان',
    code: 'LB',
    dialCode: '+961',
    flag: '🇱🇧',
    placeholder: 'XX XXX XXX',
    minLength: 8,
    maxLength: 8,
  ),
  Country(
    name: 'Palestine',
    nameAr: 'فلسطين',
    code: 'PS',
    dialCode: '+970',
    flag: '🇵🇸',
    placeholder: '59X XXX XXX',
    minLength: 9,
    maxLength: 9,
  ),
  Country(
    name: 'United States',
    nameAr: 'الولايات المتحدة',
    code: 'US',
    dialCode: '+1',
    flag: '🇺🇸',
    placeholder: '(XXX) XXX-XXXX',
    minLength: 10,
    maxLength: 10,
  ),
  Country(
    name: 'United Kingdom',
    nameAr: 'المملكة المتحدة',
    code: 'GB',
    dialCode: '+44',
    flag: '🇬🇧',
    placeholder: 'XXXX XXXXXX',
    minLength: 10,
    maxLength: 10,
  ),
];