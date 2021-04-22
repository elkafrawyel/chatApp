import 'dart:async';
import 'dart:io';

import 'package:chat_app/api/notification_center.dart';
import 'package:chat_app/controllers/settings_controller.dart';
import 'package:chat_app/data/super_message_model.dart';
import 'package:chat_app/data/user_model.dart';
import 'package:chat_app/helper/Utilies.dart';
import 'package:chat_app/helper/local_storage.dart';
import 'package:chat_app/screens/auth/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class FirebaseApi {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final String userRef = 'Users';
  final String chatRef = 'Chat';
  final String keyMessages = 'Messages';
  final String keyLastMessage = 'LastMessage';
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final UserModel me = UserModel.fromLocalStorage();

  Future<UserModel> createNewUser(
    String name,
    String email,
    String phone,
    String password,
    bool isMale,
    String countryCode,
    File userImage,
  ) async {
    print('signing up');

    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = _auth.currentUser;
      assert(user.uid != null);
      Reference imageReference =
          FirebaseStorage.instance.ref('profile/user_${user.uid}');
      UploadTask uploadTask = imageReference.putFile(userImage);
      await uploadTask.whenComplete(() => print('Photo upload done'));
      String imageUrl = await imageReference.getDownloadURL();
      //update user profile and save it
      UserModel userModel = UserModel(
          name,
          imageUrl,
          user.uid,
          phone,
          email,
          countryCode,
          true,
          DateTime.now().millisecondsSinceEpoch,
          isMale,
          null,
          null);

      _fireStore.collection(userRef).doc(user.uid).set(userModel.toJson());

      print('You have new account');
      return userModel;
    } on FirebaseAuthException catch (e) {
      _handleFirebaseError(e);
      return null;
    }
  }

  Future<UserModel> editProfile(
    String name,
    String email,
    String phone,
    String countryCode,
    String bio,
    File userImage,
  ) async {
    print('changing profile');

    try {
      UserModel currentUser = UserModel.fromLocalStorage();
      String imageUrl;
      if (userImage != null) {
        Reference imageReference =
            FirebaseStorage.instance.ref('profile/user_${currentUser.id}');
        UploadTask uploadTask = imageReference.putFile(userImage);
        await uploadTask.whenComplete(() => print('Photo upload done'));
        imageUrl = await imageReference.getDownloadURL();
      }

      //update user profile and save it
      UserModel userModel = UserModel(
          name,
          imageUrl == null ? currentUser.imageUrl : imageUrl,
          currentUser.id,
          phone,
          email,
          countryCode,
          true,
          DateTime.now().millisecondsSinceEpoch,
          currentUser.isMale,
          bio,
          null);

      _fireStore
          .collection(userRef)
          .doc(currentUser.id)
          .update(userModel.toJson());

      print('You account has changed');
      return userModel;
    } on FirebaseAuthException catch (e) {
      _handleFirebaseError(e);
      return null;
    }
  }

  Future<UserModel> login(String email, String password) async {
    print('logging in');
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = _auth.currentUser;
      assert(user.uid != null);
      UserModel userModel = await getUserProfile();
      return userModel;
    } on FirebaseAuthException catch (e) {
      _handleFirebaseError(e);
      return null;
    }
  }

  Future<UserModel> getUserProfile({String id}) async {
    print('getting profile');

    if (id == null) {
      if (_auth.currentUser == null)
        return null;
      else {
        String id = _auth.currentUser.uid;
        DocumentSnapshot snapshot =
            await _fireStore.collection(userRef).doc(id).get();
        return UserModel.fromJson(snapshot.data());
      }
    } else {
      DocumentSnapshot snapshot =
          await _fireStore.collection(userRef).doc(id).get();
      return UserModel.fromJson(snapshot.data());
    }
  }

  void setUserOnlineState(bool isOnline) {
    print('change online state to $isOnline');
    final controller = Get.find<SettingsController>();
    if (_auth.currentUser == null || controller.userModel == null)
      return null;
    else {
      controller.userModel.isOnline = isOnline;
      if (!isOnline) {
        controller.userModel.lastSeen = DateTime.now().millisecondsSinceEpoch;
      }
      _fireStore
          .collection(userRef)
          .doc(_auth.currentUser.uid)
          .update(controller.userModel.toJson());
    }
  }

  static setFirebaseToken(String token) {
    UserModel me = UserModel.fromLocalStorage();
    if (me != null) {
      me.firebaseToken = token;
      FirebaseFirestore.instance
          .collection('Users')
          .doc(me.id)
          .update(me.toJson());
    }
  }

  logOut() {
    FirebaseAuth.instance.signOut();
    LocalStorage().clear();
    Get.offAll(() => LoginScreen());
  }

  void updateProfile(UserModel userModel) {
    print('updating profile');
    final controller = Get.find<SettingsController>();
    if (_auth.currentUser == null)
      return null;
    else {
      _fireStore
          .collection(userRef)
          .doc(_auth.currentUser.uid)
          .update(userModel.toJson());
      controller.userModel = userModel;
    }
  }

  /// =================== chat messages ===================================

  static String _getChatRoom(String idUser) {
    String myId = UserModel.fromLocalStorage().id;
    if (idUser.substring(0, 1).codeUnitAt(0) >
        myId.substring(0, 1).codeUnitAt(0)) {
      return '${idUser}_$myId';
    } else {
      return '${myId}_$idUser';
    }
  }

  seeSingleMessage(String idUser, String messageId) async {
    var document = await FirebaseFirestore.instance
        .collection(keyMessages)
        .doc(_getChatRoom(idUser))
        .collection(keyMessages)
        .doc(messageId)
        .get();
    // document.reference.update(<String, dynamic>{
    //   SuperMessageFields.seen: true,
    // });
  }

  static Future uploadMessage(
      String idUser, String message, SuperMessage replyMessage) async {
    final refMessages = FirebaseFirestore.instance
        .collection('chats/${_getChatRoom(idUser)}/messages');

    final newMessage = SuperMessage(
      idTo: idUser,
      idFrom: UserModel.fromLocalStorage().id,
      message: message,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      replyMessage: replyMessage,
    );
    DocumentReference documentReference =
        await refMessages.add(newMessage.toJson());

    documentReference.update({MessageField.idMessage: documentReference.id});

    //save message into room doc for me and for him
    final refUsers = FirebaseFirestore.instance.collection('ChatRooms');

    await refUsers
        .doc(idUser)
        .collection('rooms')
        .doc(UserModel.fromLocalStorage().id)
        .set({
      'lastMessage': newMessage.toJson(),
      'time': DateTime.now().millisecondsSinceEpoch
    });

    await refUsers
        .doc(UserModel.fromLocalStorage().id)
        .collection('rooms')
        .doc(idUser)
        .set({
      'lastMessage': newMessage.toJson(),
      'time': DateTime.now().millisecondsSinceEpoch
    });

    //send him a message


    NotificationCenter().sendNotification(
        idUser,
        UserModel.fromLocalStorage().name,
        message,
        NotificationType.CHAT);
  }

  static Stream<List<SuperMessage>> getMessagesStream(String idUser) =>
      FirebaseFirestore.instance
          .collection('chats/${_getChatRoom(idUser)}/messages')
          .orderBy(MessageField.createdAt, descending: true)
          .snapshots()
          .transform(
              AppUtilies.transformer((json) => SuperMessage.fromJson(json)));

  // static Stream<List<SuperMessage>> getMessagesStream(String idUser) =>
  //     FirebaseFirestore.instance
  //         .collection('chats/${_getChatRoom(idUser)}/messages')
  //         .orderBy(MessageField.createdAt, descending: true)
  //         .snapshots()
  //         .transform(AppUtilies.transformer(SuperMessage.fromJson));

  static Future<QuerySnapshot> getMessages(String idUser, int limit) async =>
      (await FirebaseFirestore.instance
          .collection('chats/${_getChatRoom(idUser)}/messages')
          .orderBy(MessageField.createdAt, descending: true)
          .limit(limit)
          .get());

  static Future<QuerySnapshot> loadMoreMessages(
          String idUser, int limit, DocumentSnapshot lastDocument) async =>
      (await FirebaseFirestore.instance
          .collection('chats/${_getChatRoom(idUser)}/messages')
          .orderBy(MessageField.createdAt, descending: true)
          .startAfterDocument(lastDocument)
          .limit(limit)
          .get());

  static Stream<List<SuperMessage>> getMyChats() => FirebaseFirestore.instance
      .collection('ChatRooms')
      .doc(UserModel.fromLocalStorage().id)
      .collection('rooms')
      .orderBy('time', descending: true)
      .snapshots()
      .transform(AppUtilies.transformer(
          (json) => SuperMessage.fromJson(json['lastMessage'])));

  /// =================== End chat messages ===================================

  void _handleFirebaseError(FirebaseAuthException e) {
    print(e.code);
    bool isArabic = false;
    var errorMessage;
    switch (e.code) {
      case "ERROR_INVALID_EMAIL":
        if (isArabic) {
          errorMessage = "ايميل غير صحيح";
        } else {
          errorMessage = "Your email address appears to be invalid.";
        }
        break;
      case "ERROR_WRONG_PASSWORD":
        if (isArabic) {
          errorMessage = "كلمة المرور غير صحيحة";
        } else {
          errorMessage = "Your password is wrong.";
        }
        break;
      case "ERROR_USER_NOT_FOUND":
        if (isArabic) {
          errorMessage = "ايميل غير موجود";
        } else {
          errorMessage = "User with this email doesn't exist.";
        }

        break;
      case "ERROR_USER_DISABLED":
        if (isArabic) {
          errorMessage = "هذا الحساب معطل";
        } else {
          errorMessage = "User with this email has been disabled.";
        }
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        if (isArabic) {
          errorMessage = "خطأ حاول مرة اخري لاحقا";
        } else {
          errorMessage = "Too many requests. Try again later.";
        }
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        if (isArabic) {
          errorMessage = "التسجيل غير متاح";
        } else {
          errorMessage = "Signing in with this method is not enabled.";
        }
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        if (isArabic) {
          errorMessage =
              "هذا البريد مستخدم من قبل حاول تسجيل الدخول او جرب طريقة اخري للتسجيل";
        } else {
          errorMessage =
              "The email has already been registered. Please login or reset your password.";
        }
        break;
      case "account-exists-with-different-credential":
        if (isArabic) {
          errorMessage = "هذا الايميل مستخدم من قبل بطريقة تسجيل اخري";
        } else {
          errorMessage =
              "An account already exists with the same email address but different sign-in credentials.";
        }
        break;
      case "user-not-found":
        if (isArabic) {
          errorMessage = "مستخدم غير موجود";
        } else {
          errorMessage =
              "There is no user record corresponding to this identifier. The user may have been deleted.";
        }
        break;
      default:
        if (isArabic) {
          errorMessage = "خطأ غير معروف";
        } else {
          errorMessage = "An undefined Error happened.";
        }
    }
    Get.snackbar('Login Error', errorMessage);
  }

  static Stream<DocumentSnapshot> singleUserStream(String idUser) =>
      FirebaseFirestore.instance.collection('Users').doc(idUser).snapshots();
}
