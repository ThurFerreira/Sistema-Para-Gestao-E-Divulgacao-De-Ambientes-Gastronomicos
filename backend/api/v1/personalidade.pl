:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).

:- use_module(bd(personalidade), []).
:- use_module(bd(boteco), []).

/*
   GET api/v1/personalidade/
   Retorna uma lista com todos os personalidades.
*/
personalidade(get, '', _Pedido):- !,
    envia_tabela_personalidade.

/*
   GET api/v1/personalidade/Id
   Retorna o `personalidade` com Id 1 ou erro 404 caso o `personalidade` não
   seja encontrado.
*/
personalidade(get, AtomId, _Pedido):-
    atom_number(AtomId, Cd_personalidade),
    !,
    envia_tupla_personalidade(Cd_personalidade).

/*
   POST api/v1/personalidade
   Adiciona uma nova personalidade. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
personalidade(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_personalidade(Dados).

/*
  PUT api/v1/personalidade/Id
  Atualiza o personalidade com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
personalidade(put, AtomId, Pedido):-
    atom_number(AtomId, Cd_personalidade),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_personalidade(Dados, Cd_personalidade).

/*
   DELETE api/v1/personalidade/Id
   Apaga o personalidade com o Id informado
*/
personalidade(delete, AtomId, _Pedido):-
    atom_number(AtomId, Cd_personalidade),
    !,
    personalidade:remove(Cd_personalidade),
    throw(http_reply(no_content)).

/*
    Se algo ocorrer de errado, a resposta de método não
    permitido será retornada.
*/
personalidade(Metodo, Cd_personalidade, _Pedido) :-
    % responde com o código 405 Method Not Allowed
    throw(http_reply(method_not_allowed(Metodo, Cd_personalidade))).

insere_tupla_personalidade( _{ cd_boteco:Cd_boteco, nm_personalidade:Nm_personalidade,ds_personalidade:Ds_personalidade}):-

    atom_number(Cd_boteco, Cd_botecoVal),

    personalidade:insere(Cd_personalidade, Cd_botecoVal, Nm_personalidade,Ds_personalidade)
    -> envia_tupla_personalidade(Cd_personalidade)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla_personalidade( _{ cd_boteco:Cd_boteco, nm_personalidade:Nm_personalidade,ds_personalidade:Ds_personalidade}, Cd_personalidade):-

    atom_number(Cd_boteco, Cd_botecoVal),

    personalidade:atualiza(Cd_personalidade, Cd_botecoVal, Nm_personalidade,Ds_personalidade)
    -> envia_tupla_personalidade(Cd_personalidade)
    ;  throw(http_reply(not_found(Cd_personalidade))).

envia_tupla_personalidade(Cd_personalidade):-
       personalidade:personalidade(Cd_personalidade, Cd_boteco, Nm_personalidade,Ds_personalidade)
    -> reply_json_dict( _{cd_personalidade:Cd_personalidade ,cd_boteco:Cd_boteco, nm_personalidade:Nm_personalidade,ds_personalidade:Ds_personalidade} )
    ;  throw(http_reply(not_found(Cd_personalidade))).

envia_tabela_personalidade :-
    findall( _{cd_personalidade:Cd_personalidade ,cd_boteco:Cd_boteco, nm_personalidade:Nm_personalidade, ds_personalidade:Ds_personalidade},
             personalidade:personalidade(Cd_personalidade, Cd_boteco, Nm_personalidade,Ds_personalidade),
             Tuplas ),
    reply_json_dict(Tuplas).
