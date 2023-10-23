import pyodbc
import config
import os

# pyodbc connect string
conn = dev
cursor = conn.cursor()

def export(type):

    sql = """SELECT name,  
                SM.Definition
            FROM SYS.SQL_Modules As SM 
            INNER JOIN SYS.Objects As Obj ON SM.Object_ID = Obj.Object_ID 
            WHERE Obj.Type = '"""+type+"""' and left(name,3)<>'sp_' COLLATE Latin1_General_CS_AS """

    if type == 'T':
        sql = """
SELECT QUOTENAME(t.name) , 
    'CREATE TABLE ' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name) + CHAR(13) + CHAR(10) + '(' +
    STUFF((
        SELECT 
            CHAR(13) + CHAR(10) + '    ' + c.name + ' ' + 
            CASE 
                WHEN c.is_computed = 1 THEN 'AS ' + OBJECT_DEFINITION(c.default_object_id)
                ELSE t.name
            END + ' ' +
            CASE 
                WHEN c.is_nullable = 1 THEN 'NULL'
                ELSE 'NOT NULL'
            END + ',' 
        FROM sys.columns c
        WHERE c.object_id = t.object_id
        FOR XML PATH(''), TYPE
    ).value('.', 'NVARCHAR(MAX)'), 1, 5, '') +
    CHAR(13) + CHAR(10) + ');'
FROM sys.tables t
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id;
"""        
    
    # gewoon alles verwijderen, de sql server is leidend. 
    # Eventueel een git add en git commit om de huidige versie in git te zetten. 
    for file in os.scandir(type):
        os.remove('objects/'+type+'/'+file.name)

    cursor.execute(sql)
    for row in cursor.fetchall():
        f = open('objects/'+type+"/"+row[0]+".sql", "w")
        f.write(row[1])
        f.close()

# voer functie ... x uit
# export('T') # de tabellen doen het nog niet. 
# #SELECT
# FROM
#     dairycampusplus.INFORMATION_SCHEMA.columns

export('T')
export('P')
export('V')
export('FN')
export('IF')
