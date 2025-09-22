
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/app_user.dart';
import 'package:myapp/services/firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // Create user object from Firebase user
  AppUser? _userFromFirebaseUser(User? user) {
    return user != null ? AppUser(uid: user.uid, email: user.email!, name: user.displayName) : null;
  }

  // Auth change user stream
  Stream<AppUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // Sign in with email and password
  Future<AppUser?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register with email and password
  Future<AppUser?> registerWithEmailAndPassword(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (user == null) {
        return null;
      }

      // Update the user's display name in Firebase Auth
      await user.updateDisplayName(name);
      
      // We need to reload the user to get the updated display name
      await user.reload();
      user = _auth.currentUser;


      // Create a new user object
      AppUser newUser = AppUser(uid: user!.uid, email: email, name: name);

      // Save the user to Firestore
      await _firestoreService.addUser(newUser);

      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
        // Re-throw the exception to be handled by the calling function in AuthProvider
        
        rethrow;
    }
  }
  // Update user name
  Future<void> updateUserName(String name) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      await user.reload();
      final updatedUser = _auth.currentUser;
      await _firestoreService.updateUser(
        AppUser(uid: updatedUser!.uid, email: updatedUser.email!, name: name),
      );
    }
  }


  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return;
    }
  }
}
