:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).

:- use_module(bd(institucional), []).

/*
   GET api/v1/institucional/
   Retorna uma lista com todos os institucional.
*/
institucional(get, '', _Pedido):- !,
    envia_tabela_institucional.

/*
   GET api/v1/institucional/Id
   Retorna o `institucional` com Id 1 ou erro 404 caso o `institucional` não
   seja encontrado.
*/
institucional(get, AtomId, _Pedido):-
    atom_number(AtomId, Cd_institucional),
    !,
    envia_tupla_institucional(Cd_institucional).

/*
   POST api/v1/institucional
   Adiciona um novo institucional. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
institucional(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_institucional(Dados).

/*
  PUT api/v1/institucional/Id
  Atualiza o institucional com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
institucional(put, AtomId, Pedido):-
    atom_number(AtomId, Cd_institucional),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_institucional(Dados, Cd_institucional).

/*
   DELETE api/v1/institucional/Id
   Apaga o institucional com o Id informado
*/
institucional(delete, AtomId, _Pedido):-
    atom_number(AtomId, Cd_institucional),
    !,
    institucional:remove(Cd_institucional),
    throw(http_reply(no_content)).

/*
    Se algo ocorrer de errado, a resposta de método não
    permitido será retornada.
*/
institucional(Metodo, Cd_institucional, _Pedido) :-
    % responde com o código 405 Method Not Allowed
    throw(http_reply(method_not_allowed(Metodo, Cd_institucional))).

insere_tupla_institucional( _{ tl_institucional:Tl_institucional,ds_institucional:Ds_institucional}):-

    institucional:insere(Cd_institucional, Tl_institucional,Ds_institucional)
    -> envia_tupla_institucional(Cd_institucional)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla_institucional( _{ tl_institucional:Tl_institucional,ds_institucional:Ds_institucional}, Cd_institucional):-

    institucional:atualiza(Cd_institucional, Tl_institucional,Ds_institucional)
    -> envia_tupla_institucional(Cd_institucional)
    ;  throw(http_reply(not_found(Cd_institucional))).

envia_tupla_institucional(Cd_institucional):-
       institucional:institucional(Cd_institucional, Tl_institucional,Ds_institucional)
    -> reply_json_dict( _{cd_institucional:Cd_institucional, tl_institucional:Tl_institucional, ds_institucional:Ds_institucional} )
    ;  throw(http_reply(not_found(Cd_institucional))).

envia_tabela_institucional :-
    findall( _{cd_institucional:Cd_institucional, tl_institucional:Tl_institucional, ds_institucional:Ds_institucional},
             institucional:institucional(Cd_institucional, Tl_institucional, Ds_institucional),
             Tuplas ),
    reply_json_dict(Tuplas).
