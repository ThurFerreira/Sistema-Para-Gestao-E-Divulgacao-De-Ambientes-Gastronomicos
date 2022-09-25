:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_path)).
:- ensure_loaded(caminhos).

/***********************************
 *                                 *
 *      Rotas do Servidor Web      *
 *                                 *
 ***********************************/

:- multifile http:location/3.
:- dynamic   http:location/3.

http:location(img, root(img), []).
http:location(api, root(api), []).
http:location(api1, api(v1), []).

/**************************
 *                        *
 *      Tratadores        *
 *                        *
 **************************/

% Recursos estáticos
:- http_handler( css(.),
                 serve_files_in_directory(dir_css), [prefix]).
:- http_handler( img(.),
                 serve_files_in_directory(dir_img), [prefix]).
:- http_handler( js(.),
                 serve_files_in_directory(dir_js),  [prefix]).

% Rotas do Frontend
:- http_handler(root(.), index, []).

:- http_handler(root(estado), pag_estado:pagina_estado, []).
:- http_handler(root(estado/cadastro), pag_estado:cadastro_estado, []).
:- http_handler(root(estado/editar/Id), pag_estado:editar_estado(Id), []).

:- http_handler(root(cidade), pag_cidade:pagina_cidade, []).
:- http_handler(root(cidade/cadastro), pag_cidade:cadastro_cidade, []).
:- http_handler(root(cidade/editar/Id), pag_cidade:editar_cidade(Id), []).

:- http_handler(root(cadastro), pag_cadastro:pagina_cadastro, []).
:- http_handler(root(cadastro/cadastro), pag_cadastro:cadastro_cadastro, []).
:- http_handler(root(cadastro/editar/Id), pag_cadastro:editar_cadastro(Id), []).

:- http_handler(root(status), pag_status:pagina_status, []).
:- http_handler(root(status/cadastro), pag_status:cadastro_status, []).
:- http_handler(root(status/editar/Id), pag_status:editar_status(Id), []).

:- http_handler(root(nivel), pag_nivel:pagina_nivel, []).
:- http_handler(root(nivel/cadastro), pag_nivel:cadastro_nivel, []).
:- http_handler(root(nivel/editar/Id), pag_nivel:editar_nivel(Id), []).

:- http_handler(root(boteco), pag_boteco:pagina_boteco, []).
:- http_handler(root(boteco/cadastro), pag_boteco:cadastro_boteco, []).
:- http_handler(root(boteco/editar/Id), pag_boteco:editar_boteco(Id), []).

:- http_handler(root(video), pag_video:pagina_video, []).
:- http_handler(root(video/cadastro), pag_video:cadastro_video, []).
:- http_handler(root(video/editar/Id), pag_video:editar_video(Id), []).

:- http_handler(root(foto), pag_foto:pagina_foto, []).
:- http_handler(root(foto/cadastro), pag_foto:cadastro_foto, []).
:- http_handler(root(foto/editar/Id), pag_foto:editar_foto(Id), []).

:- http_handler(root(personalidade), pag_personalidade:pagina_personalidade, []).
:- http_handler(root(personalidade/cadastro), pag_personalidade:cadastro_personalidade, []).
:- http_handler(root(personalidade/editar/Id), pag_personalidade:editar_personalidade(Id), []).

:- http_handler(root(categoria), pag_categoria:pagina_categoria, []).
:- http_handler(root(categoria/cadastro), pag_categoria:cadastro_categoria, []).
:- http_handler(root(categoria/editar/Id), pag_categoria:editar_categoria(Id), []).

:- http_handler(root(institucional), pag_institucional:pagina_institucional, []).
:- http_handler(root(institucional/cadastro), pag_institucional:cadastro_institucional, []).
:- http_handler(root(institucional/editar/Id), pag_institucional:editar_institucional(Id), []).

:- http_handler(root(receita), pag_receita:pagina_receita, []).
:- http_handler(root(receita/cadastro), pag_receita:cadastro_receita, []).
:- http_handler(root(receita/editar/Id), pag_receita:editar_receita(Id), []).

% Rotas API         
:- http_handler( api1(estado/Id), estado(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).

:- http_handler( api1(cidade/Id), cidade(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).

:- http_handler( api1(cadastro/Id), cadastro(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).

:- http_handler( api1(status/Id), status(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).

:- http_handler( api1(nivel/Id), nivel(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).

:- http_handler( api1(boteco/Id), boteco(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).

:- http_handler( api1(video/Id), video(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).

:- http_handler( api1(foto/Id), foto(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).

:- http_handler( api1(personalidade/Id), personalidade(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).

:- http_handler( api1(categoria/Id), categoria(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).

:- http_handler( api1(institucional/Id), institucional(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).

:- http_handler( api1(receita/Id), receita(Metodo, Id),
                 [ method(Metodo),
                   methods([ get, post, put, delete ]) ]).