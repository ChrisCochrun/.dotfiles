#!/usr/bin/env python3

import os
from datetime import datetime


dir = os.listdir()
print(dir)

for file in dir:
    print(file)
    #print(os.stat(file))
    modified = datetime.fromtimestamp(os.stat(file).st_mtime)
    print(modified)
    year = modified.year
    # print(year)
    # month = modified.month
    # print(month)
    # day = modified.day
    # print(day)
    # root, extension = os.path.splitext(file)
    # print(extension)
    # if not extenstion:
    #     continue
    if year in dir:
        print("dir 2020 exists")
        break
        continue
    #os.makedirs(str(year) + '/' + str(month) + '/' + str(day))
