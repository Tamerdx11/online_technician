import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:online_technician/shared/components/constants.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';
import 'package:online_technician/shared/styles/colors.dart';

import '../../models/user.dart';
import '../../shared/components/components.dart';

// ignore: must_be_immutable
class ReportScreen extends StatelessWidget {
  String reportUsername, reportUserId;
  var formKey = GlobalKey<FormState>();
  ReportScreen({
    super.key,
    required this.reportUsername,
    required this.reportUserId,
  });

  var reportController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is CreatReportedUserErrorState) {
          showToast(text: "تم الابلاغ بنجاح", state: ToastState.SUCCESS);
        }
      },
      builder: (context, state) {

        return Scaffold(
          appBar: AppBar(
            backgroundColor: header_color,
            elevation: 8.0,
            centerTitle: true,
            title: const Text("إبلاغ", style: TextStyle(color: Colors.white)),
            foregroundColor: Colors.white,
          ),
          backgroundColor: background_color,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'يرجي كتابة سبب الإبلاغ حتي نتمكن من التحقق من الأمر * ',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30.0,),
                      TextFormField(
                        controller: reportController,
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          hintText: "ما الذي تراه غير مقبول؟..",
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
                            return 'يرجي إدخال إبلاغك';
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
                          text: "إرسال الإبلاغ",
                          function: () {
                            if (formKey.currentState!.validate()) {
                              AppCubit.get(context).createReportedUser(
                                dateReport:'${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}',
                                reportedUId: reportUserId,
                                reportedUsername: reportUsername,
                                senderUId: uId,
                                senderUsername: AppCubit.get(context).model.name,
                                notes: reportController.text,
                                context: context,
                              );
                            }
                          },
                          size: 17.0,
                          isUpperCase: true,
                          color: header_color,
                          width: 140,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
