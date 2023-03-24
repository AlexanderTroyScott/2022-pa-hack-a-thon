using Pkg;
Pkg.add("LibPQ")
Pkg.add("DataFrames")
using LibPQ
using DataFrames

# Define the connection parameters
host = "database.lan"
port = 5432
dbname = "username"
user = "username"
password = "password"

# Connect to the database
conn = LibPQ.Connection(
    "host=$(host) port=$(port) dbname=$(dbname) user=$(user) password=$(password)"
)

# Execute a query and fetch the results into a DataFrame
query = "SELECT * FROM hackathons.training_2023"
result = LibPQ.execute(conn, query)
df = DataFrame(result)
