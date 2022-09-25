:- module(
  foto, 
  [ carrega_tab/1,
	foto/3,
    insere/3,
    remove/1,
    atualiza/3  ]
).

:- use_module(library(persistency)).
:- use_module(boteco, []).

:- persistent
	foto(cd_foto: positive_integer,
		cd_boteco: positive_integer,
		ds_legenda: text).


carrega_tab(ArqTabela):- db_attach(ArqTabela, []).

:- initialization( at_halt(db_sync(gc(always))) ).

insere(Cd_foto, Cd_boteco, Ds_legenda):-
	boteco:boteco(Cd_boteco, _, _,_,_,_,_,_,_,_),
	chave:pk(foto, Cd_foto),
	with_mutex(foto,
		assert_foto(Cd_foto, Cd_boteco, Ds_legenda)).

remove(Cd_foto):-
	with_mutex(foto,
	retractall_foto(Cd_foto, _Cd_boteco, _Ds_legenda)).

atualiza(Cd_foto, Cd_boteco, Ds_legenda):-
	foto(Cd_foto, _,_),
	boteco:boteco(Cd_boteco, _,_,_,_,_,_,_,_,_),
	with_mutex(foto,
	(retractall_foto(Cd_foto, _Cd_boteco, _Ds_legenda),
	assert_foto(Cd_foto, Cd_boteco, Ds_legenda))).
