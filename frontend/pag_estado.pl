:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).

pagina_estado(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Estados')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                \tabela_estado,
                \cadastro_botao('/estado/cadastro'),
                \voltar_botao('/')
              ]) ]).
  
cadastro_botao(Link) --> 
    html(div(a([ style='background-color: #555555; border: none;  color: white;  padding: 15px 32px;  text-align: center;  text-decoration: none;  display: inline-block;  font-size: 16px;' ,href(Link)],'Cadastrar'))).

voltar_botao(Link) --> 
    html(div(a([ style='background-color: #008CBA; border: none;  color: white;  padding: 15px 32px;  text-align: center;  text-decoration: none;  display: inline-block;  font-size: 16px;' ,href(Link)],'Voltar'))).

tabela_estado -->
    html(div(class('container'),
             [
               \tabelas_estado
             ]
            )).

tabelas_estado -->
    html( table(class('table'),
                   [ \cabecalho_estado,
                     tbody( \corpo_tabela_estado)
                   ])).

cabecalho_estado -->
    html(thead(tr([ th([scope(col), style='background-color: #04AA6D;  color: white;'], '#'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Nome do estado'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Sigla do estado'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Ações')
                  ]))).

corpo_tabela_estado -->
    {
        findall( tr([th(scope(row), Cd_estado), td(Nm_estado), td(Sg_estado), td(Acao)]),
          linha_estado(Cd_estado, Nm_estado, Sg_estado, Acao),
          Linhas)
    },
    html(Linhas).

linha_estado(Cd_estado, Nm_estado, Sg_estado, Acao):-
    estado:estado(Cd_estado, Nm_estado, Sg_estado),
    acoes_estado(Cd_estado, Acao).

acoes_estado(Cd_estado, Campo):-
    Campo = [ a([
                  href('/estado/editar/~w' - Cd_estado),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([
                  href('/api/v1/estado/~w' - Cd_estado),
                  onClick("apagar( event, '/estado' )"),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].    

cadastro_estado(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro de estado')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Cadastro de estado'),
                \form_estado
              ]) ]).      

form_estado -->
    html(form([ id('estado-form'),
                onsubmit("redirecionaResposta( event, '/estado' )"),
                action('/api/v1/estado/') ],
              [ \metodo_de_envio('POST'),
                \campo(nm_estado, 'Nome do Estado: ', text),
                \campo(sg_estado, 'Sigla do Estado: ', text),
                \enviar_ou_cancelar('/estado')
              ])).         

enviar_ou_cancelar(RotaDeRetorno) -->
    html(div([ class('btn-group'), role(group), ('Enviar ou cancelar')],
             [ button([ type(submit),
                        style='background-color: #4CAF50; border: none;  color: white;  padding: 15px 32px;  text-align: center;  text-decoration: none;  display: inline-block;  font-size: 16px;' ], 'Enviar'),
               a([ href(RotaDeRetorno), style='background-color: #FF0000; border: none;  color: white;  padding: 15px 32px;  text-align: center;  text-decoration: none;  display: inline-block;  font-size: 16px;' ], 'Cancelar')
            ])).

campo(Nome, Rotulo, Tipo) -->
    html(div(class('mb-3'),
             [ label([ for(Nome), class('form-label') ], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome), name(Nome)])
             ] )).

editar_estado(AtomId, _Pedido):-
    atom_number(AtomId, Cd_estado),
    ( estado:estado(Cd_estado, Nm_estado, Sg_estado)
    ->
    reply_html_page(
        boot5rest,
        [ title('Editar estado')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Editar estado'),
                \form_estado(Cd_estado, Nm_estado, Sg_estado)
              ]) ])
    ; throw(http_reply(not_found(Cd_estado)))
    ).

form_estado(Cd_estado, Nm_estado, Sg_estado) -->
    html(form([ id('estado-form'),
                onsubmit("redirecionaResposta( event, '/estado' )"),
                action('/api/v1/estado/~w' - Cd_estado) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(cd_estado, 'Id', text, Cd_estado),
                \campo(nm_estado, 'Nome do Estado: ', text, Nm_estado),
                \campo(sg_estado, 'Sigla do Estado: ', text, Sg_estado),
                \enviar_ou_cancelar('/estado')
              ])).

campo(Nome, Rotulo, Tipo, Valor) -->
    html(div(class('mb-4'),
             [ label([ for(Nome), class('form-label')], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome), name(Nome), value(Valor)])
             ] )).

campo_nao_editavel(Nome, Rotulo, Tipo, Valor) -->
    html(div(class('mb-4 w-100'),
             [ label([ for(Nome), class('form-label')], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome),
                       value(Valor),
                       readonly ])
             ] )).

metodo_de_envio(Metodo) -->
    html(input([type(hidden), name('_método'), value(Metodo)])).