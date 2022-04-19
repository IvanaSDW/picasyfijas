import '../shared/constants.dart';

const Map<String, String> esES = {
  'instructions' : 'Instrucciones',
  'instructions_detail_1': 'Tu objetivo es descifrar un número secreto compuesto por 4 dígitos diferentes.',
  'instructions_detail_2': 'Para descubrirlo, deberás intentar con números de 4 dígitos hasta dar con el número secreto.',
  'instructions_detail_3': 'En cada intento, el sistema buscará los dígitos que estén en el número secreto y devolverá un resultado...',
  'instructions_detail_4': 'Los dígitos de tu intento que estén en el número secreto, y que además coincidan en la misma posición, son \'Fijas\'...',
  'instructions_detail_5': 'los que aparezcan pero en una posición distinta, son \'Picas\'.',
  'instructions_detail_6': 'Revisa el ejemplo y luego presiona "Continuar"',
  'example': 'Ejemplo:',
  'lets say..': 'Digamos que el número secreto es',
  'and your guess..': '...si tu intento es',
  'the result..': '...el resultado sería',
  'and you..': '...y lo verás asi:',
  'one bull': 'Una fija ( 2 )',
  'two cows': 'Dos picas ( 5,4 )',
  '1B2C': '"5 2 9 4 -- 1f : 2p"',
  'player_status': 'Registro:',
  'requires_google': 'Solo usuario Google',
  'play_as_guest' : 'Invitado',
  'basic_features' : '(Modo "Solo" únicamente )',
  'solo_mode' : 'Modo Solo',
  'vs_mode' : 'Modo Multijugador',
  'time_average' : '  Tiempo promedio',
  'guesses_average' : '  Intentos promedio',
  'world_ranking' : '  Ranking mundial',
  'win_rate' : '  Victorias %',
  'network' : 'Red:',
  'connected' : 'Conectado',
  'not_connected' : 'Sin internet',
  'players_online' : 'Jugadores:',
  'skip' : '-Saltar-',
  'cancel' : 'Cancelar',
  'waiting_opponent_to_move' : 'Esperando intento de tu oponente...',
  'be_ready_for_your_first_guess' : 'Prepara tu primer intento...',
  'time_is_running_input_your_guess' : 'El tiempo corre!! digita tu número',
  'think_your_next_guess' : 'Ve pensando tu próximo intento',
  'you_can_do_it_try_your_guess' : 'Tu puedes! pon tu nuevo intento',
  'be_ready_for_your_second_guess' : 'Prepara tu segundo intento',
  'think_of_a_smart_guess_for_your next_move' : 'Intenta un número que te arroje pistas concretas',
  'b' : 'f',
  'c' : 'p',
  'tap_here_to_start': 'Toca aquí para empezar',
  'waiting_opponent_to_be_ready' : 'Esperando que tu oponente este listo...',
  'good_continue_until_you_find_it' : 'Bien, continua hasta encontrarlo!',
  'mission_successfully_completed' : 'Misión terminada con éxito!',
  'game_canceled' : 'Juego cancelado',
  'game_was_canceled' : 'El juego fue cancelado',
  'cross_your_fingers' : 'Cruza los dedos! tu oponente todavía tiene una oportunidad...',
  'you_better_find_it_now' : 'Mas vale que lo aciertes en este...',
  'your_opponent_is_still_active' : 'Tu oponente aun esta activo...',
  'You_will_loose_this_game_if_quit_now' : 'Perderás el juego si abandonas ahora',
  'press_quit_to_leave_game' : 'Toca \'Salir\' para abandonar el juego.',
  'press_exit_to_leave_app' : 'Toca \'Salir\' para confirmar.',
  'press_confirm_to_logout' : 'Toca \'Confirmar\' para salir de la cuenta.',
  'quit' : 'Salir',
  'exit' : 'Salir',
  'time_left' : 'Tiempo restante: ',
  'guesses' : 'Intentos: ',
  'looking_for_opponent' : 'Buscando jugador...',
  '_players' : ' jugadores',
  '_games' : ' partidas',
  'enter_your_secret_number:' : 'Digita tu número secreto:',
  'auto_generate_number' : 'Generarlo automáticamente ->',
  'locale' : 'Regional:',
  'email_' : 'Email ',
  'country_' : 'Pais ',
  'member_since_': 'Miembro desde ',
  'total_games_' : 'Total juegos ',
  'won:_' : 'Ganados: ',
  'lost:_' : 'Perdidos: ',
  'draw:_' : 'Empates: ',
  '__percentile:_' : '  Percentil: ',
  'rating:_' : 'Rating: ',
  'profile' : 'Perfil',
  'refresh_stats' : 'Refrescar estadísticas',
  'logout' : 'Salir de la cuenta',
  'confirm' : 'Confirmar',
  'you_won' : 'GANASTE!!',
  '-you_lost-' : '-PERDISTE-',
  'congratulations' : 'Felicitaciones!',
  'maybe_next_time' : 'Tal vez la próxima.',
  'you_won_by_time' : 'GANASTE POR TIEMPO!!',
  'you_lost_by_time' : 'PERDISTE POR TIEMPO!!',
  'that_was_close' : 'Wow, eso estuvo cerca!',
  'but_well_played' : 'Pero jugaste muy bien!',
  'your_opponent_left' : 'TU OPONENTE ABANDONÓ!!',
  'you_left' : 'ABANDONASTE!!',
  'you_won_lower' : 'Ganaste!',
  'you_lost_lower' : 'Perdiste!',
  'your_time_is_up' : 'TU TIEMPO SE ACABÓ!!',
  'your_opponent_time_is_up' : 'Tu oponente se quedó sin tiempo!',
  'sorry_you_lost' : 'Lo siento, perdiste.',
  'amazing' : 'Asombroso!!',
  'its_a_draw' : 'es un empate',
  'country' : 'Pais',
  'language' : 'Idioma',
  'solo_games_left_unlock' : 'Partidas "Solo" faltantes:',
  'time_average_below_max' : 'Tiempo promedio menor a ${maxTimeAverageToUnlockVsMode~/60000} min',
  'versus_mode_locked' : '** Modo Versus bloquedado **',
  'to_unlock_need' : 'Para desbloquear necesitas:',
  'at_least_min_games' : 'Mínimo $minSoloGamesToUnlockVsMode juegos en modo "Solo".',
  'locked' : '** Bloqueado **',
  'unlocked' : 'DESBLOQUEADO',
  'enjoy_playing_vs_mode_line1' : 'Disfruta jugando con tus amigos',
  'enjoy_playing_vs_mode_line2' : 'o gente al rededor del mundo',
  'requires_google_sign_in' : 'Ingresa con Google',
  'sign_in_with_google_for_multiplayer_mode.' : 'Regístrate con tu cuenta de Google para habilitar multijugador.',
  'sign_in' : 'Registrarme',
  'guest' : 'Invitado',
  'well_done' : 'Bien hecho!!',
  'mission_completed_in': 'Misión completada en:',
  'time' : 'Tiempo:',
  'share' : 'Compartir',
  'rate' : 'Calificar',
  'share_message' : 'Me gustaría jugar esto contigo. Instala este juego ',
  'share_subject' : 'Te recomiendo este juego.',
  'refresh_leaderboard' : 'Actualizar',
  'leaderboard' : 'Clasificación',
  'leaderboard_title' : 'Tabla de Posiciones',
  'play_solo' : 'Jugar Solo',
  'play_versus' : 'Jugar Versus',
  'save' : 'Guardar',
  'edit_profile' : 'Editar Perfil',
  'at_least_3_chars' : 'Ingresa al menos 3 caracteres',
  'gallery' : 'Galería',
  'camera' : 'Cámara',
  'volume' : 'Volumen',
};