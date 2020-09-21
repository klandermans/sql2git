# pygitsqlserver
Simple Python tool to maintain &amp; deploy SQL Server projects in GIT

# prerequisites
Create config.py with the environments
[environment] = pyodbc.connect()

install microsoft commandline tools (sqlcmd)

# usage

## pull code from dev & commit to GIT
python3 pygit.py pull [environment] 
git add .
git commit .
git push

## Deploy 
python3 pygit.py push git   

## Voila
