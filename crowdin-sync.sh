#!/usr/bin/env bash

source .env && export $(cut -d= -f1 .env)

crowdin download
crowdin upload sources
