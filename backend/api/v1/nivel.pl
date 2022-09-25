:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).

:- use_module(bd(nivel), []).

/*
   GET api/v1/nivel/
   Retorna uma lista com todos os nivel.
*/
nivel(get, '', _Pedido):- !,
    envia_tabela_nivel.

/*
   GET api/v1/nivel/Id
   Retorna o `nivel` com Id 1 ou erro 404 caso o `nivel` não
   seja encontrado.
*/
nivel(get, AtomId, _Pedido):-
    atom_number(AtomId, Cd_nivel),
    !,
    envia_tupla_nivel(Cd_nivel).

/*
   POST api/v1/nivel
   Adiciona um novo nivel. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
nivel(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_nivel(Dados).

/*
  PUT api/v1/nivel/Id
  Atualiza o nivel com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
nivel(put, AtomId, Pedido):-
    atom_number(AtomId, Cd_nivel),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_nivel(Dados, Cd_nivel).

/*
   DELETE api/v1/nivel/Id
   Apaga o nivel com o Id informado
*/
nivel(delete, AtomId, _Pedido):-
    atom_number(AtomId, Cd_nivel),
    !,
    nivel:remove(Cd_nivel),
    throw(http_reply(no_content)).

/*
    Se algo ocorrer de errado, a resposta de método não
    permitido será retornada.
*/
nivel(Metodo, Cd_nivel, _Pedido) :-
    % responde com o código 405 Method Not Allowed
    throw(http_reply(method_not_allowed(Metodo, Cd_nivel))).

insere_tupla_nivel( _{ tl_nivel:Tl_nivel}):-

    nivel:insere(Cd_nivel, Tl_nivel)
    -> envia_tupla_nivel(Cd_nivel)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla_nivel( _{ tl_nivel:Tl_nivel}, Cd_nivel):-

    nivel:atualiza(Cd_nivel, Tl_nivel)
    -> envia_tupla_nivel(Cd_nivel)
    ;  throw(http_reply(not_found(Cd_nivel))).

envia_tupla_nivel(Cd_nivel):-
       nivel:nivel(Cd_nivel, Tl_nivel)
    -> reply_json_dict( _{cd_nivel:Cd_nivel, tl_nivel:Tl_nivel} )
    ;  throw(http_reply(not_found(Cd_nivel))).

envia_tabela_nivel :-
    findall( _{cd_nivel:Cd_nivel, tl_nivel:Tl_nivel},
             nivel:nivel(Cd_nivel, Tl_nivel),
             Tuplas ),
    reply_json_dict(Tuplas).
