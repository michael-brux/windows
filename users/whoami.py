import subprocess
import csv
from tabulate import tabulate  # Ensure you have the tabulate library installed

def run_whoami_command(option):
    """Run a whoami command with the specified option and return the parsed CSV output."""
    try:
        # Run the whoami command
        result = subprocess.run(
            ["whoami", option, "/fo", "csv"],
            capture_output=True,
            text=True,
            check=True
        )
        # Parse the CSV output
        csv_reader = csv.DictReader(result.stdout.splitlines())
        return list(csv_reader)
    except subprocess.CalledProcessError as e:
        print(f"Error running whoami {option}: {e}")
        return []

# Run the whoami commands
user_info = run_whoami_command("/user")
group_info = run_whoami_command("/groups")
priv_info = run_whoami_command("/priv")

# Display the results
print("Parsed whoami /user /fo csv result:")
for row in user_info:
    print(row)

# Display group results in a pretty table
print("\nParsed whoami /groups /fo csv result:")
group_table = [[row.get("Group Name"), row.get("SID")] for row in group_info]
print(tabulate(group_table, headers=["Group Name", "SID"], tablefmt="grid"))

print("\nParsed whoami /priv /fo csv result:")
for row in priv_info:
    print(row)