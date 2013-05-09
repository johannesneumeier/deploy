# deploy (v0.0.1)

Helper bash script for easier repeated scp'ing of the same resources or subfolders and -files. 


## Problem: 

You have a project you often scp from ~/foo/bar/ to host:/var/www/foo/bar/
The script remembers the two scp "root folders" and you can deploy the whole folder or subfolders or -files based on that path.


## Example usage:

- Setup deploy to use source folder ~/foo/bar/ and destination folder host:/var/www/foo/bar/ (calling ./deploy.sh will automatically prompt to setup a configuration file)
- Deploy the whole content of ~/foo/bar/: 

    $user: ./deploy.sh
- Deploy the whole content of subfolder "~/foo/bar/goo/": 

    $user: ./deploy.sh goo/*
- Deploy the file "~/foo/bar/goo/foobar.txt": 

    $user: ./deploy.sh goo/foobar.txt
- Reverse the direction, get the file "host:/var/www/foo/goo/barfoo.txt":

    $user: ./deploy.sh -r goo/barfoo.txt


## Parameters:

- -u (update) will ask you to set new source and destination locations and store them in the deploy.config file (when you run the script without a deploy.config file present, this will be called automatically)
- -r (reverse) will reverse the copy direction


### Notes:

- You might have to make the script executable first by typeing:
    chmod +x deploy.sh
- The script always copies recursively
- You can't copy to folders that don't exist
- Use at your own risk