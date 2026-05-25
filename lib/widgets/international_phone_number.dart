import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Reusable International Phone Number Widget
class InternationalPhoneField extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialCountryCode;
  final String? label;
  final String? hint;
  final Function(String countryCode, String phoneNumber)? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;

  const InternationalPhoneField({
    Key? key,
    this.controller,
    this.initialCountryCode = '+1',
    this.label = 'Phone Number',
    this.hint = 'Enter phone number',
    this.onChanged,
    this.validator,
    this.enabled = true,
  }) : super(key: key);

  @override
  _InternationalPhoneFieldState createState() =>
      _InternationalPhoneFieldState();
}

class _InternationalPhoneFieldState extends State<InternationalPhoneField> {
  late TextEditingController _phoneController;
  late String _selectedCountryCode;

  // Popular country codes with flags
  final List<Map<String, String>> _countryCodes = [
    {'code': '+1', 'country': 'US', 'flag': '🇺🇸', 'name': 'United States'},
    {'code': '+44', 'country': 'GB', 'flag': '🇬🇧', 'name': 'United Kingdom'},
    {'code': '+91', 'country': 'IN', 'flag': '🇮🇳', 'name': 'India'},
    {'code': '+20', 'country': 'EG', 'flag': '🇪🇬', 'name': 'Egypt'},
    {'code': '+971', 'country': 'AE', 'flag': '🇦🇪', 'name': 'UAE'},
    {'code': '+966', 'country': 'SA', 'flag': '🇸🇦', 'name': 'Saudi Arabia'},
    {'code': '+61', 'country': 'AU', 'flag': '🇦🇺', 'name': 'Australia'},
    {'code': '+81', 'country': 'JP', 'flag': '🇯🇵', 'name': 'Japan'},
    {'code': '+86', 'country': 'CN', 'flag': '🇨🇳', 'name': 'China'},
    {'code': '+49', 'country': 'DE', 'flag': '🇩🇪', 'name': 'Germany'},
    {'code': '+33', 'country': 'FR', 'flag': '🇫🇷', 'name': 'France'},
    {'code': '+34', 'country': 'ES', 'flag': '🇪🇸', 'name': 'Spain'},
    {'code': '+39', 'country': 'IT', 'flag': '🇮🇹', 'name': 'Italy'},
    {'code': '+7', 'country': 'RU', 'flag': '🇷🇺', 'name': 'Russia'},
    {'code': '+55', 'country': 'BR', 'flag': '🇧🇷', 'name': 'Brazil'},
    {'code': '+52', 'country': 'MX', 'flag': '🇲🇽', 'name': 'Mexico'},
    {'code': '+27', 'country': 'ZA', 'flag': '🇿🇦', 'name': 'South Africa'},
    {'code': '+234', 'country': 'NG', 'flag': '🇳🇬', 'name': 'Nigeria'},
    {'code': '+90', 'country': 'TR', 'flag': '🇹🇷', 'name': 'Turkey'},
    {'code': '+82', 'country': 'KR', 'flag': '🇰🇷', 'name': 'South Korea'},
  ];

  @override
  void initState() {
    super.initState();
    _phoneController = widget.controller ?? TextEditingController();
    _selectedCountryCode = widget.initialCountryCode ?? '+1';
    
    _phoneController.addListener(_onPhoneChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _phoneController.dispose();
    }
    super.dispose();
  }

  void _onPhoneChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(_selectedCountryCode, _phoneController.text);
    }
  }

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter phone number';
    }
    
    String cleanNumber = value.replaceAll(RegExp(r'[\s-]'), '');
    
    if (!RegExp(r'^\d+$').hasMatch(cleanNumber)) {
      return 'Only numbers are allowed';
    }
    
    if (cleanNumber.length < 7 || cleanNumber.length > 15) {
      return 'Invalid phone number length';
    }
    
    return null;
  }

  String getFullPhoneNumber() {
    return '$_selectedCountryCode${_phoneController.text.replaceAll(RegExp(r'[\s-]'), '')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              widget.label!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country Code Dropdown
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCountryCode,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  borderRadius: BorderRadius.circular(8),
                  items: _countryCodes.map((country) {
                    return DropdownMenuItem<String>(
                      value: country['code'],
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            country['flag']!,
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(width: 8),
                          Text(
                            country['code']!,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: widget.enabled
                      ? (value) {
                          setState(() {
                            _selectedCountryCode = value!;
                          });
                          _onPhoneChanged();
                        }
                      : null,
                  selectedItemBuilder: (BuildContext context) {
                    return _countryCodes.map((country) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            country['flag']!,
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(width: 4),
                          Text(
                            country['code']!,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      );
                    }).toList();
                  },
                ),
              ),
            ),
            SizedBox(width: 12),
            // Phone Number Field
            Expanded(
              child: TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                enabled: widget.enabled,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d\s-]')),
                ],
                decoration: InputDecoration(
                  hintText: widget.hint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                validator: widget.validator ?? _defaultValidator,
              ),
            ),
          ],
        ),
      ],
    );
  }
}