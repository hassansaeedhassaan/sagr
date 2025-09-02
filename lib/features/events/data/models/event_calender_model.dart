import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';

class EventCalenderModel {
  final int? id;
  final String? name;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;

  const EventCalenderModel({
    required this.id,
    this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
  });

  factory EventCalenderModel.fromJson(Map<String, dynamic> json) {
    try {
      return EventCalenderModel(
        id: _parseToInt(json['id']),
        name: json['name'],
        description: json['description'],
        startTime: DateTime.parse(json['startTime']),
        endTime: DateTime.parse(json['endTime']),
      );
    } catch (e) {
      print('Error in EventCalenderModel.fromJson: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }

  static int _parseToInt(dynamic value) {
    if (value == null) {
      throw ArgumentError('Cannot parse null to int');
    }
    
    if (value is int) return value;
    
    if (value is double) return value.toInt();
    
    if (value is String) {
      // Handle empty or whitespace strings
      if (value.trim().isEmpty) {
        throw ArgumentError('Cannot parse empty string to int');
      }
      
      try {
        return int.parse(value.trim());
      } catch (e) {
        throw ArgumentError('Cannot parse "$value" to int: $e');
      }
    }
    
    throw ArgumentError('Cannot parse $value (${value.runtimeType}) to int');
  }

  @override
  String toString() {
    return name ?? 'Unnamed Event';
  }
}