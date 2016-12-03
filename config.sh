# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    :
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    python --version
    # Sanity check: the compiled extensions are available.
    python -c "import sqlalchemy.cprocessors"
    python -c "import sqlalchemy.cresultproxy"
    python -c "import sqlalchemy.cutils"
}

function notag_wheel_cmd {
    # This is a copy of bdist_wheel_cmd, but adds `egg_info --tag-build=''`
    local abs_wheelhouse=$1
    python setup.py egg_info --tag-build='' bdist_wheel
    cp dist/*.whl $abs_wheelhouse
}


function build_notag_wheel {
    build_wheel_cmd "notag_wheel_cmd" $@
}

function build_wheel {
    # Override common_utils.sh/build_wheel to use our build function.
    build_notag_wheel $@
}

function upload_wheel {
    if [ "$UPLOAD_TO_PYPI" = "true" ]
    then
        pip install twine
        echo "Uploading to PyPI..."
        twine upload -u "$PYPI_USERNAME" -p "$PYPI_PASSWORD" ${TRAVIS_BUILD_DIR}/wheelhouse/*.whl
    else
        echo "Skipping PyPI upload, UPLOAD_TO_PYPI != true"
    fi
}