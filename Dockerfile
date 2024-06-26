# Base on the LTS of your choice
FROM ubuntu:focal

# We mount a BuildKit secret here to access the attach config file which should
# be kept separate from the Dockerfile and managed in a secure fashion since it
# needs to contain your Ubuntu Pro token.
# In the next step, we demonstrate how to pass the file as a secret when
# running docker build.
# RUN --mount=type=secret,id=pro-attach-config \
RUN --mount=type=secret,id=fips_config \
   #
   # First we update apt so we install the correct versions of packages in
   # the next step
   apt-get update \
   #
   # Here we install `pro` (ubuntu-advantage-tools) as well as ca-certificates,
   # which is required to talk to the Ubuntu Pro authentication server securely.
   && apt-get install --no-install-recommends -y ubuntu-advantage-tools ca-certificates \
   #
   # With pro installed, we attach using our attach config file from the
   # previous step
   && pro attach --attach-config /run/secrets/fips_config \
   #
   ###########################################################################
   # At this point, the container has access to all Ubuntu Pro services
   # specified in the attach config file.
   ###########################################################################
   #
   # Always upgrade all packages to the latest available version with the Ubuntu Pro
   # services enabled.
   && apt-get upgrade -y \
   #
   # Then, you can install any specific packages you need for your docker
   # container.
   # Install them here, while Ubuntu Pro is enabled, so that you get the appropriate
   # versions.
   # Any `apt-get install ...` commands you have in an existing Dockerfile
   # that you may be migrating to use Ubuntu Pro should probably be moved here.
   && apt-get install -y openssl \
                         snapd
   #
   ###########################################################################
   # Now that we have upgraded and installed any packages from the Ubuntu Pro
   # services, we can clean up.
   ###########################################################################
   #
   # This purges ubuntu-advantage-tools, including all Ubuntu Pro related
   # secrets from the system.
   ###########################################################################
   # IMPORTANT: As written here, this command assumes your container does not
   # need ca-certificates so it is purged as well.
   # If your container needs ca-certificates, then do not purge it from the
   # system here.
   ###########################################################################
   && apt-get purge --auto-remove -y ubuntu-advantage-tools ca-certificates \
   #
   # Finally, we clean up the apt lists which should not be needed anymore
   # because any `apt-get install`s should have happened above. Cleaning these
   # lists keeps your image smaller.
   && rm -rf /var/lib/apt/lists/*


# Now, with all of your Ubuntu apt packages installed, including all those
# from Ubuntu Pro services, you can continue the rest of your app-specific Dockerfile.
