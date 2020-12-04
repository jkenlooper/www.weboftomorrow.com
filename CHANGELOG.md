# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!--
Not every commit is added to this list, but many items listed are taken from the
git commit messages (`git shortlog 0.7.0..origin/develop`).

Types of changes

- **Added** for new features.
- **Changed** for changes in existing functionality.
- **Deprecated** for soon-to-be removed features.
- **Removed** for now removed features.
- **Fixed** for any bug fixes.
- **Security** in case of vulnerabilities.
-->

<!--
## [Unreleased] - ...
-->

<!-- TODO: update changelog when developing -->

## [Unreleased] - ...

Support deployment to S3 bucket.

### Added

- Shell scripts to create and deploy patch files to S3 and start a StaticPatch
  codebuild project
- Initial buildspec file to run integration testing in a CI environment
- Buildspec file to build the static site and start a deployment pipeline
- Page about weboftomorrow-infrastructure project

### Changed

- Moved custom SQL bits of document page and document list page to be in chill-data.yaml

### Removed

- Replaced old deploy S3 script
- Old page about Awesome Mud Works

## [0.8.0] - 2020-04-17

Rebaked project from cookiecutter-website 0.3.0.

### Added

- Canonical URLs can be set per page by chill data and defaults to request URL path.
- Design token support
- Changelog.

### Fixed

- favicon URL when served by https

### Changed

- Combined scripts for creating NGINX web config
- Cleaned up script to create ssl certificates for local development
- favicon
- Cleaned up print styles
- ...lots of things from version 0.1.0 to 0.7.0.

## [0.1.0] - 2015-09-20

Start of the project. Generated source files from
[cookiecutter-website version 0.1.0](https://github.com/jkenlooper/cookiecutter-website).
Created the initial [www.weboftomorrow.com](http://www.weboftomorrow.com) website.
