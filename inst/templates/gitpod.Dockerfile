# {{{generator}}}
#
# Call:
{{{call}}}

# You can find the new timestamped tags here: https://hub.docker.com/r/gitpod/workspace-base/tags
FROM gitpod/workspace-base:latest

# Install R and ccache
RUN sudo apt update
RUN sudo apt install -y \
  r-base \
  ccache \
  cmake \
  {{{apt_packages}}} \
  # Install dependencies for devtools package
  libharfbuzz-dev libfribidi-dev
