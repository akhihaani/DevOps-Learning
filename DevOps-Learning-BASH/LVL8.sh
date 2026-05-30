#!/bin/bash

# **Mission**: Create a script that searches for a specific word or phrase across all `.log` files in a directory and outputs the names of the files that contain the word or phrase.

grep -l "cat" ~/projects/*.log 
