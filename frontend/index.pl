:- use_module(library(http/html_write)).
:- use_module(library(http/html_head)).

% :- ensure_loaded(gabarito(boot5rest)).

index(_):-
    reply_html_page(
        boot5rest,
        [ title('Sistema')],
        [ /*\html_requires(css('bootstrap.min.css')),
          \html_requires(js('bootstrap.bundle.min.js')),*/
          \homepage
              ]).

homepage -->
    html([  
    div(style('background-color: rgb(40, 116, 166) ; position: fixed ; width:100% ; margin: 0px ; padding: 0px'), [
        div(
          [style('display:flex ; text-decoration: none ; background-color: rgb(21, 67, 96) ; font-size:20px')], 
          [a([style('padding-left:18px ; text-decoration: none ; color:white'), href(estado)], 'Estado'),
            a([style('padding-left:18px ; text-decoration: none ; color:white'), href(cidade)], 'Cidade'),
            a([style('padding-left:18px ; text-decoration: none ; color:white'), href(cadastro)], 'Cadastro'),
            a([style('padding-left:18px ; text-decoration: none ; color:white'), href(status)], 'Status'),
            a([style('padding-left:18px ; text-decoration: none ; color:white'), href(nivel)], 'Nivel'),
            a([style('padding-left:18px ; text-decoration: none ; color:white'), href(boteco)], 'Boteco'),
            a([style('padding-left:18px ; text-decoration: none ; color:white'), href(video)], 'Vídeo'),
            a([style('padding-left:18px ; text-decoration: none ; color:white'), href(foto)], 'Foto'),
            a([style('padding-left:18px ; text-decoration: none ; color:white'), href(personalidade)], 'Personalidade'),
            a([style('padding-left:18px ; text-decoration: none ; color:white'), href(categoria)], 'Categoria'),
            a([style('padding-left:18px ; text-decoration: none ; color:white'), href(institucional)], 'Institucional'),
            a([style('padding-left:18px ; text-decoration: none ; color:white'), href(receita)], 'Receita')
            ])]),
          %img('fundo.webp')
          img([src('https://imgcy.trivago.com/c_lfill,f_auto,g_faces,q_auto:good,w_1638/mag/sites/13/2016/05/11123520/bares-terracos-de-paris-HOLIDAY-INN-vista.jpg'), alt('Ambiente Gastronomico desfocado'), width('100%'), height('100%'), style('marin: 0px ; padding 0px')], []) 
         ]).
