# Retos y Desafíos en Dice Catcher 🧠

## 1. Conexión de Señales Dinámicas 📡
**El Desafío:**
Aprender a usar señales fue uno de los retos que más me costó entender al principio. Conectar señales de forma estática en el editor es bastante directo, pero cuando las escenas se crean dinámicamente en tiempo de ejecución (como los dados que van cayendo de manera aleatoria), la conexión no es tan intuitiva. El problema era entender cómo hacer que todas las escenas dinámicas de dados pudieran conectarse y notificar a la escena principal (`Game`) sin crear un acoplamiento directo entre ellas.

**La Solución:**
Comprendí que al instanciar un nodo mediante código, antes de añadirlo al árbol con `add_child()`, es el momento  para conectarse a sus señales mediante programación que a veces resulta lo mejor y lo unico posible comparado con conección de señales de manera gráfica:
```gdscript
func spawn_dice() -> void:
	var new_dice: Dice = DICE.instantiate()
	# Conexión dinámica antes de añadir al árbol de escenas
	new_dice.game_over.connect(_on_game_over)
	# ...
	pausable.add_child(new_dice)
```
Esto me ayudó a entender el patrón de comunicación en Godot: las señales viajan hacia arriba en la jerarquía (de hijos a padres) y las llamadas directas de métodos van hacia abajo (de padres a hijos). De esta forma, el `Dice` simplemente emite su señal `game_over` y es la escena de mayor jerarquía (`Game`) la que decide cómo manejar ese evento.

---

## 2. Estructuración del Árbol de Nodos y Sistema de Pausa ⏸️
**El Desafío:**
Al principio, detener el gameplay tras un Game Over y permitir un reinicio fluido fue confuso. Si pausaba todo el árbol de escenas directamente con `get_tree().paused = true`, todas las funciones de físicas y procesos de todos los nodos se congelaban de manera global, lo que impedía que el script principal detectara la tecla para reiniciar el nivel (`restart`). 

**La Solución:**
Entendí que para resolver esto debíamos estructurar el árbol de nodos de tal manera que pudiéramos separar lo que queríamos pausar de lo que no. Esto se ha resuleto usando la propiedad **Process Mode** en Godot 4:
1. Comprendi una separación de responsabilidades en el árbol de escenas:
   - Configuré el nodo raíz `Game` en modo **Always** (para que procese la entrada incluso en pausa).
   - Agrupé todos los elementos dinámicos e interactivos del juego (jugador, temporizadores, enemigos) bajo un único nodo agrupador llamado `Pausable` en modo **Pausable**.
2. De este modo, al perder se activa `get_tree().paused = true`, lo cual congela automáticamente a todos los elementos del juego dentro de `Pausable` (deteniendo la caída de los dados y el movimiento de Fox), pero permite que el script principal en `Game` siga detectando la pulsación de teclas.
3. Para reiniciar, el script ejecuta `get_tree().reload_current_scene()`. Aquí fue clave aprender que debíamos restablecer `get_tree().paused = false` en la función `_ready()` del script `Game.gd` al recargar, de lo contrario la pausa global persistiría y el juego se iniciaría congelado.
