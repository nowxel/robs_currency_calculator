import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:robs_currency_calculator/models/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common_utils.dart';

SettingsModel globalSettings;

class LocalStorage {

  Future<void> saveCurrency(List<String> currencies) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      prefs.setStringList('currency', currencies);
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<String>> getCurrency() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      return prefs.getStringList('currency');
    } catch (error) {
      throw Exception('No credentials found');
    }
  }

  Future<void> saveSettings(SettingsModel settings) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    globalSettings = settings;
    final String setting = json.encode(settings.toJson());
    try {
      globalSettings = settings;
      prefs.setString('setting', setting);
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<SettingsModel> getSettings() async {
    if (globalSettings == null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        final Map<String, dynamic> json =
        jsonDecode(prefs.getString('setting')) as Map<String, dynamic>;
        final SettingsModel result = SettingsModel.fromJson(json);
        return globalSettings = result;
      } catch (error) {
        return globalSettings = SettingsModel();
      }
    } else {
      return globalSettings;
    }
  }

  Future<String> getFirstStartDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String firstStart;
    try {
      firstStart = prefs.getString('first_start');
    } catch (error) {
      debugPrint('Error getting shared preferences');
    }
    return firstStart;
  }

  Future<void> setFirstStartDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('first_start', CommonUtils().getCurrentDate(),);
  }

  Future<DateTime> getLastUpdateDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime lastUpdate;
    try {
      lastUpdate = CommonUtils().stringToDate(date: prefs.getString('last_update'), dateFormatPattern: CommonUtils.dateFormatPattern);
    } catch (error) {
      debugPrint('Error getting shared preferences');
    }
    return lastUpdate;
  }

  Future<void> setLastUpdateDate(DateTime lastUpdate) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('last_update', CommonUtils().dateToString(dateTime: lastUpdate, dateFormatPattern: CommonUtils.dateFormatPattern),);
  }

}
