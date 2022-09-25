:- module(
  personalidade, 
  [ carrega_tab/1,
	personalidade/4,
    insere/4,
    remove/1,
    atualiza/4  ]
).

:- use_module(library(persistency)).
:- use_module(boteco, []).

:- persistent
	personalidade(cd_personalidade: positive_integer,
		cd_boteco: positive_integer,
		nm_personalidade: text,
		ds_personalidade: text).


carrega_tab(ArqTabela):- db_attach(ArqTabela, []).

:- initialization( at_halt(db_sync(gc(always))) ).

insere(Cd_personalidade, Cd_boteco, Nm_personalidade, Ds_personalidade):-
	boteco:boteco(Cd_boteco, _, _,_,_,_,_,_,_,_),
	chave:pk(personalidade, Cd_personalidade),
	with_mutex(personalidade,
		assert_personalidade(Cd_personalidade, Cd_boteco, Nm_personalidade, Ds_personalidade)).

remove(Cd_personalidade):-
	with_mutex(personalidade,
	retractall_personalidade(Cd_personalidade, _Cd_boteco, _Nm_personalidade, _Ds_personalidade)).

atualiza(Cd_personalidade, Cd_boteco, Nm_personalidade, Ds_personalidade):-
	personalidade(Cd_personalidade, _,_,_),
	boteco:boteco(Cd_boteco, _,_,_,_,_,_,_,_,_),
	with_mutex(personalidade,
	(retractall_personalidade(Cd_personalidade, _Cd_boteco, _Nm_personalidade, _Ds_personalidade),
	assert_personalidade(Cd_personalidade, Cd_boteco, Nm_personalidade, Ds_personalidade))).
