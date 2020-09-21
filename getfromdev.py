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

export('P')
export('V')
export('FN')
export('IF')