import 'package:fitness_app2/models/category_model.dart';
import 'package:fitness_app2/models/diet_model.dart';
import 'package:fitness_app2/models/popular_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories = [];
  List<DietModel> diets = [];
  List<PopularDietModel> popularDiets = [];
  TextEditingController textController = TextEditingController();

  void _getCategories() {
    categories = CategoryModel.getCategories();
  }

  void _getDiets() {
    diets = DietModel.getDiets();
  }

  void _getInitialInfo() {
    categories = CategoryModel.getCategories();
    diets = DietModel.getDiets();
    popularDiets = PopularDietModel.getPopularDiets();
  }

  void handleSearch(String query) {
    // Normalize the query for case-insensitive comparison
    final normalizedQuery = query.toLowerCase();

    // Check if the query matches any diet
    final hasMatchedDiet = diets.any(
      (diet) => diet.name.toLowerCase() == normalizedQuery,
    );

    // Check if the query matches any popular diet
    final hasMatchedPopularDiet = popularDiets.any(
      (popularDiet) => popularDiet.name.toLowerCase() == normalizedQuery,
    );

    // Navigate to the appropriate page if a match is found
    if (hasMatchedDiet) {
      final matchedDiet = diets.firstWhere(
        (diet) => diet.name.toLowerCase() == normalizedQuery,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondPage(matchedDiet)),
      );
    } else if (hasMatchedPopularDiet) {
      final matchedPopularDiet = popularDiets.firstWhere(
        (popularDiet) => popularDiet.name.toLowerCase() == normalizedQuery,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ThirdPage(matchedPopularDiet)),
      );
    } else {
      // If no match is found, navigate to a different page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FourthPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _getCategories();
    _getDiets();
    _getInitialInfo();

    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          _searchField(),
          SizedBox(height: 40),
          _categoriesSection(),
          SizedBox(height: 40),
          _dietSection(),
          SizedBox(height: 40),
          _popularSection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Column _popularSection() {
    int? selectedIndex;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Popular',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 15),
        ListView.separated(
          itemCount: popularDiets.length,
          shrinkWrap: true,
          separatorBuilder: (context, index) => SizedBox(height: 25),
          padding: const EdgeInsets.only(left: 20, right: 20),
          itemBuilder: (context, index) {
            return Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        selectedIndex = null;
                      });
                    },
                    child: SvgPicture.asset(
                      popularDiets[index].iconPath,
                      width: 65,
                      height: 65,
                    ),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        popularDiets[index].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        popularDiets[index].level +
                            ' | ' +
                            popularDiets[index].duration +
                            ' | ' +
                            popularDiets[index].calorie,
                        style: const TextStyle(
                          color: Color(0xff7B6F72),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ThirdPage(popularDiets[index]),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      height: 45,
                      width: 130,
                      child: Center(
                        child: Text(
                          'Unleash!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 234, 157, 255),
                            Color(0xff92A3FD),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color:
                    popularDiets[index].boxIsSelected
                        ? Colors.white
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                boxShadow:
                    popularDiets[index].boxIsSelected
                        ? [
                          BoxShadow(
                            color: Color(0xff1D1617).withValues(alpha: 0.1),
                            offset: Offset(0, 10),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ]
                        : [],
              ),
            );
          },
        ),
      ],
    );
  }

  Column _dietSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'Recommendation\nfor Diet',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          height: 250,
          child: ListView.separated(
            itemBuilder: (context, index) {
              return Container(
                width: 210,
                decoration: BoxDecoration(
                  color: diets[index].boxColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SvgPicture.asset(diets[index].iconPath),
                    Column(
                      children: [
                        Text(
                          diets[index].name,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          diets[index].level +
                              ' | ' +
                              diets[index].duration +
                              ' | ' +
                              diets[index].calorie,
                          style: TextStyle(
                            color: Color(0xff7B6F72),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SecondPage(diets[index]),
                          ),
                        );
                        setState(() {
                          diets[index].viewIsSelected =
                              !diets[index].viewIsSelected;
                        });
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        height: 45,
                        width: 130,
                        child: Center(
                          child: Text(
                            'View',
                            style: TextStyle(
                              color:
                                  diets[index].viewIsSelected
                                      ? Colors.white
                                      : Color(0xffC58BF2),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              diets[index].viewIsSelected
                                  ? Color(0xff9DCEFF)
                                  : Colors.transparent,
                              diets[index].viewIsSelected
                                  ? Color(0xff92A3FD)
                                  : Colors.transparent,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(width: 25),
            itemCount: diets.length,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 20, right: 20),
          ),
        ),
      ],
    );
  }

  Column _categoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'Category',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 15),
        Container(
          height: 120,
          //color: Colors.green,
          child: ListView.separated(
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 20, right: 20),
            separatorBuilder: (context, index) => SizedBox(width: 25),
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                decoration: BoxDecoration(
                  color: categories[index].boxColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(categories[index].iconPath),
                      ),
                    ),
                    Text(
                      categories[index].name,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Container _searchField() {
    return Container(
      margin: EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Color(0xff1D1617).withValues(alpha: 0.11),
            blurRadius: 40,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: TextField(
        controller: textController,
        onChanged: (value) {
          setState(() {});
        },
        decoration: InputDecoration(
          //border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(15),
          hintText: 'Savor the Search ',
          hintStyle: TextStyle(color: Color(0xffDDDADA), fontSize: 14),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: IconButton(
              icon: SvgPicture.asset('assets/icons/Search.svg'),
              onPressed: () {
                handleSearch(textController.text);
                textController.clear();
              },
            ),
          ),
          suffixIcon: Container(
            width: 100,
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  VerticalDivider(
                    color: Colors.black,
                    indent: 10,
                    endIndent: 10,
                    thickness: 0.1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: IconButton(
                      icon: SvgPicture.asset('assets/icons/Filter.svg'),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        'Fitness Diet',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0.8,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {},
        child: Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/Arrow - Left 2.svg',
            height: 20,
            width: 20,
          ),
          decoration: BoxDecoration(
            color: Color(0xffF7F8F8),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      actions: [
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            width: 37,
            child: SvgPicture.asset(
              'assets/icons/dots.svg',
              height: 20,
              width: 20,
            ),
            decoration: BoxDecoration(
              color: Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

class SecondPage extends StatelessWidget {
  final DietModel diet;

  const SecondPage(this.diet, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          diet.name,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          height: 300,
          child: Container(
            width: 290,
            decoration: BoxDecoration(
              color: diet.boxColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff1D1617).withValues(alpha: 0.15),
                  offset: Offset(0, 5),
                  blurRadius: 20,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset(diet.iconPath),
                Column(
                  children: [
                    Text(
                      diet.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      diet.name == 'Sandwich'
                          ? "Protein Source\nFiber-Rich\nCustomizable Options\nHealthy Fats\nPortable Meal"
                          : "Natural Sweetener\nQuick Energy\nWhole Grain\nAntioxidant Boost\nMood Enhancer",
                      //diet.level + ' | ' + diet.duration + ' | ' + diet.calorie,
                      style: TextStyle(
                        color: Color(0xff7B6F72),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  final PopularDietModel popular;

  ThirdPage(this.popular);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          popular.name,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          height: 300,
          child: Container(
            width: 290,
            decoration: BoxDecoration(
              color: popular.boxColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff1D1617).withValues(alpha: 0.15),
                  offset: Offset(0, 5),
                  blurRadius: 20,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset(popular.iconPath),
                Column(
                  children: [
                    Text(
                      popular.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      popular.name == 'Burrito'
                          ? "Protein-Packed\nFiber-Rich\nCustomizable Fillings\nBalanced Macronutrients\nPortable Meal"
                          : "Energy Source\nGluten Free\nVersatile Ingredients\nlow in Fat\nQuick Snack",
                      //diet.level + ' | ' + diet.duration + ' | ' + diet.calorie,
                      style: TextStyle(
                        color: Color(0xff7B6F72),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FourthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Missing',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          height: 300,
          child: Container(
            width: 290,
            decoration: BoxDecoration(
              color: Color(0xff92A3FD).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff1D1617).withValues(alpha: 0.15),
                  offset: Offset(0, 5),
                  blurRadius: 20,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset('assets/icons/Oops.svg'),
                Column(
                  children: [
                    Text(
                      "OOPS",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "sorry!!\nbut it seems that item is not available.",
                      //diet.level + ' | ' + diet.duration + ' | ' + diet.calorie,
                      style: TextStyle(
                        color: Color(0xff7B6F72),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
