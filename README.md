# CF Get Service Info

## Overview
A shell script for retrieving service instance information using the service GUID. The primary usage scenario for this script is to trace a service instance found via `bosh deployments` back to the the relevant Cloud Foundry service information, such as the service name, orgs, space, and bound apps.


## Requirements
This script must be run from a system with both the CFI CLI and `jq` installed. In order to get the most output, it is desirable that the CF CLI be logged in with a user with administrative privileges.

## Usage
The script takes a single argument: the service GUID. In many cases this will be all characters following the `service-instance_` section of a service instance BOSH deployment name.
