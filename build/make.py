#!/usr/bin/env python

"""Run this file to build the appropriate elements in this
library. This file should be self-sufficient with a basic Python
install of version 2.5 or above. It doesn't rely on any other
libraries or tools."""

import os.path
import subprocess
import logging

# Set this explicitly if the default sniffing doesn't work.
FLEX_SDK_BIN_PATH = os.path.abspath(os.path.dirname(
    subprocess.Popen(['which','mxmlc'], stdout=subprocess.PIPE).communicate()[0]
    ))

# These are then derived from the above.
COMPC_PATH = os.path.join(FLEX_SDK_BIN_PATH, 'compc')
MXMLC_PATH = os.path.join(FLEX_SDK_BIN_PATH, 'mxmlc')

# The package layout is detected relative to this directory.
PACKAGE_PATH = os.path.join(os.path.split(
        os.path.abspath(os.path.dirname(__file__))
        )[0])


def main():
    """Runs the build tasks from the command line."""
    logging.basicConfig(level=logging.INFO)
    build_library()

# Build functions
def build_library():
    """Builds the library into library/bin/thebigdev.swc"""

    logging.info("Building library.")
    
    # Find the .as files in the library and turn them into fully
    # qualified classes.
    src_path = os.path.join(PACKAGE_PATH, 'library', 'src')
    classes = _get_classes_from_files(src_path)

    # Compile the compc command
    command = [
        COMPC_PATH,
        '-source-path+='+src_path,
        '-source-path+='+
        os.path.join(PACKAGE_PATH, 'library', 'externals', 'tweener'),
        '-output='+
        os.path.join(PACKAGE_PATH, 'library', 'lib', 'thebigdev.swc'),
        '-include-classes'] + classes
    subprocess.call(command)
    
# Utility functions
def _get_classes_from_files(base_path):
    """Given a base path, search for .as files and return their class names.
    
    Recursively searches and returns a list of fully qualified class
    names corresponding to those files.  The classes assume that the
    base path is the root of the package hierarchy."""
    
    classes = []
    def add_class(_, path, fnames):
        path = os.path.relpath(path, base_path)
        for i in range(len(fnames)-1, -1, -1):
            fname = fnames[i]
            if fname[0] == '.':
                # Don't recurse into hidden directories.
                del fnames[i]
                continue
            elif fname[-3:] == '.as':
                full_path = os.path.join(path, fname[:-3])
                classes.append(full_path.replace('/', '.'))
    os.path.walk(base_path, add_class, None)
    return classes
    
    
if __name__ == '__main__':
    main()
