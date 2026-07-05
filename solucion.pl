/* distintos paises */
paisContinente(argentina, americaDelSur).
paisContinente(bolivia, americaDelSur).
paisContinente(brasil, americaDelSur).
paisContinente(chile, americaDelSur).
paisContinente(ecuador, americaDelSur).
paisContinente(alemania, europa).
paisContinente(espania, europa).
paisContinente(francia, europa).
paisContinente(inglaterra, europa).
paisContinente(aral, asia).
paisContinente(china, asia).
paisContinente(gobi, asia).
paisContinente(india, asia).
paisContinente(iran, asia).

/*países importantes*/
paisImportante(argentina).
paisImportante(kamchatka).
paisImportante(alemania).

/*países limítrofes*/
limitrofes([argentina,brasil]).
limitrofes([bolivia,brasil]).
limitrofes([bolivia,argentina]).
limitrofes([argentina,chile]).
limitrofes([espania,francia]).
limitrofes([alemania,francia]).
limitrofes([nepal,india]).
limitrofes([china,india]).
limitrofes([nepal,china]).
limitrofes([afganistan,china]).
limitrofes([iran,afganistan]).

/*distribución en el tablero */
ocupa(argentina, azul, 4).
ocupa(bolivia, rojo, 1).
ocupa(brasil, verde, 4).
ocupa(chile, negro, 3).
ocupa(ecuador, rojo, 2).
ocupa(alemania, azul, 3).
ocupa(espania, azul, 1).
ocupa(francia, azul, 1).
ocupa(inglaterra, azul, 2). 
ocupa(aral, negro, 2).
ocupa(china, verde, 1).
ocupa(gobi, verde, 2).
ocupa(india, rojo, 3).
ocupa(iran, verde, 1).

/*continentes*/
continente(americaDelSur).
continente(europa).
continente(asia).

/*objetivos*/
objetivo(rojo, ocuparContinente(asia)).
objetivo(azul, ocuparPaises([argentina, bolivia, francia, inglaterra, china])).
objetivo(verde, destruirJugador(rojo)).
objetivo(negro, ocuparContinente(europa)).


% 1 
estaEnContinente(Jugador, Continente):-
	ocupa(Pais, Jugador),
	paisContinente(Pais, Continente).

ocupa(Pais, Jugador):-
	ocupa(Pais, Jugador, _ ).

% 2
cantidadPaises(Jugador, Cantidad):-
	jugador(Jugador),
	findall(Pais, ocupa(Pais, Jugador), Paises),
	length(Paises, Cantidad).

jugador(Jugador):-
	objetivo(Jugador, _ ).

% 3
ocupaContinente(Jugador, Continente):-
	jugador(Jugador),
	continente(Continente),
	forall(
		paisContinente(Pais, Continente),
		ocupa(Jugador, Pais)
	).

% 4
leFaltaMucho(Jugador, Continente):-
	leFaltaMasDe(2, Jugador, Continente).

leFaltaMasDe(Limite, Jugador, Continente):-
	jugador(Jugador),
	continente(Continente),
	findall(Pais, leFaltaPais(Jugador, Continente, Pais), PaisesNoOcupados),
	length(PaisesNoOcupados, Cantidad),
	Cantidad > Limite.

leFaltaPais(Jugador, Continente, Pais):-
	paisContinente(Pais, Continente),
	not(ocupa(Pais, Jugador)).

% 5
sonLimitrofes(Pais1, Pais2):-
	limitrofes(Paises),
	member(Pais1, Paises),
	member(Pais2, Paises),
	Pais1 \= Pais2.

% 6 
% ocupa todos los países importantes
esGroso(Jugador):-
	jugador(Jugador),
	forall(
		paisImportante(Pais),
		ocupa(Pais, Jugador)
	).
% ocupa más de 10 países 
esGroso(Jugador):-
	cantidadPaises(Jugador, Cantidad),
	Cantidad > 10.
% tiene más de 50 ejércitos
esGroso(Jugador):-
	jugador(Jugador),
	findall(Cantidad, ocupa( _ , Jugador, Cantidad), Cantidades),
	sum_list(Cantidades, Total),
	Total > 50.
	
% 7
estaEnElHorno(Pais):-
	ocupa(Pais, Jugador),
	jugador(OtroJugador),
	Jugador \= OtroJugador,
	forall(
		sonLimitrofes(Pais, PaisLimitrofe),
		ocupa(PaisLimitrofe, OtroJugador)
	).

% 8
esCaotico(Continente):-
	continente(Continente),
	findall(Jugador, estaEnContinente(Jugador, Continente), Jugadores),
	list_to_set(Jugadores, JugadoresSinRepetir),
	length(JugadoresSinRepetir, Cantidad),
	Cantidad > 3.

% 9
capoCannoniere(Jugador):-
	cantidadPaises(Jugador, Cantidad),
	forall(
		(cantidadPaises(OtroJugador , OtraCantidad), OtroJugador \= Jugador),
		Cantidad > OtraCantidad
	).

% 10
ganadooor(Jugador):-
	objetivo(Jugador, Objetivo),
	cumplioObjetivo(Jugador, Objetivo).

cumplioObjetivo(Jugador, ocuparContinente(Continente)):-
	ocupaContinente(Jugador, Continente).
cumplioObjetivo(Jugador, ocuparPaises(Paises)):-
	forall(
		member(Pais, Paises),
		ocupa(Pais, Jugador)
	).
cumplioObjetivo(Jugador, destruirJugador(Victima)):-
	not(ocupa( _ , Victima)).
