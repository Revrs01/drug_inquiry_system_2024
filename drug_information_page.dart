import 'package:flutter/material.dart';

class DrugInformationPage extends StatelessWidget {
  const DrugInformationPage(
      {Key? key, required this.data, required this.imgSrc})
      : super(key: key);

  final Map<String, dynamic> data;
  final String imgSrc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("藥物資訊"),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.network(
              imgSrc,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          Card(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                            flex: 2,
                            child: Text("中文品名", style: TextStyle(fontSize: 24))),
                        Expanded(
                          flex: 3,
                          child: Text(
                            data["中文品名"],
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(
                            flex: 2,
                            child: Text("英文品名", style: TextStyle(fontSize: 24))),
                        Expanded(
                          flex: 3,
                          child: Text(
                            data["英文品名"],
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(
                            flex: 2,
                            child: Text("適應症", style: TextStyle(fontSize: 24))),
                        Expanded(
                          flex: 3,
                          child: Text(
                            data["適應症"],
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(
                            flex: 2,
                            child: Text("劑型", style: TextStyle(fontSize: 24))),
                        Expanded(
                          flex: 3,
                          child: Text(
                            data["劑型"],
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(
                            flex: 2,
                            child: Text("包裝", style: TextStyle(fontSize: 24))),
                        Expanded(
                          flex: 3,
                          child: Text(
                            data["包裝"],
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(
                            flex: 2,
                            child: Text("藥品類別", style: TextStyle(fontSize: 24))),
                        Expanded(
                          flex: 3,
                          child: Text(
                            data["藥品類別"],
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}