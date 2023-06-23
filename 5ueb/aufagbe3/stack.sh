#!/bin/bash

ulimit -s 1024

recursive_function() {
    recursive_function
}

recursive_function
