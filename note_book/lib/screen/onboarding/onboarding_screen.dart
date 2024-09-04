import 'package:flutter/material.dart';
import 'package:note_book/screen/home_screen.dart';
import 'package:note_book/services/shared_preferance.dart';
import 'comman_onboarding_screen.dart';
import 'onbording_data.dart';

class OnBoardingBodyScreen extends StatefulWidget {
  const OnBoardingBodyScreen({super.key});

  @override
  State<OnBoardingBodyScreen> createState() => _OnBoardingBodyScreenState();
}

class _OnBoardingBodyScreenState extends State<OnBoardingBodyScreen> {
  int selectindex = 0;

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: Container(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: 3,
                  onPageChanged: (value) {
                    setState(() {
                      selectindex = value;
                    });
                  },
                  itemBuilder: (context, index) {
                    return onBoardingCommonScreen(
                        onboardingdata[index].image,
                        onboardingdata[index].title,
                        onboardingdata[index].Decsription);
                  },
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 70,
                    width: 350,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.blue.shade600,
                          Colors.blue.shade700,
                          Colors.blue.shade900,
                        ]),
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectindex == 2 ? "Get Started" : "Next",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectindex < onboardingdata.length - 1) {
                                  selectindex++;
                                  pageController.animateToPage(selectindex,
                                      duration:
                                          const Duration(milliseconds: 1500),
                                      curve: Curves.fastLinearToSlowEaseIn);
                                } else {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(),
                                      ));
                                }
                              });
                            },
                            child: Container(
                              height: 35,
                              width: 60,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(
                                child: Icon(
                                  size: 30,
                                  Icons.navigate_next,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
            SizedBox(
              height: 25,
            )
          ],
        ),
      ),
    );
  }
}
