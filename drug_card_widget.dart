import 'package:flutter/material.dart';

import 'drug_information_page.dart';

class DrugCardWidget extends StatefulWidget {
  const DrugCardWidget(
      {super.key,
      required this.favoriteDrugNames,
      required this.drugData,
      required this.imgSrc});

  final List<Map<String, dynamic>> favoriteDrugNames;
  final Map<String, dynamic> drugData;
  final String imgSrc;

  @override
  State<DrugCardWidget> createState() => _DrugCardState();
}

class _DrugCardState extends State<DrugCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DrugInformationPage(
                    data: widget.drugData,
                    imgSrc: widget.imgSrc)));
      },
      child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (widget.favoriteDrugNames.contains(widget.drugData)) {
                            widget.favoriteDrugNames.remove(widget.drugData);
                          } else {
                            widget.favoriteDrugNames.add(widget.drugData);
                          }
                        });
                      },
                      icon: widget.favoriteDrugNames.contains(widget.drugData) == true
                          ? const Icon(Icons.favorite)
                          : const Icon(Icons.favorite_border),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(widget.drugData['中文品名']),
                        subtitle: Text(widget.drugData['適應症']),
                      ),
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          widget.imgSrc,
                          width: 100,
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ))
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
