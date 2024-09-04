class OnBoardingModel {
  String image;
  String title;
  String Decsription;

  OnBoardingModel(
      {required this.image, required this.title, required this.Decsription});
}

List<OnBoardingModel> onboardingdata = [
  OnBoardingModel(
      image: "assets/images/1.png.png",
      title: "Create Your Scheduale",
      Decsription:
          "Make your important schedule well organized at work to make your work easier later "),
  OnBoardingModel(
      image: "assets/images/2.png.png",
      title: "Easily Manage Task",
      Decsription:
          "You can easily organize your work and schedule properly so that you are more comfortable while doing work"),
  OnBoardingModel(
      image: "assets/images/3.png.png",
      title: "Ready Start Your Day",
      Decsription:
          "And after all your schedule has been arranged properly and neatly now you are ready to start the day with fun. Enjoy your day."),
];
