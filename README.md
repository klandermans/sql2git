# sql 2 git
Simple Python tool to maintain &amp; deploy SQL Server projects in GIT

# prerequisites
- Create config.py with the environments [environment] = pyodbc.connect()
```
# config object with environments
config = {}
config.production = pyodbc.connect(server='??.database.windows.net', user='??', password='??', database='??')
config.dev = pyodbc.connect(server='??.database.windows.net', user='??', password='??', database='??')
config.test = pyodbc.connect(server='??.database.windows.net', user='??', password='??', database='??')
config.acceptance = pyodbc.connect(server='??.database.windows.net', user='??', password='??', database='??')
config.local = pyodbc.connect(server='??.database.windows.net', user='??', password='??', database='??')
```

- Install microsoft commandline tools (sqlcmd)

# usage

## pull code from dev & commit to GIT
- python3 sql2git.py pull [environment] 
- git add .
- git commit .
- git push

## Deploy 
- python3 sql2git.py push git   

# Notes

- Tables are currently not supported
