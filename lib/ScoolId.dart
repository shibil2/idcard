import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SchoolId extends StatefulWidget {
  const SchoolId({super.key});

  @override
  State<SchoolId> createState() => _SchoolIdState();
}

class _SchoolIdState extends State<SchoolId> {
  Future<List<Map<String, dynamic>>> getStudentData() async {
    final snapshot = await FirebaseFirestore.instance.collection("User").get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        "docId": doc.id,
        "name": data["Name"],
        "school": data["School"],
        "idNumber": data["ID Number"],
        "place": data["Place"],
      };
    }).toList();
  }

  Future<void> deleteStudent(String docId) async {
    await FirebaseFirestore.instance.collection("User").doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(
          child: Text(
            "School ID",
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getStudentData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No students found"));
          }

          final students = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];

              return Dismissible(
                key: Key(student["docId"]),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Delete Student"),
                      content: const Text(
                        "Are you sure you want to delete this student?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (direction) async {
                  await deleteStudent(student["docId"]);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 80,
                            height: 100,
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student["name"] ?? "",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                student["school"] ?? "",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "ID Number: ${student["idNumber"] ?? ""}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                student["place"] ?? "",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
