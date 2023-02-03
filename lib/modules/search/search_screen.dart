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
        var data = AppCubit.get(context).search; ///search data

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              title:Text("البحث",style: TextStyle(color: Colors.black,fontFamily: 'NotoNaskhArabic',fontWeight: FontWeight.w600)),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon:const Icon(Icons.arrow_back_sharp,color: Colors.black,),
              )),
          body: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20,left: 20,bottom: 20),
                  child: TextFormField(
                    validator: (value)
                    {
                      if(value == null)
                      {
                        return "search must not be empty";
                      }
                      return null;
                    },
                    controller: searchController,
                    onChanged: (value) {
                      AppCubit.get(context).getSearchData(value,'name');
                    },
                    decoration: InputDecoration(
                      labelText: "Search...",
                      prefixIcon: const Icon(Icons.search_sharp,color: Colors.black),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30),borderSide: BorderSide(color: Colors.black)),
                    ),
                    onFieldSubmitted: (value){
                      AppCubit.get(context).getSearchData(value,'name');
                    },

                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics:const BouncingScrollPhysics(),
                  reverse: true,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5,bottom: 10,left: 20),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("نقاش",'profession');
                          }, child: Text(
                            "نقاش",
                            style: TextStyle(color: Colors.white,fontSize: 18),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("كهربائي",'profession');
                          }, child: Text(
                            "كهربائي",
                            style: TextStyle(color: Colors.white,fontSize: 18),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("نجار",'profession');
                          }, child: Text(
                            "نجار",
                            style: TextStyle(color: Colors.white,fontSize: 18),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("صيانة حمامات السباحة",'profession');
                          }, child: Text(
                            "صيانة حمامات السباحة",
                            style: TextStyle(color: Colors.white,fontSize: 18),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("سباك",'profession');
                          }, child: Text(
                            "سباك",
                            style: TextStyle(color: Colors.white,fontSize: 18),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("بنّاء",'profession');
                          }, child: Text(
                            "بنّاء",
                            style: TextStyle(color: Colors.white,fontSize: 18),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("ميكانيكي",'profession');
                          }, child: Text(
                            "ميكانيكي",
                            style: TextStyle(color: Colors.white,fontSize: 18),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("مكافحة حشرات",'profession');
                          }, child: Text(
                            "مكافحة حشرات",
                            style: TextStyle(color: Colors.white,fontSize: 18),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("صيانة اجهزة منزلية",'profession');
                          }, child: Text(
                            "صيانة اجهزة منزلية",
                            style: TextStyle(color: Colors.white,fontSize: 18),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("صيانة دش",'profession');

                          }, child: Text(
                            "صيانة دش",
                            style: TextStyle(color: Colors.white,fontSize: 18),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("اعمال زجاج",'profession');
                          }, child: Text(
                            "اعمال زجاج",
                            style: TextStyle(color: Colors.white,fontSize: 18),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("اعمال رخام",'profession');
                          }, child: Text(
                            "اعمال رخام",
                            style: TextStyle(color: Colors.white,fontSize: 18),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("عامل بناء",'profession');
                          }, child: Text(
                            "عامل بناء",
                            style: TextStyle(color: Colors.white,fontSize: 18),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("اعمال ارضيات",'profession');
                          }, child: Text(
                            "اعمال ارضيات",
                            style: TextStyle(color: Colors.white,fontSize: 18),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("حداد",'profession');
                          }, child: Text(
                            "حداد",
                            style: TextStyle(color: Colors.white,fontSize: 18),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5,bottom: 10,left: 5),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("محار",'profession');

                          }, child: Text(
                            "محار",
                            style: TextStyle(color: Colors.white,fontSize: 18),
                          )

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20,bottom: 10,left: 5),
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.black),
                          child: TextButton(onPressed: (){
                            AppCubit.get(context).getSearchData("جزار",'profession');
                          }, child: Text(
                            "جزار",
                            style: TextStyle(color: Colors.white,fontSize: 18),
                            selectionColor: Colors.red,
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