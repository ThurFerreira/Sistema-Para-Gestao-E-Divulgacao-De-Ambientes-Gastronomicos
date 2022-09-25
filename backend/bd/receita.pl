:- module(
  receita, 
  [ carrega_tab/1,
	receita/4,
    insere/4,
    remove/1,
    atualiza/4  ]
).

:- use_module(library(persistency)).
:- use_module(chave,[]).

:- persistent
	receita(cd_receita: positive_integer,	% PK
		tl_receita: text,
		ds_receita: text,
		dt_receita: text).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela, []).

insere(Cd_receita, Tl_receita, Ds_receita, Dt_receita):-
	chave:pk(receita, Cd_receita),
	with_mutex(receita, 
	assert_receita(Cd_receita, Tl_receita, Ds_receita, Dt_receita)).

remove(Cd_receita):-
	with_mutex(receita,
	retractall_receita(Cd_receita, _Tl_receita, _Ds_receita, _Dt_receita)).

atualiza(Cd_receita, Tl_receita, Ds_receita, Dt_receita):-
	receita(Cd_receita, _, _, _),
	with_mutex(receita, 
	(retractall_receita(Cd_receita, _Tl_receita, _Ds_receita, _Dt_receita),
	assert_receita(Cd_receita, Tl_receita, Ds_receita, Dt_receita))).
