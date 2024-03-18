import 'package:drug_inquiry_system_2024/drug_card_widget.dart';
import 'package:flutter/material.dart';

class FavoriteDrugPage extends StatefulWidget {
  const FavoriteDrugPage(
      {super.key, required this.favoriteDrugNames, required this.data});

  final List<Map<String, dynamic>> favoriteDrugNames;
  final Map<String, dynamic> data;

  @override
  State<FavoriteDrugPage> createState() => _FavoriteDrugState();
}

class _FavoriteDrugState extends State<FavoriteDrugPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("我的最愛"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.favoriteDrugNames.length,
              itemBuilder: (BuildContext context, int index) {
                String imgSrc = "";
                bool containsKey = widget.data
                    .containsKey(widget.favoriteDrugNames[index]['中文品名']);
                if (containsKey == true) {
                  imgSrc = widget.data[widget.favoriteDrugNames[index]['中文品名']];
                } else {
                  imgSrc =
                      "https://i0.wp.com/learn.onemonth.com/wp-content/uploads/2017/08/1-10.png?w=845&ssl=1";
                }
                return DrugCardWidget(
                  favoriteDrugNames: widget.favoriteDrugNames,
                  drugData: widget.favoriteDrugNames[index],
                  imgSrc: imgSrc,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
