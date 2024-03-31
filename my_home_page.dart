import 'dart:convert';
import 'dart:io';
import 'package:drug_inquiry_system_2024/drug_card_widget.dart';
import 'package:drug_inquiry_system_2024/drug_information_page.dart';
import 'package:drug_inquiry_system_2024/favorite_drug_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import 'API/STT.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

dynamic data;

class _MyHomePageState extends State<MyHomePage> {
  String keyWord = "";
  List<Map<String, dynamic>> favoriteDrugNames = [];

  Future<Map<String, dynamic>> loadData() async {
    String jsonDLIString = await rootBundle.loadString('assets/data/DLI.json');
    String jsonDAString = await rootBundle.loadString('assets/data/DA.json');

    Map<String, dynamic> data = {
      "DLI": jsonDecode(jsonDLIString),
      "DA": jsonDecode(jsonDAString),
    };

    return data;
  }

  bool isRecord = false;
  String speechRecognitionAudioPath = "";
  bool isNeedSendSpeechRecognition = false;
  String base64String = "";
  List<String> items = ["華語", "台語", "客語", "英語", "印尼語", "粵語"];
  String selectedLanguage = "華語";
  AudioEncoder encoder = AudioEncoder.wav;
  TextEditingController textController = TextEditingController();

  Future<String> askForService(String base64String) {
    return STTClient().askForService(base64String, "華語");
  }

  void _updateTextController() async {
    try {
      String result = await askForService(base64String);
      setState(() {
        textController.text =
            result.replaceAll(' ', ''); // Update the text field
        isNeedSendSpeechRecognition = false; // Reset the flag
        keyWord = textController.text;
      });
      print('Received result: $result');
    } catch (error) {
      print('Recognition failed: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    // 根據設備決定錄音的 encoder
    if (Platform.isIOS) {
      encoder = AudioEncoder.pcm16bit;
    } else {
      encoder = AudioEncoder.wav;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FavoriteDrugPage(
                                favoriteDrugNames: favoriteDrugNames,
                                data: data["DA"],
                              )));
                },
                icon: const Icon(Icons.favorite_border))
          ],
        ),
        // 重要 FutureBuilder
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                        labelText: 'Search',
                        prefixIcon: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(5),
                              side: const BorderSide(
                                  width: 1.0, color: Colors.black)
                              // side: (isRecord == false)
                              //     ? const BorderSide(
                              //         width: 1.0, color: Colors.blue)
                              //     : const BorderSide(
                              //         width: 1.0, color: Colors.red),
                              ),
                          child: (isRecord == false)
                              ? (isNeedSendSpeechRecognition == true)
                                  ? const CircularProgressIndicator()
                                  : const Icon(
                                      Icons.mic,
                                      color: Colors.blue,
                                    )
                              : const Icon(
                                  Icons.stop,
                                  color: Colors.red,
                                ),
                          onPressed: () async {
                            debugPrint('receive click');
                            final record = Record();
                            if (isRecord == false) {
                              if (await record.hasPermission()) {
                                Directory tempDir =
                                    await getTemporaryDirectory();
                                speechRecognitionAudioPath =
                                    "${tempDir.path}/record.wav";

                                await record.start(
                                  numChannels: 1,
                                  path: speechRecognitionAudioPath,
                                  encoder: encoder,
                                  bitRate: 128000,
                                  samplingRate: 16000,
                                );
                                setState(() {
                                  isRecord = true;
                                  isNeedSendSpeechRecognition = false;
                                });
                              }
                            } else {
                              await record.stop();
                              var fileBytes =
                                  await File(speechRecognitionAudioPath)
                                      .readAsBytes();

                              setState(() {
                                base64String = base64Encode(fileBytes);
                                isRecord = false;
                                isNeedSendSpeechRecognition = true;
                              });

                              if (isNeedSendSpeechRecognition) {
                                _updateTextController();
                              }
                            }
                          },
                        )),
                    onChanged: (value) {
                      keyWord = value;
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: const Icon(Icons.search),
                )
              ],
            ),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: loadData(),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    data = snapshot.data;

                    List<dynamic> queryData = [];
                    if (keyWord != "") {
                      for (int i = 0; i < data!["DLI"].length; i++) {
                        if (data["DLI"][i]["中文品名"].contains(keyWord)) {
                          queryData.add(data["DLI"][i]);
                        }
                      }
                      data['DLI'] = queryData;
                    }

                    // 重要 ListView.builder
                    return ListView.builder(
                      itemCount: data!["DLI"].length,
                      itemBuilder: (BuildContext context, int index) {
                        // 取得 圖片位址
                        String imgSrc = "";
                        bool containsKey =
                            data["DA"].containsKey(data['DLI'][index]['中文品名']);
                        if (containsKey == true) {
                          imgSrc = data['DA'][data['DLI'][index]['中文品名']];
                        } else {
                          imgSrc =
                              "https://i0.wp.com/learn.onemonth.com/wp-content/uploads/2017/08/1-10.png?w=845&ssl=1";
                        }
                        return DrugCardWidget(
                            favoriteDrugNames: favoriteDrugNames,
                            drugData: data["DLI"][index],
                            imgSrc: imgSrc);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            )
          ],
        ));
  }
}
