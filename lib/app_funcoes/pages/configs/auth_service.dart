import 'dart:async';
import 'dart:io';
import 'package:app_freelancer/app_funcoes/pages/freelancer/home/home_chat/chat/message.dart';
import 'package:app_freelancer/app_funcoes/pages/homeprincip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart'; // Para kIsWeb
// import 'package:image_picker/image_picker.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;




Future<void> setprojectorfreelancers(String id, String email) async {
  final freelancerSnapshot = await _firestore
      .collection('freelancers')
      .where('email', isEqualTo: email)
      .limit(1)
      .get();

  if (freelancerSnapshot.docs.isNotEmpty) {
    var docFreelancer = freelancerSnapshot.docs.first;

    await _firestore.collection('freelancers').doc(docFreelancer.id).update({
      "projects": FieldValue.arrayUnion([id]), 
    });

    await _firestore.collection('projects').doc(id).update({
      "emailfree": email
    });
  }
}


 Future<List<Map<String, dynamic>>?> getprojectsorfreelancers(String tipo, String email, String? area) async {
  try {
    String? newarea;
    if (area != null) {
      if (area == 'Tecnologia') {
        newarea = 'ti';
      }
      else if (area == 'Edificação') {
        newarea = 'edifecation';
      }
      else if (area == 'Administração') {
        newarea = 'administration';
      }
    }
    final freelancerSnapshot = await _firestore
        .collection('freelancers')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    // Se o usuário for um freelancer
    if (freelancerSnapshot.docs.isNotEmpty) {
      final QuerySnapshot<Map<String, dynamic>> projectsSnapshot;
      if (tipo == 'All') {
        projectsSnapshot = await _firestore.collection('projects').get();
      } else {
        projectsSnapshot = await _firestore
            .collection('projects')
            .where('classificacao', arrayContains: tipo) // Busca por projetos onde o array 'classificacao' contém o tipo
            .get();
      }

      final List<Map<String, dynamic>> projects = projectsSnapshot.docs
          .map((doc) => doc.data())
          .toList();

      return projects; // Retorna os projetos encontrados para freelancers
    }

    // Se não for freelancer, verifica se o email pertence a um cliente
    final clientSnapshot = await _firestore
        .collection('clientes')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (clientSnapshot.docs.isNotEmpty) {
      final QuerySnapshot<Map<String, dynamic>> freelancersSnapshot;
      if (tipo == 'All') {
        freelancersSnapshot = await _firestore.collection('freelancers').where('area', isEqualTo: newarea).get();
      } else {
        freelancersSnapshot = await _firestore.collection('freelancers')
            .where('classificacao', arrayContains: tipo)
            .where('area', isEqualTo: newarea) // Busca por freelancers onde o array 'classificacao' contém o tipo
            .get();
      }

      final List<Map<String, dynamic>> freelancers = freelancersSnapshot.docs
          .map((doc) => doc.data())
          .toList();

      return freelancers; // Retorna os freelancers encontrados para clientes
    } else {
      print('Usuário não encontrado.');
      return null; // Retorna null se não for freelancer nem cliente
    }
  } on FirebaseAuthException catch (e) {
    throw Exception(e.code); // Trata exceções relacionadas à autenticação
  } catch (e) {
    print('Erro: $e'); // Captura outros erros
    return null; // Retorna null em caso de erro
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
  return list;
}
 Future<List> getfileterhome(String email, String area) async {
  String? tipoverdadeiro = '';
  if (area == 'Tecnologia') {
  tipoverdadeiro = 'ti';
} else if (area == 'Edificação') {
  tipoverdadeiro = 'edifecation';
} else if (area == 'Administração') {
  tipoverdadeiro = 'administration';
}

  // Consulta Firestore com o filtro where
  final snapshot = await _firestore
      .collection('filters')
      .doc('VPyiRaZZB8IyxoxOpotH').get();

 final categories =  snapshot.data()?['curses'];
 final list = categories[tipoverdadeiro];
  return list;
}


  Future<Map<String, dynamic>> verificationTypeUser(String email) async {
  // Verifica na coleção 'freelancers'
  final freelancerSnapshot = await _firestore
      .collection('freelancers')
      .where('email', isEqualTo: email) 
      .get();

  if (freelancerSnapshot.docs.isNotEmpty) {
    // Usuário encontrado como freelancer
    return {
      'isFreelancer': true,
      'userId': freelancerSnapshot.docs.first.id,
      'userName': freelancerSnapshot.docs.first['nome'],
    };
  }

  // Verifica na coleção 'clientes'
  final clientSnapshot = await _firestore
      .collection('clientes')
      .where('email', isEqualTo: email) 
      .get();

  if (clientSnapshot.docs.isNotEmpty) {
    // Usuário encontrado como cliente
    return {
      'isFreelancer': false,
      'userId': clientSnapshot.docs.first.id,
      'userName': clientSnapshot.docs.first['nome'],
    };
  } else {
    // Se não encontrar em ambas as coleções
    print('Usuário não encontrado para o e-mail: $email');
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

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }



  // ============================================================//
  // =============================CHATS==========================//
  // ============================================================//

Future<String?> receiverUserID(String? cliente, String? freelancer, bool freeorcli, String chatRoomDoc) async {
  try {
    // Obtém o documento da coleção 'chat' usando o ID do chatRoom
    DocumentSnapshot<Map<String, dynamic>> chatDocSnapshot = await _firestore.collection('chat').doc(chatRoomDoc).get();

    // Verifica se o documento do chat existe
    if (chatDocSnapshot.exists) {
      // Obtém a referência à coleção 'users' dentro do documento do chat
      CollectionReference<Map<String, dynamic>> usersCollection = _firestore.collection('chat').doc(chatRoomDoc).collection('users');

      // Obtém todos os documentos da coleção 'users'
      QuerySnapshot<Map<String, dynamic>> usersSnapshot = await usersCollection.get();

      // Verifica se a coleção 'users' possui documentos
      if (usersSnapshot.docs.isNotEmpty) {
        // Debug: Imprime os documentos encontrados
        for (var userDoc in usersSnapshot.docs) {
          print('Documento encontrado: ${userDoc.id} - Dados: ${userDoc.data()}');
        }
        
        // Obtém o primeiro documento da coleção 'users'
        var userDoc = usersSnapshot.docs.first.data();
        
        // Verifica se uidcli ou uidfree estão presentes nos dados
        if (userDoc.containsKey('uidcli') && userDoc.containsKey('uidfree')) {
          // Retorna uidcli se freeorcli for true, caso contrário retorna uidfree
          return freeorcli ? userDoc['uidfree'] : userDoc['uidcli'];
        } else {
          print('Campos uidcli ou uidfree não encontrados no documento.');
        }
      } else {
        print('Nenhum documento encontrado na coleção "users".');
      }
    } else {
      print('Documento do chat não encontrado para o ID: $chatRoomDoc');
    }
  } catch (e) {
    print('Erro ao buscar ID do usuário: $e');
  }
  return null; // Retorna null se nenhum ID for encontrado
}






  Future<String> createChatrooms(String? user1, String? user2) async {
  try {
    // Verifica se os parâmetros são nulos
    if (user1 == null || user2 == null) {
      throw Exception('Parâmetros user1 e user2 são obrigatórios');
    }

    // Busca os documentos do user1 e do user2
    QuerySnapshot queryCliente = await _firestore
        .collection('users')
        .where('email', isEqualTo: user1)
        .get();

    QuerySnapshot queryFreelancer = await _firestore
        .collection('users')
        .where('email', isEqualTo: user2)
        .get();


    QuerySnapshot queryClientevery = await _firestore
        .collection('freelancers')
        .where('email', isEqualTo: user1)
        .get();

    QuerySnapshot queryFreelancervery = await _firestore
        .collection('cliente')
        .where('email', isEqualTo: user2)
        .get();

    // Verifica se os documentos foram encontrados
    if (queryClientevery.docs.isEmpty || queryFreelancervery.docs.isEmpty) {
          QuerySnapshot queryCliente = await _firestore
        .collection('users')
        .where('email', isEqualTo: user2)
        .get();

    QuerySnapshot queryFreelancer = await _firestore
        .collection('users')
        .where('email', isEqualTo: user1)
        .get();

        DocumentSnapshot docCliente = queryCliente.docs.first;
        DocumentSnapshot docFreelancer = queryFreelancer.docs.first;

    Map<String, dynamic> userDataCliente = docCliente.data()! as Map<String, dynamic>;
    Map<String, dynamic> userDataFreelancer = docFreelancer.data()! as Map<String, dynamic>;

    String emailCliente = userDataCliente['email'];
    String emailFreelancer = userDataFreelancer['email'];
    String uidfree = userDataFreelancer['uid'];
    String uidcli = userDataCliente['uid'];

    final infoprops = <String, dynamic>{
      'cliente':  emailCliente,
      'freelancer': emailFreelancer,
      'uidcli': uidcli,
      'uidfree':   uidfree,
    };

     DocumentReference chatRoomRef = _firestore.collection('chat').doc();

    // Obtém o ID do documento criado
    String chatRoomId = chatRoomRef.id;

    // Verifica se o documento pai foi criado antes de adicionar à subcoleção
    await chatRoomRef.set({'createdAt': FieldValue.serverTimestamp()});

    // Adiciona os dados à subcoleção 'users'
    await chatRoomRef.collection('users').add(infoprops);

    return chatRoomId;
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

  Future<void> realizarPagamento(String cardName, String cardNumber, String expiry, String valor, String cvc, String email) async {
  try {
    // Converte o valor fornecido para um número
    double valorPagamento = double.parse(valor);

    // Consulta para encontrar o documento do freelancer com o email fornecido
    final querySnapshot = await _firestore
        .collection('freelancers')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Obtém a referência do documento encontrado
      final docRef = querySnapshot.docs.first.reference;
      
      // Obtém os dados atuais do documento
      final docSnapshot = await docRef.get();
      double valorAtual = (docSnapshot.data()?['recebido'] ?? 0).toDouble();

      // Soma o valor atual com o valor fornecido
      double novoValorRecebido = valorAtual + valorPagamento;

      // Atualiza o campo 'recebido' com o novo valor
      final updateInfos = {
        "recebido": novoValorRecebido
      };

      await docRef.update(updateInfos);
      print('Informações de pagamento atualizadas com sucesso.');
    } else {
      print('Nenhum freelancer encontrado com o email fornecido.');
    }
  } catch (e) {
    print('Erro ao atualizar informações de pagamento: $e');
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


   Future<List<String>> getcontactsclient(String? cliente) async {
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

          if (userData['cliente'] == cliente) {
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
  

  Future<String?> getChatRoomId(String userEmail, String emailCliOrFree) async {
  try {
    // Primeiro, busca na coleção 'chat' e na subcoleção 'users' onde o cliente é 'emailCliOrFree' e o freelancer é 'userEmail'
    final QuerySnapshot<Map<String, dynamic>> chatSnapshot = await _firestore
        .collection('chat')
        .get();

    // Itera sobre cada documento de chat para procurar na subcoleção 'users'
    for (final chatDoc in chatSnapshot.docs) {
      final usersCollection = chatDoc.reference.collection('users');

      final QuerySnapshot<Map<String, dynamic>> userDocs = await usersCollection
          .where('cliente', isEqualTo: emailCliOrFree)
          .where('freelancer', isEqualTo: userEmail)
          .get();

      if (userDocs.docs.isNotEmpty) {
        // Retorna o ID do documento do chat correspondente
        return chatDoc.id;
      }
      else{
        // Caso a primeira busca não tenha retornado resultados, faz a busca alternativa
    for (final chatDoc in chatSnapshot.docs) {
      final usersCollection = chatDoc.reference.collection('users');

      final QuerySnapshot<Map<String, dynamic>> userDocsAlt = await usersCollection
          .where('cliente', isEqualTo: userEmail)
          .where('freelancer', isEqualTo: emailCliOrFree)
          .get();

      if (userDocsAlt.docs.isNotEmpty) {
        // Retorna o ID do documento do chat correspondente
        return chatDoc.id;
      }
    }
      }
    }

    
  } catch (e) {
    print("Erro ao buscar chat room ID: $e");
  }
  return null; // Retorna null caso nenhum chat room seja encontrado
}







  

  // ============================================================//
  // ===========================PROFILE==========================//
  // ============================================================//


    Future<XFile?> getimage() async {
        final ImagePicker _picker = ImagePicker();
        XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        return image;
    }

    Future<void> upload(String path, String email) async {
  File file = File(path);
  try {
    String ref = 'images/img-${DateTime.now().toString()}.jpg';
    
    final QuerySnapshot<Map<String, dynamic>> freelancerSnapshot = await _firestore
        .collection('freelancers')
        .where('email', isEqualTo: email)
        .get();
    
    if (freelancerSnapshot.docs.isNotEmpty) {
      String documentId = freelancerSnapshot.docs.first.id;

      await _firestore
          .collection('freelancers')
          .doc(documentId)
          .update({'ref': ref});
      
      // Faz o upload do arquivo para o Firebase Storage
      await _firebaseStorage.ref(ref).putFile(file);
    } else {
      final QuerySnapshot<Map<String, dynamic>> clienteSnapshot = await _firestore
        .collection('clientes')
        .where('email', isEqualTo: email)
        .get();
        if (clienteSnapshot.docs.isNotEmpty) {
      String documentId = clienteSnapshot.docs.first.id;

      await _firestore
          .collection('clientes')
          .doc(documentId)
          .update({'ref': ref});
      
      // Faz o upload do arquivo para o Firebase Storage
      await _firebaseStorage.ref(ref).putFile(file);
    }
    }
  } on FirebaseException catch (e) {
    throw Exception('Erro no upload: ${e.code}');
  }
}

  Future<String> fetchImage(String email) async {
  try {
    // Buscando freelancer
    final QuerySnapshot<Map<String, dynamic>> freelancerSnapshot = await _firestore
        .collection('freelancers')
        .where('email', isEqualTo: email)
        .get();

    if (freelancerSnapshot.docs.isNotEmpty) {
      String caminhoImg = freelancerSnapshot.docs.first.data()['ref'];

      Reference ref = FirebaseStorage.instance.ref(caminhoImg);
      String url = await ref.getDownloadURL();
      return url;
    } else {
      // Buscando cliente
      final QuerySnapshot<Map<String, dynamic>> clienteSnapshot = await _firestore
          .collection('clientes')
          .where('email', isEqualTo: email)
          .get();
      
      if (clienteSnapshot.docs.isNotEmpty) {
        String caminhoImg = clienteSnapshot.docs.first.data()['ref']; // Correção aqui

        Reference ref = FirebaseStorage.instance.ref(caminhoImg);
        String url = await ref.getDownloadURL();
        return url;
      }
    }
    
    return "erro"; // Caso não encontre nenhum documento
  } catch (e) {
    print('Erro ao buscar a imagem: $e');
    return "erro"; // Retorna um erro genérico
  }
}

  


    pickandUploadImage(String email) async {
      XFile? file = await getimage();
      if (file != null) {
        await upload(file.path, email);
        
      }

    }



  Future<List<Map<String, dynamic>>?> getProjects(String email) async {
  try {
    // Busca o freelancer pelo email
    final QuerySnapshot<Map<String, dynamic>> freelancer = await _firestore
      .collection('freelancers')
      .where('email', isEqualTo: email)
      .get();

    print("Freelancer encontrado: ${freelancer.docs.length} documentos");

    if (freelancer.docs.isNotEmpty) {
      // Recupera o array de projectIds
      final List<dynamic> projectIds = freelancer.docs.first.data()['projects'];
      print("Project IDs: $projectIds");

      // Verifica se o array não está vazio
      if (projectIds.isNotEmpty) {
        // Busca projetos usando whereIn
        final QuerySnapshot<Map<String, dynamic>> projectsSnapshot = await _firestore
          .collection('projects')
          .where(FieldPath.documentId, whereIn: projectIds) // Use whereIn para buscar por vários IDs
          .get();

        print("Projetos encontrados como freelancer: ${projectsSnapshot.docs.length} documentos");
        return projectsSnapshot.docs.map((doc) => doc.data()).toList();
      } else {
        print("Array de projectIds está vazio.");
      }
    } else {
      print("Nenhum freelancer encontrado.");
    }

    // Busca projetos como cliente
    final QuerySnapshot<Map<String, dynamic>> projectsSnapshot = await _firestore
      .collection('projects')
      .where('emailcli', isEqualTo: email)
      .get();

    print("Projetos encontrados como cliente: ${projectsSnapshot.docs.length} documentos");
    if (projectsSnapshot.docs.isNotEmpty) {
      return projectsSnapshot.docs.map((doc) => doc.data()).toList();
    }
  } catch (e) {
    print("Erro ao buscar projetos: $e");
  }
  
  print("Nenhum projeto encontrado.");
  return null;
}


Future<void> updateProjects(String email, String frase) async {
  try {
    // Busca os projetos pelo email do freelancer
    final QuerySnapshot<Map<String, dynamic>> freelancerSnapshot = await _firestore
        .collection('projects')
        .where('emailfree', isEqualTo: email)
        .get();

    print("Freelancer encontrado: ${freelancerSnapshot.docs.length} documentos");

    // Verifica se encontrou algum projeto
    if (freelancerSnapshot.docs.isNotEmpty) {
      // Atualiza o campo 'status' para 'finalizado' em todos os documentos encontrados
      for (var doc in freelancerSnapshot.docs) {
        await _firestore.collection('projects').doc(doc.id).update({
          'status': frase,
        });
      }
      print("Todos os projetos com email '$email' foram atualizados para 'finalizado'.");
    } else {
      print("Nenhum projeto encontrado para o email: $email.");
    }
  } catch (e) {
    print("Erro ao buscar e atualizar projetos: $e");
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
      QuerySnapshot<Map<String, dynamic>> area = await _firestore
        .collection('clientes')
        .where('email', isEqualTo: email)
        .get();
        if (area.docs.isNotEmpty) {
      return area.docs.first.data()['area'] as String?;
    }
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
     if (getInfosUsers.docs.isNotEmpty) {
        var docFreelancer = getInfosUsers.docs.first; // Pega o primeiro documento
      await _firestore.collection('freelancers').doc(docFreelancer.id).update(updateinfos);
     } else {
      getInfosUsers = await _firestore
      .collection('clientes')
      .where('email', isEqualTo: email)
      .get();
      if (getInfosUsers.docs.isNotEmpty) {
        var docFreelancer = getInfosUsers.docs.first; // Pega o primeiro documento
      await _firestore.collection('clientes').doc(docFreelancer.id).update(updateinfos);
     }
     } 
}

Future<void> saveNota(String email, String nota) async {
  QuerySnapshot<Map<String, dynamic>> getInfosUsers = await _firestore
    .collection('freelancers')
    .where('email', isEqualTo: email)
    .get();

  if (getInfosUsers.docs.isNotEmpty) {
    var docFreelancer = getInfosUsers.docs.first;
    await _firestore.collection('freelancers').doc(docFreelancer.id).update({
      "nota": FieldValue.arrayUnion([nota]), // Adiciona a nova nota ao array
    });
  } else {
    getInfosUsers = await _firestore
      .collection('clientes')
      .where('email', isEqualTo: email)
      .get();
    if (getInfosUsers.docs.isNotEmpty) {
      var docCliente = getInfosUsers.docs.first; // Pega o primeiro documento
      await _firestore.collection('clientes').doc(docCliente.id).update({
        "nota": FieldValue.arrayUnion([nota]), // Adiciona a nova nota ao array
      });
    }
  }
}

Future<void> saveProjects(
  String area, 
  List<String> classificacao, 
  List<String> ferramentas,
  String desc, 
  String emailcli, 
  String titulo, 
  String valmin, 
  String valmax, 
  String _status,
  DateTime? fim
) async {
  // Cria um mapa com as informações do projeto (sem o ID ainda)
  Map<String, dynamic> updateinfos = {
    "area": area,
    "classificacao": classificacao,
    "desc": desc,
    "id": '',
    "emailcli": emailcli,
    "ferramentas": ferramentas,
    "titulo": titulo,
    "valmin": valmin,
    "status": _status,
    "valmax": valmax,
    "dtfim": fim?.toIso8601String(),
  };

  // Adiciona o documento ao Firestore e pega a referência do documento
  DocumentReference docRef = await _firestore.collection('projects').add(updateinfos);

  // Atualiza o mapa com o ID do documento
  String docId = docRef.id;
  updateinfos['id'] = docId;

  // Atualiza o próprio documento com o ID
  await _firestore.collection('projects').doc(docId).update(updateinfos);

}




Future<void> saveProfile(
  String name,
  String desc,
  context,
  String email,
  List<String> classificacoes, // Novo parâmetro para classificações
) async {
  if (name.isNotEmpty && desc.isNotEmpty && email.isNotEmpty) {
    try {
      // Tenta atualizar na coleção 'freelancers'
      bool updated = await _updateProfile('freelancers', email, name, desc, classificacoes);
      
      // Se não encontrou na coleção 'freelancers', tenta na coleção 'clientes'
      if (!updated) {
        updated = await _updateProfile('clientes', email, name, desc, classificacoes);
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
      const SnackBar(content: Text('Por favor, preencha todos os campos.')),
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
      'name': documento['nome'] ?? 'Nome Desconhecido',  
      'nota': documento['nota'] ?? [0],                  
    };
  }

  return {
    'name': 'Nome Desconhecido', 
    'nota': [0],                 
  };
}



Future<bool> _updateProfile(
  String collection,
  String email,
  String name,
  String desc,
  List<String> classificacoes, // Novo parâmetro para classificações
) async {
  // Pesquisa na coleção pelo documento correspondente ao email
  QuerySnapshot<Map<String, dynamic>> getInfosUsers = await _firestore
      .collection(collection)
      .where('email', isEqualTo: email)
      .get();
  
  if (getInfosUsers.docs.isNotEmpty) {
    var doc = getInfosUsers.docs.first; // Pega o primeiro documento encontrado
    Map<String, dynamic> updateinfos = {
      "desc": desc,
      "nome": name,
      "classificacao": classificacoes, // Adiciona as classificações ao mapa de atualização
    };
    // Atualiza o documento usando a referência do documento
    await _firestore.collection(collection).doc(doc.id).update(updateinfos);
    return true; // Retorna true se a atualização for bem-sucedida
  }
  
  return false; // Retorna false se nenhum documento foi atualizado
}


Future<void> savePreregister(
    String? desc,
    String? name,
    List<String>? languages,
    String? projects,
    String? email,
    List<dynamic> selectedItems,
    String? area,
    String? valmedi) async {
  // Verifica se o email é nulo
  if (email == null || email.isEmpty) {
    print('O email fornecido é nulo ou vazio.');
    return;
  }

  try {
      Map<String, dynamic> updateinfos = {
        "desc": desc,
        "nome": name,
        "linguagens": languages ?? [],
        "valmed": valmedi,
        "nota": [],
        "email": email,
        'area': area,
        "classificacao": selectedItems,
        "projects": projects,
      };

      // Adiciona um novo documento na coleção 'freelancers'
      await _firestore.collection('freelancers').add(updateinfos);
    
  } catch (e) {
    print('Erro ao salvar pré-registro: $e');
  }
}
Future<void> savePreregisterCliente(
    String? desc,
    String? name,
    String? telefone,
    String? cnpjcpf,
    String? email
    ) async {
  // Verifica se o email é nulo
  if (email == null || email.isEmpty) {
    print('O email fornecido é nulo ou vazio.');
    return;
  }

  try {
      Map<String, dynamic> updateinfos = {
        "desc": desc,
        "nome": name,
        "nota": [],
        "telefone": telefone,
        "email": email,
        "cnpjcpf": cnpjcpf,
      };

      // Adiciona um novo documento na coleção 'freelancers'
      await _firestore.collection('clientes').add(updateinfos);
    
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