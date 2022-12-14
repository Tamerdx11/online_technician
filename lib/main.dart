import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:online_technician/firebase_options.dart';
import 'package:online_technician/layout/home_layout.dart';
import 'package:online_technician/modules/login/login_screen.dart';
import 'package:online_technician/modules/on_boarding/on_boarding_screen.dart';
import 'package:online_technician/shared/bloc_observer.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/components/constants.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';
import 'package:online_technician/shared/network/local/cache_helper.dart';
import 'package:online_technician/shared/network/remote/dio_helper.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
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
    showToast(text: '${event.notification!.title.toString()}: ${event.notification!.body.toString()}', state: ToastState.SUCCESS);
  });

  ///...........app opened in background........
  FirebaseMessaging.onMessageOpenedApp.listen((event) {});

  ///............app closed......
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Widget? widget = null;
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

  ///------------------------------------
  runApp(MyApp(
    isDark: isDark,
    widget: widget,
  ));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  bool? isDark = false;
  Widget widget;

  MyApp({super.key, this.isDark, required this.widget});

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
