:- module(
  estado, 
  [ carrega_tab/1,
	estado/3,
    insere/3,
    remove/1,
    atualiza/3  ]
).

:- use_module(library(persistency)).
:- use_module(chave,[]).

:- persistent
	estado(cd_estado: positive_integer,	% PK
		nm_estado: text,
		sg_estado: text).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela, []).

insere(Cd_estado, Nm_estado, Sg_estado):-
	chave:pk(estado, Cd_estado),
	with_mutex(estado, 
	assert_estado(Cd_estado, Nm_estado, Sg_estado)).

remove(Cd_estado):-
	with_mutex(estado,
	retractall_estado(Cd_estado, _Nm_estado, _Sg_estado)).

atualiza(Cd_estado, Nm_estado, Sg_estado):-
	estado(Cd_estado, _, _),
	with_mutex(estado, 
	(retractall_estado(Cd_estado, _Nm_estado, _Sg_estado),
	assert_estado(Cd_estado, Nm_estado, Sg_estado))).
