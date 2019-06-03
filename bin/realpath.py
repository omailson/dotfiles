#!/usr/bin/env python3

import os
import sys

def main():
    if len(sys.argv) < 2:
        sys.exit(1)

    path = sys.argv[1]

    # Expand environment vars
    path = os.path.expandvars(path)

    # Expand user var (eg: ~)
    path = os.path.expanduser(path)

    # Absolute path
    path = os.path.abspath(path)

    print(path)

if __name__ == '__main__':
    main()
