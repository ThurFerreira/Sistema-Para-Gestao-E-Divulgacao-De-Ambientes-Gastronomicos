:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).

pagina_institucional(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Institucional')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                \tabela_institucional,
                \cadastro_botao('/institucional/cadastro'),
                \voltar_botao('/')
              ]) ]).

tabela_institucional -->
    html(div(class('container'),
             [
               \tabelas_institucional
             ]
            )).

tabelas_institucional -->
    html( table(class('table'),
                   [ \cabecalho_institucional,
                     tbody( \corpo_tabela_institucional)
                   ])).

cabecalho_institucional -->
    html(thead(tr([ th([scope(col), style='background-color: #04AA6D;  color: white;'], '#'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Nome da instituição:'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Descrição da instituição:'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Ações')
                  ]))).

corpo_tabela_institucional -->
    {
        findall( tr([th(scope(row), Cd_institucional), td(Tl_institucional), td(Ds_institucional), td(Acao)]),
          linha_institucional(Cd_institucional, Tl_institucional, Ds_institucional, Acao),
          Linhas)
    },
    html(Linhas).

linha_institucional(Cd_institucional, Tl_institucional, Ds_institucional, Acao):-
    institucional:institucional(Cd_institucional, Tl_institucional, Ds_institucional),
    acoes_institucional(Cd_institucional, Acao).

acoes_institucional(Cd_institucional, Campo):-
    Campo = [ a([
                  href('/institucional/editar/~w' - Cd_institucional),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([
                  href('/api/v1/institucional/~w' - Cd_institucional),
                  onClick("apagar( event, '/institucional' )"),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].    

cadastro_institucional(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro de institucional')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Cadastro de institucional'),
                \form_institucional
              ]) ]).      

form_institucional -->
    html(form([ id('institucional-form'),
                onsubmit("redirecionaResposta( event, '/institucional' )"),
                action('/api/v1/institucional/') ],
              [ \metodo_de_envio('POST'),
                \campo(tl_institucional, 'Nome da instituição: ', text),
                \campo(ds_institucional, 'Descrição da instituição: ', text),
                \enviar_ou_cancelar('/institucional')
              ])).         

editar_institucional(AtomId, _Pedido):-
    atom_number(AtomId, Cd_institucional),
    ( institucional:institucional(Cd_institucional, Tl_institucional, Ds_institucional)
    ->
    reply_html_page(
        boot5rest,
        [ title('Editar institucional')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Editar institucional'),
                \form_institucional(Cd_institucional, Tl_institucional, Ds_institucional)
              ]) ])
    ; throw(http_reply(not_found(Cd_institucional)))
    ).

form_institucional(Cd_institucional, Tl_institucional, Ds_institucional) -->
    html(form([ id('institucional-form'),
                onsubmit("redirecionaResposta( event, '/institucional' )"),
                action('/api/v1/institucional/~w' - Cd_institucional) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(cd_institucional, 'Id', text, Cd_institucional),
                \campo(tl_institucional, 'Nome da instituição: ', text, Tl_institucional),
                \campo(ds_institucional, 'Descrição da instituição: ', text, Ds_institucional),
                \enviar_ou_cancelar('/institucional')
              ])).