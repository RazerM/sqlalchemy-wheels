@echo ON
pip install --no-index --find-links=dist %PACKAGE_NAME%

rem Do sanity check to make sure we can import the compiled extensions
python -c "import sqlalchemy.cprocessors"
python -c "import sqlalchemy.cresultproxy"
python -c "import sqlalchemy.cutils"

IF "%UPLOAD_TO_PYPI%"=="true" (
    twine upload -u %PYPI_USERNAME% -p %PYPI_PASSWORD% dist\*.whl
)
