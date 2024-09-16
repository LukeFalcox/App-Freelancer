// ignore_for_file: file_names, avoid_print, non_constant_identifier_names


import 'dart:async';
import 'dart:io';
import 'dart:html' as html;
import 'package:app_freelancer/app/pages/freelancer/home/home_chat/chat/message.dart';
import 'package:app_freelancer/app/pages/homeprincip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'package:image_picker/image_picker.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  void register_complementos(String username, String cep, String phone,
      UserCredential userCredential) {
    try {
      _firestore.collection('users').doc(userCredential.user!.uid).set(
        {
          'username': username,
          'cep': cep,
          'phone': phone,
        },
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  void register_card(String title, String desc, String propostMin,
      String propostMax, DateTime? selectedDate, String uid) async {
    try {
      final String formattedDate = selectedDate != null
          ? "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}"
          : '';

      final infocard = <String, dynamic>{
        'titulo': title,
        'desc': desc,
        'minima': propostMin,
        'maxima': propostMax,
        'prazo': formattedDate, // Aqui o DateTime é armazenado como String
        'uid': uid
      };

    

      await _firestore.collection('jobs').doc().set(infocard);
    } catch (e) {
      print('Error creating card: $e');
    }
  }

  void getprojects(String tipo) async {
      List projects = [];
      try {
        if (tipo == 'All') {
          QuerySnapshot querySnapshot = await _firestore.collection('projects').get();

          List<QueryDocumentSnapshot> documents = querySnapshot.docs; 

          for (var doc in documents) {
            var data = doc.data() as Map<String, dynamic>;
            String classificao = data['classificao'];
            print(classificao);
          }
        } else {
            QuerySnapshot queryprojects = await _firestore.collection('projects').where('classificao', isEqualTo: tipo).get();

     List<QueryDocumentSnapshot> documents = queryprojects.docs; 

     print(documents);
     
     for (var doc in documents) {
        var data = doc.data() as Map<String, dynamic>;
        String classificao = data['classificao'];
        print(classificao);
     }
        }
    
     

      } catch (e) {
        
      }
    }

// ============================================================//
// ================ENTRADA DO USUARIO E SAIDA==================//
// ============================================================//
  Future<void> logout(BuildContext context) async {
    try {
      await _firebaseAuth.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePrincip()),
        (route) => false,
      );
    } catch (e) {
      print('Error signing out: $e');
      // Você pode exibir uma mensagem de erro aqui, se desejar
    }
  }

  Future<UserCredential> login(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> register_users(
      String email, String password, String name) async {
    try {
      await _firebaseAuth.setLanguageCode('en_US');
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _firestore.collection('users').doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        },
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> singOut() async {
    return await _firebaseAuth.signOut();
  }

  // ============================================================//
  // =============================CHATS==========================//
  // ============================================================//

  Future<String> createChatrooms(String? cliente, String? freelancer) async {
  try {
    // Verifica se os parâmetros são nulos
    if (cliente == null || freelancer == null) {
      throw Exception('Parâmetros cliente e freelancer são obrigatórios');
    }

    // Busca os documentos do cliente e do freelancer
    QuerySnapshot queryCliente = await _firestore
        .collection('users')
        .where('email', isEqualTo: cliente)
        .get();

    QuerySnapshot queryFreelancer = await _firestore
        .collection('users')
        .where('email', isEqualTo: freelancer)
        .get();

    // Verifica se os documentos foram encontrados
    if (queryCliente.docs.isEmpty || queryFreelancer.docs.isEmpty) {
      throw Exception('Cliente ou freelancer não encontrado');
    }

    // Extrai os dados relevantes
    DocumentSnapshot docCliente = queryCliente.docs.first;
    DocumentSnapshot docFreelancer = queryFreelancer.docs.first;

    Map<String, dynamic> userDataCliente = docCliente.data()! as Map<String, dynamic>;
    Map<String, dynamic> userDataFreelancer = docFreelancer.data()! as Map<String, dynamic>;

    String nomeCliente = userDataCliente['email'];
    String emailFreelancer = userDataFreelancer['email'];
    String uidfree = userDataFreelancer['uid'];
    String uidcli = userDataCliente['uid'];

    final infoprops = <String, dynamic>{
      'cliente': nomeCliente,
      'freelancer': emailFreelancer,
      'uidcli': uidcli,
      'uidfree': uidfree,
    };

    // Cria um novo documento na coleção 'chat' com um ID gerado automaticamente
    DocumentReference chatRoomRef = _firestore.collection('chat').doc();

    // Obtém o ID do documento criado
    String chatRoomId = chatRoomRef.id;

    // Verifica se o documento pai foi criado antes de adicionar à subcoleção
    await chatRoomRef.set({'createdAt': FieldValue.serverTimestamp()});

    // Adiciona os dados à subcoleção 'users'
    await chatRoomRef.collection('users').add(infoprops);

    return chatRoomId;
  } on FirebaseAuthException catch (e) {
    throw Exception(e.code);
  }
}

Future<Map<String, dynamic>?> getInfosUsers(String? email) async {
  if (email == null || email.isEmpty) {
    print('Email inválido.');
    return null;
  }

  // Tenta buscar na coleção de freelancers primeiro
  final freelancerSnapshot = await _firestore
      .collection('freelancers')
      .where('email', isEqualTo: email)
      .limit(1)
      .get();

  if (freelancerSnapshot.docs.isNotEmpty) {
    final freelancerData = freelancerSnapshot.docs.first.data();
    print('Freelancer encontrado: $freelancerData');
    return freelancerData;
  }

  // Se não encontrar na coleção de freelancers, tenta buscar na coleção de clientes
  final clientSnapshot = await _firestore
      .collection('clientes')
      .where('email', isEqualTo: email)
      .limit(1)
      .get();

  if (clientSnapshot.docs.isNotEmpty) {
    final clientData = clientSnapshot.docs.first.data();
    print('Cliente encontrado: $clientData');
    return clientData;
  } else {
    print('Usuário não encontrado.');
    return null;
  }
}





  Future<List<String>> getcontactsfreelancers(String? freelancer) async {
    try {
      QuerySnapshot chatRoomsSnapshot =
          await _firestore.collection('chat').get();
      List<QueryDocumentSnapshot> documents = chatRoomsSnapshot.docs;
      for (var doc in documents) {
        print('ID: ${doc.id} | Dados: ${doc.data()}');
      }

      List<String> chatRooms = [];

      for (var chatRoomDoc in documents) {
        QuerySnapshot usersSnapshot =
            await chatRoomDoc.reference.collection('users').get();

        for (var userDoc in usersSnapshot.docs) {
          Map<String, dynamic> userData =
              userDoc.data()! as Map<String, dynamic>;

          if (userData['freelancer'] == freelancer) {
            chatRooms.add(chatRoomDoc.id);
            break;
          }
        }
      }

      return chatRooms;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> excluiChatrooms(String? cliente, String? freelancer) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('chat')
          .where('cliente', isEqualTo: cliente)
          .where('freelancer', isEqualTo: freelancer)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> sendMessage(String receiverId, String message,
      String formattedTime, chatRoomId) async {
    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
      formattedTime: formattedTime, // Add this field
      type: 'new'
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    await _firestore
        .collection('chat')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }


Stream<int> countNewMessagesStream(String chatRoomId) async* {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  yield* FirebaseFirestore.instance
      .collection('chat')
      .doc(chatRoomId)
      .collection('messages')
      .where('type', isEqualTo: 'new')
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .where((doc) => (doc.data() as Map<String, dynamic>)['senderId'] != currentUserId)
            .length;
      });
}


  //GET MESSAGES



  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    return _firestore
        .collection('chat')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  

  // ============================================================//
  // ===========================PROFILE==========================//
  // ============================================================//


 Future<String> getImageUrl(String imagePath) async {
  try {

    // Obtém a URL de download para a imagem
    String downloadURL = await _firebaseStorage.ref(imagePath).getDownloadURL();
    return downloadURL;
  } on FirebaseException catch (e) {
    throw Exception('Erro ao obter URL da imagem: ${e.code}');
  }
}


Future<String?> uploadMobile(String path, String userEmail) async {
    final file = File(path);
    try {
      final Uint8List fileBytes = await file.readAsBytes();
      final ref = _firebaseStorage.ref().child('images/$userEmail/Usuario/Perfil.jpg');
      
      final uploadTask = ref.putData(fileBytes);
      await uploadTask.whenComplete(() => null);
      
      final imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } on FirebaseException catch (e) {
      print("Erro no upload: ${e.code}");
      return null;
    }
  }

  Future<String?> getProfileImageUrl(String userEmail) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('images/$userEmail/Usuario/Perfil.jpg');
      final imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("Erro ao obter a URL da imagem: $e");
      return null;
    }
  }


  Future<String?> uploadWeb(html.File file, String userEmail) async {
    try {
      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);

      final Completer<String?> completer = Completer<String?>();
      reader.onLoadEnd.listen((_) async {
        final Uint8List fileBytes = reader.result as Uint8List;
        final ref = _firebaseStorage.ref().child('images/$userEmail/Usuario/Perfil.jpg');
        
        try {
          final uploadTask = ref.putData(fileBytes);
          await uploadTask.whenComplete(() => null);
          final imageUrl = await ref.getDownloadURL();
          completer.complete(imageUrl);
        } catch (e) {
          print("Erro no upload: $e");
          completer.complete(null);
        }
      });

      reader.onError.listen((e) {
        print("Erro no upload: $e");
        completer.complete(null);
      });

      return completer.future;
    } catch (e) {
      print("Erro no upload: $e");
      return null;
    }
  }



  Future<String?> getArea(String email) async {
  try {
    // Consulta a coleção de freelancers onde o email corresponde
    QuerySnapshot<Map<String, dynamic>> area = await _firestore
        .collection('freelancers')
        .where('email', isEqualTo: email)
        .get();

    // Verifica se encontrou documentos e retorna o campo 'area'
    if (area.docs.isNotEmpty) {
      return area.docs.first.data()['area'] as String?;
    } else {
      print('Nenhuma área registrada para o email: $email');
      return null;
    }
  } catch (e) {
    print('Erro ao buscar a área: $e');
    return null;
  }
}

Future<Map<String, dynamic>?> getinfos(String email) async {
  QuerySnapshot<Map<String, dynamic>> infos = await _firestore
        .collection('freelancers')
        .where('email', isEqualTo: email)
        .get();

        if(infos.docs.isNotEmpty){
          return infos.docs.first.data();
        }
        else{
          return null;
        }
}


Future<void> saveProfile(String name, String desc, context) async {
    if (name.isNotEmpty && desc.isNotEmpty) {
      try {
        await _firestore.collection('profiles').add({
          'name': name,
          'description': desc,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields.')),
      );
    }
  }

Future<List<String>> getEsp(String area) async {
  try {
    // Obtém o documento de filtros a partir do ID fornecido
    DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
        .collection('filters')
        .doc('VPyiRaZZB8IyxoxOpotH')
        .get();

    // Verifica se o documento existe
    if (doc.exists) {
      Map<String, dynamic>? data = doc.data();

      // Verifica se o campo 'curses' está presente no documento
      if (data != null && data.containsKey('curses')) {
        Map<String, dynamic>? map = data['curses'];

        // Verifica se o mapa contém a chave da área especificada
        if (map != null && map.containsKey(area)) {
          List<dynamic>? arrayTI = map[area];

          // Converte o array de dinâmico para lista de strings
          if (arrayTI != null && arrayTI is List) {
            return List<String>.from(arrayTI);
          } else {
            print('O campo $area não é uma lista válida ou está vazio.');
          }
        } else {
          print('Chave "$area" não encontrada em "curses".');
        }
      } else {
        print('Campo "curses" não encontrado no documento.');
      }
    } else {
      print('Documento com ID "VPyiRaZZB8IyxoxOpotH" não encontrado.');
    }

    // Retorna uma lista vazia se ocorrer alguma falha
    return [];
  } catch (e) {
    print('Erro ao buscar o array: $e');
    return [];
  }
}



Future<void> updateDadosFreelancer(String email, List, String name, String des) async {
  
  final infoprops = <String, dynamic>{
    'name': name,
    'desc': des,
  };

  try {
    final querySnapshot = await _firestore.collection('freelancers').where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs.first.id;
      await _firestore.collection('freelancers').doc(docId).update(infoprops);
      print('Dados atualizados com sucesso!');
    } else {
      print('Nenhum documento encontrado com o email fornecido.');
    }
  } catch (e) {
    print('Erro ao atualizar dados: $e');
  }
}

Future<void> save_classification(Map<int, bool> _selectedItems, List<String> items, String email) async {
  List<dynamic> itemsT = []; 
  List<dynamic> saveItems = [];

  // Mapeando os índices dos itens selecionados
  _selectedItems.forEach((key, value) {
    if (value == true) {
      itemsT.add(key);
    }
  });

  // Iterando sobre itens com índice e filtrando os selecionados
  for (var i in items.indexed) {
    for (var j in itemsT) {
      if (j == i.$1) {
        saveItems.add(i.$2); // Adiciona o item correspondente
      }
    }
  }

  // Criando o objeto para atualização no Firestore
  final infoprops = <String, dynamic>{
    'classificacao': saveItems,
  };

  try {
    // Consultando o documento no Firestore
    QuerySnapshot querySnapshot = await _firestore
        .collection('freelancers')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot document = querySnapshot.docs.first;
      DocumentReference documentRef = document.reference;

      // Atualizando o documento com os novos dados
      await documentRef.update(infoprops);
      print('Documento atualizado com sucesso.');
    } else {
      print('Nenhum documento encontrado com o email $email');
    }
  } catch (e) {
    print('Erro ao atualizar o documento: $e');
  }
}

  Future<List<Map<String, dynamic>>> get_data() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('cards').get();

    List<Map<String, dynamic>> cards =
        snapshot.docs.map((doc) => doc.data()).toList();
    return cards;
  }

  void register_info(String name, String skills, String projects, String exp,
      String taxa, dynamic dynamicImage, dynamic uid) async {
    try {
      // Upload da imagem para o Firebase Storage
      String fileName =
          'profile_images/${DateTime.now().millisecondsSinceEpoch}.png';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(dynamicImage);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      // Criação do objeto infocard com a URL da imagem
      final infocard = <String, dynamic>{
        'name': name,
        'skills': skills,
        'projects': projects,
        'exp': exp,
        'taxa': taxa,
        'imageUrl': imageUrl, // Adiciona a URL da imagem ao objeto infocard
      };

      // Armazenando o infocard no Firestore
      await _firestore
          .collection('users')
          .doc(uid) // Use o UID como o ID do documento
          .update(infocard);
      print('Card criado com sucesso!');
    } catch (e) {
      print('Erro ao criar card: $e');
    }
  }
}
