# Database Object Deployment Script

This Python script is designed to deploy database objects (stored procedures, views, functions, etc.) to a database. It scans a specified directory for SQL files representing database objects, compares them with existing objects in the database, and deploys the changes accordingly.

## Features

- Automatically retrieves definitions of database objects from the database.
- Compares SQL files with existing database objects and deploys changes if necessary.
- Supports deployment of stored procedures, views, functions, and inline functions.
- Handles errors gracefully and provides informative messages.

## Dependencies

- Python 3
- pyodbc
- pymssql

## Installation

1. Clone this repository to your local machine:

2. Install the required dependencies using pip:

pip install pyodbc pymssql

## Usage

1. Place your SQL files representing database objects in the respective directories (e.g., 'P' for stored procedures, 'V' for views).
2. Rn the `deploy.py` script to deploy the database objects:
3. The script will automatically deploy changes to the database based on the SQL files provided.

## Configuration

- Update the database connection details in the script (`production` variable) to point to your target database.
- Customize the script as needed to fit your specific deployment requirements.

## Contributors

- [Your Name](https://github.com/your-username)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
