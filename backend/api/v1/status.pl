:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).

:- use_module(bd(status), []).

/*
   GET api/v1/status/
   Retorna uma lista com todos os status.
*/
status(get, '', _Pedido):- !,
    envia_tabela_status.

/*
   GET api/v1/status/Id
   Retorna o `status` com Id 1 ou erro 404 caso o `status` não
   seja encontrado.
*/
status(get, AtomId, _Pedido):-
    atom_number(AtomId, Cd_status),
    !,
    envia_tupla_status(Cd_status).

/*
   POST api/v1/status
   Adiciona um novo status. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
status(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_status(Dados).

/*
  PUT api/v1/status/Id
  Atualiza o status com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
status(put, AtomId, Pedido):-
    atom_number(AtomId, Cd_status),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_status(Dados, Cd_status).

/*
   DELETE api/v1/status/Id
   Apaga o status com o Id informado
*/
status(delete, AtomId, _Pedido):-
    atom_number(AtomId, Cd_status),
    !,
    status:remove(Cd_status),
    throw(http_reply(no_content)).

/*
    Se algo ocorrer de errado, a resposta de método não
    permitido será retornada.
*/
status(Metodo, Cd_status, _Pedido) :-
    % responde com o código 405 Method Not Allowed
    throw(http_reply(method_not_allowed(Metodo, Cd_status))).

insere_tupla_status( _{ tl_status:Tl_status}):-

    status:insere(Cd_status, Tl_status)
    -> envia_tupla_status(Cd_status)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla_status( _{ tl_status:Tl_status}, Cd_status):-

    status:atualiza(Cd_status, Tl_status)
    -> envia_tupla_status(Cd_status)
    ;  throw(http_reply(not_found(Cd_status))).

envia_tupla_status(Cd_status):-
       status:status(Cd_status, Tl_status)
    -> reply_json_dict( _{cd_status:Cd_status, tl_status:Tl_status} )
    ;  throw(http_reply(not_found(Cd_status))).

envia_tabela_status :-
    findall( _{cd_status:Cd_status, tl_status:Tl_status},
             status:status(Cd_status, Tl_status),
             Tuplas ),
    reply_json_dict(Tuplas).
