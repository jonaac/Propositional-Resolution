# Propositional-Resolution

My goal is to be able to implement the resolution rule for propositional logic in PROLOG. This implementation follows, to some degree, the level-saturation algorithm.

I will have as input a text file with a list of propositional logic literals represented as integers: positive literals are
integers > 0 while negative literals are integers < 0.

Propositional clauses will be stored in a text le. Before the refutation process can begin, these clauses have to be inserted into the initial level in the level-saturation algorithm. This (and the following levels) will be represented as a list. I will be using the predicate:
```
db(Id,P1,P2,Cl,Next)
```
For such a list where:

* Cl is a clause (as specified above);
* Id is a unique clause id (an integer);
* P1 and P2 are id's of Cl's parent clauses;
* Next is the rest of the clause list.

I have braken down the implementation in 4 parts:

1. A program that will read a file of clauses and create the initial level using the predicate mentioned above. This level will be stored in a new file, "level0".
2. A program that resolves to clauses, I will be using the predicate resolve(C1,C2).
3. A program that takes the file "level0" from step 1 and find two first clauses, say C0 and C1 (with the ids i0 and i1) that can be resolved. Then, it resolves these clauses and inserts the resolvent into a new db list as the first clause. This clause is inserted with its id and i0 and i1 as the ids of the resolvent's parents. The updated list will be stored in file "level1".
4. A program so that all the clauses subsumed by the new resolvent are removed. I will print the new list of predicates i file "level2".
