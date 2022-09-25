:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).

:- use_module(bd(video), []).
:- use_module(bd(boteco), []).

/*
   GET api/v1/video/
   Retorna uma lista com todos os videos.
*/
video(get, '', _Pedido):- !,
    envia_tabela_video.

/*
   GET api/v1/video/Id
   Retorna o `video` com Id 1 ou erro 404 caso o `video` não
   seja encontrado.
*/
video(get, AtomId, _Pedido):-
    atom_number(AtomId, Cd_video),
    !,
    envia_tupla_video(Cd_video).

/*
   POST api/v1/video
   Adiciona uma nova video. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
video(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla_video(Dados).

/*
  PUT api/v1/video/Id
  Atualiza o video com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
video(put, AtomId, Pedido):-
    atom_number(AtomId, Cd_video),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla_video(Dados, Cd_video).

/*
   DELETE api/v1/video/Id
   Apaga o video com o Id informado
*/
video(delete, AtomId, _Pedido):-
    atom_number(AtomId, Cd_video),
    !,
    video:remove(Cd_video),
    throw(http_reply(no_content)).

/*
    Se algo ocorrer de errado, a resposta de método não
    permitido será retornada.
*/
video(Metodo, Cd_video, _Pedido) :-
    % responde com o código 405 Method Not Allowed
    throw(http_reply(method_not_allowed(Metodo, Cd_video))).

insere_tupla_video( _{ cd_boteco:Cd_boteco, tl_video:Tl_video, ds_link:Ds_link}):-

    atom_number(Cd_boteco, Cd_botecoVal),

    video:insere(Cd_video, Cd_botecoVal, Tl_video,Ds_link)
    -> envia_tupla_video(Cd_video)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla_video( _{ cd_boteco:Cd_boteco, tl_video:Tl_video,ds_link:Ds_link}, Cd_video):-

    atom_number(Cd_boteco, Cd_botecoVal),

    video:atualiza(Cd_video, Cd_botecoVal, Tl_video,Ds_link)
    -> envia_tupla_video(Cd_video)
    ;  throw(http_reply(not_found(Cd_video))).

envia_tupla_video(Cd_video):-
       video:video(Cd_video, Cd_boteco, Tl_video, Ds_link)
    -> reply_json_dict( _{cd_video:Cd_video ,cd_boteco:Cd_boteco, tl_video:Tl_video,ds_link:Ds_link} )
    ;  throw(http_reply(not_found(Cd_video))).

envia_tabela_video :-
    findall( _{cd_video:Cd_video ,cd_boteco:Cd_boteco, tl_video:Tl_video,ds_link:Ds_link},
             video:video(Cd_video, Cd_boteco, Tl_video,Ds_link),
             Tuplas ),
    reply_json_dict(Tuplas).
