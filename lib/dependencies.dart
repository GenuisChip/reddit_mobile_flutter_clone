import 'layers/data/data_source_interfaces/posts_data_source_interface.dart';
import 'layers/data/data_source/network/posts_network_data_source.dart';
import 'layers/data/data_source/local/posts_local_data_source.dart';
import 'layers/domain/repositories/posts_repo_interface.dart';
import 'layers/domain/usecases/posts_use_case.dart';
import 'layers/data/repositories/post_repo.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'commons/network/network_info/network_info.dart';
import 'layers/data/data_source/in_memory_cache.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';

final sl = GetIt.instance;

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initMethods <<!dot't delete this line>>
  _initPostsDependencies();

  //common
  var pref = await SharedPreferences.getInstance();
  sl.registerFactory<INetworkInfo>(() => NetworkInfo(sl()));
  sl.registerFactory(() => InMemoryCache());
  sl.registerFactory(() => pref);

  sl.registerLazySingleton(() => InternetConnectionChecker());
}

void _initPostsDependencies() {
  sl.registerFactory(() => PostsUseCase(repo: sl()));
  sl.registerLazySingleton<IPostsRepo>(
    () => PostsRepo(
      networkDataSource: sl(),
      localDataSource: sl(),
      inMemoryCache: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerFactory<IPostsLocalDataSource>(
    () => PostsLocalDataSource(preferences: sl()),
  );
  sl.registerFactory<IPostsNetworkDataSource>(
    () => PostsNetworkDataSource(),
  );
}
