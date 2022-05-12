#!/bin/bash
sort \
< <(cat a.txt) \
> >(wc -l)