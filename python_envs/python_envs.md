# Working With Python on FIJI

Working with python on FIJI is a huge pain. Today we'll go over the
basics of setting things up so that it's not quite so painful. Today
we'll go over:
- Making sure that pip is available for your user
- Installing packages on your own user account
- Setting up virtual environments (easy, medium, and hard)
- Managing different python versions

## Setting up pip in the first place

Unfortunately, the python packages provided with FIJI don't always
work well with pip. You can fix this by running:

```shell
module load python/3.6.3 # Pick your favorite python version
python3 -m ensurepip --user # Install pip in your user directory
```

When you do this, python installs a copy of pip to `~/.local/`. To use
this version of pip, you need to add the following to your `~/.bash_profile`:

```shell
export PATH=$PATH:"$HOME"/.local/bin
```

With this done, you should be able to install python packages normally
using pip. From now on you can install whatever you want by using the
`--user` flag for pip. Try to test it by running:

```shell
source ~/.bash_profile # Load the changes we just made
pip install --user numpy # Install a package
pip show --user # Show all your installed packages
```

## Virtual environments, from hard to easy

Virtual environments allow you to keep separate installations of
python for different projects. By doing this, you can keep fixed
versions of your dependencies for tools that need them. We'll walk
through 3 different ways to do this, from easy to hard.

## More advanced tools

- pipenv
- pyenv
- pipx
- poetry
