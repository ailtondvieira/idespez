import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio_web_despesas/confirm_guests/models/guests_model.dart';
import 'package:desafio_web_despesas/confirm_guests/views/widgets/field_add_guests.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BodyConfirmGuests extends StatefulWidget {
  const BodyConfirmGuests({Key? key}) : super(key: key);

  @override
  State<BodyConfirmGuests> createState() => _BodyConfirmGuestsState();
}

class _BodyConfirmGuestsState extends State<BodyConfirmGuests> {
  CollectionReference guestsCollection =
      FirebaseFirestore.instance.collection("Guests");

  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getGuests();
  }

  Future<void> addGuests() async {
    guestsCollection
        .add(
          GuestsModel(
            name: nameController.text,
            phone: phoneController.text,
            isConfirm: false,
          ).toMap(),
        )
        .then(
          (value) => debugPrint('Guests added'),
        )
        .whenComplete(() {
      nameController.clear();
      phoneController.clear();
      getGuests();
    }).catchError(
      (error) => debugPrint('Failed to added Guests: $error'),
    );
  }

  List<GuestsModel> guestsList = [];

  Future<void> getGuests() async {
    return guestsCollection.get().then((QuerySnapshot querySnapshot) {
      guestsList = [];
      for (var doc in querySnapshot.docs) {
        final guests = GuestsModel(
          id: doc.reference.id,
          name: doc['name'],
          phone: doc['phone'],
          isConfirm: doc['isConfirm'],
        );
        guestsList.add(guests);
      }
    }).whenComplete(() => setState(() {}));
  }

  Future<void> updateGuests(String id, bool isConfirm) async {
    guestsCollection
        .doc(id)
        .update(
          {'isConfirm': isConfirm},
        )
        .then((value) => debugPrint('Guests Update'))
        .whenComplete(
          () => getGuests(),
        )
        .catchError((error) => debugPrint('Failed to added Guests: $error'));
  }

  Future<void> deleteGuests(String id) async {
    guestsCollection
        .doc(id)
        .delete()
        .then(
          (value) => debugPrint('Guests delete'),
        )
        .whenComplete(
          () => getGuests(),
        )
        .catchError(
          (error) => debugPrint('Failed error delete $error'),
        );
  }

  Future<void> whatsapp(String phone) async {
    final Uri url = Uri.parse('https://wa.me/$phone');
    try {
      await launchUrl(url);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Convidados'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Column(
          children: [
            const Text(
              "Adicione Seu Convidado",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            FieldAddGuests(
              nameController: nameController,
              phoneController: phoneController,
            ),
            ElevatedButton(
              onPressed: () {
                addGuests();
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                backgroundColor: MaterialStateProperty.all(Colors.purple),
              ),
              child: const Text(
                'Adicionar',
              ),
            ),
            Visibility(
              visible: guestsList.isEmpty,
              replacement: ListView.builder(
                shrinkWrap: true,
                itemCount: guestsList.length,
                itemBuilder: (context, index) {
                  var guest = guestsList[index];
                  return ListTile(
                    trailing: Padding(
                      padding: const EdgeInsets.only(top: 17),
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          deleteGuests(guest.id!);
                        },
                      ),
                    ),
                    leading: IconButton(
                      color: guest.isConfirm ? Colors.purple : Colors.grey,
                      icon: const Icon(Icons.assignment_turned_in),
                      onPressed: () {
                        updateGuests(guest.id!, !guest.isConfirm);
                      },
                    ),
                    title: Text(guest.name),
                    subtitle: Row(
                      children: [
                        Text(guest.phone),
                        IconButton(
                          onPressed: () {
                            whatsapp(
                              guest.phone
                                  .replaceAll(RegExp(r'[^0-9]'), '')
                                  .trim(),
                            );
                            print(
                              guest.phone
                                  .replaceAll(RegExp(r'[^0-9]'), "")
                                  .trim(),
                            );
                          },
                          icon: const Icon(
                            Icons.perm_phone_msg_sharp,
                          ),
                        ),
                        const Spacer(),
                        Visibility(
                          visible: guest.isConfirm,
                          replacement: const Text("#Pendente"),
                          child: const Text(
                            "#Confirmado",
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              child: const Text(
                'Nenhum Dado Adicionado',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
