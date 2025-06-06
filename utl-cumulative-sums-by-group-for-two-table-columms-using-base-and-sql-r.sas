%let pgm=utl-cumulative-sums-by-group-for-two-table-columms-using-base-and-sql-r;

%stop_submission;

Cumulative sums by group for two table columms using base and sql r

   TWO SOLUTIONS
       1 r dplyr language
       2 r sql
         https://tinyurl.com/4e6yaap8 for python and excel


The smiplified the problem is equivalant to the posed problem.

github
https://tinyurl.com/3eytb8vs
https://github.com/rogerjdeangelis/utl-cumulative-sums-by-group-for-two-table-columms-using-base-and-sql-r

sas communities
https://tinyurl.com/yyaat4rs
https://communities.sas.com/t5/SAS-IML-Software-and-Matrix/Cumulative-sum-by-byvar-in-the-order-of-rank-variable/m-p/775629#M5711

perplexity AI
please provide a reproducible example of cumulative sums by group for two numeric dataframe columms using r sqldf window functions

/**************************************************************************************************************************/
/*    INPUT                 |               PROCESS                      |                    OUTPUT                      */
/* GRP VAL1 VAL2            |  1 R DPLYR LANGUAGE                        |               CUM               CUM            */
/*                          |  ==================                        |  GRP VAL1    val1        VAL2   val2           */
/*  A    1    2             |                                            |    A    1       1 1         2      2  2        */
/*  A    2    4             |  %utl_rbeginx;                             |    A    2       3 1+2       4      6  2+4      */
/*  A    3    6             |  parmcards4;                               |    A    3       6 1+2+3     6     12  2+4+6    */
/*  B    1    7             |  library(dplyr)                            |                                                */
/*  B    3    8             |  library(haven)                            |    B    1       1           7      7           */
/*  B    5    9             |  source("c:/oto/fn_tosas9x.R")             |    B    3       4           8     15           */
/*                          |  have<-read_sas("d:/sd1/have.sas7bdat")    |    B    5       9           9     24           */
/* options                  |  print(have)                               |                                                */
/*  validvarname=upcase;    |  want <- have %>%                          |   SAS                                          */
/* libname sd1 "d:/sd1";    |    group_by(GRP) %>%                       |   GRP VAL1 VAL2 CUMVAL1 CUMVAL2                */
/* data sd1.have;           |    mutate(                                 |                                                */
/*   input grp$ val1 val2;  |      cumval1 = cumsum(VAL1),               |    A    1    2     1        2                  */
/* cards4;                  |      cumval2 = cumsum(VAL2)                |    A    2    4     3        6                  */
/* A 1 2                    |    )                                       |    A    3    6     6       12                  */
/* A 2 4                    |  want;                                     |    B    1    7     1        7                  */
/* A 3 6                    |  fn_tosas9x(                               |    B    3    8     4       15                  */
/* B 1 7                    |        inp    = want                       |    B    5    9     9       24                  */
/* B 3 8                    |       ,outlib ="d:/sd1/"                   |                                                */
/* B 5 9                    |       ,outdsn ="want"                      |                                                */
/* ;;;;                     |       )                                    |                                                */
/* run;quit;                |  ;;;;                                      |                                                */
/*                          |  %utl_rendx;                               |                                                */
/*                          |                                            |                                                */
/*                          |  proc print data=sd1.want;                 |                                                */
/*                          |  run;quit;                                 |                                                */
/*                          |                                            |                                                */
/*                          |---------------------------------------------------------------------------------------------*/
/*                          |  2 R SQL                                   |   R                                            */
/*                          |  =======                                   |     GRP VAL1 VAL2 cumval1 cumval2              */
/*                          |                                            |   1   A    1    2       1       2              */
/*                          |  %utl_rbeginx;                             |   2   A    2    4       3       6              */
/*                          |  parmcards4;                               |   3   A    3    6       6      12              */
/*                          |  library(haven)                            |   4   B    1    7       1       7              */
/*                          |  library(sqldf)                            |   5   B    3    8       4      15              */
/*                          |  source("c:/oto/fn_tosas9x.r")             |   6   B    5    9       9      24              */
/*                          |  options(sqldf.dll = "d:/dll/sqlean.dll")  |                                                */
/*                          |  have<-read_sas("d:/sd1/have.sas7bdat")    |   SAS                                          */
/*                          |  print(have)                               |   GRP VAL1 VAL2 CUMVAL1 CUMVAL2                */
/*                          |  want <- sqldf("                           |                                                */
/*                          |    select                                  |    A    1    2     1        2                  */
/*                          |      grp                                   |    A    2    4     3        6                  */
/*                          |     ,val1                                  |    A    3    6     6       12                  */
/*                          |     ,val2                                  |    B    1    7     1        7                  */
/*                          |     ,sum(val1) over                        |    B    3    8     4       15                  */
/*                          |        (partition by grp order by rowid)   |    B    5    9     9       24                  */
/*                          |        as cumval1                          |                                                */
/*                          |     ,sum(val2) over                        |                                                */
/*                          |        (partition by grp order by rowid)   |                                                */
/*                          |        as cumval2                          |                                                */
/*                          |    from have                               |                                                */
/*                          |  ")                                        |                                                */
/*                          |  want                                      |                                                */
/*                          |  fn_tosas9x(                               |                                                */
/*                          |        inp    = want                       |                                                */
/*                          |       ,outlib ="d:/sd1/"                   |                                                */
/*                          |       ,outdsn ="want"                      |                                                */
/*                          |       )                                    |                                                */
/*                          |  ;;;;                                      |                                                */
/*                          |  %utl_rendx;                               |                                                */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

options
 validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
  input grp$ val1 val2;
cards4;
A 1 2
A 2 4
A 3 6
B 1 7
B 3 8
B 5 9
;;;;
run;quit;

/**************************************************************************************************************************/
/* GRP VAL1 VAL2                                                                                                          */
/*                                                                                                                        */
/*  A    1    2                                                                                                           */
/*  A    2    4                                                                                                           */
/*  A    3    6                                                                                                           */
/*  B    1    7                                                                                                           */
/*  B    3    8                                                                                                           */
/*  B    5    9                                                                                                           */
/**************************************************************************************************************************/

/*              _       _             _
/ |  _ __    __| |_ __ | |_   _ _ __ | | __ _ _ __   __ _ _   _  __ _  __ _  ___
| | | `__|  / _` | `_ \| | | | | `__|| |/ _` | `_ \ / _` | | | |/ _` |/ _` |/ _ \
| | | |    | (_| | |_) | | |_| | |   | | (_| | | | | (_| | |_| | (_| | (_| |  __/
|_| |_|     \__,_| .__/|_|\__, |_|   |_|\__,_|_| |_|\__, |\__,_|\__,_|\__, |\___|
                 |_|      |___/                     |___/             |___/
*/

%utl_rbeginx;
parmcards4;
library(dplyr)
library(haven)
source("c:/oto/fn_tosas9x.R")
have<-read_sas("d:/sd1/have.sas7bdat")
print(have)
want <- have %>%
  group_by(GRP) %>%
  mutate(
    cumval1 = cumsum(VAL1),
    cumval2 = cumsum(VAL2)
  )
want;
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/* > want;                               |  SAS                                                                           */
/*                                       |                                                                                */
/*   GRP    VAL1  VAL2 cumval1 cumval2   |  GRP    VAL1    VAL2    CUMVAL1    CUMVAL2                                     */
/*                                       |                                                                                */
/* 1 A         1     2       1       2   |   A       1       2        1           2                                       */
/* 2 A         2     4       3       6   |   A       2       4        3           6                                       */
/* 3 A         3     6       6      12   |   A       3       6        6          12                                       */
/* 4 B         1     7       1       7   |   B       1       7        1           7                                       */
/* 5 B         3     8       4      15   |   B       3       8        4          15                                       */
/* 6 B         5     9       9      24   |   B       5       9        9          24                                       */
/**************************************************************************************************************************/

/*___                     _
|___ \   _ __   ___  __ _| |
  __) | | `__| / __|/ _` | |
 / __/  | |    \__ \ (_| | |
|_____| |_|    |___/\__, |_|
                       |_|
*/

%utl_rbeginx;
parmcards4;
library(haven)
library(sqldf)
source("c:/oto/fn_tosas9x.r")
options(sqldf.dll = "d:/dll/sqlean.dll")
have<-read_sas("d:/sd1/have.sas7bdat")
print(have)
want <- sqldf("
  select
    grp
   ,val1
   ,val2
   ,sum(val1) over
      (partition by grp order by rowid)
      as cumval1
   ,sum(val2) over
      (partition by grp order by rowid)
      as cumval2
  from have
")
want
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/* R                              |                                                                                       */
/* GRP VAL1 VAL2 cumval1 cumval2  | GRP    VAL1    VAL2    CUMVAL1    CUMVAL2                                             */
/*                                |                                                                                       */
/*   A    1    2       1       2  |  A       1       2        1           2                                               */
/*   A    2    4       3       6  |  A       2       4        3           6                                               */
/*   A    3    6       6      12  |  A       3       6        6          12                                               */
/*   B    1    7       1       7  |  B       1       7        1           7                                               */
/*   B    3    8       4      15  |  B       3       8        4          15                                               */
/*   B    5    9       9      24  |  B       5       9        9          24                                               */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
