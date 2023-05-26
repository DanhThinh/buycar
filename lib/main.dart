import 'dart:io';
import 'dart:ui';

import 'package:car_rent/providers/user_state.dart';
import 'package:car_rent/screens/home/home_screen.dart';
import 'package:car_rent/screens/home_car/discount_screen.dart';
import 'package:car_rent/screens/welcome/login_screen.dart';
import 'package:car_rent/screens/welcome/register_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive/hive.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'configs/basic_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await settingFirebaseApp();
  await setupHive();
  await setupAppLanguage();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => UserState(),
      ),
    ],
    builder: ((context, child) {
      context.read<UserState>().initData();
      return LocalizedApp(
        child: const MyApp(),
      );
    }),
  ));
}

//TODO innit Hive storage
Future setupHive() async {
  Directory documents = await getApplicationDocumentsDirectory();
  Hive.init(documents.path);
  await Hive.openBox(boxUserSettingName);
}

//init language for app
Future setupAppLanguage() async {
  late final Box boxUserSetting = Hive.box(boxUserSettingName);
  String languge = boxUserSetting.get("language", defaultValue: "");
  if (languge == "") {
    final currentLanguage = (window.locale).toString().split(RegExp('[-_]'))[0];
    if (supportedLanguage.contains(currentLanguage)) {
      boxUserSetting.put("language", currentLanguage);
      await translator.init(
        localeType: LocalizationDefaultType.device,
        languagesList: supportedLanguage,
        assetsDirectory: 'assets/langs/',
      );
    } else {
      await translator.init(
        language: defaulLanguage,
        languagesList: supportedLanguage,
        assetsDirectory: 'assets/langs/',
      );
    }
  } else {
    await translator.init(
      language: languge,
      languagesList: supportedLanguage,
      assetsDirectory: 'assets/langs/',
    );
  }
}

//init FireBase
Future settingFirebaseApp() async {
  await Firebase.initializeApp();
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  await remoteConfig.setDefaults(defaultRemoteConfig);
  await remoteConfig.fetchAndActivate();
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initialization();
    super.initState();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: translator.delegates, // Android + iOS Delegates
        locale: translator.activeLocale, // Active locale
        supportedLocales: translator.locals(),
        theme: ThemeData(
          fontFamily: "poppin",
          primarySwatch: Colors.blue,
        ),
        initialRoute: HomeScreen.id,
        routes: {
          RegisterScreen.id: (_) => const RegisterScreen(),
          HomeScreen.id: (_) => const HomeScreen(),
          LoginScreen.id: (_) => const LoginScreen(),
        },
      ),
    );
  }
}
