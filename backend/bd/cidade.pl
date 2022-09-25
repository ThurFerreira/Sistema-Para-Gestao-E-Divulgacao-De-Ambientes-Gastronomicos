:- module(
  cidade, 
  [ carrega_tab/1,
	cidade/3,
    insere/3,
    remove/1,
    atualiza/3  ]
).

:- use_module(library(persistency)).
:- use_module(estado, []).
:- use_module(chave,[]).

:- persistent
	cidade(cd_cidade: positive_integer,
		tl_cidade: text,
		cd_estado: positive_integer).


carrega_tab(ArqTabela):- db_attach(ArqTabela, []).

:- initialization( at_halt(db_sync(gc(always))) ).

insere(Cd_cidade, Tl_cidade, Cd_estado):-
	estado:estado(Cd_estado, _Tl_estado, _Sg_estado),
	chave:pk(cidade, Cd_cidade),
	with_mutex(cidade,
		assert_cidade(Cd_cidade, Tl_cidade, Cd_estado)).

remove(Cd_cidade):-
	with_mutex(cidade,
	retractall_cidade(Cd_cidade, _Tl_cidade, _Cd_estado)).

atualiza(Cd_cidade, Tl_cidade, Cd_estado):-
	cidade(Cd_cidade, _,_),
	estado:estado(Cd_estado, _Tl_estado, _Sg_estado),
	with_mutex(cidade,
	(retractall_cidade(Cd_cidade, _Tl_cidade, _Cd_estado),
	assert_cidade(Cd_cidade, Tl_cidade, Cd_estado))).
