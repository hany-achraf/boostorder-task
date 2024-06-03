import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/di/injection_container.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/theming/themes.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final Stream<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged;
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.drain();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return StreamBuilder<List<ConnectivityResult>>(
            stream: _connectivitySubscription,
            builder: (_, snapshot) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Boostorder',
                theme: Themes.light,
                initialRoute: Routes.catalog,
                onGenerateRoute: sl<AppRouter>().generateRoute,
                builder: (_, child) => SafeArea(
                  top: true,
                  child: Column(
                    children: [
                      if (snapshot.hasData &&
                          snapshot.data!.last == ConnectivityResult.none)
                        Material(
                          child: Container(
                            width: double.infinity,
                            color: Colors.red.shade900,
                            padding: const EdgeInsets.all(8.0),
                            child: const Center(
                              child: Text(
                                'No connection!',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      else
                        const SizedBox(),
                      Expanded(child: child!),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
