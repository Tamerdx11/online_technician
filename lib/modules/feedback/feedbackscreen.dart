import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';
import 'package:online_technician/shared/styles/colors.dart';
import '../../models/technician.dart';
import '../../shared/components/components.dart';

// ignore: must_be_immutable
class feddbackscreen extends StatelessWidget {
  String id;
  TechnicianModel? Tech;
  var deadline;
  var formKey = GlobalKey<FormState>();
  feddbackscreen({
    super.key,
    required this.id,
    required this.Tech,
    required this.deadline,
  });

  var reportController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is apierrrorstate) {
          showToast(text: "خطأ في الاتصال حاول مرة اخري", state: ToastState.ERROR);
        }
        if (state is apisuccesstate) {
          showToast(text: "تم ارسال تقييمك بنجاح", state: ToastState.SUCCESS);
          AppCubit.get(context).changeSendRequestStates(
            userId: id,
            techReceivedRequests: Tech?.receivedRequests,
            deadline: true,
            done: true,
            rated: true,
            accepted: true,
            rejected: false,
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {

        return Scaffold(
          appBar: AppBar(
            backgroundColor: header_color,
            elevation: 8.0,
            centerTitle: true,
            title: const Text("تقييم جودة العمل", style: TextStyle(color: Colors.black)),
            foregroundColor: Colors.black,
          ),
          backgroundColor:background_color,
          body: SingleChildScrollView(
            child: Column(
              children: [
                if(state is AppSendingRequestState)
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
                              'يرجي كتابة مدي رضاك عن العمل الذي فام به الحرفي * ',
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
                                hintText: "اكتب تقييمك..",
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
                                  return 'يرجي ادخال التقييم..';
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
                                text: "تقييم",
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    AppCubit.get(context).getTech(id);
                                    AppCubit.get(context).testApi(userid: id,text: reportController.text);
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
