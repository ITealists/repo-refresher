# repo-refresher
Simple utility to setup a git repository in a docker and update it periodically

## Status
- 3 Jun 17 - This is under development! Currently only tested with user+token

## About
I wanted a `docker image` that only did one thing - setup up a `git` repository in your docker and take care of refreshing it on a schedule.
That way it could be more easily pulled into other builds as needed and resused for multiple repositories
This uses `alpine:latest` as this is a popular base for other lightweight builds.

## What it does
1. Schedules `git-setup` to run everyminute until `$REPO` is set and it runs successfully
2. Schedules `git-refresh` to run periodically (default 10m)

### in standalone mode
3. Starts `crond` in the foreground to keep the docker running.

### as inherited build
tk

### What it doesn't do
- Start your app
- Expose ports

## Quick Start

    docker build -t repo-refresher:latest .
    docker run -d -e REPO=test -e GIT_BASE=github.com/ITealist --name=my-test:0.1
    

## Configuration
You set the configuration with environment variables. This allows the utility to be run outside docker as well if desired.

### ENV Options
####Refresh Setting
- `REFRESH` - _in cron syntax eg `* * * * *` or the current default `*/10 * * * *` See [Cron Tutorial[(https://code.tutsplus.com/tutorials/scheduling-tasks-with-cron-jobs--net-8800) if you need help
####Git Settings
**Note** These settings can also be set by mounting a directory `git` with corresponding files. See the **`git` credentials** section
- `GIT_BASE` - _the host and username/orgname where the repository resides. eg `github.com/ITealist`
- `GIT_USER` - _the username for authentication, if needed._
- `GIT_KEY` - _the auth token for GIT_USER, if needed._

####Repository Settings
- `REPO` **required** - _the name of the repository to pull. Is also used as the name of the file repository is pulled into_
- `BRANCH` **default=master** _allows you to sync to a specific branch. useful for version branches or comparison testing_
- `STAGE` **defaults to branch** _allows you to specify the stage (eg `dev`,`qa`,`prod`) if working in staged environments
- `GIT_FULL` _allows you to fully specify the target repo

### `git` credentials
_Credentials can either be supplied as `ENV`s or via files in the mounted `VOLUME` `git`_ Environment Variables will take precedence. When using the file, the value is expected to be the only contents and on the first line without any quotes

**Credentials**
- **User**: Either `$GIT_USER` or `git/git_user`
- **Key**: Either `$GIT_KEY` or `git/git_key`
- **Base**: Either `$GIT_BASE` or `git/git_base`

This break-down of parameters is intended to facilitate a higher degree of reuse by allowing the same `git` directory to be mounted onto multiple docker. In cases where that is not needed, **`$GIT_FULL`** can be used to completely bypass.

#### Example of file contents
**`git/git_base`**

    github.com/ITealist
    
**`git/git_user`**

    lnryan
    

    
