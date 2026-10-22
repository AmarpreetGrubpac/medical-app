import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grubpac_driver/data/auth/session_manager.dart';

/// Renders [child] if the current session persona matches [allowedPersonas].
/// Otherwise renders [fallback] (defaults to [SizedBox.shrink]).
class RoleGated extends StatelessWidget {
  final List<PersonaType> allowedPersonas;
  final Widget child;
  final Widget fallback;

  const RoleGated({
    super.key,
    required this.allowedPersonas,
    required this.child,
    this.fallback = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SessionManager>()) {
      return fallback;
    }
    final session = Get.find<SessionManager>();
    if (allowedPersonas.contains(session.personaType)) {
      return child;
    }
    return fallback;
  }
}

/// Convenience widget that only displays [child] for Owner accounts.
class OwnerOnly extends StatelessWidget {
  final Widget child;
  final Widget fallback;

  const OwnerOnly({
    super.key,
    required this.child,
    this.fallback = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    return RoleGated(
      allowedPersonas: const [PersonaType.owner],
      fallback: fallback,
      child: child,
    );
  }
}

/// Convenience widget that only displays [child] for Handler (driver) accounts.
class HandlerOnly extends StatelessWidget {
  final Widget child;
  final Widget fallback;

  const HandlerOnly({
    super.key,
    required this.child,
    this.fallback = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    return RoleGated(
      allowedPersonas: const [PersonaType.handler],
      fallback: fallback,
      child: child,
    );
  }
}
