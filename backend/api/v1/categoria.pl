:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).

:- use_module(bd(categoria), []).

/*
   GET api/v1/categoria/
   Retorna uma lista com todos os categoria.
*/
categoria(get, '', _Pedido):- !,
    envia_tabela_categoria.

/*
   GET api/v1/categoria/Id
   Retorna o `categoria` com Id 1 ou erro 404 caso o `categoria` não
   seja encontrado.
*/
categoria(get, AtomId, _Pedido):-
    atom_number(AtomId, Cd_categoria),
    !,
    envia_tupla_categoria(Cd_categoria).

/*
   POST api/v1/categoria
   Adiciona um novo categoria. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
categoria(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_categoria(Dados).

/*
  PUT api/v1/categoria/Id
  Atualiza o categoria com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
categoria(put, AtomId, Pedido):-
    atom_number(AtomId, Cd_categoria),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_categoria(Dados, Cd_categoria).

/*
   DELETE api/v1/categoria/Id
   Apaga o categoria com o Id informado
*/
categoria(delete, AtomId, _Pedido):-
    atom_number(AtomId, Cd_categoria),
    !,
    categoria:remove(Cd_categoria),
    throw(http_reply(no_content)).

/*
    Se algo ocorrer de errado, a resposta de método não
    permitido será retornada.
*/
categoria(Metodo, Cd_categoria, _Pedido) :-
    % responde com o código 405 Method Not Allowed
    throw(http_reply(method_not_allowed(Metodo, Cd_categoria))).

insere_tupla_categoria( _{ tl_categoria:Tl_categoria}):-

    categoria:insere(Cd_categoria, Tl_categoria)
    -> envia_tupla_categoria(Cd_categoria)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla_categoria( _{ tl_categoria:Tl_categoria}, Cd_categoria):-

    categoria:atualiza(Cd_categoria, Tl_categoria)
    -> envia_tupla_categoria(Cd_categoria)
    ;  throw(http_reply(not_found(Cd_categoria))).

envia_tupla_categoria(Cd_categoria):-
       categoria:categoria(Cd_categoria, Tl_categoria)
    -> reply_json_dict( _{cd_categoria:Cd_categoria, tl_categoria:Tl_categoria} )
    ;  throw(http_reply(not_found(Cd_categoria))).

envia_tabela_categoria :-
    findall( _{cd_categoria:Cd_categoria, tl_categoria:Tl_categoria},
             categoria:categoria(Cd_categoria, Tl_categoria),
             Tuplas ),
    reply_json_dict(Tuplas).
