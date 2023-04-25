import "dart:math";

import "package:flutter/material.dart";

import "./widgets/back_view.dart";
import "./widgets/front_view.dart";
import "./widgets/action_buttons.dart";
import "./widgets/search_and_menu.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool isFrontView = true;
  late AnimationController controller;

  void switchView() {
    setState(() {
      if (isFrontView) {
        controller.forward();
      } else {
        controller.reverse();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          const SearchAndMenu(),
          const SizedBox(
            height: 30.0,
          ),
          DropdownButton(
            value: "2022",
            items: const [
              DropdownMenuItem(
                value: "2022",
                child: Text("2022"),
              ),
            ],
            onChanged: (value) {},
          ),
          const SizedBox(height: 30.0),
          Expanded(
            child: Container(
              // color: Colors.grey.shade300,
              padding: const EdgeInsets.symmetric(vertical: 22.0),
              child: PageView.builder(
                controller: PageController(
                  initialPage: 0,
                  viewportFraction: 0.78,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: 12, // For 12 months.
                itemBuilder: (_, i) => AnimatedBuilder(
                    animation: controller,
                    builder: (_, child) {
                      if (controller.value >= 0.5) {
                        isFrontView = false;
                      } else {
                        isFrontView = true;
                      }

                      return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(controller.value * pi),
                        alignment: Alignment.center,
                        child: isFrontView
                            ? FrontView(
                                monthIndex: i + 1,
                              )
                            : Transform(
                                transform: Matrix4.rotationY(pi),
                                alignment: Alignment.center,
                                child: BackView(
                                  monthIndex: i + 1,
                                ),
                              ),
                      );
                    }),
              ),
            ),
          ),
          const SizedBox(height: 30.0),
          ActionButtons(change: switchView),
          const SizedBox(height: 30.0),
        ],
      ),
    ));
  }
}

