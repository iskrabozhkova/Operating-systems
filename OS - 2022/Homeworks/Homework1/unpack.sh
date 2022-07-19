#!/bin/bash

#validate user input
if [ $# -ne 4 ];then
    echo "Error! Wrong number of arguments!"
    exit 1
fi
if ! [ -f "$1" ];then
    echo "First argument must be a file."
    exit 1
fi
if ! $(file "$1" | grep -q "Zip archive"); then
    echo "First argument must be a zip archive"
    exit 1
fi

dir_ok=$2
dir_failed=$3
flags=$4

#create directory to unzip archive
mkdir unzipped1 
unzip "$1" -d "unzipped1"

mkdir -p "$dir_ok"
mkdir -p "$dir_failed"

files=$(find "unzipped1" -maxdepth 2 -mindepth 2 -printf "%p\n")
repeated_fn=$(echo "$files" | cut -d "/" -f2 | cut -d '-' -f1 | uniq -d)

 while read line; do 
    file_type=$(file "$line")
    archive_name=$(echo "$line" | cut -d "/" -f3)
    faculty_num=$(echo "$line" | cut -d "/" -f2 | cut -d '-' -f1)
    #check if there is more than one file in moodle
     while read fn; do
        if [ "$fn" == "$faculty_num" ];then
             mkdir -p "$dir_failed"/"$faculty_num"
            cp "./"$line"" ""$dir_failed"/"$faculty_num""
        else
        #check file type of archives
             if ! $(echo "$file_type" | grep -q "XZ compressed data") &&
                ! $(echo "$file_type" | grep -q "gzip compressed data") &&
                ! $(echo "$file_type" | grep -q "Zip archive data") &&
                ! $(echo "$file_type" | grep -q "RAR archive data") &&
                ! $(echo "$file_type" | grep -q "bzip2 compressed data") &&
                ! $(echo "$file_type" | grep -q "POSIX tar archive"); then  
                mkdir -p "$dir_failed"/"$faculty_num"
                cp "./"$line"" ""$dir_failed"/"$faculty_num""
            else 
                wrong_format=0
                wrong_name_ext=0
                no_dir=0
                wrong_dirname=0
                #file type - xz compressed data
               if  $(echo "$file_type" | grep -q "XZ compressed data") ;then
                    temp=$(mktemp -d)
                    tar -xf "./"$line"" -C "$temp"
                    path=$(find "$temp" -mindepth 1 -maxdepth 1 -not -path '*/.*')
                    #check if in archive there is a directory
                    if [ -d "$path" ];then
                        no_dir=0
                        path_dir=$(echo "$path" | cut -d '/' -f4)
                        #check name of the directory
                        if [ "$path_dir" == "$faculty_num" ];then
                            wrong_dirname=0
                        else    
                            wrong_dirname=1
                        fi
                    else
                        no_dir=1
                        wrong_dirname=1
                    fi
                    mkdir -p "$dir_ok"/"$faculty_num" && tar -xf "./"$line"" -C "$dir_ok"/"$faculty_num" --strip-components 1 
                    rm temp
                    # gzip compressed data file type
                elif $(echo "$file_type" | grep -q "gzip compressed data") ;then
                     wrong_format=1
                    temp=$(mktemp -d)
                    tar -xf "./"$line"" -C "$temp"
                    path=$(find "$temp" -mindepth 1 -maxdepth 1 -not -path '*/.*')
                     #check if in archive there is a directory
                    if [ -d "$path" ];then
                        no_dir=0
                        path_dir=$(echo "$path" | cut -d '/' -f4)
                    #check name of the directory
                        if [ "$path_dir" == "$faculty_num" ];then
                            wrong_dirname=0
                        else    
                            wrong_dirname=1
                        fi
                    else
                        no_dir=1
                        wrong_dirname=1
                    fi
                    mkdir -p "$dir_ok"/"$faculty_num" && tar -xf "./"$line"" -C "$dir_ok"/"$faculty_num" --strip-components 1 
                    rm temp
                    #zip archive file type
                 elif $(echo "$file_type" | grep -q "Zip archive data") ;then
                    wrong_format=1
                    temp=$(mktemp -d)
                    unzip "$line" -d "$temp"
                    path=$(find "$temp" -mindepth 1 -maxdepth 1 -not -path '*/.*')
                    if [ -d "$path" ];then
                        no_dir=0
                        path_dir=$(echo "$path" | cut -d '/' -f4)
                  
                        if [ "$path_dir" == "$faculty_num" ];then
                            wrong_dirname=0
                        else    
                            wrong_dirname=1
                        fi
                    else
                        no_dir=1
                        wrong_dirname=1
                    fi
                    mkdir -p "$dir_ok"/"$faculty_num"
                    unzip -d "$dir_ok"/"$faculty_num" -j "./"$line""
                    rm temp
                #rar archive file type
                elif $(echo "$file_type" | grep -q "RAR archive data"); then
                    wrong_format=1
                    unrar x "./"$line"" ""$dir_ok""
                #bzip2 file type
                elif  $(echo "$file_type" | grep -q "bzip2 compressed data");then
                    wrong_format=1
                    temp=$(mktemp -d)
                    unzip -d "$temp" -j "$line"
                    path=$(find "$temp" -mindepth 1 -maxdepth 1 -not -path '*/.*')
                    if [ -d "$path" ];then
                        no_dir=0
                        path_dir=$(echo "$path" | cut -d '/' -f4)
                  
                        if [ "$path_dir" == "$faculty_num" ];then
                            wrong_dirname=0
                        else    
                            wrong_dirname=1
                        fi
                    else
                        no_dir=1
                        wrong_dirname=1
                    fi
                mkdir -p "$dir_ok"/"$faculty_num" && unzip "./"$line"" -d "$dir_ok"/"$faculty_num" --strip-components 1
                rm temp
                #posix tar archive type 
                elif  $(echo "$file_type" | grep -q "POSIX tar archive");then
                    wrong_format=1
                       temp=$(mktemp -d)
                    tar -xf "./"$line"" -C "$temp"
                    path=$(find "$temp" -mindepth 1 -maxdepth 1 -not -path '*/.*')
                    if [ -d "$path" ];then
                        no_dir=0
                        path_dir=$(echo "$path" | cut -d '/' -f4)
                  
                        if [ "$path_dir" == "$faculty_num" ];then
                            wrong_dirname=0
                        else    
                            wrong_dirname=1
                        fi
                    else
                        no_dir=1
                        wrong_dirname=1
                    fi
                mkdir -p "$dir_ok"/"$faculty_num" && tar -xf "./"$line"" -C "$dir_ok"/"$faculty_num" --strip-components 1
                rm temp 
                fi
                #check archive name extension
                if ! $(echo "$line" | cut -d '/' -f3 | egrep -q "^"$faculty_num"\.tar\.xz");then
                     wrong_name_ext=1
                fi
                #write flags in file and sort
                 echo ""$faculty_num" "$wrong_name_ext" "$wrong_format" "$no_dir" "$wrong_dirname"" >> "$flags"
                 sort -n -o -k 1
            fi
        
        fi
        done < <(echo "$repeated_fn")
 done < <(echo "$files")

#delete created directory with archives
rm -r unzipped1