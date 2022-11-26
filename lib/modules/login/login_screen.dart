import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/modules/login/cubit/cubit.dart';
import 'package:online_technician/modules/login/cubit/states.dart';
import 'package:online_technician/modules/register/register_screen.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/network/local/cache_helper.dart';



class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  var formKey =GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => AppLoginCubit(),
      child: BlocConsumer<AppLoginCubit, AppLoginState>(
        listener: (context, state) {
          ///----- show login error -----
          if(state is AppLoginErrorState)
          {
            showToast(text: state.error, state: ToastState.ERROR);
          }
          ///----- login success-----
          if(state is AppLoginSuccessState)
          {
            CacheHelper.savaData(
                key: 'uId',
                value: state.uid).then((value) {
              navigateToAndFinish(context, Container());/// main layout
            });
          }
        },
        builder: (context, state) {

          var cubit = AppLoginCubit.get(context);

          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Text(
                          'login now to connect with....',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        defaultFormText(
                          validate: (value) {
                            if(value.toString().isEmpty)
                            {
                              return 'email is too short!';
                            }
                            return null;
                          },
                          controller: emailController,
                          label: 'Email Address',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormText(
                          isPassword: cubit.isPassword,
                          validate: (value) {
                            if(value.toString().isEmpty)
                            {
                              return 'password does not match email!';
                            }
                            return null;
                          },
                          controller: passwordController,
                          label: 'Password',
                          keyboardType: TextInputType.visiblePassword,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            onPressed: () {
                              cubit.showPassword();
                            },
                            icon:cubit.isPassword?const Icon(Icons.visibility):const Icon(Icons.visibility_off_outlined),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is !AppLoginLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if(formKey.currentState!.validate())
                              {
                                cubit.userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            text: 'Login',
                            isUpperCase: true,
                            color: Colors.blue,
                          ),
                          fallback: (context) =>const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: [
                            const Text('Don\'t have an account?'),
                            TextButton(
                              onPressed: () {
                                navigateTo(context, RegisterScreen());
                              },
                              child:const Text('register now'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}
