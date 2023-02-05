import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';

// ignore: must_be_immutable
class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var data = AppCubit.get(context).search;


        return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.only(top: 45.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20,left: 20,bottom: 8.0),
                  child: TextFormField(
                    validator: (value) {
                      if(value == null)
                      {
                        return "شريط البحث فارغ";
                      }
                      return null;
                    },
                    controller: searchController,
                    onChanged: (value) {
                      AppCubit.get(context).getSearchData(value,'name');
                    },
                    decoration: InputDecoration(
                      labelText: "بحث...",
                      prefixIcon: const Icon(
                        Icons.search_sharp,
                        color: Colors.black87,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide:const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide:const BorderSide(color: Colors.black),
                      ),
                    ),
                    onFieldSubmitted: (value){
                      AppCubit.get(context).getSearchData(value,'name');
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 3.0),
                  child: Text(
                    " :الأكثر بحثا",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics:const BouncingScrollPhysics(),
                  reverse: true,
                  padding:const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Padding(
                        padding:const  EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 32,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black87),
                          child: TextButton(onPressed: (){
                            data =[];
                            AppCubit.get(context).getSearchData("نقاش",'profession');
                            searchController.text = "نقاش";
                          }, child:const Text(
                            "نقاش",
                            style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding:const  EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 32.0,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black87),
                          child: TextButton(onPressed: (){
                            data =[];
                            AppCubit.get(context).getSearchData("كهربائي",'profession');
                            searchController.text = "كهربائي";
                          }, child:const Text(
                            "كهربائي",
                            style: TextStyle(color: Colors.white,fontSize: 12, fontWeight: FontWeight.bold),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding:const  EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 32.0,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black87),
                          child: TextButton(onPressed: (){
                            data =[];
                            AppCubit.get(context).getSearchData("نجار",'profession');
                            searchController.text = "نجار";
                          }, child:const Text(
                            "نجار",
                            style: TextStyle(color: Colors.white,fontSize: 12, fontWeight: FontWeight.bold),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding:const  EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 32.0,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black87),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("صيانة حمامات السباحة",'profession');
                            searchController.text = "صيانة حمامات السباحة";
                          }, child:const Text(
                            "صيانة حمامات السباحة",
                            style: TextStyle(color: Colors.white,fontSize: 12, fontWeight: FontWeight.bold),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding:const  EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 32.0,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black87),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("سباك",'profession');
                            searchController.text = "سباك";
                          }, child:const Text(
                            "سباك",
                            style: TextStyle(color: Colors.white,fontSize: 12, fontWeight: FontWeight.bold),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding:const  EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 32.0,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black87),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("عامل بناء",'profession');
                            searchController.text = "عامل بناء";
                          }, child:const Text(
                            "عامل بناء",
                            style: TextStyle(color: Colors.white,fontSize: 12, fontWeight: FontWeight.bold),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding:const  EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 32.0,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black87),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("ميكانيكي",'profession');
                            searchController.text = "ميكانيكي";
                          }, child:const Text(
                            "ميكانيكي",
                            style: TextStyle(color: Colors.white,fontSize: 12, fontWeight: FontWeight.bold),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding:const  EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 32.0,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black87),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("مكافحة حشرات",'profession');
                            searchController.text = "مكافحة حشرات";
                          }, child:const Text(
                            "مكافحة حشرات",
                            style: TextStyle(color: Colors.white,fontSize: 12, fontWeight: FontWeight.bold),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding:const  EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 32.0,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black87),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("صيانة أجهزة منزلية",'profession');
                            searchController.text = "صيانة أجهزة منزلية";
                          }, child:const Text(
                            "صيانة أجهزة منزلية",
                            style: TextStyle(color: Colors.white,fontSize: 12, fontWeight: FontWeight.bold),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding:const  EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 32.0,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black87),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("صيانة دش",'profession');
                            searchController.text = "صيانة دش";
                          }, child:const Text(
                            "صيانة دش",
                            style: TextStyle(color: Colors.white,fontSize: 12, fontWeight: FontWeight.bold),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding:const  EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 32.0,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black87),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("أعمال زجاج",'profession');
                            searchController.text = "أعمال زجاج";
                          }, child:const Text(
                            "أعمال زجاج",
                            style: TextStyle(color: Colors.white,fontSize: 12, fontWeight: FontWeight.bold),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding:const  EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 32.0,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black87),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("أعمال رخام",'profession');
                            searchController.text = "أعمال رخام";
                          }, child:const Text(
                            "أعمال رخام",
                            style: TextStyle(color: Colors.white,fontSize: 12, fontWeight: FontWeight.bold),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding:const  EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 32.0,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black87),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("بنّاء",'profession');
                            searchController.text = "بنّاء";
                          }, child:const Text(
                            "بنّاء",
                            style: TextStyle(color: Colors.white,fontSize: 12, fontWeight: FontWeight.bold),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding:const  EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 32.0,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black87),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("أعمال أرضيات",'profession');
                            searchController.text = "أعمال أرضيات";
                          }, child:const Text(
                            "أعمال أرضيات",
                            style: TextStyle(color: Colors.white,fontSize: 12, fontWeight: FontWeight.bold),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding:const  EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 32.0,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black87),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("حداد",'profession');
                            searchController.text = "حداد";
                          }, child:const Text(
                            "حداد",
                            style: TextStyle(color: Colors.white,fontSize: 12, fontWeight: FontWeight.bold),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding:const  EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 32.0,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black87),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("محار",'profession');
                            searchController.text = "محار";
                          }, child:const Text(
                            "محار",
                            style: TextStyle(color: Colors.white,fontSize: 12, fontWeight: FontWeight.bold),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding:const  EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 32.0,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black87),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("جزار",'profession');
                            searchController.text = "جزار";
                          }, child:const Text(
                            "جزار",
                            style: TextStyle(color: Colors.white,fontSize: 12, fontWeight: FontWeight.bold),
                          )

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: searchResultsBuilder(data, context)),
              ],
            ),
          ),
        );
      },
    );
  }
}