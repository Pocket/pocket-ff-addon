#!/usr/bin/python

##
# This script is designed to update the l10n files and locale registration for
# the standalone loop client and loop add-on. The source of the localization
# files is https://github.com/mozilla/loop-client-l10n repository.
# The loop repo is assumed to be https://github.com/mozilla/loop.
#
# Run this script from the local version of loop. It assumes that a local
# version of loop-client-l10n is in a parallel directory: ../loop-client-l10n.
##

from __future__ import print_function

import argparse
import io
import os
import re
import shutil
import localeUtils

# defaults
DEF_L10N_DST = os.path.join("build", "locale")
DEF_JAR_FILE_NAME = os.extsep.join(["locale", "jar", "mn"])
DST_JAR_FILE_NAME = os.path.join("build", "locale", os.extsep.join(["jar", "mn"]))


def main(l10n_dst, jar_file_name):
    shutil.copy(DEF_JAR_FILE_NAME, jar_file_name);

    # Note: Use the destination directory here to get en-US as well.
    locale_list = localeUtils.getLocalesList(l10n_dst)

    print("updating locales list in", jar_file_name)
    with io.open(jar_file_name, "r+") as jar_file:
        jar_mn = jar_file.read()

        # Replace multiple locale registrations with new locales.
        # The jar.mn preprocessor can't cope with '-' so we add some defines
        # in so it can handle '_' instead.
        dashLocales = []
        for locale in locale_list:
            if "-" in locale:
                dashLocales.append('#define {0} {1}'.format(locale.replace("-", "_"), locale))

        new_content = re.sub(
            '(#define .+\n)+',
            '\n'.join(dashLocales) + '\n',
            jar_mn)

        # One big if statement to avoid lots of if/endif lines, and the preprocessor
        # can't cope with '\' on the end of the line.
        jar_locales = ['AB_CD == {0}'.format(x.replace("-", "_")) for x in locale_list]

        new_content = re.sub(
            '(#if AB_CD.+\n)',
            '#if ' + ' || '.join(jar_locales) + '\n',
            new_content)

        jar_file.seek(0)
        jar_file.truncate(0)
        jar_file.write(new_content)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Generate jar.mn for locale directory")
    parser.add_argument('--dst',
                        default=DEF_L10N_DST,
                        metavar="path",
                        help="Destination path for l10n resources. Default = " + DEF_L10N_DST)
    parser.add_argument('--jar-file',
                        default=DST_JAR_FILE_NAME,
                        metavar="name",
                        help="Jar file to be updated with the locales list. Default = " + DST_JAR_FILE_NAME)
    args = parser.parse_args()
    main(args.dst, args.jar_file)
