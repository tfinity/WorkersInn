import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workers_inn/workerModule/customerRequestsList.dart';

import '../variables.dart';

class WorkRequestPage extends StatefulWidget {
  const WorkRequestPage({super.key, required this.services});
  final List<dynamic> services;
  @override
  State<WorkRequestPage> createState() => _WorkRequestPageState();
}

class _WorkRequestPageState extends State<WorkRequestPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log("${widget.services}");
    // FirebaseFirestore.instance
    //     .collection("orders")
    //     .where("service", whereIn: widget.services)
    //     .get()
    //     .then((value) {
    //   for (var element in value.docs) {
    //     log("${element.data()}");
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size Screensize = MediaQuery.of(context).size;
    //default backpress manipulation
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text('Customer Requests'),
          automaticallyImplyLeading: false,
          actions: [
            TextButton(
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          content: const Text("Cancel Request ?"),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                },
                                child: const Text("no")),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(ctx);

                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "yes",
                                )),
                          ],
                        );
                      });
                },
                child: Text(
                  'cancel',
                  style: TextStyle(color: white),
                )),
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("orders")
                .where("service", whereIn: widget.services)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  return WorkerRequestList(
                    data: snapshot.data!.docs[index].data(),
                  );
                },
              );
            }),
      ),
    );
  }
}
