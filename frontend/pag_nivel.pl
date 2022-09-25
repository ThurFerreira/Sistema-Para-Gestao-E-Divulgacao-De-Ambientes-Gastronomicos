:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).

pagina_nivel(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Nivel')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                \tabela_nivel,
                \cadastro_botao('/nivel/cadastro'),
                \voltar_botao('/')
              ]) ]).

tabela_nivel -->
    html(div(class('container'),
             [
               \tabelas_nivel
             ]
            )).

tabelas_nivel -->
    html( table(class('table'),
                   [ \cabecalho_nivel,
                     tbody( \corpo_tabela_nivel)
                   ])).

cabecalho_nivel -->
    html(thead(tr([ th([scope(col), style='background-color: #04AA6D;  color: white;'], '#'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Nome nivel:'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Ações')
                  ]))).

corpo_tabela_nivel -->
    {
        findall( tr([th(scope(row), Cd_nivel), td(Tl_nivel), td(Acao)]),
          linha_nivel(Cd_nivel, Tl_nivel, Acao),
          Linhas)
    },
    html(Linhas).

linha_nivel(Cd_nivel, Tl_nivel, Acao):-
    nivel:nivel(Cd_nivel, Tl_nivel),
    acoes_nivel(Cd_nivel, Acao).

acoes_nivel(Cd_nivel, Campo):-
    Campo = [ a([
                  href('/nivel/editar/~w' - Cd_nivel),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([
                  href('/api/v1/nivel/~w' - Cd_nivel),
                  onClick("apagar( event, '/nivel' )"),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].    

cadastro_nivel(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro de nivel')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Cadastro de nivel'),
                \form_nivel
              ]) ]).      

form_nivel -->
    html(form([ id('nivel-form'),
                onsubmit("redirecionaResposta( event, '/nivel' )"),
                action('/api/v1/nivel/') ],
              [ \metodo_de_envio('POST'),
                \campo(tl_nivel, 'Nome do nivel: ', text),
                \enviar_ou_cancelar('/nivel')
              ])).         

editar_nivel(AtomId, _Pedido):-
    atom_number(AtomId, Cd_nivel),
    ( nivel:nivel(Cd_nivel, Tl_nivel)
    ->
    reply_html_page(
        boot5rest,
        [ title('Editar nivel')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Editar nivel'),
                \form_nivel(Cd_nivel, Tl_nivel)
              ]) ])
    ; throw(http_reply(not_found(Cd_nivel)))
    ).

form_nivel(Cd_nivel, Tl_nivel) -->
    html(form([ id('nivel-form'),
                onsubmit("redirecionaResposta( event, '/nivel' )"),
                action('/api/v1/nivel/~w' - Cd_nivel) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(cd_nivel, 'Id', text, Cd_nivel),
                \campo(tl_nivel, 'Nome do nivel: ', text, Tl_nivel),
                \enviar_ou_cancelar('/nivel')
              ])).