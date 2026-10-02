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
# Functiions
########################################################################################################################

    function Print_Text_With_Label()
    {
        local _label_text="${1}"

        local _text="${2}"

        local _label_background_color="${3:-42}"

        local _text_background_color="${4:-229}"

        printf "\n\e[1;${_label_background_color}m ${_label_text}:\e[30;48;5;${_text_background_color}m ${_text} \e[0m \n"
    }


########################################################################################################################
# Variables Arguments
########################################################################################################################

    container_user="${1?}"

    container_shell="${2?}"

    # Path inside the container (copied into the image by an extending Dockerfile) of a custom setup script.
    host_setup_user_shell_file="${3:-/.container/custom-setup-user-shell.sh}"

    OH_MY_ZSH_COMMIT="${OH_MY_ZSH_COMMIT:-4d4cfc287e9d887b81242c0e431b5f49f9cec5c1}"


########################################################################################################################
# Execution
########################################################################################################################

    Print_Text_With_Label "Container User" "${container_user}"
    Print_Text_With_Label "Container Shell" "${container_shell}"
    Print_Text_With_Label "Host Setup User Shell File" "${host_setup_user_shell_file}"

    # Let's give the User the chance to customize the Shell
    if [ -f "${host_setup_user_shell_file}" ]
        then
            bash "${host_setup_user_shell_file}" "${container_user}" "${container_shell}"

    # If setup user shell file is not found in the given path and the Shell to setup is ZSH we will install ZSH with awesome
    #  Oh My Zsh package to increase the Shell functionality and productivity, with the added benefit of coloured output.
    elif [ 'zsh' == "${container_shell##*/}" ]
        then
            # Git is needed to fetch Oh My Zsh. Ca-certificates are already installed by the Dockerfile.
            apt-get install -y --no-install-recommends \
                zsh \
                git && \
            # Fetching a pinned commit, instead of `curl | sh` the installer from master, so that the build is
            #  reproducible and we don't execute whatever is in master at build time.
            su "${container_user}" -c "
                set -e
                git init -q ~/.oh-my-zsh
                cd ~/.oh-my-zsh
                git remote add origin https://github.com/ohmyzsh/ohmyzsh.git
                git fetch -q --depth 1 origin ${OH_MY_ZSH_COMMIT}
                git checkout -q FETCH_HEAD
                cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
            "
    fi
