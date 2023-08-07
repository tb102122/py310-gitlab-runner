# Layer Build Process

based on reference https://randywestergren.com/building-pyodbc-for-lambdas-python-3-9-runtime/
https://learn.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver16&tabs=redhat18-install%2Calpine17-install%2Cdebian8-install%2Credhat7-13-install%2Crhel7-offline


## Run command

```
docker build -t pyodbc-3-10 .  
docker run --rm --entrypoint bash -v $PWD:/local pyodbc-3-10 -c "cp -R /opt /local"  
# for PowerShell
docker run --rm --entrypoint bash -v ${PWD}:/local pyodbc-3-10 -c "cp -R /opt /local"

```