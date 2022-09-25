:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).

pagina_foto(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Fotos')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                \tabela_foto,
                \cadastro_botao('/foto/cadastro'),
                \voltar_botao('/')
              ]) ]).

tabela_foto -->
    html(div(class('container'),
             [
               \tabelas_foto
             ]
            )).

tabelas_foto -->
    html( table(class('table'),
                   [ \cabecalho_foto,
                     tbody( \corpo_tabela_foto)
                   ])).

cabecalho_foto -->
    html(thead(tr([ th([scope(col), style='background-color: #04AA6D;  color: white;'], '#'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Cod. Boteco'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Legenda'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Ações')
                  ]))).

corpo_tabela_foto -->
    {
        findall( tr([th(scope(row), Cd_foto), td(Cd_boteco), td(Ds_legenda), td(Acao)]),
          linha_foto(Cd_foto, Cd_boteco, Ds_legenda, Acao),
          Linhas)
    },
    html(Linhas).

linha_foto(Cd_foto, Cd_boteco, Ds_legenda, Acao):-
    foto:foto(Cd_foto, Cd_boteco, Ds_legenda),
    acoes_foto(Cd_foto, Acao).

acoes_foto(Cd_foto, Campo):-
    Campo = [ a([
                  href('/foto/editar/~w' - Cd_foto),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([
                  href('/api/v1/foto/~w' - Cd_foto),
                  onClick("apagar( event, '/foto' )"),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].    

cadastro_foto(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro de foto')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Cadastro de foto'),
                \form_foto
              ]) ]).      

form_foto -->
    html(form([ id('foto-form'),
                onsubmit("redirecionaResposta( event, '/foto' )"),
                action('/api/v1/foto/') ],
              [ \metodo_de_envio('POST'),
                \campo(cd_boteco, 'Código do boteco: ', number),
                \campo(ds_legenda, 'Legenda: ', text),
                \enviar_ou_cancelar('/foto')
              ])).         

editar_foto(AtomId, _Pedido):-
    atom_number(AtomId, Cd_foto),
    ( foto:foto(Cd_foto, Cd_boteco, Ds_legenda)
    ->
    reply_html_page(
        boot5rest,
        [ title('Editar foto')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Editar foto'),
                \form_foto(Cd_foto, Cd_boteco, Ds_legenda)
              ]) ])
    ; throw(http_reply(not_found(Cd_foto)))
    ).

form_foto(Cd_foto, Cd_boteco, Ds_legenda) -->
    html(form([ id('foto-form'),
                onsubmit("redirecionaResposta( event, '/foto' )"),
                action('/api/v1/foto/~w' - Cd_foto) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(cd_foto, 'Id', text, Cd_foto),
                \campo(cd_boteco, 'Código do boteco: ', number, Cd_boteco),
                \campo(ds_legenda, 'Legenda: ', text, Ds_legenda),
                \enviar_ou_cancelar('/foto')
              ])).