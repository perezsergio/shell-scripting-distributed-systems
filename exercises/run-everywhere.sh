#!/bin/bash

# Executes some command from all the servers specified at the servers_file

function echoUsage() {
    # prints usage statement
    echo "Usage: $0 [-f FILE] [-n] [-s] [-v] COMMAND" >&2
}

function checkFileExists() {
    # Usage checkFileExists FILE
    file=$1
    if [[ ! -e "$file" ]]; then
        echo "Cannot open $file. No such file or directory." >&2
        exit 1
    fi
}

function dryRun() {
    # Usage: dryRun run_with_sudo server command1;command2;command3
    run_with_sudo=$1
    server=$2
    shift 2
    if [ "$run_with_sudo" == true ]; then
        echo "$*" | tr ';' '\n' | while read -r command; do
            echo "DRY RUN: [$USER@$server]\$ sudo $command"
        done
    else
        echo "$*" | tr ';' '\n' | while read -r command; do
            echo "DRY RUN: [$USER@$server]\$ $command"
        done
    fi
}

# parse command line options
use_custom_servers_file=false
is_dry_run=false
run_with_sudo=false
verbose=false
while getopts f:nsv OPTION; do
    case ${OPTION} in
    f)
        use_custom_servers_file=true
        custom_servers_file=${OPTARG}
        ;;
    n)
        is_dry_run=true
        ;;
    s)
        run_with_sudo=true
        ;;
    v)
        verbose=true
        ;;
    *)
        echoUsage
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1)) # Remove options from arguments

# Don't execute script with sudo, use -s option instead
if [[ "$UID" == 0 ]]; then
    echo "Don't execute script with sudo, use -s option instead"
    echoUsage
    exit 1
fi

# if num of options is 0, echo usage and exit
if [[ "$#" == 0 ]]; then
    echoUsage
    exit 1
fi

# if use_custom_servers_file, use the specified file, else use the default servers_file
if [ "$use_custom_servers_file" == true ]; then
    checkFileExists "$custom_servers_file"
    servers_file=$custom_servers_file
else
    servers_file="/vagrant/data/servers"
fi

# Loop over the servers at servers_file
while read -r server; do
    if [ "$verbose" == true ]; then
        echo "Executing command on host $server"
    fi
    if [ "$is_dry_run" == true ]; then
        dryRun "$run_with_sudo" "$server" "$*"
        continue
    fi
    if [ "$run_with_sudo" == true ]; then
        sudo ssh -n -o ConnectTimeout=2 "$server" "$*"
        exit_status=$?
    else
        ssh -n -o ConnectTimeout=2 "$server" "$*"
        exit_status=$?
    fi
    if [ $exit_status -ne 0 ]; then
        echo "Error: Received a non-zero exit status from $server" >&2
    fi
done <"$servers_file"

exit "$exit_status"
