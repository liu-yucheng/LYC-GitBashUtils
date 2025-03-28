<!---
Copyright 2022 Yucheng Liu. GNU GPL3 license.
GNU GPL3 license copy: https://www.gnu.org/licenses/gpl-3.0.txt
--->

# LYC-GitBashUtils

A Git Bash utility application I write for software engineering purposes.

Properly updating a multi-branch Git repository typically requires dozens of Git Bash commands or dozens of clicks on the Git GUI.

I write this application with the hope that it can save the users from endlessly and repeatedly typing series of Git Bash commands or clicking on certain elements of the Git GUI when updating their repositories.

In many of my projects, this application saved me the time to enter multiple Git Bash commands on my terminals.

It also saved me the time to think about the right command combination to use when updating my repositories.

It lets me focus on the software codes to update and gives me a better software developing experience.

This application, formerly an utility collection, manages to **control the version of itself** in a Git Bash environment since version `0.2.2`.

# Notes On `git` Operations

This application contains commands that have **batch `git` operations**.

I recommend you to **run and check `git status` and `git log`** before running commands provided by this application.

# Installation

- Download the source code.
- Ensure that `bash` and `git` are ready.
- Install the application. (Optional. See below.)
- Run the application in the following ways.

## Bash Environment Installation

- I recommend you to install the application in this way.
- Go to the root directory of this repository.
- Run the `./install.bash` command.
- This will install the application to `~/.bash_profile` and `~/.bashrc`.
- Upon uninstallation, remember to run the `./uninstall.bash` command.
- Run `gbu` and its sub-commands from a GNU Bash shell.

## Direct Script Execution

- You can run the application in this way without a Bash environment installation.
- Directly run the Bash scripts in the `lyc-git-bash-utils/exes` folder of this repository.
- You can make a shortcut to the `exes` folder at somewhere you like to get access to the scripts more easily.

# Usage (From a GNU Bash shell with `git`)

`gbu`:

The main command and entry to the sub-commands.
Short for `Git Bash Utilities`.

`gbu help`:

The help subcommand.
Shows detailed help information.

# `gbu` Branching Model

This application implements the `gbu` branching model.

The `gbu` branching model is a branching model I designed for this application based on my past software developing experience.

I am continuously refining this model as I am updating this application.

A flowchart of the current `gbu` branching model is attached as an SVG image below.

![GBU-Branching-Model-White-BG.svg](README-Assets/GBU-Branching-Model-White-BG.svg)

# `gbu help` Help Page
```bash
$ gbu help
Usage: gbu <command> ...
==== Commands ====
help:
    When:   You need help info. For example, now.
    How-to: gbu help
info:
    When:   You need too see the package info.
    How-to: gbu info
list-main-names:
    When:   You need to list git and gbu main branch name settings.
    How-to: gbu list-main-names
clear-main-names:
    When:   You need to restore the default git and gbu main branch name settings.
    How-to: gbu clear-main-names
set-main-name:
    When:   You need to update git and gbu main branch name settings.
    How-to: gbu set-main-name <new-main-name>
list-user-info:
    When:   You need to list the git user info.
    How-to: gbu list-user-info
set-user-info:
    When:   You need to update the git user info.
    How-to: gbu set-user-info <name> <email>
show-graph:
    When:   You need to show the git branch graph.
    How-to: gbu show-graph
create-rel:
    When:   You need to create a rel (release) branch.
    How-to: gbu create-rel
create-dev:
    When:   You need to create a dev (development) branch.
    How-to: gbu create-dev
init-repo:
    When:   You need to initialize the current repository.
    How-to: gbu init-repo
dev-merge-rel:
    When:   You need the dev branch to merge the rel branch.
    How-to: gbu dev-merge-rel
update-feature:
    When:   You need to update a feature with a feature branch.
    How-to: gbu update-feature <feature-branch-name> <feature-commit-message>
    Aliases: update-dev-feature
rel-merge-dev:
    When:   You need the rel branch to merge the dev branch.
    How-to: gbu rel-merge-dev
update-patch:
    When:   You need to update a patch with a patch branch.
    How-to: gbu update-patch <patch-branch-name> <patch-commit-message>
    Aliases: update-rel-patch
main-merge-rel:
    When:   You need the main branch to merge the rel branch.
    How-to: gbu main-merge-rel
merge-dev-updates:
    When:   You need rel to merge dev, and then main to merge rel.
    How-to: gbu merge-dev-updates
merge-rel-updates:
    When:   You need dev to merge rel, and then main to merge rel.
    How-to: gbu merge-rel-updates
tag-main:
    When:   You need to tag the latest commit on the main branch.
    How-to: gbu tag-main <tag-name>
push-updates:
    When:   You need to push the local updates to a remote repository.
    How-to: gbu push-updates [<optional-remote>]
pull-updates:
    When:   You need to pull the updates from a remote repository.
    How-to: gbu pull-updates [<optional-remote>]
```

# Dependencies

The list of dependencies can be found in `<this-repo>/dependencies.txt`.

- `bash`
- `git`

# Testing

After installation, you can test this application by running `<this-repo>/test-all.bash`.

If you see some terminal outputs in the following form, then go on and enjoy the application.

```bash
$ ./test-all.bash
............ ...
-
Ran <test-count> tests  Time taken: H:MM:SS (hours: minutes: seconds)
Successes: <test-count>  Failures: 0
```

Otherwise, you are welcomed to start some issues in or send some pull requests to this repository.

# Miscellaneous
## Developer's Notes :memo: And Warnings :warning:
### Notes :memo:

This application is distributed under the **GNU GPL3 license**.

A subsequent work of this application is a work that satisfies **any one** of the following:

- Is a variant of any form of this application.
- Contains a part, some parts, or all parts of this application.
- Integrates a part, some parts, or all parts of this application.

All subsequent works of this application **must also be distributed under the GNU GPL3 license, and must also open their source codes to the public**.

The non-subsequent works whose versions are managed by this application do not have to be distributed under the GNU GPL3 license.

However, if you find this application useful, I encourage you to also distribute a selection your works under the GNU GPL3 license as your contribution to the open-source community.

### Warnings :warning:

Making a **closed-source** subsequent work (as defined above) of this application, and distribute it to the public is **unlawful**, no matter if such work makes a profit.

Doing so may result in severe civil and criminal penalties.

I reserve the rights, funds, time, and efforts to prosecute those who violate the license of this application to the maximum extent under applicable laws.

## Versions
### Versioning

```text
The versioning of this application is based on Semantic Versioning.
You can see the complete Semantic Versioning specification from
  https://semver.org/.
Basically, the version name of this application is in the form of:
  x.y.z
  Where x, y, and z are integers that are greater than or equal to 0.
  Where x, y, and z are separated by dots.
  x stands for the major version and indicates non-compatible major changes to
    the application.
  y stands for the minor version and indicates forward compatible minor
    changes to the application.
  z stands for the patch version and indicates bug fixes and patches to the
    application.
```

### Version Tags

```text
The version tags of this repository has the form of a letter "v" followed by a
  semantic version.
Given a semantic version:
  $x.$y.$z
  Where $x, $y, and $z are the semantic major, minor, and patch versions.
The corresponding version tag would be:
  v$x.$y.$z
The version tags are on the main branch.
```

## Copyright

```text
Copyright 2022-2025 Yucheng Liu. Under the GNU AGPL 3.0 license.
GNU AGPL 3.0 license: https://www.gnu.org/licenses/agpl-3.0.txt .
```
