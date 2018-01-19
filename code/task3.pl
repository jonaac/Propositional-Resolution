:- style_check(-singleton).
:- [task2].
:- [task1].

closure(Out,0):- write(Out,'.').
closure(Out,Count):- Coun is Count - 1, write(Out,')'), closure(Out,Coun).

start_first_level(File) :- 	open(File,read,In),
							open('Users/jazpurc/Documents/YorkU/EECS4401/assignment4/aux',write,Out),
							read(In,DB),
							return_size(DB,Size),
							return_clause(DB,C1),
							return_id(DB,P1),
							cut_head(DB,Rest),
							find_resolvent(DB,P1,C1,Rest,Size,Resol,Out),
							close(In),
							close(Out),
							/*------------------------ print rest of the list ------------------------*/
							open('Users/jazpurc/Documents/YorkU/EECS4401/assignment4/aux',read,InHandle),
				  			read(InHandle,NewDB),
				  			open('Users/jazpurc/Documents/YorkU/EECS4401/assignment4/level1',write,OutWrite),
				  			write(OutWrite,NewDB),write(OutWrite,'.'),write(OutWrite,'\n'),
				  			close(OutWrite),
				  			open('Users/jazpurc/Documents/YorkU/EECS4401/assignment4/level1',append,OutHandle),
				  			cut_head(NewDB,NewRest),
				  			print_remaining(OutHandle,NewRest),
				  			close(InHandle),close(OutHandle),
			  				delete_file('Users/jazpurc/Documents/YorkU/EECS4401/assignment4/aux'),!.

find_resolvent(DB,P1,C1,Rest,Size,Resol,Out) :- return_id(Rest,P2),return_clause(Rest,C2),
												try_resolve(C1,C2,Resol,None),
												(None == yes -> try_resolve(C1,C2,Resol,None), Id is (Size + 1), print_original_DB(DB,Out),
												write(Out,db(Id,P1,P2,Resol,end)),
												closure(Out,Size);
												cut_head(Rest,Next),find_resolvent(DB,P1,C1,Next,Size,NewResol,Out)),!.

find_resolvent(DB,P1,C1,end,Size,Resol,Out) :-	write(Out,'db('),write(Out,P1),write(Out,',0,0,'),write(Out,C1),write(Out,','),
													cut_head(DB,NewDB),
													return_id(NewDB,P3),
													return_clause(NewDB,C3),
													cut_head(NewDB,NewRest),
													(P3 == Size -> write(Out,'db('),write(Out,P3),write(Out,',0,0,'),write(Out,C3),write(Out,',end'),closure(Out,P3);
													find_resolvent(NewDB,P3,C3,NewRest,Size,NewResol,Out)),!.

try_resolve([],C2,Res,None).
try_resolve(C1,[],Res,None).
try_resolve([X|Rest],C2,Res,yes) :- resolve([X|Rest],C2,X,Res).
try_resolve([X|Rest],C2,Res,None) :- 	member(X,C2),try_resolve(Rest,C2,Res,None).
try_resolve([X|Rest],C2,[X|Res],None) :-	not(member(X,C2)),try_resolve(Rest,C2,Res,None).

print_original_DB(end,_).
print_original_DB(DB,Out) :- 	return_id(DB,Id),
								return_par(DB,P1,P2),
								return_clause(DB,Cl),
								cut_head(DB,Next),
								write(Out,'db('),write(Out,Id),write(Out,','),
								write(Out,P1),write(Out,','),write(Out,P2),
								write(Out,','),write(Out,Cl), write(Out,','),
								print_original_DB(Next,Out),!.

cut_head(db(_,_,_,_,Next),Next).
return_id(db(I,_,_,_,_),I).
return_par(db(_,P1,P2,_,_),P1,P2).
return_clause(db(_,_,_,Cl,_),Cl).
return_size(db(Num,_,_,_,end), Num).
return_size(DB,Num) :- cut_head(DB,Next), return_size(Next,Num),!.

