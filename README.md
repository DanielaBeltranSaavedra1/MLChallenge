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
---
