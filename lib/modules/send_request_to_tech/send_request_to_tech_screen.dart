import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

// ignore: must_be_immutable
class SendRequestToTechScreen extends StatelessWidget {
  String id, name, userImage, latitude, longitude, location;

  SendRequestToTechScreen(
      {Key? key,
      required this.id,
      required this.name,
      required this.userImage,
      required this.latitude,
      required this.longitude,
      required this.location})
      : super(key: key);

  var detailsController = TextEditingController();
  var dateController = TextEditingController();
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  int day = DateTime.now().day;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        print(
            '---------------------------------------------date----------------');
        print(
            ('${DateTime.now().year + 1}-${DateTime.now().month + 2}-${DateTime.now().day}'));

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 1.0,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 21.2,
                  child: CircleAvatar(
                    radius: 21.0,
                    backgroundImage: NetworkImage(userImage),
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                  'طلب عمل الي $name',
                  style: const TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black87,
              ),
            ),
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: 200.0,
                          child: defaultFormText(
                            onTap: () {
                              DatePicker.showSimpleDatePicker(
                                context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse(
                                    '${DateTime.now().year + 1}-12-01'),
                                dateFormat: "dd-MMMM-yyyy",
                                locale: DateTimePickerLocale.ar,
                                cancelText: 'ألغاء',
                                confirmText: 'تم',
                                titleText: 'حدد التاريخ',
                                textColor: Colors.blueAccent,
                                pickerMode: DateTimePickerMode.date,
                                looping: false,
                              ).then((value) {
                                year = value!.year;
                                month = value.month;
                                day = value.day;
                                dateController.text = '$year/$month/$day';
                              });
                            },
                            validate: (value) {
                              if (value.toString().isEmpty) {
                                return 'لا يمكنك إرسال طلب عمل بلا تاريخ';
                              }
                              return null;
                            },
                            controller: dateController,
                            keyboardType: TextInputType.none,
                            prefixIcon: const Icon(
                              Icons.date_range,
                              color: Colors.black54,
                            ),
                            label: 'التاريخ',
                            maxLines: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 35.0,),
                      const Text(
                        'تاريخ الإنتهاء من العمل ⓘ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 16.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50.0),
                  const Text(
                    'ⓘ يرجي كتابة بعض التفاصيل لتوضيح العمل الذي يجب علي الحرفي القيام به.',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textDirection: ui.TextDirection.rtl,
                    softWrap: true,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 18.0),
                  ),
                  const SizedBox(height: 10.0),
                  defaultFormText(
                    validate: (value) {
                      if (value.toString().isEmpty) {
                        return 'لا يمكنك ارسال طلب عمل بلا تفاصيل';
                      }
                      return null;
                    },
                    controller: detailsController,
                    prefixIcon: const Icon(
                      Icons.edit_note_rounded,
                      color: Colors.black54,
                    ),
                    label: ' التفاصيل... ',
                    maxLines: 5,
                  ),
                  const SizedBox(height: 50.0),
                  defaultButton(
                    function: (){},
                    text: ' إرسال الطلب ',
                    size: 17.0,
                    color: Colors.black87,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 10.0),
                    child: Text(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textDirection: ui.TextDirection.rtl,
                      softWrap: true,
                      'عند إرسال الطلب الي $name سيتمكن من رؤية تفاصيل هذا الطلب وبأمكانه الموافقة او الرفض وسيتم إعلامك بذلك.',
                      style:const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),

                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
