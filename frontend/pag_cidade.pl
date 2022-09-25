:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).

pagina_cidade(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cidades')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                \tabela_cidade,
                \cadastro_botao('/cidade/cadastro'),
                \voltar_botao('/')
              ]) ]).

tabela_cidade -->
    html(div(class('container'),
             [
               \tabelas_cidade
             ]
            )).

tabelas_cidade -->
    html( table(class('table'),
                   [ \cabecalho_cidade,
                     tbody( \corpo_tabela_cidade)
                   ])).

cabecalho_cidade -->
    html(thead(tr([ th([scope(col), style='background-color: #04AA6D;  color: white;'], '#'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Cod. Estado'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Nome cidade'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Ações')
                  ]))).

corpo_tabela_cidade -->
    {
        findall( tr([th(scope(row), Cd_cidade), td(Cd_estado), td(Tl_cidade), td(Acao)]),
          linha_cidade(Cd_cidade, Tl_cidade, Cd_estado, Acao),
          Linhas)
    },
    html(Linhas).

linha_cidade(Cd_cidade, Tl_cidade, Cd_estado, Acao):-
    cidade:cidade(Cd_cidade, Tl_cidade, Cd_estado),
    acoes_cidade(Cd_cidade, Acao).

acoes_cidade(Cd_cidade, Campo):-
    Campo = [ a([
                  href('/cidade/editar/~w' - Cd_cidade),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([
                  href('/api/v1/cidade/~w' - Cd_cidade),
                  onClick("apagar( event, '/cidade' )"),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].    

cadastro_cidade(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro de cidade')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Cadastro de cidade'),
                \form_cidade
              ]) ]).      

form_cidade -->
    html(form([ id('cidade-form'),
                onsubmit("redirecionaResposta( event, '/cidade' )"),
                action('/api/v1/cidade/') ],
              [ \metodo_de_envio('POST'),
                \campo(tl_cidade, 'Nome da cidade: ', text),
                \campo(cd_estado, 'Código do estado: ', text),
                \enviar_ou_cancelar('/cidade')
              ])).         

editar_cidade(AtomId, _Pedido):-
    atom_number(AtomId, Cd_cidade),
    ( cidade:cidade(Cd_cidade, Tl_cidade, Cd_estado)
    ->
    reply_html_page(
        boot5rest,
        [ title('Editar cidade')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Editar cidade'),
                \form_cidade(Cd_cidade, Tl_cidade, Cd_estado)
              ]) ])
    ; throw(http_reply(not_found(Cd_cidade)))
    ).

form_cidade(Cd_cidade, Tl_cidade, Cd_estado) -->
    html(form([ id('cidade-form'),
                onsubmit("redirecionaResposta( event, '/cidade' )"),
                action('/api/v1/cidade/~w' - Cd_cidade) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(cd_estado, 'Id', text, Cd_cidade),
                \campo(tl_cidade, 'Nome da cidade: ', text, Tl_cidade),
                \campo(cd_estado, 'Código do estado: ', text, Cd_estado),
                \enviar_ou_cancelar('/cidade')
              ])).