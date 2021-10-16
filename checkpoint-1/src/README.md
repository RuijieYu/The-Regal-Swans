# The Regal Swans Checkpoint 1

All questions are calculated in the file `queries.sql`. Hence all
subsequent instructions require executing queries from this file.

## Q1

What is the variance of the number of use of force reports per capita
accross units?

One can view the results via the following SQL query:

```sql
SELECT * FROM q1 ;
```

The result of this query is the desired variance.

## Q2

Per capita, are veteran police officers more likely to acquire a use
of force complaint than less experienced ones?

One can view the results via the following SQL query:

```sql
SELECT * FROM q2 ;
```

The result of this query is the correlation between seniority of
officers (in years) and the number of use-of-force complaints.

## Q3

What is the correlation between salary and complaints?

One can view the results via the following SQL query:

```sql
SELECT * FROM q3 ;
```

The result of this query is the desired correlation.

## Q4

Do some units of the police force fire more bullets per officer on
average in incidents?

One can view the results via the following SQL query:

```sql
SELECT * FROM q4 ;
```

The result of this query is a sorted table showing the average bullets
shot per incident per officer for each unit.

## Q5

Does seniority affect the type of force an active officer might use?

One can view the results via the following SQL query:

```sql
SELECT * FROM q5 ;
```

The result of this query is the correlation between the seniority of
officers (in years) and each types of force: firearm, tazer, and no
force.
