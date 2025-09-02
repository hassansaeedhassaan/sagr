import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneNumberInput extends StatefulWidget {
  final Function(String phoneNumber, String countryCode)? onChanged;
  final Function(String countryCode, String countryName, String countryFlag, String iso)? onCountryChanged;
  final String? initialCountryCode;
  final String? initialPhoneNumber;
  final String? hintText;
  final bool isRTL;
  final InputDecoration? decoration;
  
  const PhoneNumberInput({
    Key? key,
    this.onChanged,
    this.onCountryChanged,
    this.initialCountryCode = '+1',
    this.initialPhoneNumber,
    this.hintText,
    this.isRTL = false,
    this.decoration,
  }) : super(key: key);

  @override
  State<PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  late TextEditingController _phoneController;
  late String _selectedCountryCode;
  late String _selectedCountryFlag;
  late String _selectedCountryName;
  late String _selectedCountryIso;

  // Complete list of all countries with their phone codes and flags
  final List<Map<String, String>> _countries = [
    {'name': 'Afghanistan', 'code': '+93', 'flag': '🇦🇫', 'iso': 'AF'},
    {'name': 'Albania', 'code': '+355', 'flag': '🇦🇱', 'iso': 'AL'},
    {'name': 'Algeria', 'code': '+213', 'flag': '🇩🇿', 'iso': 'DZ'},
    {'name': 'American Samoa', 'code': '+1684', 'flag': '🇦🇸', 'iso': 'AS'},
    {'name': 'Andorra', 'code': '+376', 'flag': '🇦🇩', 'iso': 'AD'},
    {'name': 'Angola', 'code': '+244', 'flag': '🇦🇴', 'iso': 'AO'},
    {'name': 'Anguilla', 'code': '+1264', 'flag': '🇦🇮', 'iso': 'AI'},
    {'name': 'Antarctica', 'code': '+672', 'flag': '🇦🇶', 'iso': 'AQ'},
    {'name': 'Antigua and Barbuda', 'code': '+1268', 'flag': '🇦🇬', 'iso': 'AG'},
    {'name': 'Argentina', 'code': '+54', 'flag': '🇦🇷', 'iso': 'AR'},
    {'name': 'Armenia', 'code': '+374', 'flag': '🇦🇲', 'iso': 'AM'},
    {'name': 'Aruba', 'code': '+297', 'flag': '🇦🇼', 'iso': 'AW'},
    {'name': 'Australia', 'code': '+61', 'flag': '🇦🇺', 'iso': 'AU'},
    {'name': 'Austria', 'code': '+43', 'flag': '🇦🇹', 'iso': 'AT'},
    {'name': 'Azerbaijan', 'code': '+994', 'flag': '🇦🇿', 'iso': 'AZ'},
    {'name': 'Bahamas', 'code': '+1242', 'flag': '🇧🇸', 'iso': 'BS'},
    {'name': 'Bahrain', 'code': '+973', 'flag': '🇧🇭', 'iso': 'BH'},
    {'name': 'Bangladesh', 'code': '+880', 'flag': '🇧🇩', 'iso': 'BD'},
    {'name': 'Barbados', 'code': '+1246', 'flag': '🇧🇧', 'iso': 'BB'},
    {'name': 'Belarus', 'code': '+375', 'flag': '🇧🇾', 'iso': 'BY'},
    {'name': 'Belgium', 'code': '+32', 'flag': '🇧🇪', 'iso': 'BE'},
    {'name': 'Belize', 'code': '+501', 'flag': '🇧🇿', 'iso': 'BZ'},
    {'name': 'Benin', 'code': '+229', 'flag': '🇧🇯', 'iso': 'BJ'},
    {'name': 'Bermuda', 'code': '+1441', 'flag': '🇧🇲', 'iso': 'BM'},
    {'name': 'Bhutan', 'code': '+975', 'flag': '🇧🇹', 'iso': 'BT'},
    {'name': 'Bolivia', 'code': '+591', 'flag': '🇧🇴', 'iso': 'BO'},
    {'name': 'Bosnia and Herzegovina', 'code': '+387', 'flag': '🇧🇦', 'iso': 'BA'},
    {'name': 'Botswana', 'code': '+267', 'flag': '🇧🇼', 'iso': 'BW'},
    {'name': 'Brazil', 'code': '+55', 'flag': '🇧🇷', 'iso': 'BR'},
    {'name': 'British Indian Ocean Territory', 'code': '+246', 'flag': '🇮🇴', 'iso': 'IO'},
    {'name': 'British Virgin Islands', 'code': '+1284', 'flag': '🇻🇬', 'iso': 'VG'},
    {'name': 'Brunei', 'code': '+673', 'flag': '🇧🇳', 'iso': 'BN'},
    {'name': 'Bulgaria', 'code': '+359', 'flag': '🇧🇬', 'iso': 'BG'},
    {'name': 'Burkina Faso', 'code': '+226', 'flag': '🇧🇫', 'iso': 'BF'},
    {'name': 'Burundi', 'code': '+257', 'flag': '🇧🇮', 'iso': 'BI'},
    {'name': 'Cambodia', 'code': '+855', 'flag': '🇰🇭', 'iso': 'KH'},
    {'name': 'Cameroon', 'code': '+237', 'flag': '🇨🇲', 'iso': 'CM'},
    {'name': 'Canada', 'code': '+1', 'flag': '🇨🇦', 'iso': 'CA'},
    {'name': 'Cape Verde', 'code': '+238', 'flag': '🇨🇻', 'iso': 'CV'},
    {'name': 'Cayman Islands', 'code': '+1345', 'flag': '🇰🇾', 'iso': 'KY'},
    {'name': 'Central African Republic', 'code': '+236', 'flag': '🇨🇫', 'iso': 'CF'},
    {'name': 'Chad', 'code': '+235', 'flag': '🇹🇩', 'iso': 'TD'},
    {'name': 'Chile', 'code': '+56', 'flag': '🇨🇱', 'iso': 'CL'},
    {'name': 'China', 'code': '+86', 'flag': '🇨🇳', 'iso': 'CN'},
    {'name': 'Christmas Island', 'code': '+61', 'flag': '🇨🇽', 'iso': 'CX'},
    {'name': 'Cocos Islands', 'code': '+61', 'flag': '🇨🇨', 'iso': 'CC'},
    {'name': 'Colombia', 'code': '+57', 'flag': '🇨🇴', 'iso': 'CO'},
    {'name': 'Comoros', 'code': '+269', 'flag': '🇰🇲', 'iso': 'KM'},
    {'name': 'Congo', 'code': '+242', 'flag': '🇨🇬', 'iso': 'CG'},
    {'name': 'Cook Islands', 'code': '+682', 'flag': '🇨🇰', 'iso': 'CK'},
    {'name': 'Costa Rica', 'code': '+506', 'flag': '🇨🇷', 'iso': 'CR'},
    {'name': 'Croatia', 'code': '+385', 'flag': '🇭🇷', 'iso': 'HR'},
    {'name': 'Cuba', 'code': '+53', 'flag': '🇨🇺', 'iso': 'CU'},
    {'name': 'Curacao', 'code': '+599', 'flag': '🇨🇼', 'iso': 'CW'},
    {'name': 'Cyprus', 'code': '+357', 'flag': '🇨🇾', 'iso': 'CY'},
    {'name': 'Czech Republic', 'code': '+420', 'flag': '🇨🇿', 'iso': 'CZ'},
    {'name': 'Democratic Republic of the Congo', 'code': '+243', 'flag': '🇨🇩', 'iso': 'CD'},
    {'name': 'Denmark', 'code': '+45', 'flag': '🇩🇰', 'iso': 'DK'},
    {'name': 'Djibouti', 'code': '+253', 'flag': '🇩🇯', 'iso': 'DJ'},
    {'name': 'Dominica', 'code': '+1767', 'flag': '🇩🇲', 'iso': 'DM'},
    {'name': 'Dominican Republic', 'code': '+1', 'flag': '🇩🇴', 'iso': 'DO'},
    {'name': 'East Timor', 'code': '+670', 'flag': '🇹🇱', 'iso': 'TL'},
    {'name': 'Ecuador', 'code': '+593', 'flag': '🇪🇨', 'iso': 'EC'},
    {'name': 'Egypt', 'code': '+20', 'flag': '🇪🇬', 'iso': 'EG'},
    {'name': 'El Salvador', 'code': '+503', 'flag': '🇸🇻', 'iso': 'SV'},
    {'name': 'Equatorial Guinea', 'code': '+240', 'flag': '🇬🇶', 'iso': 'GQ'},
    {'name': 'Eritrea', 'code': '+291', 'flag': '🇪🇷', 'iso': 'ER'},
    {'name': 'Estonia', 'code': '+372', 'flag': '🇪🇪', 'iso': 'EE'},
    {'name': 'Ethiopia', 'code': '+251', 'flag': '🇪🇹', 'iso': 'ET'},
    {'name': 'Falkland Islands', 'code': '+500', 'flag': '🇫🇰', 'iso': 'FK'},
    {'name': 'Faroe Islands', 'code': '+298', 'flag': '🇫🇴', 'iso': 'FO'},
    {'name': 'Fiji', 'code': '+679', 'flag': '🇫🇯', 'iso': 'FJ'},
    {'name': 'Finland', 'code': '+358', 'flag': '🇫🇮', 'iso': 'FI'},
    {'name': 'France', 'code': '+33', 'flag': '🇫🇷', 'iso': 'FR'},
    {'name': 'French Guiana', 'code': '+594', 'flag': '🇬🇫', 'iso': 'GF'},
    {'name': 'French Polynesia', 'code': '+689', 'flag': '🇵🇫', 'iso': 'PF'},
    {'name': 'Gabon', 'code': '+241', 'flag': '🇬🇦', 'iso': 'GA'},
    {'name': 'Gambia', 'code': '+220', 'flag': '🇬🇲', 'iso': 'GM'},
    {'name': 'Georgia', 'code': '+995', 'flag': '🇬🇪', 'iso': 'GE'},
    {'name': 'Germany', 'code': '+49', 'flag': '🇩🇪', 'iso': 'DE'},
    {'name': 'Ghana', 'code': '+233', 'flag': '🇬🇭', 'iso': 'GH'},
    {'name': 'Gibraltar', 'code': '+350', 'flag': '🇬🇮', 'iso': 'GI'},
    {'name': 'Greece', 'code': '+30', 'flag': '🇬🇷', 'iso': 'GR'},
    {'name': 'Greenland', 'code': '+299', 'flag': '🇬🇱', 'iso': 'GL'},
    {'name': 'Grenada', 'code': '+1473', 'flag': '🇬🇩', 'iso': 'GD'},
    {'name': 'Guadeloupe', 'code': '+590', 'flag': '🇬🇵', 'iso': 'GP'},
    {'name': 'Guam', 'code': '+1671', 'flag': '🇬🇺', 'iso': 'GU'},
    {'name': 'Guatemala', 'code': '+502', 'flag': '🇬🇹', 'iso': 'GT'},
    {'name': 'Guernsey', 'code': '+44', 'flag': '🇬🇬', 'iso': 'GG'},
    {'name': 'Guinea', 'code': '+224', 'flag': '🇬🇳', 'iso': 'GN'},
    {'name': 'Guinea-Bissau', 'code': '+245', 'flag': '🇬🇼', 'iso': 'GW'},
    {'name': 'Guyana', 'code': '+592', 'flag': '🇬🇾', 'iso': 'GY'},
    {'name': 'Haiti', 'code': '+509', 'flag': '🇭🇹', 'iso': 'HT'},
    {'name': 'Honduras', 'code': '+504', 'flag': '🇭🇳', 'iso': 'HN'},
    {'name': 'Hong Kong', 'code': '+852', 'flag': '🇭🇰', 'iso': 'HK'},
    {'name': 'Hungary', 'code': '+36', 'flag': '🇭🇺', 'iso': 'HU'},
    {'name': 'Iceland', 'code': '+354', 'flag': '🇮🇸', 'iso': 'IS'},
    {'name': 'India', 'code': '+91', 'flag': '🇮🇳', 'iso': 'IN'},
    {'name': 'Indonesia', 'code': '+62', 'flag': '🇮🇩', 'iso': 'ID'},
    {'name': 'Iran', 'code': '+98', 'flag': '🇮🇷', 'iso': 'IR'},
    {'name': 'Iraq', 'code': '+964', 'flag': '🇮🇶', 'iso': 'IQ'},
    {'name': 'Ireland', 'code': '+353', 'flag': '🇮🇪', 'iso': 'IE'},
    {'name': 'Isle of Man', 'code': '+44', 'flag': '🇮🇲', 'iso': 'IM'},
    {'name': 'Israel', 'code': '+972', 'flag': '🇮🇱', 'iso': 'IL'},
    {'name': 'Italy', 'code': '+39', 'flag': '🇮🇹', 'iso': 'IT'},
    {'name': 'Ivory Coast', 'code': '+225', 'flag': '🇨🇮', 'iso': 'CI'},
    {'name': 'Jamaica', 'code': '+1876', 'flag': '🇯🇲', 'iso': 'JM'},
    {'name': 'Japan', 'code': '+81', 'flag': '🇯🇵', 'iso': 'JP'},
    {'name': 'Jersey', 'code': '+44', 'flag': '🇯🇪', 'iso': 'JE'},
    {'name': 'Jordan', 'code': '+962', 'flag': '🇯🇴', 'iso': 'JO'},
    {'name': 'Kazakhstan', 'code': '+7', 'flag': '🇰🇿', 'iso': 'KZ'},
    {'name': 'Kenya', 'code': '+254', 'flag': '🇰🇪', 'iso': 'KE'},
    {'name': 'Kiribati', 'code': '+686', 'flag': '🇰🇮', 'iso': 'KI'},
    {'name': 'Kosovo', 'code': '+383', 'flag': '🇽🇰', 'iso': 'XK'},
    {'name': 'Kuwait', 'code': '+965', 'flag': '🇰🇼', 'iso': 'KW'},
    {'name': 'Kyrgyzstan', 'code': '+996', 'flag': '🇰🇬', 'iso': 'KG'},
    {'name': 'Laos', 'code': '+856', 'flag': '🇱🇦', 'iso': 'LA'},
    {'name': 'Latvia', 'code': '+371', 'flag': '🇱🇻', 'iso': 'LV'},
    {'name': 'Lebanon', 'code': '+961', 'flag': '🇱🇧', 'iso': 'LB'},
    {'name': 'Lesotho', 'code': '+266', 'flag': '🇱🇸', 'iso': 'LS'},
    {'name': 'Liberia', 'code': '+231', 'flag': '🇱🇷', 'iso': 'LR'},
    {'name': 'Libya', 'code': '+218', 'flag': '🇱🇾', 'iso': 'LY'},
    {'name': 'Liechtenstein', 'code': '+423', 'flag': '🇱🇮', 'iso': 'LI'},
    {'name': 'Lithuania', 'code': '+370', 'flag': '🇱🇹', 'iso': 'LT'},
    {'name': 'Luxembourg', 'code': '+352', 'flag': '🇱🇺', 'iso': 'LU'},
    {'name': 'Macao', 'code': '+853', 'flag': '🇲🇴', 'iso': 'MO'},
    {'name': 'Macedonia', 'code': '+389', 'flag': '🇲🇰', 'iso': 'MK'},
    {'name': 'Madagascar', 'code': '+261', 'flag': '🇲🇬', 'iso': 'MG'},
    {'name': 'Malawi', 'code': '+265', 'flag': '🇲🇼', 'iso': 'MW'},
    {'name': 'Malaysia', 'code': '+60', 'flag': '🇲🇾', 'iso': 'MY'},
    {'name': 'Maldives', 'code': '+960', 'flag': '🇲🇻', 'iso': 'MV'},
    {'name': 'Mali', 'code': '+223', 'flag': '🇲🇱', 'iso': 'ML'},
    {'name': 'Malta', 'code': '+356', 'flag': '🇲🇹', 'iso': 'MT'},
    {'name': 'Marshall Islands', 'code': '+692', 'flag': '🇲🇭', 'iso': 'MH'},
    {'name': 'Martinique', 'code': '+596', 'flag': '🇲🇶', 'iso': 'MQ'},
    {'name': 'Mauritania', 'code': '+222', 'flag': '🇲🇷', 'iso': 'MR'},
    {'name': 'Mauritius', 'code': '+230', 'flag': '🇲🇺', 'iso': 'MU'},
    {'name': 'Mayotte', 'code': '+262', 'flag': '🇾🇹', 'iso': 'YT'},
    {'name': 'Mexico', 'code': '+52', 'flag': '🇲🇽', 'iso': 'MX'},
    {'name': 'Micronesia', 'code': '+691', 'flag': '🇫🇲', 'iso': 'FM'},
    {'name': 'Moldova', 'code': '+373', 'flag': '🇲🇩', 'iso': 'MD'},
    {'name': 'Monaco', 'code': '+377', 'flag': '🇲🇨', 'iso': 'MC'},
    {'name': 'Mongolia', 'code': '+976', 'flag': '🇲🇳', 'iso': 'MN'},
    {'name': 'Montenegro', 'code': '+382', 'flag': '🇲🇪', 'iso': 'ME'},
    {'name': 'Montserrat', 'code': '+1664', 'flag': '🇲🇸', 'iso': 'MS'},
    {'name': 'Morocco', 'code': '+212', 'flag': '🇲🇦', 'iso': 'MA'},
    {'name': 'Mozambique', 'code': '+258', 'flag': '🇲🇿', 'iso': 'MZ'},
    {'name': 'Myanmar', 'code': '+95', 'flag': '🇲🇲', 'iso': 'MM'},
    {'name': 'Namibia', 'code': '+264', 'flag': '🇳🇦', 'iso': 'NA'},
    {'name': 'Nauru', 'code': '+674', 'flag': '🇳🇷', 'iso': 'NR'},
    {'name': 'Nepal', 'code': '+977', 'flag': '🇳🇵', 'iso': 'NP'},
    {'name': 'Netherlands', 'code': '+31', 'flag': '🇳🇱', 'iso': 'NL'},
    {'name': 'Netherlands Antilles', 'code': '+599', 'flag': '🇧🇶', 'iso': 'AN'},
    {'name': 'New Caledonia', 'code': '+687', 'flag': '🇳🇨', 'iso': 'NC'},
    {'name': 'New Zealand', 'code': '+64', 'flag': '🇳🇿', 'iso': 'NZ'},
    {'name': 'Nicaragua', 'code': '+505', 'flag': '🇳🇮', 'iso': 'NI'},
    {'name': 'Niger', 'code': '+227', 'flag': '🇳🇪', 'iso': 'NE'},
    {'name': 'Nigeria', 'code': '+234', 'flag': '🇳🇬', 'iso': 'NG'},
    {'name': 'Niue', 'code': '+683', 'flag': '🇳🇺', 'iso': 'NU'},
    {'name': 'Norfolk Island', 'code': '+672', 'flag': '🇳🇫', 'iso': 'NF'},
    {'name': 'North Korea', 'code': '+850', 'flag': '🇰🇵', 'iso': 'KP'},
    {'name': 'Northern Mariana Islands', 'code': '+1670', 'flag': '🇲🇵', 'iso': 'MP'},
    {'name': 'Norway', 'code': '+47', 'flag': '🇳🇴', 'iso': 'NO'},
    {'name': 'Oman', 'code': '+968', 'flag': '🇴🇲', 'iso': 'OM'},
    {'name': 'Pakistan', 'code': '+92', 'flag': '🇵🇰', 'iso': 'PK'},
    {'name': 'Palau', 'code': '+680', 'flag': '🇵🇼', 'iso': 'PW'},
    {'name': 'Palestine', 'code': '+970', 'flag': '🇵🇸', 'iso': 'PS'},
    {'name': 'Panama', 'code': '+507', 'flag': '🇵🇦', 'iso': 'PA'},
    {'name': 'Papua New Guinea', 'code': '+675', 'flag': '🇵🇬', 'iso': 'PG'},
    {'name': 'Paraguay', 'code': '+595', 'flag': '🇵🇾', 'iso': 'PY'},
    {'name': 'Peru', 'code': '+51', 'flag': '🇵🇪', 'iso': 'PE'},
    {'name': 'Philippines', 'code': '+63', 'flag': '🇵🇭', 'iso': 'PH'},
    {'name': 'Pitcairn', 'code': '+64', 'flag': '🇵🇳', 'iso': 'PN'},
    {'name': 'Poland', 'code': '+48', 'flag': '🇵🇱', 'iso': 'PL'},
    {'name': 'Portugal', 'code': '+351', 'flag': '🇵🇹', 'iso': 'PT'},
    {'name': 'Puerto Rico', 'code': '+1787', 'flag': '🇵🇷', 'iso': 'PR'},
    {'name': 'Qatar', 'code': '+974', 'flag': '🇶🇦', 'iso': 'QA'},
    {'name': 'Reunion', 'code': '+262', 'flag': '🇷🇪', 'iso': 'RE'},
    {'name': 'Romania', 'code': '+40', 'flag': '🇷🇴', 'iso': 'RO'},
    {'name': 'Russia', 'code': '+7', 'flag': '🇷🇺', 'iso': 'RU'},
    {'name': 'Rwanda', 'code': '+250', 'flag': '🇷🇼', 'iso': 'RW'},
    {'name': 'Saint Barthelemy', 'code': '+590', 'flag': '🇧🇱', 'iso': 'BL'},
    {'name': 'Saint Helena', 'code': '+290', 'flag': '🇸🇭', 'iso': 'SH'},
    {'name': 'Saint Kitts and Nevis', 'code': '+1869', 'flag': '🇰🇳', 'iso': 'KN'},
    {'name': 'Saint Lucia', 'code': '+1758', 'flag': '🇱🇨', 'iso': 'LC'},
    {'name': 'Saint Martin', 'code': '+590', 'flag': '🇲🇫', 'iso': 'MF'},
    {'name': 'Saint Pierre and Miquelon', 'code': '+508', 'flag': '🇵🇲', 'iso': 'PM'},
    {'name': 'Saint Vincent and the Grenadines', 'code': '+1784', 'flag': '🇻🇨', 'iso': 'VC'},
    {'name': 'Samoa', 'code': '+685', 'flag': '🇼🇸', 'iso': 'WS'},
    {'name': 'San Marino', 'code': '+378', 'flag': '🇸🇲', 'iso': 'SM'},
    {'name': 'Sao Tome and Principe', 'code': '+239', 'flag': '🇸🇹', 'iso': 'ST'},
    {'name': 'Saudi Arabia', 'code': '+966', 'flag': '🇸🇦', 'iso': 'SA'},
    {'name': 'Senegal', 'code': '+221', 'flag': '🇸🇳', 'iso': 'SN'},
    {'name': 'Serbia', 'code': '+381', 'flag': '🇷🇸', 'iso': 'RS'},
    {'name': 'Seychelles', 'code': '+248', 'flag': '🇸🇨', 'iso': 'SC'},
    {'name': 'Sierra Leone', 'code': '+232', 'flag': '🇸🇱', 'iso': 'SL'},
    {'name': 'Singapore', 'code': '+65', 'flag': '🇸🇬', 'iso': 'SG'},
    {'name': 'Sint Maarten', 'code': '+1721', 'flag': '🇸🇽', 'iso': 'SX'},
    {'name': 'Slovakia', 'code': '+421', 'flag': '🇸🇰', 'iso': 'SK'},
    {'name': 'Slovenia', 'code': '+386', 'flag': '🇸🇮', 'iso': 'SI'},
    {'name': 'Solomon Islands', 'code': '+677', 'flag': '🇸🇧', 'iso': 'SB'},
    {'name': 'Somalia', 'code': '+252', 'flag': '🇸🇴', 'iso': 'SO'},
    {'name': 'South Africa', 'code': '+27', 'flag': '🇿🇦', 'iso': 'ZA'},
    {'name': 'South Korea', 'code': '+82', 'flag': '🇰🇷', 'iso': 'KR'},
    {'name': 'South Sudan', 'code': '+211', 'flag': '🇸🇸', 'iso': 'SS'},
    {'name': 'Spain', 'code': '+34', 'flag': '🇪🇸', 'iso': 'ES'},
    {'name': 'Sri Lanka', 'code': '+94', 'flag': '🇱🇰', 'iso': 'LK'},
    {'name': 'Sudan', 'code': '+249', 'flag': '🇸🇩', 'iso': 'SD'},
    {'name': 'Suriname', 'code': '+597', 'flag': '🇸🇷', 'iso': 'SR'},
    {'name': 'Swaziland', 'code': '+268', 'flag': '🇸🇿', 'iso': 'SZ'},
    {'name': 'Sweden', 'code': '+46', 'flag': '🇸🇪', 'iso': 'SE'},
    {'name': 'Switzerland', 'code': '+41', 'flag': '🇨🇭', 'iso': 'CH'},
    {'name': 'Syria', 'code': '+963', 'flag': '🇸🇾', 'iso': 'SY'},
    {'name': 'Taiwan', 'code': '+886', 'flag': '🇹🇼', 'iso': 'TW'},
    {'name': 'Tajikistan', 'code': '+992', 'flag': '🇹🇯', 'iso': 'TJ'},
    {'name': 'Tanzania', 'code': '+255', 'flag': '🇹🇿', 'iso': 'TZ'},
    {'name': 'Thailand', 'code': '+66', 'flag': '🇹🇭', 'iso': 'TH'},
    {'name': 'Togo', 'code': '+228', 'flag': '🇹🇬', 'iso': 'TG'},
    {'name': 'Tokelau', 'code': '+690', 'flag': '🇹🇰', 'iso': 'TK'},
    {'name': 'Tonga', 'code': '+676', 'flag': '🇹🇴', 'iso': 'TO'},
    {'name': 'Trinidad and Tobago', 'code': '+1868', 'flag': '🇹🇹', 'iso': 'TT'},
    {'name': 'Tunisia', 'code': '+216', 'flag': '🇹🇳', 'iso': 'TN'},
    {'name': 'Turkey', 'code': '+90', 'flag': '🇹🇷', 'iso': 'TR'},
    {'name': 'Turkmenistan', 'code': '+993', 'flag': '🇹🇲', 'iso': 'TM'},
    {'name': 'Turks and Caicos Islands', 'code': '+1649', 'flag': '🇹🇨', 'iso': 'TC'},
    {'name': 'Tuvalu', 'code': '+688', 'flag': '🇹🇻', 'iso': 'TV'},
    {'name': 'U.S. Virgin Islands', 'code': '+1340', 'flag': '🇻🇮', 'iso': 'VI'},
    {'name': 'Uganda', 'code': '+256', 'flag': '🇺🇬', 'iso': 'UG'},
    {'name': 'Ukraine', 'code': '+380', 'flag': '🇺🇦', 'iso': 'UA'},
    {'name': 'United Arab Emirates', 'code': '+971', 'flag': '🇦🇪', 'iso': 'AE'},
    {'name': 'United Kingdom', 'code': '+44', 'flag': '🇬🇧', 'iso': 'GB'},
    {'name': 'United States', 'code': '+1', 'flag': '🇺🇸', 'iso': 'US'},
    {'name': 'Uruguay', 'code': '+598', 'flag': '🇺🇾', 'iso': 'UY'},
    {'name': 'Uzbekistan', 'code': '+998', 'flag': '🇺🇿', 'iso': 'UZ'},
    {'name': 'Vanuatu', 'code': '+678', 'flag': '🇻🇺', 'iso': 'VU'},
    {'name': 'Vatican', 'code': '+379', 'flag': '🇻🇦', 'iso': 'VA'},
    {'name': 'Venezuela', 'code': '+58', 'flag': '🇻🇪', 'iso': 'VE'},
    {'name': 'Vietnam', 'code': '+84', 'flag': '🇻🇳', 'iso': 'VN'},
    {'name': 'Wallis and Futuna', 'code': '+681', 'flag': '🇼🇫', 'iso': 'WF'},
    {'name': 'Western Sahara', 'code': '+212', 'flag': '🇪🇭', 'iso': 'EH'},
    {'name': 'Yemen', 'code': '+967', 'flag': '🇾🇪', 'iso': 'YE'},
    {'name': 'Zambia', 'code': '+260', 'flag': '🇿🇲', 'iso': 'ZM'},
    {'name': 'Zimbabwe', 'code': '+263', 'flag': '🇿🇼', 'iso': 'ZW'},
  ];

  List<Map<String, String>> _filteredCountries = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.initialPhoneNumber);
    _filteredCountries = _countries;
    
    // Find initial country or default to first one
    final initialCountry = _countries.firstWhere(
      (country) => country['code'] == widget.initialCountryCode,
      orElse: () => _countries.first,
    );
    
    _selectedCountryCode = initialCountry['code']!;
    _selectedCountryFlag = initialCountry['flag']!;
    _selectedCountryName = initialCountry['name']!;
    _selectedCountryIso = initialCountry['iso']!;
    
    _phoneController.addListener(_onPhoneNumberChanged);
    _searchController.addListener(_filterCountries);
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCountries = _countries.where((country) {
        return country['name']!.toLowerCase().contains(query) ||
               country['code']!.contains(query) ||
               country['iso']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _onPhoneNumberChanged() {
    widget.onChanged?.call(_phoneController.text, _selectedCountryCode);
  }

  void _onCountryChanged(Map<String, String> country) {
    setState(() {
      _selectedCountryCode = country['code']!;
      _selectedCountryFlag = country['flag']!;
      _selectedCountryName = country['name']!;
      _selectedCountryIso = country['iso']!;
    });

    // Call the country change callback
    widget.onCountryChanged?.call(
      _selectedCountryCode,
      _selectedCountryName,
      _selectedCountryFlag,
      _selectedCountryIso,
    );

    // Also call the general onChanged callback
    _onPhoneNumberChanged();
  }

  void _showCountryPicker() {
    // Reset search when opening picker
    _searchController.clear();
    _filteredCountries = _countries;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) => Column(
            children: [
              // Header with search
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Select Country',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Search TextField
                    TextField(
                      controller: _searchController,
                      onChanged: (query) {
                        setModalState(() {
                          _filterCountries();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: widget.isRTL ? 'البحث عن بلد...' : 'Search countries...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setModalState(() {
                                    _searchController.clear();
                                    _filteredCountries = _countries;
                                  });
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Countries List
              Expanded(
                child: _filteredCountries.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              widget.isRTL ? 'لم يتم العثور على نتائج' : 'No countries found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: _filteredCountries.length,
                        itemBuilder: (context, index) {
                          final country = _filteredCountries[index];
                          final isSelected = country['code'] == _selectedCountryCode;
                          
                          return ListTile(
                            leading: Text(
                              country['flag']!,
                              style: const TextStyle(fontSize: 24),
                            ),
                            title: Text(
                              country['name']!,
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? Theme.of(context).primaryColor : null,
                              ),
                            ),
                            trailing: Text(
                              country['code']!,
                              style: TextStyle(
                                color: isSelected 
                                    ? Theme.of(context).primaryColor 
                                    : Colors.grey.shade600,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            selected: isSelected,
                            selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
                            onTap: () {
                              _onCountryChanged(country);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: widget.isRTL ? [
            // RTL Layout: Country Code on left, TextField on right
            // Country Code Selector (Left side in RTL)
            InkWell(
              onTap: _showCountryPicker,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _selectedCountryFlag,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _selectedCountryCode,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ),
            
            // Phone Number Input (Right side in RTL, but input is still LTR)
            Expanded(
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textDirection: TextDirection.ltr, // Always LTR for phone numbers
                textAlign: TextAlign.right, // Align text to right in RTL
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(15),
                ],
                decoration: (widget.decoration ?? const InputDecoration()).copyWith(
                  hintText: widget.hintText ?? 'Phone number',
                  hintTextDirection: TextDirection.rtl, // RTL hint text
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 8,
                  ),
                ),
              ),
            ),
          ] : [
            // LTR Layout: Country Code on left, TextField on right
            // Country Code Selector
            InkWell(
              onTap: _showCountryPicker,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _selectedCountryFlag,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _selectedCountryCode,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ),
            
            // Phone Number Input
            Expanded(
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textDirection: TextDirection.ltr, // Always LTR for phone numbers
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(15),
                ],
                decoration: (widget.decoration ?? const InputDecoration()).copyWith(
                  hintText: widget.hintText ?? 'Phone number',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get fullPhoneNumber => '$_selectedCountryCode${_phoneController.text}';
  String get selectedCountryCode => _selectedCountryCode;
  String get selectedCountryName => _selectedCountryName;
  String get selectedCountryFlag => _selectedCountryFlag;
  String get selectedCountryIso => _selectedCountryIso;

  @override
  void dispose() {
    _phoneController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}

// Usage Example Widget
class PhoneNumberInputExample extends StatefulWidget {
  @override
  State<PhoneNumberInputExample> createState() => _PhoneNumberInputExampleState();
}

class _PhoneNumberInputExampleState extends State<PhoneNumberInputExample> {
  String _phoneNumber = '';
  String _countryCode = '';
  String _countryName = '';
  String _countryFlag = '';
  String _countryIso = '';
  bool _isRTL = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isRTL ? 'إدخال رقم الهاتف' : 'Phone Number Input'),
        actions: [
          Switch(
            value: _isRTL,
            onChanged: (value) => setState(() => _isRTL = value),
          ),
          const SizedBox(width: 8),
          Text(_isRTL ? 'عربي' : 'RTL'),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isRTL ? 'أدخل رقم هاتفك:' : 'Enter your phone number:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: _isRTL ? TextAlign.right : TextAlign.left,
            ),
            const SizedBox(height: 16),
            
            // Information about RTL behavior
            if (_isRTL) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.amber, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'RTL Mode: Country code on left, text field on right, but numbers are typed left-to-right',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'في وضع RTL: كود البلد على اليسار، حقل النص على اليمين، لكن الأرقام تُكتب من اليسار إلى اليمين',
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            PhoneNumberInput(
              isRTL: _isRTL,
              initialCountryCode: '+20', // Egypt
              hintText: _isRTL ? 'رقم الهاتف' : 'Phone number',
              onChanged: (phone, code) {
                setState(() {
                  _phoneNumber = phone;
                  _countryCode = code;
                });
              },
              onCountryChanged: (code, name, flag, iso) {
                setState(() {
                  _countryCode = code;
                  _countryName = name;
                  _countryFlag = flag;
                  _countryIso = iso;
                });
                
                // You can perform additional actions here when country changes
                print('Country changed to: $name ($code)');
                
                // Show a snackbar when country changes
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Country changed to $flag $name'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),
                // Add a subtle background color to show the text field area in RTL
                filled: _isRTL,
                fillColor: _isRTL ? Colors.grey.shade50 : null,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Display current country information
            if (_countryName.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isRTL ? 'البلد المختار:' : 'Selected Country:',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.blue.shade700,
                      ),
                      textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (!_isRTL) ...[
                          Text(
                            _countryFlag,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(
                                _countryName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                              ),
                              Text(
                                _isRTL ? '$_countryIso :ISO | $_countryCode :كود' : 'Code: $_countryCode | ISO: $_countryIso',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                                textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        if (_isRTL) ...[
                          const SizedBox(width: 12),
                          Text(
                            _countryFlag,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            if (_phoneNumber.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: _isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isRTL ? 'رقم الهاتف الكامل:' : 'Full Phone Number:',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                      textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_countryCode$_phoneNumber',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                      textDirection: TextDirection.ltr, // Always LTR for phone numbers
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            ElevatedButton(
              onPressed: _phoneNumber.isNotEmpty
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isRTL 
                              ? 'تم الإرسال: $_countryCode$_phoneNumber من $_countryName'
                              : 'Submitted: $_countryCode$_phoneNumber from $_countryName',
                            textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                          ),
                        ),
                      );
                    }
                  : null,
              child: Text(_isRTL ? 'إرسال' : 'Submit'),
            ),
          ],
        ),
      ),
    );
  }
}