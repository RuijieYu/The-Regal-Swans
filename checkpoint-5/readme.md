

# Checkpoint 5


## Preparations

This notebook requires access to a private database server,
hence a file \`src/regal<sub>swans</sub><sub>private.py</sub>\` is created
separately, where the reader is expected to replace the
value of \`sql<sub>pass</sub>\` with the actual password, before
evaluating the work.

The jupyter notebook file is available as
\`src/checkpoint5.ipynb\`. One can either run \`jupyter
notebook src/checkpoint5.ipynb\` or upload this file **and**
\`src/regal<sub>swans</sub><sub>private.py</sub>\` to Google Colab (or other
similar jupyter online services). There is no additional
dependencies other than the file containing the password.

    # regal_swans_private.py
    sql_pass = 'PUT_ACTUAL_PASSWORD_HERE'
    sql_url = rf'postgresql://cpdbstudent:{sql_pass}@codd01.northwestern.edu/postgres'


## Part 1

Under the section &ldquo;**Part 1**&rdquo;, a series of transformations take
place and the ultimate result is a scatter plot of years of
employment (experience) versus the allegation sentiment
score (severity). It is concluded that some insignificant
amount of correlation exists between experience and the
severity of allegation.


## Part 2

Under the section &ldquo;**Part 2**&rdquo;, a series of transformations take
place and the ultimate result is a scatter plot of years of
employment (experience) versus the allegation sentiment
score (severity). It is condluded that virtually no
correlation exists between experience and the severity of a
lawsuit.

