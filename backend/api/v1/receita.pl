:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).

:- use_module(bd(receita), []).

/*
   GET api/v1/receita/
   Retorna uma lista com todos os receita.
*/
receita(get, '', _Pedido):- !,
    envia_tabela_receita.

/*
   GET api/v1/receita/Id
   Retorna o `receita` com Id 1 ou erro 404 caso o `receita` não
   seja encontrado.
*/
receita(get, AtomId, _Pedido):-
    atom_number(AtomId, Cd_receita),
    !,
    envia_tupla_receita(Cd_receita).

/*
   POST api/v1/receita
   Adiciona um novo receita. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
receita(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_receita(Dados).

/*
  PUT api/v1/receita/Id
  Atualiza o receita com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
receita(put, AtomId, Pedido):-
    atom_number(AtomId, Cd_receita),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_receita(Dados, Cd_receita).

/*
   DELETE api/v1/receita/Id
   Apaga o receita com o Id informado
*/
receita(delete, AtomId, _Pedido):-
    atom_number(AtomId, Cd_receita),
    !,
    receita:remove(Cd_receita),
    throw(http_reply(no_content)).

/*
    Se algo ocorrer de errado, a resposta de método não
    permitido será retornada.
*/
receita(Metodo, Cd_receita, _Pedido) :-
    % responde com o código 405 Method Not Allowed
    throw(http_reply(method_not_allowed(Metodo, Cd_receita))).

insere_tupla_receita( _{ tl_receita:Tl_receita,ds_receita:Ds_receita, dt_receita:Dt_receita}):-

    receita:insere(Cd_receita, Tl_receita,Ds_receita,Dt_receita)
    -> envia_tupla_receita(Cd_receita)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla_receita( _{ tl_receita:Tl_receita,ds_receita:Ds_receita,dt_receita:Dt_receita}, Cd_receita):-

    receita:atualiza(Cd_receita, Tl_receita,Ds_receita,Dt_receita)
    -> envia_tupla_receita(Cd_receita)
    ;  throw(http_reply(not_found(Cd_receita))).

envia_tupla_receita(Cd_receita):-
       receita:receita(Cd_receita, Tl_receita,Ds_receita,Dt_receita)
    -> reply_json_dict( _{cd_receita:Cd_receita, tl_receita:Tl_receita, ds_receita:Ds_receita,dt_receita:Dt_receita} )
    ;  throw(http_reply(not_found(Cd_receita))).

envia_tabela_receita :-
    findall( _{cd_receita:Cd_receita, tl_receita:Tl_receita, ds_receita:Ds_receita,dt_receita:Dt_receita},
             receita:receita(Cd_receita, Tl_receita, Ds_receita,Dt_receita),
             Tuplas ),
    reply_json_dict(Tuplas).
