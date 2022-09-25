:- module(
  institucional, 
  [ carrega_tab/1,
	institucional/3,
    insere/3,
    remove/1,
    atualiza/3  ]
).

:- use_module(library(persistency)).
:- use_module(chave,[]).

:- persistent
	institucional(cd_institucional: positive_integer,	% PK
		tl_institucional: text,
		ds_institucional: text).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela, []).

insere(Cd_institucional, Tl_institucional, Ds_institucional):-
	chave:pk(institucional, Cd_institucional),
	with_mutex(institucional, 
	assert_institucional(Cd_institucional, Tl_institucional, Ds_institucional)).

remove(Cd_institucional):-
	with_mutex(institucional,
	retractall_institucional(Cd_institucional, _Tl_institucional, _Ds_institucional)).

atualiza(Cd_institucional, Tl_institucional, Ds_institucional):-
	institucional(Cd_institucional, _, _),
	with_mutex(institucional, 
	(retractall_institucional(Cd_institucional, _Tl_institucional, _Ds_institucional),
	assert_institucional(Cd_institucional, Tl_institucional, Ds_institucional))).
