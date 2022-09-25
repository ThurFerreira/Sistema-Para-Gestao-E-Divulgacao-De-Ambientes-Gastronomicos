:- module(
  categoria, 
  [ carrega_tab/1,
	categoria/2,
    insere/2,
    remove/1,
    atualiza/2  ]
).

:- use_module(library(persistency)).
:- use_module(chave,[]).

:- persistent
	categoria(cd_categoria: positive_integer,	% PK
		tl_categoria: text).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela, []).

insere(Cd_categoria, Tl_categoria):-
	chave:pk(categoria, Cd_categoria),
	with_mutex(categoria, 
	assert_categoria(Cd_categoria, Tl_categoria)).

remove(Cd_categoria):-
	with_mutex(categoria,
	retractall_categoria(Cd_categoria, _Tl_categoria)).

atualiza(Cd_categoria, Tl_categoria):-
	categoria(Cd_categoria, _),
	with_mutex(categoria, 
	(retractall_categoria(Cd_categoria, _Tl_categoria),
	assert_categoria(Cd_categoria, Tl_categoria))).
