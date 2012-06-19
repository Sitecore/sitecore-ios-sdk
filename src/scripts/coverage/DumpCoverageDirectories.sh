find . -type f -name "*.gcno" -exec python -c "import os.path; import sys; print os.path.dirname( os.path.abspath(sys.argv[1]) )" {} \; > CoverageDirectories.txt
