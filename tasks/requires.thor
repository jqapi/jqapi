# HORRIBLE HACK ALERT
# This file is loaded and parsed every time thor is invoked
# meaning all other .thor files are implicitly dependent on it.
# Gross, but it works.

ROOT_DIR = File.join(File.dirname(__FILE__), '..')
$LOAD_PATH.unshift(File.join(ROOT_DIR, 'app'))

require 'jqapi'
