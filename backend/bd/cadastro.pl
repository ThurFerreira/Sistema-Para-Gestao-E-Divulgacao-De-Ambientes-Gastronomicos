:- module(
  cadastro, 
  [ carrega_tab/1,
    cadastro/9,
    insere/9,
    remove/1,
    atualiza/9  ]
).

:- use_module(library(persistency)).
:- use_module(chave,[]).
:- use_module(cidade,[]).

:- persistent
	cadastro(cd_cadastro: positive_integer,	% PK
		cd_cidade: positive_integer,		% FK
		nm_cadastro: text, 
		ds_email: text,
		ds_telefone: positive_integer,
		dt_nascimento: text,				% inicialmente como float
		dt_cadastro: text,					% inicialmente como float
		fl_sexo: text,
		fl_recnot: integer).
				
:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):- db_attach(ArqTabela, []).

insere(Cd_cadastro, Cd_cidade, Nm_cadastro, Ds_email, Ds_telefone, Dt_nascimento, Dt_cadastro, Fl_sexo, Fl_recnot):-
	cidade:cidade(Cd_cidade, _Nm_cidade, _Cd_estado),
	chave:pk(cadastro, Cd_cadastro),

	with_mutex(cadastro, 
	assert_cadastro(Cd_cadastro, Cd_cidade, Nm_cadastro, Ds_email, Ds_telefone, Dt_nascimento, Dt_cadastro, Fl_sexo, Fl_recnot)).

remove(Cd_cadastro):-
	with_mutex(cadastro,
	retractall_cadastro(Cd_cadastro, _Cd_cidade, _Nm_cadastro, _Ds_email, _Ds_telefone, _Dt_nascimento, _Dt_cadastro, _Fl_sexo, _Fl_recnot)).

atualiza(Cd_cadastro, Cd_cidade, Nm_cadastro, Ds_email, Ds_telefone, Dt_nascimento, Dt_cadastro, Fl_sexo, Fl_recnot):-
	cadastro(Cd_cadastro, _, _, _, _, _, _, _, _),
	cidade:cidade(Cd_cidade, _Nm_cidade, _Cd_estado),
	with_mutex(cadastro, 
	(retractall_cadastro(Cd_cadastro, _Cd_cidade, _Nm_cadastro, _Ds_email, _Ds_telefone, _Dt_nascimento, _Dt_cadastro, _Fl_sexo, _Fl_recnot),
	assert_cadastro(Cd_cadastro, Cd_cidade, Nm_cadastro, Ds_email, Ds_telefone, Dt_nascimento, Dt_cadastro, Fl_sexo, Fl_recnot))).
