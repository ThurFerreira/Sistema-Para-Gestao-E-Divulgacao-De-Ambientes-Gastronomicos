:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).

pagina_video(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Vídeos')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                \tabela_video,
                \cadastro_botao('/video/cadastro'),
                \voltar_botao('/')
              ]) ]).

tabela_video -->
    html(div(class('container'),
             [
               \tabelas_video
             ]
            )).

tabelas_video -->
    html( table(class('table'),
                   [ \cabecalho_video,
                     tbody( \corpo_tabela_video)
                   ])).

cabecalho_video -->
    html(thead(tr([ th([scope(col), style='background-color: #04AA6D;  color: white;'], '#'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Cod. Boteco'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Nome video'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Link'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Ações')
                  ]))).

corpo_tabela_video -->
    {
        findall( tr([th(scope(row), Cd_video), td(Cd_boteco), td(Tl_video), td(Ds_link), td(Acao)]),
          linha_video(Cd_video, Cd_boteco, Tl_video, Ds_link, Acao),
          Linhas)
    },
    html(Linhas).

linha_video(Cd_video, Cd_boteco, Tl_video, Ds_link, Acao):-
    video:video(Cd_video, Cd_boteco, Tl_video, Ds_link),
    acoes_video(Cd_video, Acao).

acoes_video(Cd_video, Campo):-
    Campo = [ a([
                  href('/video/editar/~w' - Cd_video),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([
                  href('/api/v1/video/~w' - Cd_video),
                  onClick("apagar( event, '/video' )"),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].    

cadastro_video(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro de video')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Cadastro de video'),
                \form_video
              ]) ]).      

form_video -->
    html(form([ id('video-form'),
                onsubmit("redirecionaResposta( event, '/video' )"),
                action('/api/v1/video/') ],
              [ \metodo_de_envio('POST'),
                \campo(cd_boteco, 'Código do boteco: ', number),
                \campo(tl_video, 'Nome do video: ', text),
                \campo(ds_link, 'Link do vídeo: ', text),
                \enviar_ou_cancelar('/video')
              ])).         

editar_video(AtomId, _Pedido):-
    atom_number(AtomId, Cd_video),
    ( video:video(Cd_video, Cd_boteco, Tl_video, Ds_link)
    ->
    reply_html_page(
        boot5rest,
        [ title('Editar video')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Editar video'),
                \form_video(Cd_video, Cd_boteco, Tl_video, Ds_link)
              ]) ])
    ; throw(http_reply(not_found(Cd_video)))
    ).

form_video(Cd_video, Cd_boteco, Tl_video, Ds_link) -->
    html(form([ id('video-form'),
                onsubmit("redirecionaResposta( event, '/video' )"),
                action('/api/v1/video/~w' - Cd_video) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(cd_video, 'Id', text, Cd_video),
                \campo(cd_boteco, 'Código do boteco: ', number, Cd_boteco),
                \campo(tl_video, 'Nome do vídeo: ', text, Tl_video),
                \campo(ds_link, 'Link do vídeo: ', text, Ds_link),
                \enviar_ou_cancelar('/video')
              ])).