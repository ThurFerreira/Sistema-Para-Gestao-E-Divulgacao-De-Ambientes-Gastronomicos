:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).

pagina_cadastro(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastros')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                \tabela_cadastro,
                \cadastro_botao('/cadastro/cadastro'),
                \voltar_botao('/')
              ]) ]).

tabela_cadastro -->
    html(div(class('container'),
             [
               \tabelas_cadastro
             ]
            )).

tabelas_cadastro -->
    html( table(class('table'),
                   [ \cabecalho_cadastro,
                     tbody( \corpo_tabela_cadastro)
                   ])).

cabecalho_cadastro -->
    html(thead(tr([ th([scope(col), style='background-color: #04AA6D;  color: white;'], '#'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Cod. Cidade'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Nome'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Email'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Telefone'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Data de nascimento'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Data de cadastro'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Sexo'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Receber notícias'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Ações')
                  ]))).

corpo_tabela_cadastro -->
    {
        findall( tr([th(scope(row), Cd_cadastro), td(Cd_cidade), td(Nm_cadastro),  td(Ds_email),  td(Ds_telefone),  td(Dt_nascimento),  td(Dt_cadastro),  td(Fl_sexo),  td(Fl_recnot), td(Acao)]),
          linha_cadastro(Cd_cadastro, Cd_cidade, Nm_cadastro, Ds_email, Ds_telefone, Dt_nascimento, Dt_cadastro, Fl_sexo, Fl_recnot, Acao),
          Linhas)
    },
    html(Linhas).

linha_cadastro(Cd_cadastro, Cd_cidade, Nm_cadastro, Ds_email, Ds_telefone, Dt_nascimento, Dt_cadastro, Fl_sexo, Fl_recnot, Acao):-
    cadastro:cadastro(Cd_cadastro, Cd_cidade, Nm_cadastro, Ds_email, Ds_telefone, Dt_nascimento, Dt_cadastro, Fl_sexo, Fl_recnot),
    acoes_cadastro(Cd_cadastro, Acao).

acoes_cadastro(Cd_cadastro, Campo):-
    Campo = [ a([
                  href('/cadastro/editar/~w' - Cd_cadastro),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([
                  href('/api/v1/cadastro/~w' - Cd_cadastro),
                  onClick("apagar( event, '/cadastro' )"),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].    

cadastro_cadastro(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro de Usuários')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Cadastro de Usuários'),
                \form_cadastro
              ]) ]).      


form_cadastro -->
    html(form([ id('cadastro-form'),
                onsubmit("redirecionaResposta( event, '/cadastro' )"),
                action('/api/v1/cadastro/') ],
              [ \metodo_de_envio('POST'),
                \campo(cd_cidade, 'Código da cidade: ', number),
                \campo(nm_cadastro, 'Nome: ', text),
                \campo(ds_email, 'Email: ', email),
                \campo(ds_telefone, 'Telefone: ', number),
                \campo(dt_nascimento, 'Data de nascimento: ', date),
                \campo(dt_cadastro, 'Data de cadastro: ', date),
                \campo(fl_sexo, 'Sexo: ', text),
                \campo(fl_recnot, 'Receber noticias?: ', text),
                \enviar_ou_cancelar('/cadastro')
              ])).         

editar_cadastro(AtomId, _Pedido):-
    atom_number(AtomId, Cd_cadastro),
    ( cadastro:cadastro(Cd_cadastro, Cd_cidade, Nm_cadastro, Ds_email, Ds_telefone, Dt_nascimento, Dt_cadastro, Fl_sexo, Fl_recnot)
    ->
    reply_html_page(
        boot5rest,
        [ title('Editar cadastro')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Editar cadastro'),
                \form_cadastro(Cd_cadastro, Cd_cidade, Nm_cadastro, Ds_email, Ds_telefone, Dt_nascimento, Dt_cadastro, Fl_sexo, Fl_recnot)
              ]) ])
    ; throw(http_reply(not_found(Cd_cadastro)))
    ).

form_cadastro(Cd_cadastro, Cd_cidade, Nm_cadastro, Ds_email, Ds_telefone, Dt_nascimento, Dt_cadastro, Fl_sexo, Fl_recnot) -->
    html(form([ id('cadastro-form'),
                onsubmit("redirecionaResposta( event, '/cadastro' )"),
                action('/api/v1/cadastro/~w' - Cd_cadastro) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(cd_estado, 'Id', text, Cd_cadastro),
                \campo(cd_cidade, 'Código da cidade: ', text, Cd_cidade),
                \campo(nm_cadastro, 'Nome: ', text, Nm_cadastro),
                \campo(ds_email, 'Email: ', email, Ds_email),
                \campo(ds_telefone, 'Telefone: ', number, Ds_telefone),
                \campo(dt_nascimento, 'Data de nascimento: ', date, Dt_nascimento),
                \campo(dt_cadastro, 'Data de cadastro: ', date, Dt_cadastro),
                \campo(fl_sexo, 'Sexo: ', text, Fl_sexo),
                \campo(fl_recnot, 'Receber noticias?: ', text, Fl_recnot),
                \enviar_ou_cancelar('/cadastro')
              ])).