# Set up UCliD5 environment

# Use ubuntu
FROM ubuntu:20.04

# Use bash
SHELL ["/bin/bash", "-c"]

ENV TZ=US
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# Clone the repository
RUN apt-get update && apt-get install -y git curl openjdk-11-jdk zip unzip wget vim

RUN curl -s "https://get.sdkman.io" | bash
RUN source "$HOME/.sdkman/bin/sdkman-init.sh" \
    && sdk install sbt \
    && git clone https://github.com/uclid-org/uclid.git \
    && cd /uclid && sbt update clean compile "set fork:=true" && sbt universal:packageBin

# Download from release https://github.com/uclid-org/uclid/releases/download/v0.9.5d-prerelease/uclid-0.9.5.zip
# RUN curl -LO https://github.com/uclid-org/uclid/releases/download/v0.9.5d-prerelease/uclid-0.9.5.zip
RUN unzip /uclid/target/universal/uclid-0.9.5.zip -d /uclid

# Add `/uclid/uclid-0.9.5/bin/` to the PATH environment variable.
ENV PATH="/uclid/uclid-0.9.5/bin/:${PATH}"

# Copy `./bin/z3` to `/uclid/uclid-0.9.5/bin/`
COPY ./bin/z3 /uclid/uclid-0.9.5/bin/

# Add `LD_LIBRARY_PATH` to the environment variable
ENV LD_LIBRARY_PATH="/uclid/uclid-0.9.5/bin/:${LD_LIBRARY_PATH}"

# Copy `/src` to `/src` in the container
COPY ./src /src

# Set the working directory
WORKDIR /src