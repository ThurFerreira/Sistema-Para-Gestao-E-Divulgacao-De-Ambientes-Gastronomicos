:- module(
  boteco, 
  [ carrega_tab/1,
	boteco/10,
    insere/10,
    remove/1,
    atualiza/10  ]
).

:- use_module(library(persistency)).
:- use_module(status, []).
:- use_module(nivel, []).
:- use_module(cidade, []).
:- use_module(chave,[]).

:- persistent
	boteco(cd_boteco: positive_integer,
		cd_status: positive_integer,
		cd_nivel: positive_integer,
		cd_cidade: positive_integer,
		tl_boteco: text,
		ds_endereco: text,
		ds_boteco: text,
		ds_latitude: number,
		ds_longitude: number,
		dt_atualizacao: text).


carrega_tab(ArqTabela):- db_attach(ArqTabela, []).

:- initialization( at_halt(db_sync(gc(always))) ).

insere(Cd_boteco, Cd_status, Cd_nivel, Cd_cidade, Tl_boteco, Ds_endereco, Ds_boteco, Ds_latitude, Ds_longitude, Dt_atualizacao):-
	
	status:status(Cd_status, _),
	nivel:nivel(Cd_nivel, _),
	cidade:cidade(Cd_cidade, _, _),

	chave:pk(boteco, Cd_boteco),
	with_mutex(boteco,
		assert_boteco(Cd_boteco, Cd_status, Cd_nivel, Cd_cidade, Tl_boteco, Ds_endereco, Ds_boteco, Ds_latitude, Ds_longitude, Dt_atualizacao)).

remove(Cd_boteco):-
	with_mutex(boteco,
	retractall_boteco(Cd_boteco, _Cd_status, _Cd_nivel, _Cd_cidade, _Tl_boteco, _Ds_endereco, _Ds_boteco, _Ds_latitude, _Ds_longitude, _Dt_atualizacao)).

atualiza(Cd_boteco, Cd_status, Cd_nivel, Cd_cidade, Tl_boteco, Ds_endereco, Ds_boteco, Ds_latitude, Ds_longitude, Dt_atualizacao):-
	boteco(Cd_boteco, _,_,_,_,_,_,_,_,_),
	status:status(Cd_status, _),
	nivel:nivel(Cd_nivel, _),
	cidade:cidade(Cd_cidade, _, _),

	with_mutex(boteco,
	(retractall_boteco(Cd_boteco, _Cd_status, _Cd_nivel, _Cd_cidade, _Tl_boteco, _Ds_endereco, _Ds_boteco, _Ds_latitude, _Ds_longitude, _Dt_atualizacao),
	assert_boteco(Cd_boteco, Cd_status, Cd_nivel, Cd_cidade, Tl_boteco, Ds_endereco, Ds_boteco, Ds_latitude, Ds_longitude, Dt_atualizacao))).
