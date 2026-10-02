#!/bin/bash
# @package exadra37-docker-images/dockerize-graphical-user-interface-app
# @link    https://gitlab.com/u/exadra37-docker-images/dockerize-graphical-user-interface-app
# @since   11 March 2017
# @license GPL-3.0
# @author  Exadra37(Paulo Silva) <exadra37ingmailpointcom>
#
# Social Links:
# @link    Auhthor:  https://exadra37.com
# @link    Gitlab:   https://gitlab.com/Exadra37
# @link    Github:   https://github.com/Exadra37
# @link    Linkedin: https://uk.linkedin.com/in/exadra37
# @link    Twitter:  https://twitter.com/Exadra37


########################################################################################################################
# Execution
########################################################################################################################

    # Run the given command, or the user Shell when none is given. Using exec so that signals reach the process.
    if [ "${#}" -gt 0 ]
        then
            exec "${@}"
    fi

    exec "${SHELL:-/bin/bash}"
