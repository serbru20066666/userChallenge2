# UsuariosTest

README.md  
Created by: Bruno Cardenas.

Aplicacion iOS hecha con SwiftUI para gestionar usuarios. Permite listar usuarios desde JSONPlaceholder, ver detalle, editar nombre y email, crear usuarios de forma local, eliminar usuarios con borrado logico y guardar datos en Realm para que la app pueda seguir mostrando informacion aunque falle la red.

El proyecto esta armado con MVVM + Coordinator usando `NavigationStack`. Tambien tiene una separacion ligera tipo Clean Architecture:

- `Domain`: modelos, protocolos y casos de uso.
- `Data`: API, Realm, repositorio, red y ubicacion.
- `Presentation`: vistas, view models y coordinator.

Las capas se conectan por protocolos para mantener bajo acoplamiento. El repositorio decide si usa API, cache local o ambas. Las llamadas usan `async/await`; para red se usa Alamofire con sus APIs async y para persistencia se usa RealmSwift. La pantalla de carga usa un skeleton simple con shimmer.

Dependencias agregadas por Swift Package Manager:

- RealmSwift
- Alamofire
- SwiftUI-Shimmer

Para probar:

1. Abrir `UsuariosTest.xcodeproj` en Xcode.
2. Esperar a que SPM resuelva las dependencias.
3. Ejecutar en un simulador iOS 15 o superior.

Al crear usuario hay un boton para pedir la ubicacion actual. iOS mostrara el permiso de ubicacion y luego la app enseña un popup con latitud y longitud.
