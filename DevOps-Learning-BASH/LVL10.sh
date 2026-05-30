#!/bin/bash

#**Mission**: Write a script that:
#1. Creates a directory called Arena_Boss.
#2. Creates 5 text files inside the directory, named file1.txt to file5.txt.
#3. Generates a random number of lines (between 10 and 20) in each file.
#4. Sorts these files by their size and displays the list.
#5. Checks if any of the files contain the word 'Victory', and if found, moves the file to a directory called Victory_Archive.'

# e - exit immediately if any command fails, u - treat unset variables as errors, o pipefail - if a pipeline fails anywhere in the middle, the whole pipeline fails
set -euo pipefail

# creates directories, assigns them to variables, creates five files at once
mkdir -p "$HOME/projects/Arena_Boss" "$HOME/projects/Victory_Archive"
Arena="$HOME/projects/Arena_Boss"
Archive="$HOME/projects/Victory_Archive"
touch "$Arena"/file{1..5}.txt

# f targets the file, then we specify the five files. N is a variable we are setting. RANDOM choose a random number and %11 shortened that range to 0-10, +10 increases the starting number from 0-10 to 10-20.
# seq "$N" outputs the numbers 1 through N, one per line on variable $f which is the file
for f in "$Arena"/file{1..5}.txt; do
	N=$(( RANDOM % 11 + 10 ))
	seq "$N" > "$f"
done

# f targets the file, and then we specify the five files. RANDOM %2 means 0and1. which means true and false which determines if the second command activates for a certain file or not.
for f in "$Arena"/file{1..5}.txt; do
  (( RANDOM % 2 )) && echo "Victory" >> "$f"
done

ls -l "$Arena"/*.txt | sort -k 5 -n | awk '{print $5, $9}'

# -q greps quietly, 2>/dev/null sends error messages to null, -l greps the filename containing the word. We pipe it into a while statement. IFS means no spaces between words when reading and -r means dont treat backslashes as escape characters, does not mean recusrive in this context. read will read the output that was piped and then store in a variable, in this case the variable was $f. mv -- means it still gets moved even if the file starts with a -.
if grep -q 'Victory' "$Arena"/*.txt 2>/dev/null; then
  grep -l 'Victory' "$Arena"/*.txt 2>/dev/null | while IFS= read -r f; do
    mv -- "$f" "$Archive"/
    echo "Moved: $f"
  done
fi

