import json
import os

def escape_dollar_signs(lines):
    # Replace every $ with $$
    stage1 = [line.replace('$', '$$') for line in lines]
    return [line.replace('$$(', '$(') for line in stage1]

def make_snippet(file_path, prefix, description):
    name = os.path.splitext(os.path.basename(file_path))[0]
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.read().splitlines()
    escaped_lines = escape_dollar_signs(lines)
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

with open("setup/powershell.json", "w", encoding='utf-8') as out_file:
    json.dump(snippets, out_file, indent=2)
