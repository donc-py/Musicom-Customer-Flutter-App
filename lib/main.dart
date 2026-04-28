import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/config/theme.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/generated/l10n.dart';
import 'package:readypos_flutter/models/cart_models/hive_cart_model.dart';
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/utils/global_function.dart';
import 'package:readypos_flutter/views/more/components/language_dialog.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(AppConstants.appSettingsBox);
  await Hive.openBox(AppConstants.authBox);
  Hive.registerAdapter(HiveCartModelAdapter());
  await Hive.openBox<HiveCartModel>(AppConstants.cartBox);
  // HttpOverrides.global =  MyHttpOverrides();
  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) {
  //       return const ProviderScope(child: MyApp());
  //     }));
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Locale resolveLocal({required String langCode}) {
    return Locale(langCode);
  }

  @override
  Widget build(BuildContext context) {
    final isLargeDevice = MediaQuery.sizeOf(context).shortestSide > 600;
    if (MediaQuery.sizeOf(context).shortestSide > 600) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
    );
    return ScreenUtilInit(
      designSize: context.isTabletLandsCape
          ? const Size(601, 800)
          : const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: false,
      child: AdaptiveTheme(
          light: AppTheme.lightTheme,
          dark: AppTheme.darkTheme,
          initial: AdaptiveThemeMode.light,
          builder: (theme, darkTheme) {
            return ValueListenableBuilder(
                valueListenable:
                    Hive.box(AppConstants.appSettingsBox).listenable(),
                builder: (context, appSettingsBox, _) {
                  final selectedLocal =
                      appSettingsBox.get(AppConstants.appLocal);
                  if (selectedLocal == null) {
                    appSettingsBox.put(
                      AppConstants.appLocal,
                      AppLanguage(
                              name: '\ud83c\uddfa\ud83c\uddf8 ENG', value: 'en')
                          .toMap(),
                    );
                  }
                  return MaterialApp(
                    title: 'MUCICOM',
                    navigatorKey: GlobalFunction.navigatorKey,
                    localizationsDelegates: const [
                      S.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    locale: resolveLocal(
                      langCode:
                          selectedLocal == null ? 'en' : selectedLocal['value'],
                      // langCode: 'en'
                    ),
                    localeResolutionCallback: (deviceLocal, supportedLocales) {
                      for (final locale in supportedLocales) {
                        if (locale.languageCode == deviceLocal!.languageCode) {
                          return deviceLocal;
                        }
                      }
                      return supportedLocales.first;
                    },
                    supportedLocales: S.delegate.supportedLocales,
                    theme: theme,
                    darkTheme: darkTheme,
                    initialRoute: Routes.splash,
                    onGenerateRoute: generatedRoutes,
                  );
                });
          }),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
