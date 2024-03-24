import 'package:flutter/material.dart';
import 'package:hack/common/color_extension.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import for launching URLs

class AboutUsView extends StatefulWidget {
  const AboutUsView({Key? key}) : super(key: key); // Fix the super.key syntax

  @override
  State<AboutUsView> createState() => _AboutUsViewState();
}

class _AboutUsViewState extends State<AboutUsView> {
  List<String> aboutTextArr = [
    "ORKO Pvt Ltd. is a DIPP recognised Startup by Government of India as a young manufacturing company with a zeal to make a difference in society and environmental sustainability and public health improvement by advocating for reduced meat consumption and supporting animal welfare. We have Extended our work in Food Manufacturing, Horeca Supply, Processing, Health Supplements and upcoming Tech based Services. We are driven by a deep philosophy of Ethics & Trust, backed by experienced people in diverse sectors and advised by a committed team of professionals. Our company’s vision is to popularize the vegetarian menu globally, aiming to add 1000+ new vegetarian restaurants in the next 1000 days.",
  ];

  // Function to launch Instagram profile
  void _launchInstagram() async {
    const url = 'https://www.instagram.com/zorkobrand?igsh=cTQ5dGxqaTdsdW02'; // Corrected URL
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
  void _launchFacebook() async {
    const url = 'https://www.facebook.com/ZorkoBrand?mibextid=LQQJ4d'; // Corrected URL
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
  void _launchIN() async {
    const url = 'https://www.linkedin.com/company/zorko/about/'; // Corrected URL
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
  void _launchweb() async {
    const url = 'https://zorko.in/'; // Corrected URL
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        "About Us",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20,bottom: 20),
                child: Center(
                  child: Image.asset(
                    "assets/img/zorko.png",height: 60,

                  ),
                ),
              ),   Padding(
                padding: const EdgeInsets.only(top: 20,bottom: 20),
                child: Image.asset(
                  "assets/img/zz.jpg",

                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: aboutTextArr.length,
                itemBuilder: ((context, index) {
                  var txt = aboutTextArr[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 25),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: TColor.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            txt,
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon:Image.asset("assets/img/insta.jpg",height: 50,), // Replace with your Instagram logo asset path
                    onPressed: _launchInstagram,
                  ),IconButton(
                    icon:Image.asset("assets/img/fb.jpg",height: 50,), // Replace with your Instagram logo asset path
                    onPressed: _launchFacebook,
                  ),IconButton(
                    icon:Image.asset("assets/img/in.jpg",height: 50,),  // Replace with your Instagram logo asset path
                    onPressed: _launchIN,
                  ),IconButton(
                    icon:Image.asset("assets/img/web.jpg",height: 50,),  // Replace with your Instagram logo asset path
                    onPressed: _launchweb,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


