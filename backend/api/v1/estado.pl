:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).

:- use_module(bd(estado), []).

/*
   GET api/v1/estado/
   Retorna uma lista com todos os estados.
*/
estado(get, '', _Pedido):- !,
    envia_tabela_estado.

/*
   GET api/v1/estado/Id
   Retorna o `estado` com Id 1 ou erro 404 caso o `estado` não
   seja encontrado.
*/
estado(get, AtomId, _Pedido):-
    atom_number(AtomId, Cd_estado),
    !,
    envia_tupla_estado(Cd_estado).

/*
   POST api/v1/estado
   Adiciona um novo estado. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
estado(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_estado(Dados).

/*
  PUT api/v1/estado/Id
  Atualiza o estado com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
estado(put, AtomId, Pedido):-
    atom_number(AtomId, Cd_estado),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_estado(Dados, Cd_estado).

/*
   DELETE api/v1/estado/Id
   Apaga o estado com o Id informado
*/
estado(delete, AtomId, _Pedido):-
    atom_number(AtomId, Cd_estado),
    !,
    estado:remove(Cd_estado),
    throw(http_reply(no_content)).

/*
    Se algo ocorrer de errado, a resposta de método não
    permitido será retornada.
*/
estado(Metodo, Cd_estado, _Pedido) :-
    % responde com o código 405 Method Not Allowed
    throw(http_reply(method_not_allowed(Metodo, Cd_estado))).

insere_tupla_estado( _{ nm_estado:Nm_estado, sg_estado:Sg_estado}):-

    estado:insere(Cd_estado, Nm_estado, Sg_estado)
    -> envia_tupla_estado(Cd_estado)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla_estado( _{ nm_estado:Nm_estado, sg_estado:Sg_estado}, Cd_estado):-

    estado:atualiza(Cd_estado, Nm_estado, Sg_estado)
    -> envia_tupla_estado(Cd_estado)
    ;  throw(http_reply(not_found(Cd_estado))).

envia_tupla_estado(Cd_estado):-
       estado:estado(Cd_estado, Nm_estado, Sg_estado)
    -> reply_json_dict( _{cd_estado:Cd_estado, nm_estado:Nm_estado, sg_estado:Sg_estado} )
    ;  throw(http_reply(not_found(Cd_estado))).

envia_tabela_estado :-
    findall( _{cd_estado:Cd_estado, nm_estado:Nm_estado, sg_estado:Sg_estado},
             estado:estado(Cd_estado, Nm_estado, Sg_estado),
             Tuplas ),
    reply_json_dict(Tuplas).
