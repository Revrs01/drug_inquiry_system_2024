import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'API/TTS.dart';

class DrugInformationPage extends StatefulWidget {
  const DrugInformationPage(
      {Key? key, required this.data, required this.imgSrc})
      : super(key: key);

  final Map<String, dynamic> data;
  final String imgSrc;

  @override
  State<DrugInformationPage> createState() => _DrugInformationPageState();
}

class _DrugInformationPageState extends State<DrugInformationPage> {
  final player = SoundPlayer();

  @override
  void initState() {
    super.initState();
    player.init();
  }

  Future play(String pathToReadAudio) async {
    await player.play(pathToReadAudio);
    setState(() {
      debugPrint("Playing");
      player.isPlaying;
    });
  }

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
              widget.imgSrc,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          IconButton(
              icon: const Icon(Icons.volume_up, size: 30),
              onPressed: () async {
                if (widget.data["中文品名"].isEmpty) return;

                // 連接到文字轉語音服務器
                TTSClient client = TTSClient();
                await client.connect();

                // 發送語音合成請求，傳遞語言和句子內容
                client.send("國語", widget.data["中文品名"]);

                // 等待接收服務器的回應
                String result = await client.receive();

                if (result.isEmpty) {
                  debugPrint('合成失敗');
                } else {
                  // 解析服務器回傳的 JSON 格式數據
                  Map<String, dynamic> responseData = json.decode(result);

                  // 檢查狀態是否正確且有合成的語音文件數據
                  if (responseData['status'] != null &&
                      responseData['status']) {
                    List<int> resultBytes =
                        base64.decode(responseData['bytes']);
                    Directory tempDir = await getTemporaryDirectory();
                    String speechSynthesisAudioPath =
                        '${tempDir.path}/synthesis.wav';
                    File outputFile = File(speechSynthesisAudioPath);

                    // 將語音數據寫入文件
                    await outputFile.writeAsBytes(resultBytes);
                    debugPrint('File received complete');

                    // 播放合成的語音文件
                    play(speechSynthesisAudioPath);
                  } else {
                    debugPrint('合成失敗');
                  }
                }
                client.close();
              }),
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
                            child:
                                Text("中文品名", style: TextStyle(fontSize: 24))),
                        Expanded(
                          flex: 3,
                          child: Text(
                            widget.data["中文品名"],
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(
                            flex: 2,
                            child:
                                Text("英文品名", style: TextStyle(fontSize: 24))),
                        Expanded(
                          flex: 3,
                          child: Text(
                            widget.data["英文品名"],
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
                            widget.data["適應症"],
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
                            widget.data["劑型"],
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
                            widget.data["包裝"],
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(
                            flex: 2,
                            child:
                                Text("藥品類別", style: TextStyle(fontSize: 24))),
                        Expanded(
                          flex: 3,
                          child: Text(
                            widget.data["藥品類別"],
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
