:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).

:- use_module(bd(cadastro), []).
:- use_module(bd(cidade), []).

/* *************************************************
	GET api/v1/cadastro/
	Retorna uma lista com todos os cadastros.
   ************************************************ */

cadastro(get, '', _Pedido):- !,
	envia_tabela_cadastro.
/*
	GET api/v1/cadastro/Id
	Retorna o 'cadastro' com Id 1 ou erro 404 caso o 'cadastro' não seja encontrado.
*/

cadastro(get, AtomId, _Pedido):-
	atom_number(AtomId, Cd_cadastro), % o identificador aparece na rota como um átomo,
	!,
	envia_tupla_cadastro(Cd_cadastro). 
	
/* *************************************************
	POST api/v1/cadastro
	Adiciona um novo cadastro.
	Os dados são passados no corpo do pedido usando o formato JSON.
	Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido informada.
  ************************************************ */
  
cadastro(post, _, Pedido):-
	http_read_json_dict(Pedido, Dados), % lê o JSON enviado com o Pedido
	!,
	insere_tupla_cadastro(Dados).

/* *************************************************
	PUT api/v1/cadastro/Id
	Atualiza o cadastro com o Id dado.
	Os dados são passados no corpo do pedido usando o formato JSON.
  ************************************************ */
  
cadastro(put, AtomId, Pedido):-
	atom_number(AtomId, Cd_cadastro),
	http_read_json_dict(Pedido, Dados),
	!,
	atualiza_tupla_cadastro(Dados, Cd_cadastro).
  
/* *************************************************
	DELETE api/v1/cadastro/Id
	Apaga o cadastro com o Id informado
  ************************************************ */
  
cadastro(delete, AtomId, _Pedido):-
	atom_number(AtomId, Cd_cadastro),
	!,
	cadastro:remove(Cd_cadastro),
	throw(http_reply(no_content)). % Responde usando o código 204 No Content
  
/* Se algo ocorrer de errado, a resposta de método não
permitido será retornada.
*/
cadastro(Metodo, Cd_cadastro, _Pedido) :-
	% responde com o código 405 Method Not Allowed
	throw(http_reply(method_not_allowed(Metodo, Cd_cadastro))).


/**/
insere_tupla_cadastro( _{ cd_cidade:Cd_cidade, nm_cadastro:Nm_cadastro, ds_email:Ds_email, ds_telefone:Ds_telefone, dt_nascimento:Dt_nascimento, dt_cadastro:Dt_cadastro, fl_sexo:Fl_sexo, fl_recnot:Fl_recnot}):-

	atom_number(Cd_cidade, Cd_cidadeVal),
	atom_number(Ds_telefone, Ds_telefoneVal),
	atom_number(Fl_recnot, Fl_recnotVal),

	cadastro:insere(Cd_cadastro, Cd_cidadeVal, Nm_cadastro, Ds_email, Ds_telefoneVal, Dt_nascimento, Dt_cadastro, Fl_sexo, Fl_recnotVal)
	-> envia_tupla_cadastro(Cd_cadastro)
	; throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla_cadastro( _{ cd_cidade:Cd_cidade, nm_cadastro:Nm_cadastro, ds_email:Ds_email, ds_telefone:Ds_telefone, dt_nascimento:Dt_nascimento, dt_cadastro:Dt_cadastro, fl_sexo:Fl_sexo, fl_recnot:Fl_recnot}, Cd_cadastro):-
	
	atom_number(Cd_cidade, Cd_cidadeVal),
	atom_number(Ds_telefone, Ds_telefoneVal),
	atom_number(Fl_recnot, Fl_recnotVal),
	
	cadastro:atualiza(Cd_cadastro, Cd_cidadeVal, Nm_cadastro, Ds_email, Ds_telefoneVal, Dt_nascimento, Dt_cadastro, Fl_sexo, Fl_recnotVal)
	-> envia_tupla_cadastro(Cd_cadastro)
	; throw(http_reply(not_found(Cd_cadastro))).

envia_tupla_cadastro(Cd_cadastro):-
	cadastro:cadastro(Cd_cadastro, Cd_cidade, Nm_cadastro, Ds_email, Ds_telefone, Dt_nascimento, Dt_cadastro, Fl_sexo, Fl_recnot)
	-> reply_json_dict( _{ cd_cadastro:Cd_cadastro, cd_cidade:Cd_cidade, nm_cadastro:Nm_cadastro, ds_email:Ds_email, ds_telefone:Ds_telefone, dt_nascimento:Dt_nascimento, dt_cadastro:Dt_cadastro, fl_sexo:Fl_sexo, fl_recnot:Fl_recnot} )
	; throw(http_reply(not_found(Cd_cadastro))).

envia_tabela_cadastro :-
	findall( _{cd_cadastro:Cd_cadastro, cd_cidade:Cd_cidade, nm_cadastro:Nm_cadastro, ds_email:Ds_email, ds_telefone:Ds_telefone, dt_nascimento:Dt_nascimento, dt_cadastro:Dt_cadastro, fl_sexo:Fl_sexo, fl_recnot:Fl_recnot},
	cadastro:cadastro(Cd_cadastro, Cd_cidade, Nm_cadastro, Ds_email, Ds_telefone, Dt_nascimento, Dt_cadastro, Fl_sexo, Fl_recnot),
	Tuplas ),
	reply_json_dict(Tuplas).