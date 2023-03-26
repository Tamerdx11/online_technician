// @dart=2.9
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:online_technician/firebase_options.dart';
import 'package:online_technician/layout/home_layout.dart';
import 'package:online_technician/modules/login/login_screen.dart';
import 'package:online_technician/modules/on_boarding/on_boarding_screen.dart';
import 'package:online_technician/shared/bloc_observer.dart';
import 'package:online_technician/shared/components/constants.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';
import 'package:online_technician/shared/network/local/cache_helper.dart';
import 'package:online_technician/shared/network/remote/dio_helper.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  messagesNumber++;
  // showToast(text: "new notification", state: ToastState.SUCCESS);
}

initialMessage() async {
  var message = await FirebaseMessaging.instance.getInitialMessage();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// ----------firebase initialization -----------

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  ///....... app opened ...............
  FirebaseMessaging.onMessage.listen((event) {
    messagesNumber++;
   // showToast(text: '${event.notification.title.toString()}: ${event.notification.body.toString()}', state: ToastState.SUCCESS);
  });

  ///...........app opened in background........
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    messagesNumber++;
  });

  ///............app closed......
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Widget widget = null;
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  ///---------- get cached data ----------

  bool isDark = CacheHelper.getData(key: 'isDark') ?? false;
  bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  uId = CacheHelper.getData(key: 'uId');

  ///---------- select start screen ----------

  if (onBoarding != null) {
    if (uId == null) {
      widget = LoginScreen();
    } else {
      widget = AppLayout();
    }
  } else {
    widget = const OnBoardingScreen();
  }

  runApp(MyApp(
    isDark: isDark,
    widget: widget,
  ));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  bool isDark = false;
  Widget widget;

  MyApp({Key key, this.isDark, this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AppCubit()..getUserData()),
      ],
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
            ],
            supportedLocales:const [
              Locale('ar', 'SA'),
            ],
            // theme: lightTheme,
            // darkTheme: darkTheme,
            // themeMode:AppCubit.get(context).isDark?ThemeMode.dark:ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: widget,
          );
        },
      ),
    );
  }
}
