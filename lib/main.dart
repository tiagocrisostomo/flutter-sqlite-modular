import 'dart:io';
import 'dart:ui';
import 'package:db_sqlite/firebase_options.dart';
import 'package:db_sqlite/screens/desktop/login_screen_desktop.dart';
import 'package:db_sqlite/store/finan_lancamento_store.dart';
import 'package:db_sqlite/widgets/build_responsivo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:db_sqlite/store/auth_store.dart';
import 'package:db_sqlite/store/finan_tipo_store.dart';
import 'package:db_sqlite/store/usuario_store.dart';
import 'package:db_sqlite/store/finan_categoria_store.dart';
import 'package:db_sqlite/utils/seed.dart';
import 'package:db_sqlite/screens/mobile/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid || Platform.isIOS) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await inicializarBancoComDadosPadrao();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthStore()),
        ChangeNotifierProvider(create: (_) => UsuarioStore()),
        ChangeNotifierProvider(create: (_) => FinanTipoStore()),
        ChangeNotifierProvider(create: (_) => FinanCategoriaStore()),
        ChangeNotifierProvider(create: (_) => FinanLancamentoStore()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        home: BuildResponsivo(desktop: LoginScreenDesktop(), mobile: LoginScreen(), tablet: LoginScreen()),
        title: 'Login',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          primaryColor: Colors.blueGrey,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.black),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            ),
          ),
        ),
      ),
    ),
  );
}
