# SauceDemo Smoke Test Automation

Proyecto de automatización de pruebas funcionales para **SauceDemo**, desarrollado con **Ruby, Cucumber, Capybara y Selenium WebDriver**.

El objetivo principal del proyecto es validar, mediante **Smoke Tests**, que los flujos críticos de la aplicación funcionen correctamente después de cambios, configuraciones o nuevas ejecuciones del sistema.

---

## 1. Descripción del proyecto

Este proyecto automatiza pruebas sobre la aplicación SauceDemo, una tienda web de demostración que permite iniciar sesión, visualizar productos, agregarlos al carrito y completar un proceso de compra.

Las pruebas están escritas en lenguaje **Gherkin**, lo que permite que los escenarios sean entendibles tanto para perfiles técnicos como para otros usuarios.

El proyecto cubre los siguientes módulos:

* Login.
* Catálogo de productos.
* Carrito de compras.
* Checkout.
* Validación de montos de compra.
* Validaciones de campos obligatorios.
* Cancelación del proceso de compra.
* Ordenamiento de productos.

---

## 2. Tipo de pruebas

Este proyecto se organiza principalmente como una suite de **Smoke Test**.

Un **Smoke Test** permite verificar rápidamente que las funcionalidades más importantes de una aplicación estén operativas. No busca cubrir todos los casos posibles, sino confirmar que el sistema permite realizar sus flujos esenciales.

Para este proyecto, el flujo crítico principal es:

```text
Login → Catálogo → Agregar producto → Carrito → Checkout → Confirmación de compra
```

Si alguno de estos pasos falla, el usuario no podría completar una compra correctamente.

---

## 3. Criterios para seleccionar los casos automatizados

Los casos automatizados fueron seleccionados tomando en cuenta los siguientes criterios:

### Criticidad

Se priorizan funcionalidades que son esenciales para el negocio o para el flujo principal del usuario.

Ejemplos:

* Iniciar sesión.
* Agregar productos al carrito.
* Completar checkout.
* Confirmar la compra.
* Validar el total a pagar.

### Repetitividad

Se automatizan casos que se ejecutarían frecuentemente en cada validación del sistema.

Ejemplos:

* Login exitoso.
* Agregar producto al carrito.
* Completar compra con un producto.

### Riesgo funcional

Se consideran flujos donde un error podría afectar directamente la experiencia del usuario o el resultado de la compra.

Ejemplos:

* Error en el monto total.
* Error en el impuesto.
* Error en la confirmación de orden.
* Avance incorrecto del checkout con campos obligatorios vacíos.

### Tiempo de ejecución manual

Se automatizan flujos que tomarían más tiempo si se validaran manualmente en cada entrega.

Ejemplos:

* Completar checkout.
* Validar productos en el resumen.
* Validar subtotal, impuesto y total final.

---

## 4. Alcance del Smoke Test

Los escenarios considerados más importantes para Smoke Test son:

* Login exitoso con usuario válido.
* Visualización del catálogo de productos.
* Agregar un producto al carrito.
* Verificar que el producto agregado aparezca en el carrito.
* Iniciar checkout.
* Completar checkout con un producto.
* Validar confirmación de compra.
* Validar monto final de compra para un producto.

Estos escenarios permiten confirmar que la aplicación está operativa en sus funcionalidades principales.

---

## 5. Escenarios considerados como Regression Test

Algunos escenarios también están automatizados, pero no necesariamente forman parte del Smoke Test principal. Estos casos son más adecuados para una suite de **regression testing**, porque validan comportamientos adicionales o más específicos.

Ejemplos:

* Ordenar productos por nombre.
* Ordenar productos por precio.
* Completar checkout con múltiples productos.
* Validar campos obligatorios vacíos.
* Cancelar checkout desde la página de información.
* Cancelar checkout desde la página de resumen.
* Agregar y remover múltiples productos del carrito.

Estos escenarios son importantes, pero no todos son indispensables para confirmar que la aplicación funciona de manera básica después de un cambio.

---

## 6. Tecnologías utilizadas

* Ruby
* Cucumber
* Capybara
* Selenium WebDriver
* RSpec Expectations
* Google Chrome

---

## 7. Estructura del proyecto

```text
sauce-automatizacion/
│
├── features/
│   ├── login.feature
│   ├── cart.feature
│   ├── catalog.feature
│   ├── checkout.feature
|   ├── product_detail.feature
│   │
│   ├── step_definitions/
│   │   ├── loginSteps.rb
│   │   ├── cartSteps.rb
│   │   ├── catalogSteps.rb
│   │   ├── checkoutSteps.rb
|   |   └── product_detailSteps.rb
│   │
│   └── support/
│       ├── env.rb
|       └── hooks.rb
│
└── README.md
```

---

## 8. Módulos automatizados

### Login

El módulo de login valida el acceso de usuarios a SauceDemo.

Casos cubiertos:

* Login exitoso con usuarios válidos.
* Login fallido con usuario bloqueado.
* Login fallido con contraseña incorrecta.
* Login fallido sin username.
* Login fallido sin password.

Este módulo es crítico porque el usuario debe autenticarse antes de acceder al catálogo y realizar una compra.

---

### Carrito de compras

El módulo de carrito valida que los productos puedan agregarse, visualizarse y removerse correctamente.

Casos cubiertos:

* Agregar un producto al carrito.
* Agregar dos productos diferentes.
* Verificar que un producto agregado aparece en la página del carrito.
* Verificar múltiples productos en el carrito.
* Remover un producto.
* Verificar el cambio del botón de `Add to cart` a `Remove`.

Este módulo es parte del flujo crítico porque el usuario debe poder seleccionar productos antes de iniciar el checkout.

---

### Checkout

El módulo de checkout valida el proceso de compra.

Casos cubiertos:

* Iniciar checkout con un producto.
* Completar checkout con un producto.
* Completar checkout con múltiples productos.
* Validar productos en el resumen de compra.
* Validar subtotal, impuesto y total final.
* Validar errores por campos obligatorios vacíos.
* Cancelar checkout desde la página de información.
* Cancelar checkout desde la página de resumen.
* Confirmar que la compra finaliza correctamente.

Este módulo es el más importante dentro del Smoke Test porque representa el cierre del flujo principal de compra.

---

### Catálogo de productos

El módulo de catálogo valida el ordenamiento de productos.

Casos cubiertos:

* Ordenar productos por nombre de A a Z.
* Ordenar productos por nombre de Z a A.
* Ordenar productos por precio de menor a mayor.
* Ordenar productos por precio de mayor a menor.

Este módulo es útil para pruebas de regresión, pero no se prioriza como parte principal del Smoke Test porque un error en el ordenamiento no impide necesariamente completar una compra.

---

## 9. Datos de prueba utilizados

Usuario principal:

```text
standard_user
```

Contraseña:

```text
secret_sauce
```

Productos usados en las pruebas:

```text
Sauce Labs Backpack
Sauce Labs Bike Light
Sauce Labs Bolt T-Shirt
Sauce Labs Fleece Jacket
Sauce Labs Onesie
Test.allTheThings() T-Shirt (Red)
```

Datos de checkout:

```text
First Name: Vanessa
Last Name: Canaviri
Postal Code: 0000
```

---

## 10. Ejecución del proyecto

Para ejecutar todas las pruebas:

```bash
cucumber
```

Para ejecutar una feature específica:

```bash
cucumber features/login.feature
```

```bash
cucumber features/cart.feature
```

```bash
cucumber features/checkout.feature
```

```bash
cucumber features/catalog.feature
```

```bash
cucumber features/product_detail.feature
```

---

## 11. Ejecución para Smoke Test

Para una validación rápida tipo Smoke Test:

```bash
cucumber --tags "@smoke"
```

---

## 12. Ejecución para Regression Test

Los escenarios más completos o complementarios pueden ejecutarse con:

```bash
cucumber --tags "@regression"
```

---

## 13. Validaciones implementadas

Las pruebas no se limitan únicamente a validar navegación o URLs. También validan elementos visibles y resultados funcionales.

Entre las validaciones realizadas se encuentran:

* Verificación de títulos de página.
* Verificación de formularios visibles.
* Verificación de mensajes de error.
* Verificación de productos en carrito.
* Verificación de productos en resumen de checkout.
* Verificación de botones disponibles.
* Verificación de confirmación de orden.
* Verificación de subtotal.
* Verificación de impuesto.
* Verificación del total final.
* Verificación de que el usuario no avance si faltan campos obligatorios.
* Verificación de ordenamiento completo de productos en catálogo.

---

## 14. Evidencias de ejecución

Cuando una prueba falla, el proyecto puede generar capturas de pantalla y archivos HTML para facilitar el análisis del error.

Ejemplo de archivos generados:

```text
screenshot_YYYY-MM-DD-HH-MM-SS.png
screenshot_YYYY-MM-DD-HH-MM-SS.html
```

Estas evidencias permiten revisar qué estaba mostrando el navegador en el momento de la falla.

---

## 15. Advertencias comunes

Durante la ejecución pueden aparecer mensajes internos del navegador como:

```text
DevTools listening on ws://...
DEPRECATED_ENDPOINT
PHONE_REGISTRATION_ERROR
TensorFlow Lite XNNPACK delegate
```

Estos mensajes normalmente provienen de Chrome y no necesariamente indican un error en las pruebas.

Si aparece una advertencia relacionada con ChromeDriver, se recomienda revisar que la versión de ChromeDriver sea compatible con la versión instalada de Google Chrome.
