
import re

# Ton input brute
raw_data = """
 HP
605 (+ 88 × lvl²)
 MP
425 (+ 40 × lvl²)
 HP5
2.5 (+ 0.5 × lvl²)
 MP5
11.5 (+ 0.4 × lvl²)
 AR
32 (+ 5 × lvl²)
 AD
50 (+ 3 × lvl²)
 MR
30 (+ 1.3 × lvl²)
 Crit. DMG
200%
 MS
325
 Attack range
550
 Attack speed
Base AS
0.625
Windup%
18.7%
AS ratio
N/A
Bonus AS
2.14%
Missile speed
1000

Unit radius
 Gameplay radius
65
 Select. radius
110
 Pathing radius
44
 Select. height
145
 Acq. radius
600
"""

def parse_to_tree(data):
    lines = [line.strip() for line in data.strip().split('\n') if line.strip()]
    tree = "Stats\n"

    # On définit les catégories parentes connues pour mieux structurer
    categories = {
        "Attack speed": ["Base AS", "Windup%", "AS ratio", "Bonus AS", "Missile speed"],
        "Unit radius": ["Gameplay radius", "Select. radius", "Pathing radius", "Select. height", "Acq. radius"]
    }

    i = 0
    current_parent = None

    while i < len(lines):
        line = lines[i]

        # Si la ligne est une catégorie parente
        if line in categories:
            tree += f"└── {line}\n"
            current_parent = line
            i += 1
            continue

        # Si on est dans une catégorie parente
        if current_parent and line in categories[current_parent]:
            prefix = "    ├── " if i + 1 < len(lines) and lines[i+1] in categories[current_parent] else "    └── "
            val = lines[i+1]
            tree += f"{prefix}{line}: {val}\n"
            i += 2
            # Si on arrive au bout de la catégorie
            if i >= len(lines) or (current_parent and lines[i] not in categories[current_parent]):
                current_parent = None
        else:
            # Stats standards (Nom puis Valeur sur la ligne suivante)
            name = line
            val = lines[i+1] if i+1 < len(lines) else ""
            tree += f"├── {name}: {val}\n"
            i += 2

    return tree

# Génération et sauvegarde
tree_output = parse_to_tree(raw_data)
print(tree_output)

with open("stats_tree.txt", "w", encoding="utf-8") as f:
    f.write(tree_output)

