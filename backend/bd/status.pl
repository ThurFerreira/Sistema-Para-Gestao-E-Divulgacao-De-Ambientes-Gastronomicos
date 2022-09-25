:- module(
  status, 
  [ carrega_tab/1,
	status/2,
    insere/2,
    remove/1,
    atualiza/2  ]
).

:- use_module(library(persistency)).
:- use_module(chave,[]).

:- persistent
	status(cd_status: positive_integer,	% PK
		tl_status: text).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela, []).

insere(Cd_status, Tl_status):-
	chave:pk(status, Cd_status),
	with_mutex(status, 
	assert_status(Cd_status, Tl_status)).

remove(Cd_status):-
	with_mutex(status,
	retractall_status(Cd_status, _Tl_status)).

atualiza(Cd_status, Tl_status):-
	status(Cd_status, _),
	with_mutex(status, 
	(retractall_status(Cd_status, _Tl_status),
	assert_status(Cd_status, Tl_status))).
