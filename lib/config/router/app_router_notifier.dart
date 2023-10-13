


import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/providers/auth_provider.dart';


final goRouterNotifierProvider = Provider((ref) {         // Proveedor basado en una instancia de GoRouterNotifier 
  final authNotifier = ref.read( authProvider.notifier ); // basada a su vez en el AuthNotifier del AuthProvider
  return GoRouterNotifier(authNotifier);                  // Se podrá manejar la navegación basada en el status de la autenticación.
});



class GoRouterNotifier extends ChangeNotifier { // Significa que puede notificar a los oyentes (listeners) cuando se producen cambios en el estado.

  final AuthNotifier _authNotifier;             // Gestiona la autenticación de la app
  AuthStatus _authStatus = AuthStatus.checking; // Prop del state de AuthProvider
  
  GoRouterNotifier(this._authNotifier){
    _authNotifier.addListener((state) {         // Se escuchan los cambios en el estado de autenticación proporcionados por AuthNotifier
      authStatus = state.authStatus;            // prop del status actualizado con el nuevo estatus recibido
    });
  }
  
  AuthStatus get authStatus => _authStatus;     // Getters

  set authStatus( AuthStatus value ){           // Setters
    _authStatus = value;
    notifyListeners();
  }
}