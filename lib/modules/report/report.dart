import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';

import '../../models/user.dart';
import '../../shared/components/components.dart';

// ignore: must_be_immutable
class ReportScreen extends StatelessWidget {
  UserModel userModel;
  var formKey = GlobalKey<FormState>();
  ReportScreen({ super.key,
  required this.userModel,});
  var reportController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if(state is CreatReportedUserErrorState){
          showToast(text: "تم الابلاغ بنجاح", state: ToastState.SUCCESS);
        }
      },
      builder: (context, state) {

        return Scaffold(
          appBar: AppBar(
            backgroundColor: HexColor('#ebebeb'),
            elevation: 0,
            centerTitle: true,
          title: Text("إبلاغ",style: TextStyle(color: Colors.black)),
          foregroundColor: Colors.black,
          ),
          backgroundColor: HexColor('#ebebeb'),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: reportController,
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          hintText: "اكتب ملاحظاتك..",
                          hintTextDirection: TextDirection.rtl,
                          focusColor: Colors.grey,
                          focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                          borderSide:const BorderSide(color: Colors.grey)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:const BorderSide(color: Colors.grey)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                            borderSide:const BorderSide(color: Colors.grey)),
                      ),
                      maxLines: 10,
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return 'يرجي ادخال ملاحظاتك';
                        }
                        else{
                          return null;
                        }
                      },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      defaultButton(
                        text: "ابلاغ",
                        function: (){
                          if(formKey.currentState!.validate()){
                            AppCubit.get(context)
                                .createreprotedUser(
                              uId: userModel.uId!,
                              name: userModel.name!,
                              notes1: reportController.text,
                              context: context,
                            );
                          }
                        },
                        size: 17.0,
                        isUpperCase: true,
                        color: Colors.black,
                        width: 100,
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