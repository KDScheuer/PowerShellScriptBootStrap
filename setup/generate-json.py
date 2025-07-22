import json
import os

def escape_line(line):
    # Escape backslashes first
    line = line.replace('\\', '\\\\')
    # Escape $ for VS Code snippet literals
    line = line.replace('$', '$$')
    # Escape double quotes for JSON strings
    line = line.replace('"', '\\"')
    return line

def make_snippet(file_path, prefix, description):
    name = os.path.splitext(os.path.basename(file_path))[0]
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.read().splitlines()
    escaped_lines = [escape_line(line) for line in lines]
    return {
        name: {
            "prefix": prefix,
            "body": escaped_lines,
            "description": description
        }
    }

snippets = {}
snippets.update(make_snippet("bootstrap.ps1", "!bs", "PowerShell Bootstrap Full"))
snippets.update(make_snippet("bootstrap-lite.ps1", "!bsl", "PowerShell Bootstrap Lite"))

output_path = "setup/powershell.json"
with open(output_path, "w", encoding='utf-8') as out_file:
    json.dump(snippets, out_file, indent=2)

print(f"Snippets written to {output_path}")
