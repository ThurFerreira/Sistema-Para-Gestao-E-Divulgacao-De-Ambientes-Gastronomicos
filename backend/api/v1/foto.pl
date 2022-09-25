:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).

:- use_module(bd(foto), []).
:- use_module(bd(boteco), []).

/*
   GET api/v1/foto/
   Retorna uma lista com todos os fotos.
*/
foto(get, '', _Pedido):- !,
    envia_tabela_foto.

/*
   GET api/v1/foto/Id
   Retorna o `foto` com Id 1 ou erro 404 caso o `foto` não
   seja encontrado.
*/
foto(get, AtomId, _Pedido):-
    atom_number(AtomId, Cd_foto),
    !,
    envia_tupla_foto(Cd_foto).

/*
   POST api/v1/foto
   Adiciona uma nova foto. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
foto(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_foto(Dados).

/*
  PUT api/v1/foto/Id
  Atualiza o foto com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
foto(put, AtomId, Pedido):-
    atom_number(AtomId, Cd_foto),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_foto(Dados, Cd_foto).

/*
   DELETE api/v1/foto/Id
   Apaga o foto com o Id informado
*/
foto(delete, AtomId, _Pedido):-
    atom_number(AtomId, Cd_foto),
    !,
    foto:remove(Cd_foto),
    throw(http_reply(no_content)).

/*
    Se algo ocorrer de errado, a resposta de método não
    permitido será retornada.
*/
foto(Metodo, Cd_foto, _Pedido) :-
    % responde com o código 405 Method Not Allowed
    throw(http_reply(method_not_allowed(Metodo, Cd_foto))).

insere_tupla_foto( _{ cd_boteco:Cd_boteco, ds_legenda:Ds_legenda}):-

    atom_number(Cd_boteco, Cd_botecoVal),

    foto:insere(Cd_foto, Cd_botecoVal, Ds_legenda)
    -> envia_tupla_foto(Cd_foto)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla_foto( _{ cd_boteco:Cd_boteco, ds_legenda:Ds_legenda}, Cd_foto):-

    atom_number(Cd_boteco, Cd_botecoVal),

    foto:atualiza(Cd_foto, Cd_botecoVal, Ds_legenda)
    -> envia_tupla_foto(Cd_foto)
    ;  throw(http_reply(not_found(Cd_foto))).

envia_tupla_foto(Cd_foto):-
       foto:foto(Cd_foto, Cd_boteco, Ds_legenda)
    -> reply_json_dict( _{cd_foto:Cd_foto ,cd_boteco:Cd_boteco, ds_legenda:Ds_legenda} )
    ;  throw(http_reply(not_found(Cd_foto))).

envia_tabela_foto :-
    findall( _{cd_foto:Cd_foto ,cd_boteco:Cd_boteco, ds_legenda:Ds_legenda},
             foto:foto(Cd_foto, Cd_boteco, Ds_legenda),
             Tuplas ),
    reply_json_dict(Tuplas).
