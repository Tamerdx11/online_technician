import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';

// ignore: must_be_immutable
class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  var searchController = TextEditingController();
  String groupValue = '';
  bool result = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if(state is AppEmptySearchState){
          result = false;
        }
        if(state is AppLoadingState1){
          result = true;
        }
      },
      builder: (context, state) {
        var data = AppCubit.get(context).search;
        var cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: HexColor('#ebebeb'),
          body: Padding(
            padding: const EdgeInsets.only(top: 45.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20,left: 20,bottom: 5.0),
                  child: TextFormField(
                    textDirection: TextDirection.rtl,
                    validator: (value) {
                      if(value == null)
                      {
                        return "شريط البحث فارغ";
                      }
                      return null;
                    },
                    controller: searchController,
                    onChanged: (value) {
                      AppCubit.get(context).getSearchData(value,cubit.searchItem);
                    },
                    decoration: InputDecoration(
                      fillColor: HexColor('#c6dfe7'),
                      labelText: "بحث...",
                      prefixIcon: const Icon(
                        Icons.search_sharp,
                        color: Colors.black54,
                      ),
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:const BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:const BorderSide(color: Colors.black54),
                      ),
                    ),
                    onFieldSubmitted: (value){
                      AppCubit.get(context).getSearchData(value,'name');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          const Text(
                            " الأسم",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                          Radio(
                            value: cubit.values[0],
                            groupValue: cubit.searchItem,
                            onChanged: (value) => cubit.changeSearchItem(value),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10.0,),
                      Row(
                        children: [
                          const Text(
                            " الحرفة",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                          Radio(
                            value: cubit.values[1],
                            groupValue: cubit.searchItem,
                            onChanged: (value) => cubit.changeSearchItem(value),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Text(
                        " :البحث عن طريق",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14.0,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0,right: 20.0, bottom: 5.0),
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
                            cubit.changeSearchItem('profession');
                            AppCubit.get(context).getSearchData("نقاش",cubit.searchItem);
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
                            cubit.changeSearchItem('profession');
                            AppCubit.get(context).getSearchData("كهربائي",cubit.searchItem);
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
                            cubit.changeSearchItem('profession');
                            AppCubit.get(context).getSearchData("نجار",cubit.searchItem);
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
                            data =[];
                            cubit.changeSearchItem('profession');
                            AppCubit.get(context).getSearchData("صيانة حمامات السباحة",cubit.searchItem);
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
                            data =[];
                            cubit.changeSearchItem('profession');
                            AppCubit.get(context).getSearchData("سباك",cubit.searchItem);
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
                            data =[];
                            cubit.changeSearchItem('profession');
                            AppCubit.get(context).getSearchData("عامل بناء",cubit.searchItem);
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
                            data =[];
                            cubit.changeSearchItem('profession');
                            AppCubit.get(context).getSearchData("ميكانيكي",cubit.searchItem);
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
                            data =[];
                            cubit.changeSearchItem('profession');
                            AppCubit.get(context).getSearchData("مكافحة حشرات",cubit.searchItem);
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
                            data =[];
                            cubit.changeSearchItem('profession');
                            AppCubit.get(context).getSearchData("صيانة أجهزة منزلية",cubit.searchItem);
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
                            data =[];
                            cubit.changeSearchItem('profession');
                            AppCubit.get(context).getSearchData("صيانة دش",cubit.searchItem);
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
                            data =[];
                            cubit.changeSearchItem('profession');
                            AppCubit.get(context).getSearchData("أعمال زجاج",cubit.searchItem);
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
                            data =[];
                            cubit.changeSearchItem('profession');
                            AppCubit.get(context).getSearchData("أعمال رخام",cubit.searchItem);
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
                            data =[];
                            cubit.changeSearchItem('profession');
                            AppCubit.get(context).getSearchData("بنّاء",cubit.searchItem);
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
                            data =[];
                            cubit.changeSearchItem('profession');
                            AppCubit.get(context).getSearchData("أعمال أرضيات",cubit.searchItem);
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
                            data =[];
                            cubit.changeSearchItem('profession');
                            AppCubit.get(context).getSearchData("حداد",cubit.searchItem);
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
                            data =[];
                            cubit.changeSearchItem('profession');
                            AppCubit.get(context).getSearchData("محار",cubit.searchItem);
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
                            data =[];
                            cubit.changeSearchItem('profession');
                            AppCubit.get(context).getSearchData("جزار",cubit.searchItem);
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
                if(data.isEmpty)
                  result?const Center(child: LinearProgressIndicator()):
                  const Center(child: Padding(
                    padding: EdgeInsets.only(bottom: 50.0),
                    child: Text(
                      '!لم نجد نتائج لبحثك',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
              ],
            ),
          ),
        );
      },
    );
  }
}