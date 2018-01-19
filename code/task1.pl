:- style_check(-singleton).
closing(Out,0):- write(Out,'.').
closing(Out,Count):- Coun is Count - 1, write(Out,')'), closing(Out,Coun).

finish_level_0(X,Id,In,Out) :- 	X == end_of_file,
                                write(Out,'end'), 
                                closing(Out,Id),!.

finish_level_0(X,Id,In,Out) :-  Id_New is Id + 1,
                                write(Out,'db('), write(Out,Id_New), write(Out,',0,0,'), write(Out,X), write(Out,','),
                                read(In,Y),
                                finish_level_0(Y,Id_New,In,Out).

start_level_zero(F) :- 	open(F,read,In),
                        read(In,X),
                        open('Users/jazpurc/Documents/YorkU/EECS4401/assignment4/aux',write,Out),
                        write(Out,'db(1,0,0,'),write(Out,X),write(Out,','),
                        read(In,Y),
                        finish_level_0(Y,1,In,Out),
                        close(In),
                        close(Out),
                        /*------------------------ print rest of the list ------------------------*/
                        open('Users/jazpurc/Documents/YorkU/EECS4401/assignment4/aux',read,InHandle),
                        read(InHandle,DB),
                        open('Users/jazpurc/Documents/YorkU/EECS4401/assignment4/level0',write,OutWrite),
                        write(OutWrite,DB),write(OutWrite,'.'),write(OutWrite,'\n'),
                        close(OutWrite),
                        open('Users/jazpurc/Documents/YorkU/EECS4401/assignment4/level0',append,OutHandle),
                        remove_head(DB,Rest),
                        print_remaining(OutHandle,Rest),
                        close(InHandle),close(OutHandle),
                        delete_file('Users/jazpurc/Documents/YorkU/EECS4401/assignment4/aux').

remove_head(db(_,_,_,_,Next),Next).
print_remaining(OutHandle,end).
print_remaining(OutHandle,DB) :-  write(OutHandle,DB),write(OutHandle,'.'),write(OutHandle,'\n'),
                                  remove_head(DB,Next),
                                  print_remaining(OutHandle,Next),!.
