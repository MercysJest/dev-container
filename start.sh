#!/bin/bash
docker run -d -p 127.0.0.1:22:22 -v $(pwd)/dev1:/home/coder --name dev_container dev_image
