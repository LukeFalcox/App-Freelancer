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

  Future<List<Map<String, dynamic>>?> getprojectsorfreelancers(String tipo, String email) async {
      List projects = [];
      try {

      final freelancerSnapshot = await _firestore
      .collection('freelancers')
      .where('email', isEqualTo: email)
      .limit(1)
      .get();

   if (freelancerSnapshot.docs.isNotEmpty) {
      // Se o tipo for 'All', busca todos os projetos
      if (tipo == 'All') {
        final QuerySnapshot<Map<String, dynamic>> projectsSnapshot =
            await _firestore.collection('projects').get();
        final List<Map<String, dynamic>> projects = projectsSnapshot.docs
            .map((doc) => doc.data())
            .toList();
        
        return projects; 
      }
      if (tipo == 'Desenvolvimento Web') {
        final QuerySnapshot<Map<String, dynamic>> projectsSnapshot =
            await _firestore.collection('projects').get();
        final List<Map<String, dynamic>> projects = projectsSnapshot.docs
            .map((doc) => doc.data())
            .toList();
        
        return projects; 
      }
      if (tipo == 'Desenvolvimento de Aplicativos') {
        final QuerySnapshot<Map<String, dynamic>> projectsSnapshot =
            await _firestore.collection('projects').get();
        final List<Map<String, dynamic>> projects = projectsSnapshot.docs
            .map((doc) => doc.data())
            .toList();
        
        return projects; 
      }
      if (tipo == 'Banco de Dados') {
        final QuerySnapshot<Map<String, dynamic>> projectsSnapshot =
            await _firestore.collection('projects').get();
        final List<Map<String, dynamic>> projects = projectsSnapshot.docs
            .map((doc) => doc.data())
            .toList();
        
        return projects; 
      }
      if (tipo == 'Desenvolvimento de E-Commerce') {
        final QuerySnapshot<Map<String, dynamic>> projectsSnapshot =
            await _firestore.collection('projects').get();
        final List<Map<String, dynamic>> projects = projectsSnapshot.docs
            .map((doc) => doc.data())
            .toList();
        
        return projects; 
      }
    }

  // Se não encontrar na coleção de freelancers, tenta buscar na coleção de clientes
  final clientSnapshot = await _firestore
      .collection('clientes')
      .where('email', isEqualTo: email)
      .limit(1)
      .get();

  if (clientSnapshot.docs.isNotEmpty) {

  } else {
    print('Usuário não encontrado.');
    return null;
  }

     

      } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

 Future<List> getfilters(String email) async {
  // Obtenha a área com base no email
  String? area = await getArea(email);

  // Consulta Firestore com o filtro where
  final snapshot = await _firestore
      .collection('filters')
      .doc('VPyiRaZZB8IyxoxOpotH').get();

 final categories =  snapshot.data()?['curses'];
 final list = categories[area];
 print(list);
 print(categories);
  return list;
}


  Future<Map<String, dynamic>> verificationTypeUser(String email) async {
  final freelancerSnapshot = await _firestore
      .collection('freelancers')
      .where('email', isEqualTo: email)
      .limit(1)
      .get();

  if (freelancerSnapshot.docs.isNotEmpty) {
    return {
      'isFreelancer': true,
      'userId': freelancerSnapshot.docs.first.id,
      'userName': freelancerSnapshot.docs.first['name']
    };
  }

  final clientSnapshot = await _firestore
      .collection('clientes')
      .where('email', isEqualTo: email)
      .limit(1)
      .get();

  if (clientSnapshot.docs.isNotEmpty) {
    return {
      'isFreelancer': false,
      'userId': clientSnapshot.docs.first.id,
      'userName': clientSnapshot.docs.first['name']
    };
  } else {
    throw Exception('Usuário não encontrado.');
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
      String email, String password, String type) async {
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

      _firestore.collection(type).doc().set(
         {
          'email': email,
        },
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }



  // ============================================================//
  // =============================CHATS==========================//
  // ============================================================//

//   Future<String> createChatrooms(String? cliente, String? freelancer) async {
//   try {
//     // Verifica se os parâmetros são nulos
//     if (cliente == null || freelancer == null) {
//       throw Exception('Parâmetros cliente e freelancer são obrigatórios');
//     }

//     // Busca os documentos do cliente e do freelancer
//     QuerySnapshot queryCliente = await _firestore
//         .collection('users')
//         .where('email', isEqualTo: cliente)
//         .get();

//     QuerySnapshot queryFreelancer = await _firestore
//         .collection('users')
//         .where('email', isEqualTo: freelancer)
//         .get();

//     // Verifica se os documentos foram encontrados
//     if (queryCliente.docs.isEmpty || queryFreelancer.docs.isEmpty) {
//       throw Exception('Cliente ou freelancer não encontrado');
//     }

//     // Extrai os dados relevantes
//     DocumentSnapshot docCliente = queryCliente.docs.first;
//     DocumentSnapshot docFreelancer = queryFreelancer.docs.first;

//     Map<String, dynamic> userDataCliente = docCliente.data()! as Map<String, dynamic>;
//     Map<String, dynamic> userDataFreelancer = docFreelancer.data()! as Map<String, dynamic>;

//     String nomeCliente = userDataCliente['email'];
//     String emailFreelancer = userDataFreelancer['email'];
//     String uidfree = userDataFreelancer['uid'];
//     String uidcli = userDataCliente['uid'];

//     final infoprops = <String, dynamic>{
//       'cliente': nomeCliente,
//       'freelancer': emailFreelancer,
//       'uidcli': uidcli,
//       'uidfree': uidfree,
//     };

//     // Cria um novo documento na coleção 'chat' com um ID gerado automaticamente
//     DocumentReference chatRoomRef = _firestore.collection('chat').doc();

//     // Obtém o ID do documento criado
//     String chatRoomId = chatRoomRef.id;

//     // Verifica se o documento pai foi criado antes de adicionar à subcoleção
//     await chatRoomRef.set({'createdAt': FieldValue.serverTimestamp()});

//     // Adiciona os dados à subcoleção 'users'
//     await chatRoomRef.collection('users').add(infoprops);

//     return chatRoomId;
//   } on FirebaseAuthException catch (e) {
//     throw Exception(e.code);
//   }
// }

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
    QuerySnapshot<Map<String, dynamic>> area = await _firestore
        .collection('freelancers')
        .where('email', isEqualTo: email)
        .get();

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
  // Primeira consulta na coleção 'freelancers'
  QuerySnapshot<Map<String, dynamic>> infosFreelancers = await _firestore
      .collection('freelancers')
      .where('email', isEqualTo: email)
      .get();

  if (infosFreelancers.docs.isNotEmpty) {
    return infosFreelancers.docs.first.data();
  } else {
    // Se não encontrar na coleção 'freelancers', procurar na coleção 'clientes'
    QuerySnapshot<Map<String, dynamic>> infosClientes = await _firestore
        .collection('clientes')
        .where('email', isEqualTo: email)
        .get();

    if (infosClientes.docs.isNotEmpty) {
      return infosClientes.docs.first.data();
    } else {
      return null;
    }
  }
}

Future<void> saveArea(String email, String area)async {
    QuerySnapshot<Map<String, dynamic>> getInfosUsers = await _firestore
      .collection('freelancers')
      .where('email', isEqualTo: email)
      .get();
      Map<String, dynamic> updateinfos = {
      "area": area,
    };

          var docFreelancer = getInfosUsers.docs.first; // Pega o primeiro documento
      await _firestore.collection('freelancers').doc(docFreelancer.id).update(updateinfos);
    
}


Future<void> saveProfile(String name, String desc, context, String email) async {
  if (name.isNotEmpty && desc.isNotEmpty && email.isNotEmpty) {
    try {
      // Tenta atualizar na coleção 'freelancers'
      bool updated = await _updateProfile('freelancers', email, name, desc);
      
      // Se não encontrou na coleção 'freelancers', tenta na coleção 'clientes'
      if (!updated) {
        updated = await _updateProfile('clientes', email, name, desc);
      }

      if (!updated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário não encontrado.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar perfil: $e')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill out all fields.')),
    );
  }
}

 Future<Map<String, dynamic>> getClientInfo(String email) async {
  QuerySnapshot<Map<String, dynamic>> getInfosUsers = await _firestore
      .collection('clientes')
      .where('email', isEqualTo: email)
      .get();

  if (getInfosUsers.docs.isNotEmpty) {
    var documento = getInfosUsers.docs.first.data();
    return {
      'name': documento['nome'] ?? 'Nome Desconhecido',  // Verificação se o nome é nulo
      'nota': documento['nota'] ?? [0],                  // Verificação se a nota é nula
    };
  }

  return {
    'name': 'Nome Desconhecido', // Valor padrão se o documento não for encontrado
    'nota': [0],                 // Valor padrão se a nota não estiver presente
  };
}



Future<bool> _updateProfile(String collection, String email, String name, String desc) async {
  QuerySnapshot<Map<String, dynamic>> getInfosUsers = await _firestore
      .collection(collection)
      .where('email', isEqualTo: email)
      .get();
  
  if (getInfosUsers.docs.isNotEmpty) {
    var doc = getInfosUsers.docs.first; // Pega o primeiro documento encontrado
    Map<String, dynamic> updateinfos = {
      "desc": desc,
      "nome": name,
    };
    // Atualiza o documento usando a referência do documento
    await _firestore.collection(collection).doc(doc.id).update(updateinfos);
    return true; // Retorna true se a atualização for bem-sucedida
  }
  
  return false; // Retorna false se nenhum documento foi atualizado
}


Future<void> savePreregister(String desc, String name, List<String> languages, String projects, String email) async {
  // Cria o mapa de atualização das informações
  Map<String, dynamic> updateinfos;

  // Procura nas coleções por freelancers e clientes usando o email
  try {
    // Procurar na coleção 'freelancers'
    QuerySnapshot<Map<String, dynamic>> infosFreelancers = await _firestore
        .collection('freelancers')
        .where('email', isEqualTo: email)
        .get();

    if (infosFreelancers.docs.isNotEmpty) {
      updateinfos = {
    "desc": desc,
    "nome": name,
    "linguagens": languages,
    "nota": [],
    "projects": projects
  };
      var docFreelancer = infosFreelancers.docs.first; // Pega o primeiro documento
      await _firestore.collection('freelancers').doc(docFreelancer.id).update(updateinfos);
    } else {
      // Se não encontrar na coleção 'freelancers', procurar na coleção 'clientes'
      QuerySnapshot<Map<String, dynamic>> infosClientes = await _firestore
          .collection('clientes')
          .where('email', isEqualTo: email)
          .get();

      if (infosClientes.docs.isNotEmpty) {
        updateinfos = {
    "desc": desc,
    "nome": name,
  };
        var docCliente = infosClientes.docs.first; 
        await _firestore.collection('clientes').doc(docCliente.id).update(updateinfos);
      } else {
        // Caso não encontre em nenhuma das coleções, pode-se lidar com isso aqui
        print('Nenhum documento encontrado para o email fornecido.');
      }
    }
  } catch (e) {
    print('Erro ao salvar pré-registro: $e');
  }
}




Future<List<String>> getHab(String area, String type) async {
  try {
    // Obtém o documento de filtros a partir do ID fornecido
    DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
        .collection('filters')
        .doc('VPyiRaZZB8IyxoxOpotH')
        .get();

    // Verifica se o documento existe
    if (doc.exists) {
      Map<String, dynamic>? data = doc.data();

      // Verifica se o campo fornecido por 'type' está presente no documento
      if (data != null && data.containsKey(type)) {
        Map<String, dynamic>? map = data[type];

        // Verifica se o mapa contém a chave da área especificada
        if (map != null && map.containsKey(area)) {
          List<dynamic>? arrayTI = map[area];

          // Converte o array de dinâmico para lista de strings
          if (arrayTI != null && arrayTI is List) {
            // Filtra apenas strings para garantir consistência
            List<String> validList = arrayTI.whereType<String>().toList();
            return validList;
          } else {
            print('O campo "$area" não é uma lista válida ou está vazio.');
          }
        } else {
          print('Chave "$area" não encontrada em "$type".');
        }
      } else {
        print('Campo "$type" não encontrado no documento.');
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
    querySnapshot = await _firestore.collection('clientes').where('email', isEqualTo: email).get();
    if (querySnapshot.docs.isNotEmpty) {
    DocumentSnapshot document = querySnapshot.docs.first;
    DocumentReference documentRef = document.reference;

    // Atualizando o documento com os novos dados
    await documentRef.update(infoprops);
    print('Documento atualizado com sucesso.');
  } 
    // Aqui você pode adicionar o código para lidar com a atualização da coleção 'clientes' se necessário
  }
} catch (e) {
  print('Erro ao atualizar o documento: $e');
}

}


      // Armazenando o infocard no Firestore
}