import 'package:election_exit_poll_620710650/helpers/platform_aware_asset_image.dart';
import 'package:election_exit_poll_620710650/models/candidate.dart';
import 'package:election_exit_poll_620710650/services/api.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Candidate>> _candidate;


  @override
  void initState() {
    super.initState();
    _candidate = _fetch();
  }

  Future<List<Candidate>> _fetch()async{
    List list = await Api().fetch('exit_poll');
    var cd = list.map((e) => Candidate.fromJson(e)).toList();
    return cd;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/bg.png"),
          fit: BoxFit.fill,
        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  PlatformAwareAssetImage(
                    assetPath: 'assets/images/vote_hand.png',
                    width: 100.0,
                    height: 100.0,
                  ),
                  Text(
                    'EXIT POLL',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'เลือกตั้ง อบต.',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'รายชื่อผู้สมัครรับเลือกตั้ง',
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                      Text(
                        'นายกองค์การบริหารส่วนตำบลเขาพระ',
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                      Text(
                        'อำเภอเมืองนครนายก จังหวัดนครนายก',
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),


              _buildCandidateCard(context),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.purple),
                      onPressed: () {},
                      child: Text(
                        'ดูผล',
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildCandidateCard(BuildContext context) {
    return FutureBuilder<List<Candidate>>(
      future: _candidate,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          var candidateList = snapshot.data;

          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            itemCount: candidateList!.length,
            itemBuilder: (BuildContext context, int index) {
              var candidate = candidateList[index];

              return Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: const EdgeInsets.all(8.0),
                elevation: 5.0,
                shadowColor: Colors.black.withOpacity(0.2),
                color: Colors.white.withOpacity(0.5),
                child: InkWell(
                  onTap: () => _handleClickCandidate(candidate),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 50.0,
                        color: Colors.green,
                        child: Center(
                          child: Text(
                            '${candidate.number}',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                            candidate.displayName,
                            style: Theme.of(context).textTheme.bodyText1
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('ผิดพลาด: ${snapshot.error}'),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _candidate = _fetch();
                    });
                  },
                  child: const Text('ลองใหม่'),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Future<void> _election(int candidateNumber) async {
    var elector = (await Api().submit('exit_poll', {'candidateNumber': candidateNumber}));
    _showMaterialDialog('SUCCESS', 'บันทึกข้อมูลสำเร็จ ${elector.toString()}');
  }

  _handleClickCandidate(Candidate candidate) {
    _election(candidate.number);
  }
  void _showMaterialDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg, style: Theme.of(context).textTheme.bodyText1),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
