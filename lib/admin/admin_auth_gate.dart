import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Core/Network/Remote/firebase_notification_helper.dart';
import 'admin_dashboard.dart';

const _adminUid = 'x4BowypLZRSJ3ptp8CbFuafSFjj1';

class AdminAuthGate extends StatelessWidget {
  const AdminAuthGate({super.key});

  static final _googleSignInReady = GoogleSignIn.instance.initialize();

  static Future<void> _signOut() async {
    await _googleSignInReady;
    await FirebaseNotificationHelper.unregisterToken(_adminUid);
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snapshot.data;
        if (user == null) return const AdminLoginScreen();
        if (user.uid != _adminUid)
          return _UnauthorizedScreen(onSignOut: _signOut);
        return AdminDashboardScreen(onSignOut: _signOut, adminUid: user.uid);
      },
    );
  }
}

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _signIn() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await AdminAuthGate._googleSignInReady;
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null)
        throw FirebaseAuthException(code: 'missing-google-id-token');
      final credential = await FirebaseAuth.instance.signInWithCredential(
        GoogleAuthProvider.credential(idToken: idToken),
      );
      if (credential.user?.uid != _adminUid) {
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn.instance.signOut();
        throw FirebaseAuthException(code: 'unauthorized-account');
      }
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        setState(
          () => _error = error.code == 'unauthorized-account'
              ? 'This account is not authorized for the dashboard.'
              : 'Google sign-in failed. Check the Firebase Google provider setup.',
        );
      }
    } on GoogleSignInException catch (error) {
      if (mounted) {
        setState(
          () => _error = error.code == GoogleSignInExceptionCode.canceled
              ? 'Sign in was canceled.'
              : 'Google sign-in is not configured yet.',
        );
      }
    } catch (_) {
      if (mounted)
        setState(
          () => _error =
              'Could not sign in. Check your connection and try again.',
        );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.admin_panel_settings_outlined, size: 44),
                    const SizedBox(height: 12),
                    Text(
                      'Portfolio Admin',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _loading ? null : _signIn,
                      child: _loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Continue with Google'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UnauthorizedScreen extends StatelessWidget {
  const _UnauthorizedScreen({required this.onSignOut});

  final Future<void> Function() onSignOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 48),
              const SizedBox(height: 12),
              Text(
                'This account is not authorized.',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onSignOut,
                icon: const Icon(Icons.logout),
                label: const Text('Sign out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
