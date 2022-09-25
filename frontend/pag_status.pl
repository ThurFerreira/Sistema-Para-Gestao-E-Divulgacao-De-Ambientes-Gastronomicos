:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).

pagina_status(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Status')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                \tabela_status,
                \cadastro_botao('/status/cadastro'),
                \voltar_botao('/')
              ]) ]).

tabela_status -->
    html(div(class('container'),
             [
               \tabelas_status
             ]
            )).

tabelas_status -->
    html( table(class('table'),
                   [ \cabecalho_status,
                     tbody( \corpo_tabela_status)
                   ])).

cabecalho_status -->
    html(thead(tr([ th([scope(col), style='background-color: #04AA6D;  color: white;'], '#'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Nome status:'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Ações')
                  ]))).

corpo_tabela_status -->
    {
        findall( tr([th(scope(row), Cd_status), td(Tl_status), td(Acao)]),
          linha_status(Cd_status, Tl_status, Acao),
          Linhas)
    },
    html(Linhas).

linha_status(Cd_status, Tl_status, Acao):-
    status:status(Cd_status, Tl_status),
    acoes_status(Cd_status, Acao).

acoes_status(Cd_status, Campo):-
    Campo = [ a([
                  href('/status/editar/~w' - Cd_status),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([
                  href('/api/v1/status/~w' - Cd_status),
                  onClick("apagar( event, '/status' )"),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].    

cadastro_status(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro de status')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Cadastro de status'),
                \form_status
              ]) ]).      

form_status -->
    html(form([ id('status-form'),
                onsubmit("redirecionaResposta( event, '/status' )"),
                action('/api/v1/status/') ],
              [ \metodo_de_envio('POST'),
                \campo(tl_status, 'Nome do status: ', text),
                \enviar_ou_cancelar('/status')
              ])).         

editar_status(AtomId, _Pedido):-
    atom_number(AtomId, Cd_status),
    ( status:status(Cd_status, Tl_status)
    ->
    reply_html_page(
        boot5rest,
        [ title('Editar status')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Editar status'),
                \form_status(Cd_status, Tl_status)
              ]) ])
    ; throw(http_reply(not_found(Cd_status)))
    ).

form_status(Cd_status, Tl_status) -->
    html(form([ id('status-form'),
                onsubmit("redirecionaResposta( event, '/status' )"),
                action('/api/v1/status/~w' - Cd_status) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(cd_status, 'Id', text, Cd_status),
                \campo(tl_status, 'Nome do status: ', text, Tl_status),
                \enviar_ou_cancelar('/status')
              ])).