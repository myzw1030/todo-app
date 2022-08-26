import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// key を用意
const kTitleKey = 'name';
const kCommentKey = 'comment';
const kIconKey = 'icon';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final titleController = TextEditingController();
  final commentController = TextEditingController();

  String title = '';
  String comment = '';
  bool icon = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  // アプリ起動時に保存したデータを読み込む
  void init() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      title = prefs.getString(kTitleKey) ?? '';
      comment = prefs.getString(kCommentKey) ?? '';
      icon = prefs.getBool(kIconKey) ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Text(
                'Simple Memo',
                style: TextStyle(
                  fontSize: 38.0,
                  fontWeight: FontWeight.w100,
                ),
              ),
              ListTile(
                // 保存された場合のデータを表示する
                leading: icon == false
                    ? const Icon(Icons.chat_bubble_outline)
                    : const Icon(Icons.chat),
                tileColor: Colors.white24,
                title: Text(title),
                subtitle: Text(comment),
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'タイトルを入力してね',
                ),
              ),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(hintText: 'コメントを入力してね'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      // データを保存する
                      prefs.setString(kTitleKey, titleController.text);
                      prefs.setString(kCommentKey, commentController.text);
                      prefs.setBool(kIconKey, true);
                      setState(() {
                        // データを読み込む
                        title = prefs.getString(kTitleKey) ?? '';
                        comment = prefs.getString(kCommentKey) ?? '';
                        prefs.setBool(kIconKey, true);
                        if (title != '' && comment != '') {
                          icon = true;
                        }
                      });
                    },
                    child: const Text(
                      'Save',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      setState(() {
                        // データを削除する
                        icon = false;
                        title = '';
                        titleController.text = '';
                        comment = '';
                        commentController.text = '';
                        prefs.remove(kTitleKey);
                        prefs.remove(kCommentKey);
                      });
                    },
                    child: const Text(
                      'Clear',
                    ),
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
