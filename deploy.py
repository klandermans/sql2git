import pyodbc
import config
import pymssql
import _mssql
import os

conn2 = production
cursor = conn2.cursor()

def getObject(type, name):
    
    sql = """SELECT 
                name,  
                SM.Definition 
            FROM SYS.SQL_Modules As SM 
            INNER JOIN SYS.Objects As Obj ON SM.Object_ID = Obj.Object_ID 
            WHERE Obj.Type=%s AND name=%s"""
    
    cursor.execute(sql, (type, name))
    return cursor.fetchone()

def getString(string):
    f = open('/tmp/tmp.sql', "w")
    f.write(string)
    f.close()
    return getFile('/tmp/tmp.sql')

def getFile(file):
    f = open(file, "r")
    definition = f.read()
    f.close()
    return definition

def deploy(type):
    for file in os.scandir(type):
        definition = getFile(type+"/"+file.name)
        name = file.name.replace('.sql','')
        obj = getObject(type, name)
        
        if obj == None:
            new = definition
            # new = new.replace('CREATE ', 'CREATE FORCE ', 1)
            try:
                # conn2.execute_non_query(new)
                cursor.execute(new)
                cursor.commit()
            except _mssql.MssqlDatabaseException as e:
                print(e)
            finally:                
                print('skip')

        elif obj != None:
        
            # str(obj[1])
            old = str(obj[1])
            old = getString(old)
            new = definition
            if old != new:
                print('DEPLOYING DEPLOYING DEPLOYING DEPLOYING DEPLOYING ')
                try:
                    new = new.replace('CREATE ', 'ALTER ', 1)
                    # conn2.execute_non_query(new)
                    cursor.execute(new)
                    conn2.commit()
                except _mssql.MssqlDatabaseException as e:
                    print(e)
                finally:
                    print('skip')

deploy('P')
deploy('V')
deploy('FN')
deploy('IF')
