import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/products/products.dart';
import '../../features/auth/providers/auth_provider.dart';
import 'app_router_notifier.dart';

final goRouterProvider = Provider((ref) {

  final goRouterNotifier = ref.read(goRouterNotifierProvider); // Escucha los cambios del status

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier , // RefreshListenable espera algo de tipo changeNotifier -> GoRouterNotifier
    routes: [

      ///* Primera pantalla
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),  
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),

    ],
  
    redirect: ( context, state ){ // El método redirect se utiliza para definir la lógica de redirección. 

      final isGoingTo = state.subloc;
      final authStatus = goRouterNotifier.authStatus;

      if( isGoingTo == '/splash' && authStatus == AuthStatus.checking ) return null; // Si voy a la página de laoding y status=checking no hay redirección.

      if( authStatus == AuthStatus.notAuthenticated) {                        // Si no estoy autenticado
        if( isGoingTo == '/login' || isGoingTo == 'register' ) return null;   // y quiero ir a login o register no hay redirección
        return '/login';                                                       // Pero si quiero ir a otras rutas si hay redirección a login
      }
    
      if( authStatus == AuthStatus.authenticated){                                            // Si estoy autenticado
        if( isGoingTo == '/login' || isGoingTo == '/register' || isGoingTo == '/splash'  ) {  // y quiero ir a login o registe -> redireccion a "/"
        return '/';   
        
        }
      }

      return null;
    }

  );
});



