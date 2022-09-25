:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).

pagina_boteco(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Botecos')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                \tabela_boteco,
                \cadastro_botao('/boteco/cadastro'),
                \voltar_botao('/')
              ]) ]).

tabela_boteco -->
    html(div(class('container'),
             [
               \tabelas_boteco
             ]
            )).

tabelas_boteco -->
    html( table(class('table'),
                   [ \cabecalho_boteco,
                     tbody( \corpo_tabela_boteco)
                   ])).

cabecalho_boteco -->
    html(thead(tr([ th([scope(col), style='background-color: #04AA6D;  color: white;'], '#'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Cod. Status'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Cod. Nível'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Cod. Cidade'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Nome do boteco'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Endereço'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Descrição boteco'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Latitude'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Longitude'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Atualização'),
                    th([scope(col), style='background-color: #04AA6D;  color: white;'], 'Ações')
                  ]))).

corpo_tabela_boteco -->
    {
        findall( tr([th(scope(row), Cd_boteco), td(Cd_status), td(Cd_nivel),  td(Cd_cidade),  td(Tl_boteco),  td(Ds_endereco),  td(Ds_boteco),  td(Ds_latitude),  td(Ds_longitude),  td(Dt_atualizacao), td(Acao)]),
          linha_boteco(Cd_boteco, Cd_status, Cd_nivel, Cd_cidade, Tl_boteco, Ds_endereco, Ds_boteco, Ds_latitude, Ds_longitude, Dt_atualizacao, Acao),
          Linhas)
    },
    html(Linhas).

linha_boteco(Cd_boteco, Cd_status, Cd_nivel, Cd_cidade, Tl_boteco, Ds_endereco, Ds_boteco, Ds_latitude, Ds_longitude, Dt_atualizacao, Acao):-
    boteco:boteco(Cd_boteco, Cd_status, Cd_nivel, Cd_cidade, Tl_boteco, Ds_endereco, Ds_boteco, Ds_latitude, Ds_longitude, Dt_atualizacao),
    acoes_boteco(Cd_boteco, Acao).

acoes_boteco(Cd_boteco, Campo):-
    Campo = [ a([
                  href('/boteco/editar/~w' - Cd_boteco),
                  'data-toggle'(tooltip)],
                [ \lapis ]),
              a([
                  href('/api/v1/boteco/~w' - Cd_boteco),
                  onClick("apagar( event, '/boteco' )"),
                  'data-toggle'(tooltip)],
                [ \lixeira ])
            ].    

cadastro_boteco(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Cadastro de boteco')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Cadastro de boteco'),
                \form_boteco
              ]) ]).      

form_boteco -->
    html(form([ id('boteco-form'),
                onsubmit("redirecionaResposta( event, '/boteco' )"),
                action('/api/v1/boteco/') ],
              [ \metodo_de_envio('POST'),
                \campo(cd_status, 'Código do status: ', number),
                \campo(cd_nivel, 'Código do nível: ', number),
                \campo(cd_cidade, 'Código da cidade: ', number),
                \campo(tl_boteco, 'Nome do boteco: ', text),
                \campo(ds_endereco, 'Endereço: ', text),
                \campo(ds_boteco, 'Descrição do boteco: ', text),
                \campo(ds_latitude, 'Latitude: ', number),
                \campo(ds_longitude, 'Longitude: ', number),
                \campo(dt_atualizacao, 'Nome do boteco: ', date),
                \enviar_ou_cancelar('/boteco')
              ])).         

editar_boteco(AtomId, _Pedido):-
    atom_number(AtomId, Cd_boteco),
    ( boteco:boteco(Cd_boteco, Cd_status, Cd_nivel, Cd_cidade, Tl_boteco, Ds_endereco, Ds_boteco, Ds_latitude, Ds_longitude, Dt_atualizacao)
    ->
    reply_html_page(
        boot5rest,
        [ title('Editar boteco')],
        [ div(class(container),
              [ \html_requires(js('sistema.js')),
                h1('Editar boteco'),
                \form_boteco(Cd_boteco, Cd_status, Cd_nivel, Cd_cidade, Tl_boteco, Ds_endereco, Ds_boteco, Ds_latitude, Ds_longitude, Dt_atualizacao)
              ]) ])
    ; throw(http_reply(not_found(Cd_boteco)))
    ).

form_boteco(Cd_boteco, Cd_status, Cd_nivel, Cd_cidade, Tl_boteco, Ds_endereco, Ds_boteco, Ds_latitude, Ds_longitude, Dt_atualizacao) -->
    html(form([ id('boteco-form'),
                onsubmit("redirecionaResposta( event, '/boteco' )"),
                action('/api/v1/boteco/~w' - Cd_boteco) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(cd_boteco, 'Id', text, Cd_boteco),
                \campo(cd_status, 'Código do status: ', number, Cd_status),
                \campo(cd_nivel, 'Código do nível: ', number, Cd_nivel),
                \campo(cd_cidade, 'Código da cidade: ', number, Cd_cidade),
                \campo(tl_boteco, 'Nome do boteco: ', text, Tl_boteco),
                \campo(ds_endereco, 'Endereço: ', text, Ds_endereco),
                \campo(ds_boteco, 'Descrição do boteco: ', text, Ds_boteco),
                \campo(ds_latitude, 'Latitude: ', number, Ds_latitude),
                \campo(ds_longitude, 'Longitude: ', number, Ds_longitude),
                \campo(dt_atualizacao, 'Data de atualização: ', date, Dt_atualizacao),
                \enviar_ou_cancelar('/boteco')
              ])).
