#!/usr/bin/env bash

source .env && export $(cut -d= -f1 .env)

crowdin upload sources
crowdin download
