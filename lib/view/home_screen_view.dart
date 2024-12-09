import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: SafeArea(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      // FontAwesomeIcons.magnifyingGlass,
                      Boxicons.bx_search,
                      color: Colors.black,
                      size: 40,
                    )),
              ),
              const SizedBox(
                width: 2,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.black,
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 11, vertical: 10),
                  ),
                  onPressed: () {},
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.solidSquarePlus,
                        size: 20,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Post"),
                    ],
                  ))
            ],
          ),
          const Column(
            children: [
              Text("This is home page"),
            ],
          )
        ],
      )),
    );
  }
}
