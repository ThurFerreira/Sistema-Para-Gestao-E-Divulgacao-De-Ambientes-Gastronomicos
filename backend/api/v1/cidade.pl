:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).

:- use_module(bd(cidade), []).
:- use_module(bd(estado), []).

/*
   GET api/v1/cidade/
   Retorna uma lista com todos os cidades.
*/
cidade(get, '', _Pedido):- !,
    envia_tabela_cidade.

/*
   GET api/v1/cidade/Id
   Retorna o `cidade` com Id 1 ou erro 404 caso o `cidade` não
   seja encontrado.
*/
cidade(get, AtomId, _Pedido):-
    atom_number(AtomId, Cd_cidade),
    !,
    envia_tupla_cidade(Cd_cidade).

/*
   POST api/v1/cidade
   Adiciona uma nova cidade. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
cidade(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_cidade(Dados).

/*
  PUT api/v1/cidade/Id
  Atualiza o cidade com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
cidade(put, AtomId, Pedido):-
    atom_number(AtomId, Cd_cidade),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_cidade(Dados, Cd_cidade).

/*
   DELETE api/v1/cidade/Id
   Apaga o cidade com o Id informado
*/
cidade(delete, AtomId, _Pedido):-
    atom_number(AtomId, Cd_cidade),
    !,
    cidade:remove(Cd_cidade),
    throw(http_reply(no_content)).

/*
    Se algo ocorrer de errado, a resposta de método não
    permitido será retornada.
*/
cidade(Metodo, Cd_cidade, _Pedido) :-
    % responde com o código 405 Method Not Allowed
    throw(http_reply(method_not_allowed(Metodo, Cd_cidade))).

insere_tupla_cidade( _{ tl_cidade:Tl_cidade, cd_estado:Cd_estado}):-

    atom_number(Cd_estado, Cd_estadoVal),

    cidade:insere(Cd_cidade, Tl_cidade, Cd_estadoVal)
    -> envia_tupla_cidade(Cd_cidade)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla_cidade( _{ tl_cidade:Tl_cidade, cd_estado:Cd_estado}, Cd_cidade):-

    atom_number(Cd_estado, Cd_estadoVal),

    cidade:atualiza(Cd_cidade, Tl_cidade, Cd_estadoVal)
    -> envia_tupla_cidade(Cd_cidade)
    ;  throw(http_reply(not_found(Cd_cidade))).

envia_tupla_cidade(Cd_cidade):-
       cidade:cidade(Cd_cidade, Tl_cidade, Cd_estado)
    -> reply_json_dict( _{cd_cidade:Cd_cidade ,tl_cidade:Tl_cidade, cd_estado:Cd_estado} )
    ;  throw(http_reply(not_found(Cd_cidade))).

envia_tabela_cidade :-
    findall( _{cd_cidade:Cd_cidade ,tl_cidade:Tl_cidade, cd_estado:Cd_estado},
             cidade:cidade(Cd_cidade, Tl_cidade, Cd_estado),
             Tuplas ),
    reply_json_dict(Tuplas).
