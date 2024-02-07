# [Choice] Alpine version: 3.16, 3.17, 3.18, 3.19
ARG VARIANT
FROM alpine:${VARIANT}

# [Option] Install zsh
ARG INSTALL_ZSH

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
#ARG USERNAME=vscode
#ARG USER_UID=1000
#ARG USER_GID=$USER_UID

ARG USERNAME
ARG USER_UID
ARG USER_GID

COPY library-scripts/*.sh library-scripts/*.env /tmp/library-scripts/
RUN apk update && ash /tmp/library-scripts/common-alpine.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" && rm -rf /tmp/library-scripts

# ** [Optional] Uncomment this section to install additional packages. **
# RUN apk update \
#     && apk add --no-cache <your-package-list-here>

CMD /bin/zsh
