# MercadoLibre Mobile Candidate 📱

## 📌 Descripción del Proyecto

Proyecto técnico para **Mercado Libre Mobile Candidate Challenge** que permite:

- Buscar productos usando la API pública de Mercado Libre.
- Mostrar un listado de resultados.
- Ver el detalle completo de un producto seleccionado.

El objetivo es demostrar dominio en desarrollo nativo, arquitectura limpia, modularización por feature, manejo de estados y experiencia de usuario fluida.

---

## 🧱 Arquitectura y Organización del Código

La aplicación sigue una **arquitectura limpia y modular por feature** (Screaming Architecture). Cada módulo representa un dominio o funcionalidad específica, agrupando **UI, Use Cases, Domain Models y Repositorios**.

Además, la app usa tus **Olaf Kits**:

- **OlafDesignKit** – Componentes UI *stateless* y reutilizables (botones, loaders, cards, etc.).
- **OlafStateFlowKit** – Manejo de estado y flujos unidireccionales con Combine/SwiftUI, asegurando consistencia y separación de responsabilidades.

---

### 📂 Estructura principal del proyecto
```
MLChallenge/
├── Libs/
│   ├── Commons/
│   │   ├── Screen/          # Componentes UI comunes reutilizables
│   │   └── Networking/      # Helpers y servicios de red
│   └── Modules/
│       └── Commerce/        # Feature principal de comercio
│           ├── Data/
│           │   └── Repository/
│           │       └── CommerceRepository.swift  # Repositorio de datos del módulo Commerce
│           ├── Domain/
│           │   ├── Interactor/
│           │   │   ├── ProductList/
│           │   │   │   ├── GetProductsUseCase.swift      # Definición del caso de uso para listar productos
│           │   │   │   └── GetProductsUseCaseImpl.swift  # Implementación del caso de uso de listado de productos
│           │   │   └── ProductDetail/
│           │   │       ├── GetProductDetailUseCase.swift      # Definición del caso de uso de detalle de producto
│           │   │       └── GetProductDetailUseCaseImpl.swift  # Implementación del caso de uso de detalle de producto
│           │   └── Model/
│           │       ├── Product.swift         # Modelo de producto
│           │       └── ProductDetail.swift   # Modelo de detalle de producto
│           └── Ui/
│               ├── Navigation/
│               │   └── CommerceRoutes.swift  # Rutas de navegación del módulo Commerce
│               └── Screen/
│                   └── ProductDetail/
│                       └── Components/
│                           ├── ProductDetailEmptyScreen.swift      # Pantalla para estado vacío
│                           ├── ProductDetailErrorScreen.swift      # Pantalla de error
│                           ├── ProductDetailInitScreen.swift       # Pantalla de carga/inicialización
│                           └── ProductDetailSuccessContent.swift   # Contenido de detalle de producto exitoso

```

### 🧠 Principios Arquitectónicos

- **Modularización por feature:**  
  Todo lo relacionado a un dominio (Commerce) se encuentra en un solo módulo con Data, Domain y UI. Esto facilita escalabilidad, testing y mantenimiento.

- **Clean Architecture / Screaming Architecture:**  
  Cada folder refleja la intención del feature y separa responsabilidades por capas **Domain (Use Cases + Models)**, **Data (Repositorios)** y **UI (Screens + Navigation + Components)**.

- **Stateless UI:**  
  Las pantallas y componentes no contienen lógica de negocio; todo el flujo de datos se maneja mediante **OlafStateFlowKit**.

- **Reutilización y consistencia:**  
  Componentes comunes (botones, loaders, listas) se centralizan en **OlafDesignKit** y `Commons/Screen`.

- **Use Cases como núcleo de la lógica de negocio:**  
  Encapsulan toda la lógica de interacción con el API, manteniendo la UI independiente de la infraestructura.

---

## 📌 Use Cases

| Use Case | Descripción |
|----------|-------------|
| `GetProductsUseCase`        | Recupera la lista de productos desde el API según query de búsqueda. Maneja estados y errores. |
| `GetProductDetailUseCase`   | Recupera la información completa de un producto seleccionado, transformando la data para la UI. |

Estos Use Cases consumen los repositorios (`CommerceRepository`) y devuelven estados hacia **OlafStateFlowKit**, garantizando que la UI permanezca **stateless** y reactiva.

---

## 📱 Pantallas Principales

### 🔍 Búsqueda de Productos

- Campo de búsqueda y listado de resultados.
- Estado: Loading, Success, Error.
- Mantiene estado al rotar la pantalla.
- Renderizado con componentes stateless de **OlafDesignKit**.

### 📦 Detalle de Producto

- Información completa: imágenes, título, precio, descripción y atributos.
- Múltiples componentes para manejar distintos estados:  
  - `ProductDetailEmptyScreen`  
  - `ProductDetailErrorScreen`  
  - `ProductDetailInitScreen`  
  - `ProductDetailSuccessContent`
- Estado consistente ante rotación.

---

## ⚠️ Manejo de Errores

### 👩‍💻 Para Desarrolladores

- Errores centralizados en el repositorio y los Use Cases.
- Logging con OlafStateFlowKit.
- Se usan `Result` y estados (`Loading`, `Success`, `Error`) para mantener consistencia.

### 🧑‍🤝‍🧑 Para Usuarios

- Mensajes claros para no resultados, error de conexión o timeout.
- Indicadores de carga y botones de retry.
- Feedback visual para mejorar UX.

---

## 🧪 Calidad del Proyecto

- Patrones: Clean Architecture + Screaming Architecture + Use Cases + State Flow.
- UI siguiendo Human Interface Guidelines.
- Testabilidad: ViewModels y Use Cases son fácilmente testeables.
- Código modular, legible y documentado.

---

## 🚀 Tecnologías

- Swift 5 + SwiftUI  
- Combine / OlafStateFlowKit  
- OlafDesignKit (componentes UI stateless)  
- APIs de Mercado Libre (public, sin token)  
- Xcode 15+  

---

## 📊 Diagrama de Arquitectura
```
+----------------------+
| UI |
| - Screens & Components
| - Stateless (OlafDesignKit)
+----------------------+
|
v
+----------------------+
| ViewModels |
| - Consume UseCases
| - Maneja estado via OlafStateFlowKit
+----------------------+
|
v
+----------------------+
| Use Cases |
| - GetProductsUseCase
| - GetProductDetailUseCase
+----------------------+
|
v
+----------------------+
| Repositories |
| - CommerceRepository
| - Network Layer
+----------------------+

```
# Uso de Inteligencia Artificial en MLChallenge

## 📋 Resumen Ejecutivo

Este documento detalla el uso de herramientas de Inteligencia Artificial durante el desarrollo del proyecto MLChallenge, un proyecto de arquitectura móvil iOS nativo desarrollado con SwiftUI y Combine, aplicando conceptos de arquitectura stateless inspirados en patrones de Android (Jetpack Compose), Kotlin Multiplatform (KMP) y Flutter.

---

## 🤖 Modelos de IA Utilizados

### 1. **Claude 3.5 Sonnet** (Anthropic)
- **Versión**: claude-sonnet-3-5-20241022
- **Uso principal**: 
  - Diseño de arquitectura iOS nativa con SwiftUI/Combine
  - Aplicación de conceptos stateless de Compose y Flutter a SwiftUI
  - Implementación de patrones reactivos y unidireccionales
  - Arquitectura MVVM con separación clara de responsabilidades
  - Debugging y optimización de código Swift

### 2. **GitHub Copilot**
- **Uso principal**:
  - Autocompletado de código Swift
  - Generación de ViewModels y componentes SwiftUI
  - Sugerencias de APIs del SDK de iOS

---

## 📝 Prompts Utilizados

### Prompt 1: Arquitectura iOS con Conceptos Stateless

```
Actúa como arquitecto senior de aplicaciones iOS con experiencia en SwiftUI y Combine,
pero con conocimiento profundo de conceptos stateless de Android Compose, KMP y Flutter.

Necesito diseñar la arquitectura para una aplicación iOS nativa que:
- Use SwiftUI + Combine como base tecnológica
- Aplique principios stateless: vistas como funciones puras del estado
- Implemente flujo unidireccional de datos (inspirado en Compose y Flutter)
- Tenga separación clara: UI stateless + ViewModels con lógica
- Maneje estado de forma reactiva e inmutable

Proporciona:
1. Estructura de proyecto iOS con separación de capas
2. Patrón MVVM con vistas stateless
3. Estrategia de manejo de estado inmutable
4. Navegación declarativa con SwiftUI
```

**Resultado**: Arquitectura iOS nativa que aplica mejores prácticas de desarrollo stateless multiplataforma.

---

### Prompt 2: Vistas SwiftUI Stateless (Inspirado en Compose)

```
Como experto en SwiftUI que entiende los conceptos stateless de Jetpack Compose,
ayúdame a implementar vistas completamente stateless:

1. Vistas como funciones puras que solo reciben:
   - Estado (structs inmutables)
   - Callbacks para eventos (sin lógica interna)

2. ViewModels que:
   - Manejan todo el estado con @Published
   - Exponen funciones para todas las acciones
   - Usan Combine para transformaciones reactivas

3. Patrón similar a @Composable de Compose:
   - View recibe state y callbacks
   - No usa @State interno (todo viene del ViewModel)
   - Máxima reutilización

Incluye ejemplo de:
- Vista completamente stateless
- ViewModel con lógica y estado
- Preview con diferentes estados
```

**Resultado**: Componentes SwiftUI stateless altamente testeables y reutilizables.

---

### Prompt 3: Estado Inmutable e Unidireccional (Concepto Flutter/Compose en Swift)

```
Como experto en arquitecturas reactivas, ayúdame a implementar flujo de datos 
unidireccional en iOS (inspirado en Flutter/Compose/Redux):

1. Definición de estado inmutable:
   - Structs para cada estado de pantalla
   - Enums para estados de carga/éxito/error
   - Ninguna mutación directa, solo creación de nuevos estados

2. ViewModel que:
   - Emite un único @Published state
   - Recibe actions/intents
   - Transforma estado de forma funcional con Combine

3. Vista que:
   - Observa el state único
   - Renderiza según estado actual
   - Dispara actions al ViewModel

Patrón similar a:
```kotlin
// Inspiración Compose/KMP
data class UiState(val isLoading: Boolean, val data: List<Item>)
```

Pero implementado en Swift con SwiftUI.
```

**Resultado**: Arquitectura unidireccional en iOS inspirada en patrones multiplataforma.

---

### Prompt 4: Combine con Patrones Reactivos de Otras Plataformas

```
Como experto en programación reactiva multiplataforma, ayúdame a implementar 
en iOS con Combine, aplicando conceptos de Kotlin Flow y RxJS:

SwiftUI + Combine implementando:
- Operadores similares a Flow: map, filter, flatMap, debounce
- Manejo de backpressure
- Hot vs Cold publishers (similar a StateFlow vs Flow)
- Cancelación automática de suscripciones

Casos de uso:
1. Loading/Success/Error states (enum Result<T, E>)
2. Paginación con scroll infinito
3. Búsqueda en tiempo real con debounce
4. Actualización en tiempo real con @Published

Código Swift aplicando mejores prácticas de otras plataformas pero 
manteniendo idiomático para iOS.
```

**Resultado**: Sistema reactivo en iOS inspirado en mejores prácticas multiplataforma.

---

### Prompt 5: Networking y Data Layer en iOS

```
Actúa como arquitecto de software iOS. Diseña la capa de datos aplicando 
conceptos de Repository Pattern de Android/KMP:

1. Capa de datos iOS con:
   - URLSession/Alamofire para networking
   - Codable para serialización
   - DTOs y mappers a modelos de dominio
   - Repository protocol + implementaciones

2. Persistencia local:
   - Core Data / SwiftData para base de datos
   - UserDefaults para preferencias
   - Estrategia de caché (Memory + Disk)
   - Offline-first approach

3. Reactive data layer:
   - Repositories que retornan Publishers
   - Manejo de errores tipado
   - Retry logic con Combine
   - Estados de sincronización

Inspirado en arquitectura limpia de KMP pero implementado nativamente en Swift.
```

**Resultado**: Capa de datos iOS robusta aplicando patrones de arquitectura multiplataforma.

---

### Prompt 6: Testing en iOS

```
Como experto en testing móvil, ayúdame a implementar estrategia de testing para iOS:

1. Unit Tests:
   - XCTest para ViewModels
   - Tests de Publishers de Combine
   - Mocks de repositorios
   - Tests de transformaciones de estado

2. UI Tests:
   - XCUITest para flujos críticos
   - SwiftUI Preview tests
   - Snapshot testing

3. Estrategia inspirada en otras plataformas:
   - Test fixtures (builders de objetos)
   - Given-When-Then pattern
   - Arrange-Act-Assert
   - Cobertura mínima 80%

Incluye:
- Mocks y stubs reutilizables
- Tests de flujos reactivos
- Verificación de estados inmutables
```

**Resultado**: Suite completa de tests para iOS con cobertura amplia.

---

## 🔧 Agentes de IA Implementados

### Agente 1: **SwiftUI Stateless Component Generator**

**Descripción**: Agente especializado en generación de componentes SwiftUI stateless aplicando conceptos de Compose

**Tecnología**: Claude API + Templates SwiftUI

**Funcionalidades**:
- Generación de vistas completamente stateless (sin @State interno)
- ViewModels con todo el estado centralizado
- Componentes altamente reutilizables
- Separación clara de UI y lógica

**Ejemplo de uso**:
```swift
// Entrada al agente:
"Crea una vista de lista stateless con búsqueda y navegación"

// Output generado:
struct ItemListView: View {
    let items: [Item]
    let searchText: String
    let onSearchChange: (String) -> Void
    let onItemTap: (Item) -> Void
    let onRefresh: () -> Void
    
    var body: some View {
        List(filteredItems) { item in
            ItemRow(item: item)
                .onTapGesture { onItemTap(item) }
        }
        .searchable(text: .constant(searchText))
        .onChange(of: searchText) { onSearchChange($0) }
        .refreshable { onRefresh() }
    }
    
    var filteredItems: [Item] {
        items.filter { item in
            searchText.isEmpty || item.name.contains(searchText)
        }
    }
}

// ViewModel correspondiente
class ItemListViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    func searchTextChanged(_ text: String) {
        searchText = text
        // lógica de búsqueda
    }
    
    func itemTapped(_ item: Item) {
        // navegación
    }
    
    func refresh() {
        // lógica de refresh
    }
}
```

---

### Agente 2: **iOS Architecture Pattern Agent**

**Descripción**: Generación de arquitectura MVVM con flujo unidireccional inspirado en MVI/Redux

**Tecnología**: Claude API + Patrones arquitectónicos

**Funcionalidades**:
- Creación de estados inmutables con structs
- ViewModels con un único @Published state
- Actions/Intents para eventos de usuario
- Reducers para transformación de estado

**Ejemplo de implementación**:
```swift
// Petición: "Implementa pantalla de perfil con arquitectura unidireccional"

// State
struct ProfileState {
    var profile: UserProfile?
    var isLoading: Bool = false
    var error: String?
    var hasUnsavedChanges: Bool = false
}

// Actions
enum ProfileAction {
    case load
    case updateName(String)
    case updateEmail(String)
    case save
    case cancel
}

// ViewModel
class ProfileViewModel: ObservableObject {
    @Published private(set) var state = ProfileState()
    private var cancellables = Set<AnyCancellable>()
    
    func send(_ action: ProfileAction) {
        switch action {
        case .load:
            loadProfile()
        case .updateName(let name):
            updateName(name)
        case .save:
            saveProfile()
        // ...
        }
    }
    
    private func loadProfile() {
        state.isLoading = true
        repository.getProfile()
            .sink { [weak self] completion in
                self?.state.isLoading = false
            } receiveValue: { [weak self] profile in
                self?.state.profile = profile
            }
            .store(in: &cancellables)
    }
}

// View stateless
struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    
    var body: some View {
        ProfileContent(
            state: viewModel.state,
            onAction: viewModel.send
        )
    }
}

struct ProfileContent: View {
    let state: ProfileState
    let onAction: (ProfileAction) -> Void
    
    var body: some View {
        if state.isLoading {
            ProgressView()
        } else {
            // UI content usando state
        }
    }
}
```

---

### Agente 3: **Combine Reactive Flow Agent**

**Descripción**: Implementación de flujos reactivos complejos con Combine aplicando conceptos de RxSwift y Kotlin Flow

**Tecnología**: Combine + Patrones reactivos

**Funcionalidades**:
- Operadores avanzados de Combine
- Manejo de múltiples streams
- Composición de Publishers
- Cancelación y memory management

**Ejemplos generados**:
```swift
// Búsqueda en tiempo real con debounce
class SearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var results: [Result] = []
    @Published var isSearching: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isSearching = true
            })
            .flatMap { query in
                self.repository.search(query)
                    .catch { _ in Just([]) }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] results in
                self?.results = results
                self?.isSearching = false
            }
            .store(in: &cancellables)
    }
}

// Paginación con scroll infinito
class ListViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var isLoadingMore: Bool = false
    
    private let loadMoreSubject = PassthroughSubject<Void, Never>()
    private var currentPage = 1
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadMoreSubject
            .filter { [weak self] in 
                !(self?.isLoadingMore ?? true) 
            }
            .flatMap { [weak self] _ -> AnyPublisher<[Item], Never> in
                guard let self = self else { 
                    return Just([]).eraseToAnyPublisher() 
                }
                self.isLoadingMore = true
                return self.repository.getItems(page: self.currentPage)
                    .catch { _ in Just([]) }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newItems in
                self?.items.append(contentsOf: newItems)
                self?.currentPage += 1
                self?.isLoadingMore = false
            }
            .store(in: &cancellables)
    }
    
    func loadMore() {
        loadMoreSubject.send(())
    }
}
```

---

## 🚀 Conclusiones

El uso estratégico de herramientas de IA en este proyecto iOS permitió:

1. **Aplicar conceptos multiplataforma** a iOS de forma nativa e idiomática
2. **Desarrollar arquitectura moderna** inspirada en mejores prácticas de Compose, Flutter y KMP
3. **Mantener código 100% Swift** pero con patrones probados de otras plataformas
4. **Crear componentes stateless** altamente testeables y reutilizables
5. **Acelerar el desarrollo** sin comprometer la calidad ni las convenciones de iOS

La combinación de IA como asistente, conocimiento de patrones multiplataforma, y experiencia iOS nativa resultó en una arquitectura robusta, mantenible y escalable.

---

## 📅 Última Actualización

Fecha: Febrero 2026

---
