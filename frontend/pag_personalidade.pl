:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).

pagina_personalidade(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Personalidades')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                \tabela_personalidade,
                \cadastro_botao('/personalidade/cadastro'),
                \voltar_botao('/')
              ]) ]).

tabela_personalidade -->
    html(div(class('container'),
             [
               \tabelas_personalidade
             ]
            )).

tabelas_personalidade -->
    html( table(class('table'),
                   [ \cabecalho_personalidade,
                     tbody( \corpo_tabela_personalidade)
                   ])).

cabecalho_personalidade -->
    html(thead(tr([ th([scope(col), style='background-color: #04AA6D;  color: white;'], '#'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Cod. Boteco'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Nome personalidade'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Descrição personalidade'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Ações')
                  ]))).

corpo_tabela_personalidade -->
    {
        findall( tr([th(scope(row), Cd_personalidade), td(Cd_boteco), td(Nm_personalidade), td(Ds_personalidade), td(Acao)]),
          linha_personalidade(Cd_personalidade, Cd_boteco, Nm_personalidade, Ds_personalidade, Acao),
          Linhas)
    },
    html(Linhas).

linha_personalidade(Cd_personalidade, Cd_boteco, Nm_personalidade, Ds_personalidade, Acao):-
    personalidade:personalidade(Cd_personalidade, Cd_boteco, Nm_personalidade, Ds_personalidade),
    acoes_personalidade(Cd_personalidade, Acao).

acoes_personalidade(Cd_personalidade, Campo):-
    Campo = [ a([
                  href('/personalidade/editar/~w' - Cd_personalidade),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([
                  href('/api/v1/personalidade/~w' - Cd_personalidade),
                  onClick("apagar( event, '/personalidade' )"),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].    

cadastro_personalidade(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro de personalidade')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Cadastro de personalidade'),
                \form_personalidade
              ]) ]).      

form_personalidade -->
    html(form([ id('personalidade-form'),
                onsubmit("redirecionaResposta( event, '/personalidade' )"),
                action('/api/v1/personalidade/') ],
              [ \metodo_de_envio('POST'),
                \campo(cd_boteco, 'Código do boteco: ', number),
                \campo(nm_personalidade, 'Nome personalidade: ', text),
                \campo(ds_personalidade, 'Descrição personalidade: ', text),
                \enviar_ou_cancelar('/personalidade')
              ])).         

editar_personalidade(AtomId, _Pedido):-
    atom_number(AtomId, Cd_personalidade),
    ( personalidade:personalidade(Cd_personalidade, Cd_boteco, Nm_personalidade, Ds_personalidade)
    ->
    reply_html_page(
        boot5rest,
        [ title('Editar personalidade')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Editar personalidade'),
                \form_personalidade(Cd_personalidade, Cd_boteco, Nm_personalidade, Ds_personalidade)
              ]) ])
    ; throw(http_reply(not_found(Cd_personalidade)))
    ).

form_personalidade(Cd_personalidade, Cd_boteco, Nm_personalidade, Ds_personalidade) -->
    html(form([ id('personalidade-form'),
                onsubmit("redirecionaResposta( event, '/personalidade' )"),
                action('/api/v1/personalidade/~w' - Cd_personalidade) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(cd_personalidade, 'Id', text, Cd_personalidade),
                \campo(cd_boteco, 'Código do boteco: ', number, Cd_boteco),
                \campo(nm_personalidade, 'Nome personalidade: ', text, Nm_personalidade),
                \campo(ds_personalidade, 'Descrição personalidade: ', text, Ds_personalidade),
                \enviar_ou_cancelar('/personalidade')
              ])).