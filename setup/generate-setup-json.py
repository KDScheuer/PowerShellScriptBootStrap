import json
import os

def make_snippet(file_path, prefix, description):
    name = os.path.splitext(os.path.basename(file_path))[0]
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.read().splitlines()
    return {
        name: {
            "prefix": prefix,
            "body": lines,
            "description": description
        }
    }

snippets = {}
snippets.update(make_snippet("bootstrap.ps1", "!bs", "PowerShell Bootstrap Full"))
snippets.update(make_snippet("bootstrap-lite.ps1", "!bsl", "PowerShell Bootstrap Lite"))

with open("setup/powershell.json", "w", encoding='utf-8') as out_file:
    json.dump(snippets, out_file, indent=2)

