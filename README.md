Oracle-Database-21c-on-Docker
=============================

A set of scripts for using Oracle Database 21c single instance docker image in [Oracle Container Registry](https://container-registry.oracle.com/ords/f?p=113:1).

Configuration
-------------

Copy the file `dotenv.sample` to a file named `.env` and rewrite the contents as needed.

```shell
ORACLE_CONTAINER_NAME=oracle_database_21c
ORACLE_LISTENER_PORT=1521
OEM_EXPRESS_PORT=5500
ORACLE_SID=ORCLCDB
ORACLE_PDB=ORCLPDB1
ORACLE_PWD=oracle
ORACLE_EDITION=enterprise
ORACLE_CHARACTERSET=AL32UTF8
ENABLE_ARCHIVELOG=true
```

Example of use
--------------

### [login-registry.sh](login-registry.sh) ###

Login to [Oracle Container Registry](https://container-registry.oracle.com/ords/f?p=113:1).

```console
[opc@instance-20211006-1218 ~]$ ./login-registry.sh
Username: yourname@example.com
Password:
WARNING! Your password will be stored unencrypted in /home/opc/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
[opc@instance-20211006-1218 ~]$

```

### [run.sh](run.sh) ###

Create a new container and start an Oracle Database server instance.

```console
[opc@instance-20211006-1218 ~]$ ./run.sh
Starting an Oracle Database Server Instance.
a9c0ad1b11dfbe587a4877d8bb9b2f96777489bd20736597d12bd32bdeb9e685
Waiting for oracle_database_21c to get healthy ................................................................................................................................................................................................................................................................................................................................................................................................................................................................. done
[opc@instance-20211006-1218 ~]$
```

### [install-sample.sh](install-sample.sh) ###

Installs sample schemas.

```console
[opc@instance-20211006-1218 ~]$ ./install-sample.sh

SQL*Plus: Release 21.0.0.0.0 - Production on Wed Oct 6 08:51:10 2021
Version 21.3.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.

Last Successful login time: Wed Oct 06 2021 08:12:57 +00:00

Connected to:
Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production
Version 21.3.0.0.0

SQL>
specify password for SYSTEM as parameter 1:
...
...
SH     PROMO_PK                            503        503
SH     SALES_CHANNEL_BIX                     4         92
SH     SALES_CUST_BIX                     7059      35808
SH     SALES_PROD_BIX                       72       1074
SH     SALES_PROMO_BIX                       4         54
SH     SALES_TIME_BIX                     1460       1460
SH     SUP_TEXT_IDX
SH     TIMES_PK                           1826       1826

72 rows selected.

SQL> Disconnected from Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production
Version 21.3.0.0.0
[opc@instance-20211006-1218 ~]$
```

### [sqlplus.sh](sqlplus.sh) ###

Connect to CDB root and confirm the connection.

```console
[opc@instance-20211006-1218 ~]$ ./sqlplus.sh system/oracle

SQL*Plus: Release 21.0.0.0.0 - Production on Wed Oct 6 09:01:02 2021
Version 21.3.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.

Last Successful login time: Wed Oct 06 2021 08:52:20 +00:00

Connected to:
Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production
Version 21.3.0.0.0

SQL> show con_name

CON_NAME
------------------------------
CDB$ROOT
SQL> exit
Disconnected from Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production
Version 21.3.0.0.0
[opc@instance-20211006-1218 ~]$
```

Connect to PDB and confirm the connection. If you have sample schemas installed, browse to the sample table.

```console
[opc@instance-20211006-1218 ~]$ ./sqlplus.sh system/oracle@ORCLPDB1

SQL*Plus: Release 21.0.0.0.0 - Production on Wed Oct 6 09:01:29 2021
Version 21.3.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.

Last Successful login time: Wed Oct 06 2021 09:01:03 +00:00

Connected to:
Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production
Version 21.3.0.0.0

SQL> SHOW CON_NAME

CON_NAME
------------------------------
ORCLPDB1
SQL> -- If you have sample schemas installed
SQL> SELECT JSON_OBJECT(*) FROM hr.employees WHERE rownum <= 3;

JSON_OBJECT(*)
--------------------------------------------------------------------------------
{"EMPLOYEE_ID":100,"FIRST_NAME":"Steven","LAST_NAME":"King","EMAIL":"SKING","PHO
NE_NUMBER":"515.123.4567","HIRE_DATE":"2003-06-17T00:00:00","JOB_ID":"AD_PRES","
SALARY":24000,"COMMISSION_PCT":null,"MANAGER_ID":null,"DEPARTMENT_ID":90}

{"EMPLOYEE_ID":101,"FIRST_NAME":"Neena","LAST_NAME":"Kochhar","EMAIL":"NKOCHHAR"
,"PHONE_NUMBER":"515.123.4568","HIRE_DATE":"2005-09-21T00:00:00","JOB_ID":"AD_VP
","SALARY":17000,"COMMISSION_PCT":null,"MANAGER_ID":100,"DEPARTMENT_ID":90}

{"EMPLOYEE_ID":102,"FIRST_NAME":"Lex","LAST_NAME":"De Haan","EMAIL":"LDEHAAN","P
HONE_NUMBER":"515.123.4569","HIRE_DATE":"2001-01-13T00:00:00","JOB_ID":"AD_VP","
SALARY":17000,"COMMISSION_PCT":null,"MANAGER_ID":100,"DEPARTMENT_ID":90}

JSON_OBJECT(*)
--------------------------------------------------------------------------------


SQL> exit
Disconnected from Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production
Version 21.3.0.0.0
[opc@instance-20211006-1218 ~]$
```

### [logs.sh](logs.sh) ###

Show the database alert log and others.

```console
[opc@instance-20211006-1218 ~]$ ./logs.sh
[2021:10:06 08:07:13]: Acquiring lock .ORCLCDB.create_lck with heartbeat 30 secs
[2021:10:06 08:07:13]: Lock acquired
[2021:10:06 08:07:13]: Starting heartbeat
[2021:10:06 08:07:13]: Lock held .ORCLCDB.create_lck
ORACLE EDITION: ENTERPRISE

LSNRCTL for Linux: Version 21.0.0.0.0 - Production on 06-OCT-2021 08:07:13

Copyright (c) 1991, 2021, Oracle.  All rights reserved.

Starting /opt/oracle/product/21c/dbhome_1/bin/tnslsnr: please wait...

TNSLSNR for Linux: Version 21.0.0.0.0 - Production
System parameter file is /opt/oracle/homes/OraDB21Home1/network/admin/listener.ora
Log messages written to /opt/oracle/diag/tnslsnr/a9c0ad1b11df/listener/alert/log.xml
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1)))
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=0.0.0.0)(PORT=1521)))
...
...
ORCLPDB1(3):Resize operation completed for file# 12, fname /opt/oracle/oradata/ORCLCDB/ORCLPDB1/users01.dbf, old size 290560K, new size 299520K
2021-10-06T08:51:58.092914+00:00
ORCLPDB1(3):Resize operation completed for file# 12, fname /opt/oracle/oradata/ORCLCDB/ORCLPDB1/users01.dbf, old size 299520K, new size 307200K
2021-10-06T08:52:02.417653+00:00
ORCLPDB1(3):Resize operation completed for file# 12, fname /opt/oracle/oradata/ORCLCDB/ORCLPDB1/users01.dbf, old size 307200K, new size 308480K
2021-10-06T08:52:02.549169+00:00
ORCLPDB1(3):Resize operation completed for file# 12, fname /opt/oracle/oradata/ORCLCDB/ORCLPDB1/users01.dbf, old size 308480K, new size 323840K
2021-10-06T08:55:02.458435+00:00
ORCLPDB1(3):Resize operation completed for file# 10, fname /opt/oracle/oradata/ORCLCDB/ORCLPDB1/sysaux01.dbf, old size 358400K, new size 368640K
2021-10-06T08:55:02.459199+00:00
ORCLPDB1(3):Resize operation completed for file# 12, fname /opt/oracle/oradata/ORCLCDB/ORCLPDB1/users01.dbf, old size 323840K, new size 335360K
2021-10-06T08:59:57.696761+00:00
ORCLPDB1(3):TABLE SYS.ACTIVITY_MVIEW$: ADDED INTERVAL PARTITION SYS_P361 (1) VALUES LESS THAN (106)
[opc@instance-20211006-1218 ~]$
```

### [start.sh](start.sh) ###

Start container and Oracle Database server instance.

```
[opc@instance-20211006-1218 ~]$ ./start.sh
oracle_database_21c
Waiting for oracle_database_21c to get healthy .......................................................... done
[opc@instance-20211006-1218 ~]$
```

### [stop.sh](stop.sh) ###

Shutdown database and stop container.

```
[opc@instance-20211006-1218 ~]$ ./stop.sh
oracle_database_21c
[opc@instance-20211006-1218 ~]$
```

### [remove.sh](remove.sh) ###

Remove container.

```
[opc@instance-20211006-1218 ~]$ ./remove.sh
oracle_database_21c
[opc@instance-20211006-1218 ~]$
```

Author
------

[Shinichi Akiyama](https://github.com/shakiyam)

License
-------

[MIT License](https://opensource.org/licenses/MIT)
