import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'commons/network/network_info/network_info.dart';
import 'layers/data/data_source/in_memory_cache.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

final sl = GetIt.instance;

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  //common
  var pref = await SharedPreferences.getInstance();
  sl.registerFactory<INetworkInfo>(() => NetworkInfo(sl()));
  sl.registerFactory(() => InMemoryCache());
  sl.registerFactory(() => pref);

  sl.registerLazySingleton(() => InternetConnectionChecker());
}
