import 'package:flutter/material.dart';
import 'package:minha_ebd/ui/aluno_page.dart';
import 'package:minha_ebd/ui/classe_page.dart';
import 'package:minha_ebd/ui/home_classe.dart';
import 'package:minha_ebd/ui/home_page.dart';
import 'package:minha_ebd/ui/menu_page.dart';
import 'package:minha_ebd/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {

  final _pageController= PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          body:MenuPage() ,
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          body:HomePage() ,
          drawer: CustomDrawer(_pageController),
        ),

        Scaffold(

          drawer: CustomDrawer(_pageController),
          body: HomeClassePage(),
        ),


      ],
    );
  }
}