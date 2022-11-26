import 'package:flutter/material.dart';
import 'package:online_technician/modules/login/login_screen.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel{

  final String image;
  final String title;
  final String body;

  BoardingModel({
    required this.image,
    required this.title,
    required this.body,
});
}

var boardController = PageController();

// ignore: must_be_immutable
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<BoardingModel> boarding =[
    BoardingModel(
        image: 'assets/images/onboard_1.png',
        title:'title 1',
        body: 'body 1'
    ),
    BoardingModel(
        image: 'assets/images/onboard_1.png',
        title:'title 2',
        body: 'body 2'
    ),
    BoardingModel(
        image: 'assets/images/onboard_1.png',
        title:'title 3',
        body: 'body 3'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    bool isLast =false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          TextButton(
              onPressed:submit,
              child:const Text('SKIP'),
          ),
        ],
      ),
      body:Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: boardController,
                  onPageChanged: (index) {
                    if(index == boarding.length -1){
                      isLast = true;
                    }
                    else {
                      isLast = false;
                    }
                  },
                  physics:const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => boardBuilder(boarding[index]),
                  itemCount: boarding.length,
                ),
              ),
              const SizedBox(
                height: 35.0,
              ),
              Row(
                children: [
                  SmoothPageIndicator(
                      controller: boardController,
                      effect: const ExpandingDotsEffect(
                        dotColor: Colors.grey,
                        activeDotColor: Colors.deepOrange,
                        dotHeight: 10.0,
                        expansionFactor: 4,
                        dotWidth: 10.0,
                        spacing: 5.0,
                      ),
                      count: boarding.length,),
                  const Spacer(),
                  FloatingActionButton(
                      onPressed: () {
                        if(isLast){
                          submit();
                        } else {
                          boardController.nextPage(
                            duration:const Duration(
                              milliseconds: 500,
                            ),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    child: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }

  void submit(){
    CacheHelper.savaData(key: 'onBoarding', value: true).then((value) {
      if(value){
        navigateToAndFinish(context, LoginScreen(),);
      }
    });
  }

  Widget boardBuilder(BoardingModel boarding)=> Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:[
      Expanded(
        child: Image(
          image: AssetImage(boarding.image),
        ),
      ),
      Text(
        boarding.title,
        style:const TextStyle(
          fontSize: 24.0,
        ),
      ),
      const SizedBox(
        height: 15.0,
      ),
      Text(
        boarding.body,
        style: const TextStyle(
          fontSize: 16.0,
        ),
      ),
      const SizedBox(
        height: 15.0,
      ),
    ],
  );
}
