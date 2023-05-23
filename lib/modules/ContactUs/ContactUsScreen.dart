import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/layout/home_layout.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';
import 'package:online_technician/shared/styles/colors.dart';
import '../../models/technician.dart';
import '../../shared/components/components.dart';

// ignore: must_be_immutable
class ContactUsScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  ContactUsScreen({super.key,});

  var reportController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if(state is FeedbackSentSuccessState){
          Navigator.pop(context);
          showToast(text: 'تم الارسال بنجاح, شكرا لك', state: ToastState.SUCCESS);
        }
      },
      builder: (context, state) {

        return Scaffold(
          appBar: AppBar(
            backgroundColor: header_color,
            elevation: 8.0,
            centerTitle: true,
            title: const Text("تواصل معنا ", style: TextStyle(color: Colors.white,fontSize: 18.0 ),),
            foregroundColor: Colors.white,
          ),
          backgroundColor:background_color,
          body: SingleChildScrollView(
            child: Column(
              children: [
                if(state is SendingFeedbackState)
                  const LinearProgressIndicator(color: Colors.greenAccent),
                const SizedBox(height: 100.0,),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'يرجي كتابة المشكلة او ما تود أن تره في التحديثات القادمة ',

                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(height: 30.0,),
                            TextFormField(
                              controller: reportController,
                              textDirection: TextDirection.rtl,
                              decoration: InputDecoration(
                                hintText: "اكتب تعليقك هنا..",
                                hintTextDirection: TextDirection.rtl,
                                focusColor: Colors.grey,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ),
                                    borderSide: const BorderSide(color: Colors.grey)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.grey)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ),
                                    borderSide: const BorderSide(color: Colors.grey)),
                              ),
                              maxLines: 10,
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return 'يرجي كتابة تعليق..';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: defaultButton(
                                text: "ارسال",
                                function: () {
                                  if(formKey.currentState!.validate()) {
                                    AppCubit.get(context).ContatcUs();
                                  }
                                },
                                size: 17.0,
                                isUpperCase: true,
                                color: header_color,
                                width: 100,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
