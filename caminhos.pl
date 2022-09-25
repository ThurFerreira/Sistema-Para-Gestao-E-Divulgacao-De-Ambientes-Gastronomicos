/**************************************************************
 *                                                            *
 *      Localização dos diretórios no sistema de arquivos     *
 *                                                            *
 **************************************************************/

:- multifile user:file_search_path/2.

% Diretório principal do servidor
user:file_search_path(dir_base, '/home/vm/Documentos/Prolog').

% Diretório do projeto
user:file_search_path(projeto, dir_base(trabalhoFinal)).

% Diretório de configuração
user:file_search_path(config, projeto(config)).

%% Front-end
user:file_search_path(frontend, projeto(frontend)).

%% Recursos estáticos
user:file_search_path(dir_css, frontend(css)).
user:file_search_path(dir_js,  frontend(js)).
user:file_search_path(dir_img, frontend(img)).
% Gabaritos para estilização
user:file_search_path(gabarito, frontend(gabaritos)).


%% Backend
user:file_search_path(backend, projeto(backend)).


% Banco de dados
user:file_search_path(bd, backend(bd)).
user:file_search_path(bd_tabs, bd(tabelas)).

% API REST
user:file_search_path(api,  backend(api)).
user:file_search_path(api1, api(v1)).
