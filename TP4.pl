:-dynamic(enfermedad_tratamiento/2).
:-dynamic(enfermedad_sintoma/2).

guardarBase:- tell('S:/Users/R7-Bassi/Documents/Prolog/Practica5/datos_tp4.txt'),
              listing(enfermedad_tratamiento),
              listing(enfermedad_sintoma),
              told.

inicio:- consult('S:/Users/R7-Bassi/Documents/Prolog/Practica5/datos_tp4.txt'),
         write('Elija una opción:
                1 - Mostrar todas las enfermedades cargadas.
                2 - Cargar una enfermedad.
                3 - Mostrar sintomas de una enfermedad.
                4 - Mostrar tratamientos de una enfermedad.
                5 - Dado una serie de sintomas, mostrar enfermedades posibles. '), nl,
          read(Op),nl,
          menu(Op).

menu(1):- listarEnfermedades.
menu(2):- cargarEnfermedad.
menu(3):- write('Ingrese nombre de enfermedad: '), read(Enf),
          enfermedad_sintoma(Enf,Lista),
          write(Lista).
menu(4):- write('Ingrese nombre de enfermedad: '), read(Enf),
          enfermedad_tratamiento(Enf,Trat),
          write(Trat).
menu(5):- write('Ingrese los sintomas. 0 para cortar.'),
          leerLista(Sintomas),
          enfermedadesPosibles(Sintomas).
menu(_):- write('Ingrese una opcion valida. ').

listarEnfermedades:- enfermedad_sintoma(Enf,_),
                     write(Enf), nl,
                     fail,
                     listarEnfermedades.
listarEnfermedades.
cargarEnfermedad:- nl, writeln('Ingrese nombre de enfermedad: '), read(Enf),
                   write('Ingrese los sintomas. 0 para cortar.'),
                   leerLista(ListaSintomas),
                   write('Ingrese los tratamientos. 0 para cortar'),
                   leerLista(ListaTratamientos),
                   assert(enfermedad_tratamiento(Enf,ListaTratamientos)),
                   assert(enfermedad_sintoma(Enf,ListaSintomas)),
                   guardarBase.

leerLista([H|T]):- read(H), H\=0, leerLista(T).
leerLista([]).


enfermedadesPosibles(Sintomas):- enfermedad_sintoma(E,S),
                                 perteneceAlguno(Sintomas,S,ConjuncionSintomas),
                                 ConjuncionSintomas \= [],
                                 sintomasRestantes(ConjuncionSintomas,S,Resto),
                                 mostrar(E,ConjuncionSintomas,Resto),
                                 retract(enfermedad_sintoma(E,S)),
                                 enfermedadesPosibles(Sintomas).
enfermedadesPosibles(_).

perteneceAlguno([H|T], Lista,[H|T3]):- pertenece(H,Lista),
                                       perteneceAlguno(T,Lista,T3).
perteneceAlguno([_|T],Lista,Lista2):- perteneceAlguno(T,Lista,Lista2).
perteneceAlguno([],_,[]).

pertenece(Elem,[Elem|_]).
pertenece(Elem, [_|T]):- pertenece(Elem,T).

% devuelve los sintomas de la segunda lista, que no estan en la primera.
% SintomasRestantes = sintomasEnfermedad(Sintomas) - Conjuncion(H1|T1)
sintomasRestantes(Sintomas,[H1|T1],[H1|T2]):- not(pertenece(H1,Sintomas)),
                                              sintomasRestantes(Sintomas,T1,T2).
sintomasRestantes(Sintomas,[_|T1], Conj):- sintomasRestantes(Sintomas,T1,Conj).
sintomasRestantes(_,[],[]).

mostrar(E,Conjuncion,Resto):- nl, write('----------------'), write(E), writeln('----------------'),
                              writeln('Usted tiene común a la enfermedad: '),
                              writeln(Conjuncion), nl,
                              writeln('Debería tambien experimentar: '),
                              writeln(Resto), nl, nl.
