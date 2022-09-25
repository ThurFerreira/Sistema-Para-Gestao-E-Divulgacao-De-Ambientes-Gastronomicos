:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).

:- use_module(bd(boteco), []).
:- use_module(bd(status), []).
:- use_module(bd(nivel), []).
:- use_module(bd(cidade), []).

/*
   GET api/v1/boteco/
   Retorna uma lista com todos os botecos.
*/
boteco(get, '', _Pedido):- !,
    envia_tabela_boteco.

/*
   GET api/v1/boteco/Id
   Retorna o `boteco` com Id 1 ou erro 404 caso o `boteco` não
   seja encontrado.
*/
boteco(get, AtomId, _Pedido):-
    atom_number(AtomId, Cd_boteco),
    !,
    envia_tupla_boteco(Cd_boteco).

/*
   POST api/v1/boteco
   Adiciona uma nova boteco. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
boteco(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_boteco(Dados).

/*
  PUT api/v1/boteco/Id
  Atualiza o boteco com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
boteco(put, AtomId, Pedido):-
    atom_number(AtomId, Cd_boteco),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_boteco(Dados, Cd_boteco).

/*
   DELETE api/v1/boteco/Id
   Apaga o boteco com o Id informado
*/
boteco(delete, AtomId, _Pedido):-
    atom_number(AtomId, Cd_boteco),
    !,
    boteco:remove(Cd_boteco),
    throw(http_reply(no_content)).

/*
    Se algo ocorrer de errado, a resposta de método não
    permitido será retornada.
*/
boteco(Metodo, Cd_boteco, _Pedido) :-
    % responde com o código 405 Method Not Allowed
    throw(http_reply(method_not_allowed(Metodo, Cd_boteco))).

insere_tupla_boteco( _{ cd_status:Cd_status, cd_nivel:Cd_nivel, cd_cidade:Cd_cidade, tl_boteco:Tl_boteco, ds_endereco:Ds_endereco, ds_boteco:Ds_boteco, ds_latitude:Ds_latitude, ds_longitude:Ds_longitude, dt_atualizacao:Dt_atualizacao}):-

    atom_number(Cd_status, Cd_statusVal),
    atom_number(Cd_nivel, Cd_nivelVal),
    atom_number(Cd_cidade, Cd_cidadeVal),
    atom_number(Ds_latitude, Ds_latitudeVal),
    atom_number(Ds_longitude, Ds_longitudeVal),

    boteco:insere(Cd_boteco, Cd_statusVal, Cd_nivelVal, Cd_cidadeVal, Tl_boteco, Ds_endereco, Ds_boteco, Ds_latitudeVal, Ds_longitudeVal, Dt_atualizacao)
    -> envia_tupla_boteco(Cd_boteco)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla_boteco( _{ cd_status:Cd_status, cd_nivel:Cd_nivel, cd_cidade:Cd_cidade, tl_boteco:Tl_boteco, ds_endereco:Ds_endereco, ds_boteco:Ds_boteco, ds_latitude:Ds_latitude, ds_longitude:Ds_longitude, dt_atualizacao:Dt_atualizacao}, Cd_boteco):-

    atom_number(Cd_status, Cd_statusVal),
    atom_number(Cd_nivel, Cd_nivelVal),
    atom_number(Cd_cidade, Cd_cidadeVal),
    atom_number(Ds_latitude, Ds_latitudeVal),
    atom_number(Ds_longitude, Ds_longitudeVal),

    boteco:atualiza(Cd_boteco, Cd_statusVal, Cd_nivelVal, Cd_cidadeVal, Tl_boteco, Ds_endereco, Ds_boteco, Ds_latitudeVal, Ds_longitudeVal, Dt_atualizacao)
    -> envia_tupla_boteco(Cd_boteco)
    ;  throw(http_reply(not_found(Cd_boteco))).

envia_tupla_boteco(Cd_boteco):-
       boteco:boteco(Cd_boteco, Cd_status, Cd_nivel, Cd_cidade, Tl_boteco, Ds_endereco, Ds_boteco, Ds_latitude, Ds_longitude, Dt_atualizacao)
    -> reply_json_dict( _{cd_boteco:Cd_boteco, cd_status:Cd_status, cd_nivel:Cd_nivel, cd_cidade:Cd_cidade, tl_boteco:Tl_boteco, ds_endereco:Ds_endereco, ds_boteco:Ds_boteco, ds_latitude:Ds_latitude, ds_longitude:Ds_longitude, dt_atualizacao:Dt_atualizacao} )
    ;  throw(http_reply(not_found(Cd_boteco))).

envia_tabela_boteco :-
    findall( _{cd_boteco:Cd_boteco,cd_status:Cd_status, cd_nivel:Cd_nivel, cd_cidade:Cd_cidade, tl_boteco:Tl_boteco, ds_endereco:Ds_endereco, ds_boteco:Ds_boteco, ds_latitude:Ds_latitude, ds_longitude:Ds_longitude, dt_atualizacao:Dt_atualizacao},
             boteco:boteco(Cd_boteco, Cd_status, Cd_nivel, Cd_cidade, Tl_boteco, Ds_endereco, Ds_boteco, Ds_latitude, Ds_longitude, Dt_atualizacao),
             Tuplas ),
    reply_json_dict(Tuplas).
