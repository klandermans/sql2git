import pyodbc
import config
import pymssql
import _mssql
import os

# Establish a connection to the production database
conn2 = production
cursor = conn2.cursor()

def getObject(type, name):
    """
    Retrieves the definition of a database object (stored procedure, view, function, etc.).

    Args:
        type (str): The type of database object (e.g., 'P' for stored procedure, 'V' for view).
        name (str): The name of the database object.

    Returns:
        tuple: A tuple containing the name and definition of the database object.
    """
    sql = """SELECT 
                name,  
                SM.Definition 
            FROM SYS.SQL_Modules As SM 
            INNER JOIN SYS.Objects As Obj ON SM.Object_ID = Obj.Object_ID 
            WHERE Obj.Type=%s AND name=%s"""
    
    cursor.execute(sql, (type, name))
    return cursor.fetchone()

def getString(string):
    """
    Writes a string to a temporary SQL file and returns its content.

    Args:
        string (str): The string to be written to the file.

    Returns:
        str: The content of the temporary SQL file.
    """
    f = open('/tmp/tmp.sql', "w")
    f.write(string)
    f.close()
    return getFile('/tmp/tmp.sql')

def getFile(file):
    """
    Reads the content of a SQL file and returns it as a string.

    Args:
        file (str): The path to the SQL file.

    Returns:
        str: The content of the SQL file.
    """
    f = open(file, "r")
    definition = f.read()
    f.close()
    return definition

def deploy(type):
    """
    Deploys database objects of a specified type.

    Args:
        type (str): The type of database objects to deploy (e.g., 'P' for stored procedures, 'V' for views).

    Returns:
        None
    """
    for file in os.scandir(type):
        definition = getFile(type+"/"+file.name)
        name = file.name.replace('.sql','')
        obj = getObject(type, name)
        
        if obj == None:
            new = definition
            try:
                cursor.execute(new)
                cursor.commit()
            except _mssql.MssqlDatabaseException as e:
                print(e)
            finally:                
                print('skip')

        elif obj != None:
            old = str(obj[1])
            old = getString(old)
            new = definition
            if old != new:
                print('DEPLOYING DEPLOYING DEPLOYING DEPLOYING DEPLOYING ')
                try:
                    new = new.replace('CREATE ', 'ALTER ', 1)
                    cursor.execute(new)
                    conn2.commit()
                except _mssql.MssqlDatabaseException as e:
                    print(e)
                finally:
                    print('skip')

# Deploy stored procedures, views, functions, and inline functions
deploy('P')
deploy('V')
deploy('FN')
deploy('IF')
