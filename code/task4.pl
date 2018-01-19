:- style_check(-singleton).
:- [task2].
:- [task1].

closure_1(Out,0):- write(Out,'.').
closure_1(Out,Count):- Coun is Count - 1, write(Out,')'), closure_1(Out,Coun).

first_and_second_level(File) :- open(File,read,In),
								open('Users/jazpurc/Documents/YorkU/EECS4401/assignment4/aux',write,Out),
								read(In,DB),
								return_size_1(DB,Size),
								return_clause_1(DB,C1),
								return_id_1(DB,P1),
								cut_head_1(DB,Rest),
								find_resolvent_1(DB,P1,C1,Rest,Size,Resol,Out),
								close(In),
								close(Out),
								/*------------------------ print rest of the list ------------------------*/
								open('Users/jazpurc/Documents/YorkU/EECS4401/assignment4/aux',read,InHandle),
					  			read(InHandle,NewDB),
					  			open('Users/jazpurc/Documents/YorkU/EECS4401/assignment4/level1',write,OutWrite),
					  			write(OutWrite,NewDB),write(OutWrite,'.'),write(OutWrite,'\n'),
					  			close(OutWrite),
					  			open('Users/jazpurc/Documents/YorkU/EECS4401/assignment4/level1',append,OutHandle),
					  			cut_head_1(NewDB,NewRest),
					  			print_remaining(OutHandle,NewRest),
					  			close(InHandle),close(OutHandle),
				  				second_level('Users/jazpurc/Documents/YorkU/EECS4401/assignment4/level1'),!.

find_resolvent_1(DB,P1,C1,Rest,Size,Resol,Out) :-  	return_id_1(Rest,P2),return_clause_1(Rest,C2),
													try_resolve_1(C1,C2,Resol,None),
													(None == yes -> try_resolve_1(C1,C2,Resol,None), Id is (Size + 1), print_original_DB_1(DB,Out),
													write(Out,db(Id,P1,P2,Resol,end)),
													closure_1(Out,Size);
													cut_head_1(Rest,Next),find_resolvent_1(DB,P1,C1,Next,Size,NewResol,Out)),!.

find_resolvent_1(DB,P1,C1,end,Size,Resol,Out) :-	write(Out,'db('),write(Out,P1),write(Out,',0,0,'),write(Out,C1),write(Out,','),
													cut_head_1(DB,NewDB),
													return_id_1(NewDB,P3),
													return_clause_1(NewDB,C3),
													cut_head_1(NewDB,NewRest),
													(P3 == Size -> write(Out,'db('),write(Out,P3),write(Out,',0,0,'),write(Out,C3),write(Out,',end'),closure_1(Out,P3);
													find_resolvent_1(NewDB,P3,C3,NewRest,Size,NewResol,Out)),!.

try_resolve_1([],C2,Res,None).
try_resolve_1(C1,[],Res,None).
try_resolve_1([X|Rest],C2,Res,yes) :- resolve([X|Rest],C2,X,Res).
try_resolve_1([X|Rest],C2,Res,None) :- 	member(X,C2),try_resolve_1(Rest,C2,Res,None).
try_resolve_1([X|Rest],C2,[X|Res],None) :-	not(member(X,C2)),try_resolve_1(Rest,C2,Res,None).

print_original_DB_1(end,_).
print_original_DB_1(DB,Out) :- 	return_id_1(DB,Id),
								return_par_1(DB,P1,P2),
								return_clause_1(DB,Cl),
								cut_head_1(DB,Next),
								write(Out,'db('),write(Out,Id),write(Out,','),
								write(Out,P1),write(Out,','),write(Out,P2),
								write(Out,','),write(Out,Cl), write(Out,','),
								print_original_DB_1(Next,Out),!.
return_id_1(db(I,_,_,_,_),I).
return_par_1(db(_,P1,P2,_,_),P1,P2).
return_clause_1(db(_,_,_,Cl,_),Cl).
cut_head_1(db(_,_,_,_,Next),Next).
return_size_1(db(Num,_,_,_,end), Num).
return_size_1(DB,Num) :- cut_head_1(DB,Next), return_size_1(Next,Num),!.

/*----------------------------------------------------- procedure to create level2 ---------------------------------------------------------*/
find_last(db(_,_,_,L,end), L).
find_last(Db,L) :- cut_head_1(Db,N),find_last(N,L).

second_level(File) :- 	open(File,read,In),
						open('Users/jazpurc/Documents/YorkU/EECS4401/assignment4/aux',write,Out),
						read(In,DB),
						find_last(DB,C1),
						return_size_1(DB,Size),
						return_id_1(DB,Id),
						delete_subsumed(In,Out,Size,C1,Id,DB),
						close(In),
						close(Out),
						/*------------------------ print rest of the list ------------------------*/
						open('Users/jazpurc/Documents/YorkU/EECS4401/assignment4/aux',read,InHandle),
			  			read(InHandle,NewDB),
			  			open('Users/jazpurc/Documents/YorkU/EECS4401/assignment4/level2',write,OutWrite),
			  			write(OutWrite,NewDB),write(OutWrite,'.'),write(OutWrite,'\n'),
			  			close(OutWrite),
			  			open('Users/jazpurc/Documents/YorkU/EECS4401/assignment4/level2',append,OutHandle),
			  			cut_head_1(NewDB,NewRest),
			  			print_remaining(OutHandle,NewRest),
			  			close(InHandle),close(OutHandle),
			  			delete_file('Users/jazpurc/Documents/YorkU/EECS4401/assignment4/aux'),!.

delete_subsumed(In,Out,Size,C1,Id,db(PId,P1,P2,C,end)) :- 	write(Out,'db('),write(Out,PId),write(Out,','),write(Out,P1),write(Out,','),
															write(Out,P2),write(Out,','),write(Out,C),write(Out,',end'),closure_1(Out,Size).
delete_subsumed(In,Out,Size,C1,Id,Rest) :- 	return_clause_1(Rest,C2),
											(sub(C1,C2) -> cut_head_1(Rest,Next),
											NewSize is (Size - 1),
											return_id_1(Next,NewId),
											delete_subsumed(In,Out,NewSize,C1,NewId,Next);
											write(Out,'db('),write(Out,Id),write(Out,',0,0,'),write(Out,C2),write(Out,','),
								 			cut_head_1(Rest,Next),
								 			return_id_1(Next,NewId),
								 			delete_subsumed(In,Out,Size,C1,NewId,Next)),!.
sub([],C2).
sub([X|L],C2) :- member(X,C2), sub(L,C2).