:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).

pagina_categoria(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Categorias')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                \tabela_categoria,
                \cadastro_botao('/categoria/cadastro'),
                \voltar_botao('/')
              ]) ]).

tabela_categoria -->
    html(div(class('container'),
             [
               \tabelas_categoria
             ]
            )).

tabelas_categoria -->
    html( table(class('table'),
                   [ \cabecalho_categoria,
                     tbody( \corpo_tabela_categoria)
                   ])).

cabecalho_categoria -->
    html(thead(tr([ th([scope(col), style='background-color: #04AA6D;  color: white;'], '#'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Nome categoria:'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Ações')
                  ]))).

corpo_tabela_categoria -->
    {
        findall( tr([th(scope(row), Cd_categoria), td(Tl_categoria), td(Acao)]),
          linha_categoria(Cd_categoria, Tl_categoria, Acao),
          Linhas)
    },
    html(Linhas).

linha_categoria(Cd_categoria, Tl_categoria, Acao):-
    categoria:categoria(Cd_categoria, Tl_categoria),
    acoes_categoria(Cd_categoria, Acao).

acoes_categoria(Cd_categoria, Campo):-
    Campo = [ a([
                  href('/categoria/editar/~w' - Cd_categoria),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([
                  href('/api/v1/categoria/~w' - Cd_categoria),
                  onClick("apagar( event, '/categoria' )"),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].    

cadastro_categoria(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro de categoria')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Cadastro de categoria'),
                \form_categoria
              ]) ]).      

form_categoria -->
    html(form([ id('categoria-form'),
                onsubmit("redirecionaResposta( event, '/categoria' )"),
                action('/api/v1/categoria/') ],
              [ \metodo_de_envio('POST'),
                \campo(tl_categoria, 'Nome da categoria: ', text),
                \enviar_ou_cancelar('/categoria')
              ])).         

editar_categoria(AtomId, _Pedido):-
    atom_number(AtomId, Cd_categoria),
    ( categoria:categoria(Cd_categoria, Tl_categoria)
    ->
    reply_html_page(
        boot5rest,
        [ title('Editar categoria')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Editar categoria'),
                \form_categoria(Cd_categoria, Tl_categoria)
              ]) ])
    ; throw(http_reply(not_found(Cd_categoria)))
    ).

form_categoria(Cd_categoria, Tl_categoria) -->
    html(form([ id('categoria-form'),
                onsubmit("redirecionaResposta( event, '/categoria' )"),
                action('/api/v1/categoria/~w' - Cd_categoria) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(cd_categoria, 'Id', text, Cd_categoria),
                \campo(tl_categoria, 'Nome da categoria: ', text, Tl_categoria),
                \enviar_ou_cancelar('/categoria')
              ])).