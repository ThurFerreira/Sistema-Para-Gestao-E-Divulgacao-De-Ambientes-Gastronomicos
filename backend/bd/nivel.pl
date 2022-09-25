:- module(
  nivel, 
  [ carrega_tab/1,
	nivel/2,
    insere/2,
    remove/1,
    atualiza/2  ]
).

:- use_module(library(persistency)).
:- use_module(chave,[]).

:- persistent
	nivel(cd_nivel: positive_integer,	% PK
		tl_nivel: text).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela, []).

insere(Cd_nivel, Tl_nivel):-
	chave:pk(nivel, Cd_nivel),
	with_mutex(nivel, 
	assert_nivel(Cd_nivel, Tl_nivel)).

remove(Cd_nivel):-
	with_mutex(nivel,
	retractall_nivel(Cd_nivel, _Tl_nivel)).

atualiza(Cd_nivel, Tl_nivel):-
	nivel(Cd_nivel, _),
	with_mutex(nivel, 
	(retractall_nivel(Cd_nivel, _Tl_nivel),
	assert_nivel(Cd_nivel, Tl_nivel))).
