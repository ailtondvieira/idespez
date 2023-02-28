import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio_web_despesas/confirm_guests/models/guests_model.dart';
import 'package:desafio_web_despesas/confirm_guests/views/widgets/field_add_guests.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../views/widgets/card_totals_money.dart';

class ConfirmGuestsPage extends StatefulWidget {
  const ConfirmGuestsPage({Key? key}) : super(key: key);

  @override
  State<ConfirmGuestsPage> createState() => _BodyConfirmGuestsState();
}

class _BodyConfirmGuestsState extends State<ConfirmGuestsPage> {
  CollectionReference guestsCollection =
      FirebaseFirestore.instance.collection("Guests");

  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final List<int> listAdults = <int>[1, 2, 3, 4, 5, 6, 7, 8];
  final List<int> listKids = <int>[0, 1, 2, 3, 4, 5];

  int adultsValue = 1;
  int kidsValue = 0;

  int totalAdults = 0;
  int totalKids = 0;
  int totalGuests = 0;

  @override
  void initState() {
    super.initState();
    getGuests();
  }

  Future<void> addGuests() async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        adultsValue == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Os campos precisam ser preenchidos!')),
      );
      return;
    }
    ;

    guestsCollection
        .add(
          GuestsModel(
            name: nameController.text,
            phone: phoneController.text,
            isConfirm: false,
            quantityAdults: adultsValue,
            quantityKids: kidsValue,
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
    guestsList = [];
    totalAdults = 0;
    totalKids = 0;
    totalGuests = 0;

    return guestsCollection.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        final guests = GuestsModel(
          id: doc.reference.id,
          name: doc['name'],
          phone: doc['phone'],
          isConfirm: doc['isConfirm'],
          quantityAdults: doc['quantityAdults'],
          quantityKids: doc['quantityKids'],
        );
        if (guests.isConfirm) {
          totalAdults += guests.quantityAdults;
          totalKids += guests.quantityKids;
          totalGuests += guests.quantityAdults + guests.quantityKids;
        }
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

  Future<void> openWhatsapp(String phone) async {
    final String formatted = phone.replaceAll(RegExp(r'[^0-9]'), '').trim();
    final Uri url = Uri.parse('https://wa.me/$formatted');
    try {
      await launchUrl(url);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o whatsapp.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convidados'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          addGuests();
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FieldAddGuests(
            nameController: nameController,
            phoneController: phoneController,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child:
                          Text('Quantidade de adultos contando com o mesmo.'),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<int>(
                      value: adultsValue,
                      icon: const Icon(Icons.keyboard_arrow_down_sharp),
                      elevation: 15,
                      style: const TextStyle(color: Colors.purple),
                      underline: const SizedBox.shrink(),
                      onChanged: (int? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          adultsValue = value!;
                        });
                      },
                      items: listAdults.map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              value.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Text('Quantidade de crianças (de 5 a 10 anos)'),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<int>(
                      value: kidsValue,
                      icon: const Icon(Icons.keyboard_arrow_down_sharp),
                      elevation: 15,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: const SizedBox.shrink(),
                      onChanged: (int? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          kidsValue = value!;
                        });
                      },
                      items: listKids.map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              value.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Visibility(
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
                      color: guest.isConfirm ? Colors.green : Colors.red,
                      icon: const Icon(Icons.assignment_turned_in),
                      onPressed: () {
                        updateGuests(guest.id!, !guest.isConfirm);
                      },
                    ),
                    title: Row(
                      children: [
                        Text(
                          '${guest.name} - ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Text(
                            'Adultos [${guest.quantityAdults}] - Kids [${guest.quantityKids}]',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Text(guest.phone),
                        IconButton(
                          onPressed: () async {
                            await openWhatsapp(guest.phone);
                          },
                          icon: const Icon(
                            Icons.whatsapp,
                            color: Colors.green,
                          ),
                        ),
                        const Spacer(),
                        Visibility(
                          visible: guest.isConfirm,
                          replacement: const Text(
                            "#Pendente",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text(
                            "#Confirmado",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              child: const Center(
                child: Text(
                  'Nenhum convidado adicionado',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Wrap(
              alignment: WrapAlignment.start,
              children: [
                CardTotalsMoney(
                  totalString: 'Crianças: $totalKids',
                  color: Colors.purple.shade100,
                ),
                CardTotalsMoney(
                  totalString: 'Adultos: $totalAdults',
                  color: Colors.purple.shade300,
                ),
                CardTotalsMoney(
                  totalString: 'Total: $totalGuests',
                  color: Colors.purple.shade500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
