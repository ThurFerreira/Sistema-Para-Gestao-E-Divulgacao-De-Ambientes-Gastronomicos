:- module(
  video, 
  [ carrega_tab/1,
	video/4,
    insere/4,
    remove/1,
    atualiza/4  ]
).

:- use_module(library(persistency)).
:- use_module(boteco, []).

:- persistent
	video(cd_video: positive_integer,
		cd_boteco: positive_integer,
		tl_video: text,
		ds_link: text).


carrega_tab(ArqTabela):- db_attach(ArqTabela, []).

:- initialization( at_halt(db_sync(gc(always))) ).

insere(Cd_video, Cd_boteco, Tl_video, Ds_link):-
	boteco:boteco(Cd_boteco, _, _,_,_,_,_,_,_,_),
	chave:pk(video, Cd_video),
	with_mutex(video,
		assert_video(Cd_video, Cd_boteco, Tl_video, Ds_link)).

remove(Cd_video):-
	with_mutex(video,
	retractall_video(Cd_video, _Cd_boteco, _Tl_video, _Ds_link)).

atualiza(Cd_video, Cd_boteco, Tl_video, Ds_link):-
	video(Cd_video, _,_,_),
	boteco:boteco(Cd_boteco, _,_,_,_,_,_,_,_,_),
	with_mutex(video,
	(retractall_video(Cd_video, _Cd_boteco, _Tl_video, _Ds_link),
	assert_video(Cd_video, Cd_boteco, Tl_video, Ds_link))).
