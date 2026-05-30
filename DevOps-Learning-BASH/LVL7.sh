#!/bin/bash

# **Mission**: Write a script that sorts all `.txt` files in a directory by their size, from smallest to largest, and displays the sorted list.

ls -l ~/projects/Arena/*.txt | sort -k 5 -n
