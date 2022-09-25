% Carrega o servidor e as rotas
:- load_files([ servidor, rotas ],
              [ silent(true), if(not_loaded) ]).


:- initialization( servidor(8000) ).

% Carrega o frontend
:- load_files([ gabarito(bootstrap5),
                gabarito(boot5rest), 
                frontend(icons),
                frontend(index),
                frontend(pag_estado),
                frontend(pag_cidade),
                frontend(pag_cadastro),
                frontend(pag_status),
                frontend(pag_nivel),
                frontend(pag_boteco),
                frontend(pag_video),
                frontend(pag_foto),
                frontend(pag_personalidade),
                frontend(pag_categoria),
                frontend(pag_institucional),
                frontend(pag_receita)
              ],
              [ silent(true), if(not_loaded) ]).


% Carrega o backend
:- load_files([ 
                api1(estado),
                api1(cidade),
                api1(cadastro),
                api1(status),
                api1(nivel),
                api1(boteco),
                api1(video),
                api1(foto),
                api1(personalidade),
                api1(categoria),
                api1(institucional),
                api1(receita)
              ],
              [ silent(true), if(not_loaded) ]).
