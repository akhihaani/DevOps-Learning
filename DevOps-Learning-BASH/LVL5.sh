#!/bin/bash

mkdir -p ~/projects/Battlefield/ ~/projects/Archive/


touch ~/projects/Battlefield/knight.txt ~/projects/Battlefield/sorcerer.txt ~/projects/Battlefield/rogue.txt

if [ -f ~/projects/Battlefield/knight.txt ];  then
	mv ~/projects/Battlefield/knight.txt ~/projects/Archive/
fi

ls -a ~/projects/Battlefield ~/projects/Archive


