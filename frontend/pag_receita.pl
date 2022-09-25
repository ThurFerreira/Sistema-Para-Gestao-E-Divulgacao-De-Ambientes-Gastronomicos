:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).

pagina_receita(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Receita')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                \tabela_receita,
                \cadastro_botao('/receita/cadastro'),
                \voltar_botao('/')
              ]) ]).

tabela_receita -->
    html(div(class('container'),
             [
               \tabelas_receita
             ]
            )).

tabelas_receita -->
    html( table(class('table'),
                   [ \cabecalho_receita,
                     tbody( \corpo_tabela_receita)
                   ])).

cabecalho_receita -->
    html(thead(tr([ th([scope(col), style='background-color: #04AA6D;  color: white;'], '#'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Nome da receita:'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Descrição da receita:'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Data da receita:'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Ações')
                  ]))).

corpo_tabela_receita -->
    {
        findall( tr([th(scope(row), Cd_receita), td(Tl_receita), td(Ds_receita), td(Dt_receita), td(Acao)]),
          linha_receita(Cd_receita, Tl_receita, Ds_receita, Dt_receita,Acao),
          Linhas)
    },
    html(Linhas).

linha_receita(Cd_receita, Tl_receita, Ds_receita, Dt_receita, Acao):-
    receita:receita(Cd_receita, Tl_receita, Ds_receita, Dt_receita),
    acoes_receita(Cd_receita, Acao).

acoes_receita(Cd_receita, Campo):-
    Campo = [ a([
                  href('/receita/editar/~w' - Cd_receita),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([
                  href('/api/v1/receita/~w' - Cd_receita),
                  onClick("apagar( event, '/receita' )"),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].    

cadastro_receita(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro de receita')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Cadastro de receita'),
                \form_receita
              ]) ]).      

form_receita -->
    html(form([ id('receita-form'),
                onsubmit("redirecionaResposta( event, '/receita' )"),
                action('/api/v1/receita/') ],
              [ \metodo_de_envio('POST'),
                \campo(tl_receita, 'Nome da receita: ', text),
                \campo(ds_receita, 'Descrição da receita: ', text),
                \campo(dt_receita, 'Data da receita: ', date),
                \enviar_ou_cancelar('/receita')
              ])).         

editar_receita(AtomId, _Pedido):-
    atom_number(AtomId, Cd_receita),
    ( receita:receita(Cd_receita, Tl_receita, Ds_receita,Dt_receita)
    ->
    reply_html_page(
        boot5rest,
        [ title('Editar receita')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Editar receita'),
                \form_receita(Cd_receita, Tl_receita, Ds_receita,Dt_receita)
              ]) ])
    ; throw(http_reply(not_found(Cd_receita)))
    ).

form_receita(Cd_receita, Tl_receita, Ds_receita,Dt_receita) -->
    html(form([ id('receita-form'),
                onsubmit("redirecionaResposta( event, '/receita' )"),
                action('/api/v1/receita/~w' - Cd_receita) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(cd_receita, 'Id', text, Cd_receita),
                \campo(tl_receita, 'Nome da receita: ', text, Tl_receita),
                \campo(ds_receita, 'Descrição da receita: ', text, Ds_receita),
                \campo(dt_receita, 'Data da receita: ', text, Dt_receita),
                \enviar_ou_cancelar('/receita')
              ])).