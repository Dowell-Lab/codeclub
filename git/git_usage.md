
# Table of Contents

1.  [An Overview of Git](#orgff44acd)
    1.  [Understanding Git](#org3c25750)
        1.  [Version Control Systems From Scratch](#org32dd315)
        2.  [A Brief Overview of Git's Internals](#orgc2c2f97)
        3.  [Why Design It This Way?](#org8380e7b)
    2.  [Git Basics](#org559b1dc)
        1.  [Terminology](#org5fa2dde)
        2.  [A Basic Git Workflow](#org347da21)
        3.  [Adding a Remote Repository](#org0274645)
        4.  [Branches and Forks](#orge471ba1)
    3.  [Intermediate Topics](#orgb6f19e2)
        1.  [Merging and Rebasing](#org1b2efa3)
        2.  [Gitignore](#org1d764be)
        3.  [Licensing](#org79fe248)
        4.  [Large Files](#org8f4ac52)
        5.  [Tags](#org8cc17f1)
        6.  [Stashing](#org59da0ca)
        7.  [Git Config File](#orgc0f6355)
    4.  [Advanced Topics](#org4dcb64c)
        1.  [Repositories inside Repositories](#orgf2749b0)
        2.  [Bisect](#org8a226eb)
        3.  [Cherry-pick](#org007c055)
        4.  [Filter-branch](#org90128c7)
        5.  [Email Patches](#orgf584f7a)
        6.  [Rerere](#orgc3d28a8)
    5.  [Making a Pull Request](#org6b922d8)


<a id="orgff44acd"></a>

# An Overview of Git

This document contains a thorough overview of essential concepts
that will help you effectively use the git version control system.
There are a few paths that you can take, depending on how
experienced you are with git:

-   **I've never used git before:** Go through 'Understanding Git' and
    'Git Basics'. Then, jump to 'Making a Pull Request' to practice
    what you just learned.
-   **I push and pull from repositories I own:** Go through
    'Understanding Git', then the 'forks and branches' in the 'Git
    Basics' section. From there, jump to 'Making a Pull Request' to
    practice. When you're done with that, review the intermediate
    topics that interest you.
-   **I'm know how to work with multiple repositories:** Complete the
    'Making a Pull Request' section and then look through the
    intermediate topics section. 'Licensing' is probably of
    particular interest to you.
-   **I already knew the intermediate topics:** Complete the 'Making a
    Pull Request' section and then review the advanced topics
    section. If you're at this point, you can probably teach yourself
    all of these things on your own, so the advanced section just
    describes the function of some features that you might find useful.
-   **I'm an expert on git, teach me something:** This guide isn't
    really for you. If you want to learn something new, work through
    something like [Write Yourself a Git](https://wyag.thb.lt/), [The Offical Git Internals
    Documentation](https://git-scm.com/book/en/v1/Git-Internals), or


<a id="org3c25750"></a>

## Understanding Git

Today we're going to go over a piece of software called git. Git
is currently the most widely used software for "version control"
in the world. Although git is powerful, it can be tricky to
understand at first.


<a id="org32dd315"></a>

### Version Control Systems From Scratch

To properly understand how git works, we'll first go over the
ideas that led to the creation of version control systems in the
first place. 

Suppose you were working on a document in something like
Microsoft Word, and you wanted to create a copy of it to send to
your collaborators. Say your document is called `paper.doc`.
After you send it to collaborators, you'll probably get back a
copy of the file with a different name, like
`paper_revisions.doc`. Once you make your changes, you might make
a new copy called `paper_final.doc` that contains all the changes
after you've put the revisions from your collaborator back in.

If you do this, you'll end up with a bunch of files:

-   `paper.doc`
-   `paper_revisions.doc`
-   `paper_final.doc`

If you repeated this process, you'd end up with a lot of files
eventually, and it would be hard to keep track of them. How do we
fix this? The first obvious idea is to make a new folder for each
revision, and copy over the version of the file after your latest
changes. 

-   08/05/2019 <- before revisions
    -   `paper.doc`
-   08/07/2019 <- after revisions
    -   `paper.doc`
-   08/09/2019 <- after more revisions
    -   `paper.doc`
-   Current <- your current version
    -   `paper.doc`

If we do things this way, we can go back and look at the document
at any point in time. Under the hood, this is what a version
control system like git is doing. Git provides a way to do this
with lots of files at once, and with lots of people.


<a id="orgc2c2f97"></a>

### A Brief Overview of Git's Internals

By now, you hopefully understand why someone might want to have a
version control system. Here, we're going to briefly cover how
git actually keeps track of files.

In the above example we used dates to keep track of versions.
While this makes sense, it can be tricky to work with if lots of
people are working on the same things at the same time. Instead,
git uses something called a hash, which is a special function
that creates a unique "signature" when you put data through it.
If you want to test it out, you can run `sha1sum $FILE` on any
file you have. Hashes are unique, which means we can use them to
keep track of unique versions of files. Hashes also change
dramatically if the file changes at all. If we use hashes instead
of dates for the same file structure we had above, we end up with
something like:

-   8db90c34528c04df877b63fb9ce6c38c073ae6af <- before revisions
    -   paper.doc
-   0de100ebd1dc381376b0c20adb52c0002a68dc13 <- after revisions
    -   paper.doc
-   31d2b14789c655c917040612118ee00dae61cc56 <- after more revisions
    -   paper.doc
-   HEAD <- your current version
    -   paper.doc

If you've ever looked at `git log` before, this should look sort
of familiar. We have a unique hash for the file version, and the
comment on the right is like our commit message. In git
terminology, your current version is always called "HEAD". If you
look at the structure above like a chain of changes: `8db90c ->
		 0de100 -> 31d2b1 -> HEAD`, you can see that we're always working
at the front, or head, of the chain of changes.


<a id="org8380e7b"></a>

### Why Design It This Way?

The cool thing about git is that because this design is so
simple, you can use it in many different ways. In fact, there is
no one "right" way to use git. If my friend and I are both
working on the same project, we can each make our own changes to
our local copies of the project. When we're ready to combine what
we're working on, I can share my changes directly with my friend
and they can "merge" the changes into their copy. Or, we could
have a remote copy on something like GitHub that we could both
work off of and merge our changes back in as we go. For this
tutorial, we'll go over the most common workflow that people
on GitHub use.


<a id="org559b1dc"></a>

## Git Basics


<a id="org5fa2dde"></a>

### Terminology

Before we begin, we need to cover some basic terminology. When
you're working with git, there are always 3 things that you have.
First, you have a repository, which is the project you're working
on. Within that repository, you have a branch, which is a chain
of commits. Each branch is a chain of commits, which are objects
showing the state of the repository at any point in time.

Each branch can have many commits, and each repository can have
many branches. Often people will work from the default branch in
the repository, which is called "master".

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">Term</th>
<th scope="col" class="org-left">Meaning</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-left">repository</td>
<td class="org-left">a project that git keeps track of</td>
</tr>


<tr>
<td class="org-left">branch</td>
<td class="org-left">a history of changes that git keeps track of</td>
</tr>


<tr>
<td class="org-left">working tree</td>
<td class="org-left">the branch that you're currently working on</td>
</tr>


<tr>
<td class="org-left">tracked</td>
<td class="org-left">(for a file) if git is keeping track of the file</td>
</tr>


<tr>
<td class="org-left">remote</td>
<td class="org-left">another repository that is somewhere else</td>
</tr>


<tr>
<td class="org-left">clean</td>
<td class="org-left">you have no uncommited changes for tracked files</td>
</tr>


<tr>
<td class="org-left">dirty</td>
<td class="org-left">you do have uncommited changes for tracked files</td>
</tr>


<tr>
<td class="org-left">upstream</td>
<td class="org-left">the canonical repository the project is based on</td>
</tr>
</tbody>
</table>

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="org-left">Command</th>
<th scope="col" class="org-left">Meaning</th>
</tr>
</thead>

<tbody>
<tr>
<td class="org-left">commit</td>
<td class="org-left">add my changes to the repository as a "commit"</td>
</tr>


<tr>
<td class="org-left">fetch</td>
<td class="org-left">get changes from another repository's branch</td>
</tr>


<tr>
<td class="org-left">push</td>
<td class="org-left">merge my changes to another repository's branch</td>
</tr>


<tr>
<td class="org-left">pull</td>
<td class="org-left">fetch and then merge into my branch</td>
</tr>


<tr>
<td class="org-left">merge</td>
<td class="org-left">to put another branch's changes into my branch</td>
</tr>


<tr>
<td class="org-left">&#xa0;</td>
<td class="org-left">&#xa0;</td>
</tr>
</tbody>
</table>


<a id="org347da21"></a>

### A Basic Git Workflow

Most people who are just starting out with git use a fairly
simple workflow. We'll go over this now. It's important to
understand that this kind of workflow is best for a single person
working on a project without much outside collaboration.

First, let's log in and create a new git repository to play
around in:

    git init my_first_repository

This command will make a directory called `my_first_repository`
and create a directory called `.git` inside of it. This `.git`
folder is where git stores all of the information that it keeps
track of. You should never need to change things inside the
`.git` folder. Just make sure that you don't accidentally delete
it. Now, let's create a file inside the repository:

    cd my_first_repository
    vim file.txt
    git status

Here, we make a new file. To see what's going on in our
repository, we use the command `git status`, which gives us an
overview of what's going on. This tells us that git sees our
file, but isn't keeping track of it. Let's make git start
tracking our file:

    git add file.txt
    git status

When we add the file, we "stage" it. Git isn't actually tracking
it yet, because we haven't committed our changes. Git does this
so that you can add multiple files (or changes to files) at once
before combining everything up into a single "commit". To save
our changes by making a commit, we have to run the commit
command:

    git commit -m "Add file.txt to the repository."
    git status
    git log

When you run the commit command, you should always add a message
describing the changes you are committing using the "-m" flag,
followed by your message in quotes. This helps other people
figure out what you were doing when you made a commit. The `git
		 log` command lets you look through the entire history of commits
in your repository. Now, let's make a change to `file.txt`:

    vim file.txt
    git diff

The `git diff` command lets us see the difference between the
committed (saved) state and the changes we've currently made. You
can either run `git diff` without a file's name to see every
changes to things already tracked by git, or you can add a file's
name to the command to see changes specific to that file. Try
making a few changes to the repository, commit them, and then
look at the resulting `git log`.


<a id="org0274645"></a>

### Adding a Remote Repository

Now that we know how to commit things so that git can keep track
of them, let's learn how to use a site like GitHub to keep a copy
of our code somewhere else. First, you'll need to make a
repository on the GitHub site. Go to <https://github.com>, log in,
and click the plus button on the upper right side of the page.
Click on "new repository" and follow the steps to make a new one.
**IMPORTANT: Don't add a README, .gitignore, or license yet.** Just
make an empty repository. When you've made the repository, you'll
be taken to a page telling you how to add GitHub as a `remote`
for your local repository. `Remote` is the name that git gives to
repositories that are located anywhere beside your local
computer. GitHub will tell you to run commands that look
something like this:

    git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPOSITORY.git
    git push origin master 

In the above commands, we add the remote GitHub repository to our
local repository. All this does is tell git that another copy of
our repository exists somewhere else. Then, we use the `git push`
command to 'push' our work up onto GitHub's servers, which we've
given the name `origin`. If we have changes that we want to get
from a remote repository, we can use `git pull` (which does the
opposite of a push).

    git pull origin master


<a id="orge471ba1"></a>

### Branches and Forks

Before we start talking about branches and forks, it's important
to understand the origin of the terminology for each. A 'branch'
is actually something that git knows about. A 'fork' is what
GitHub calls it when you make a copy of a repository for your own
use (although the history of the term is more complicated).

1.  Branches

    A git branch is an 'alternate history' of your repository that
    you can create at any time. Normally, when you clone a
    repository you'll get a branch called 'master', which is the
    normal linear 'chain' of commits that we talked about in the
    'Understanding Git' section above. It looks something like this:
    `a -> b -> c -> d`. When you create a branch, you start a different
    chain starting from a commit. So, if I started a branch at
    commit `b`, it would look something like this:
    
        a -> b -> c -> d
        		 \-> c' -> d'
    
    Branches lets you work on changes to the repository without
    affecting the master branch that your users might run every day.
    This lets you make changes that might temporarily break
    functionality without affecting other people. This is also
    helpful when you're working with other people. When you're done
    with a branch, you can merge your changes back in (we'll talk
    about this in the intermediate section), which makes your
    history look something like this:
    
        a -> b -> c -> d -> e -> f
        		 \-> c' -> d' ->/
    
    To make a branch, you just have to run:
    
        git branch my-new-branch
    
    This automatically creates a branch for you and switches you to
    it. To view all the branches you have, you can run:
    
        git branch -a
    
    Notice that if you do this, you can see the remote we set up
    earlier! When you add a remote, what you're really doing is
    making a branch and putting the history from the remote
    repository into it. You can switch to any branch you want
    using:
    
        git checkout the-branch-name

2.  Forks

    You can make a fork of a GitHub repository by clicking the
    'fork' button on the main page of that repository. This creates
    a copy for you to make changes with. The reason for using forks
    is so that you can contribute code back to the original
    repository. If you want to contribute to a project, you need to
    follow the following steps:
    
    1.  Fork the repository
    2.  Create a branch with the repository
    3.  Make your changes in the branch
    4.  Make a Pull Request from your branch into the original repository
    5.  Work with the project maintainers to get your changes accepted
    
    We'll practice doing this in the section 'Making a Pull
    Request', which you should go to now that you've completed this
    section.


<a id="orgb6f19e2"></a>

## Intermediate Topics


<a id="org1b2efa3"></a>

### Merging and Rebasing

Merging and rebasing are 2 of the most important concepts for
working with git in a collaborative environment. They allow you
to reconcile the histories of 2 different branches. If you have
simple changes that aren't too tricky to resolve, a merge is the
better choice. If the changes you're making are complicated, a
rebase is probably a better idea.

1.  Merging

    A merge is where you take one branch and put all of its changes
    into another branch in a single commit. In the simplest case
    (where you don't have any conflicts between the 2 branches),
    merging `my-branch` into `master` is as simple as:
    
        git checkout master
        git merge my-branch
    
    If there are conflicts, git will complain loudly and if you run
    `git status` it will tell you where you need to make changes.
    When there is a merge conflict, git rewrites the file in place
    as follows:
    
        #!/bin/bash
        # Sample Bash Script 
        <<<<<<< HEAD
        echo "Hello World!"
        =======
        echo "Howdy, Planet."
        >>>>>>> master
    
    Here, the line of equal signs separates the 2 conflicting
    chunks. The top chunk is from our current branch's HEAD, while
    the bottom chunk is from the master branch's HEAD. You just need
    to go through and delete those lines, leaving only the changes
    that you want. When this is done, you should be able to commit
    your changes and finish the merge. To make this process easier,
    you can use:
    
        git mergetool
    
    This will open up the preferred merge tool for your system,
    which lets you interactively select the chunks that you want to
    save for each chunk. This is commonly pre-set to 'vimdiff',
    which is a wrapper around vim with support for the special merge
    syntax.

2.  Rebasing

    A rebase is like a merge, but flipped. This is easier to
    understand visually, so take a look at [this visual guide first](https://coderefinery.github.io/git-branch-design/01-rebase/).
    **Never use rebase on a public branch that other people use.**
    Rebase rewrites the commit history of a repository, which will
    mess up everyone else's ability to pull from your repository
    when they need to. Rebasing is best used when you want to
    cleanly re-incorporate another branch into a private non-master
    branch that you have. A great explanation of what rebasing does
    can be found [here](https://www.atlassian.com/git/tutorials/merging-vs-rebasing). Rebasing is also great for cleaning up a
    branch by squashing (combining) commits. One more advantage is
    that rebase provides an interactive mode. For example, to rebase
    the last 5 commits in your repository to clean them up, you can
    use:
    
        git rebase -i HEAD~5


<a id="org1d764be"></a>

### Gitignore

Sometimes, you'll have files that you don't want git to keep
track of. These could be files with secrets, build files, or just
other miscellaneous things that you don't need to track. To
ignore files, just edit the file `.gitignore` at the base of the
repository. Below, I show a few ways you can ignore files:

    # Ignore all files with the extension .out
    *.out
    # Ignore things in /doc/foo
    /doc/foo
    # Ignore all files called secrets.txt
    secrets.txt

Much more detailed documentation on how to build gitignore files
can be found at the [official git documentation](https://git-scm.com/docs/gitignore).


<a id="org79fe248"></a>

### Licensing

If you're working on a project that you want the public to be
able to use, you MUST put a license in your repository. A good
overview of many of the licenses available to you can be found at
[choose a license](https://choosealicense.com/) or [the Free Software Foundation's license list](https://www.gnu.org/licenses/license-list.en.html).
Unless you choose a license for your project, no other reasonable
person will touch the code. Why? Because without a license you
(or your lab/university) have the exclusive copyright for your
code. Nobody else can touch it without fear of you suing them.
[Free Software is Important.](https://www.gnu.org/philosophy/open-source-misses-the-point.html) Below, I cover a few of the licenses
I prefer and the reasons why.

1.  Quick Reference

    If you don't care what people do with your software and don't
    care if they make money without having to give anything back to
    the community, choose a permissive license like MIT. If you want
    people to have to contribute their changes back to the
    community, choose a copyleft license. GPLv3 is a good default
    choice for this.

2.  Copyleft Licenses

    Copyleft licences are licenses that require that if people take
    your code and use it in their products, they have to also
    release the code with the changes they made. Companies aren't a
    huge fan of this because it means that they can't take other
    people's work for free without having to provide anything in
    exchange. Licenses in this category include:
    
    -   GNU General Public License (GPL). 
        -   Version 2 - Used by the Linux Kernel and many other projects.
        -   Version 3 - Adds more restrictions to prevent legal
            workarounds that companies tried to use
    -   Affero GPL (AGPL)
        -   Like GPLv3, but also forces companies to share their changes
            if they provide the software over a 'network service'. This
            is to force companies who let you use the software on their
            network (like AWS) to release their changes to the
            code.

3.  Permissive Licenses

    Permissive licenses are much more relaxed in their requirements.
    Typically, they only have the following conditions:
    
    -   You can use this code for whatever you want as long as you
        keep this license attached to it when you share it with
        others.
    -   I don't take any responsibility for the code and you're
        responsible if you mess up while using it. Please don't sue
        me.
    
    Companies tend to really like permissive licenses because it
    lets them do whatever they want with your code without having to
    give anything back. Some common permissive licenses are:
    
    -   MIT
        -   Developed at MIT (obviously).
        -   This is the most common license used on GitHub today, and is
            a good default choice if you want a permissive license.
    -   BSD 3-Clause
        -   Developed at Berkeley.
        -   The third clause prohibits people from using your name in
            advertising for products using the code, unless you give
            them permission.
    -   Apache
        -   Developed by the Apache Software Foundation.
        -   Unlike the previous 2 licenses, the Apache license also
            gives people using your code full access to any software
            patents related to the code (unless they sue you).
        -   You must add a file documenting changes made to code if you
            use this license.


<a id="org8f4ac52"></a>

### Large Files

Git doesn't work well with very large files (50MB+), especially
binary ones. The reason for this is because git tries to reduce
the amount of work by using a "delta" algorithm that calculates
the difference between each successive commit. This algorithm
doesn't work particularly well for large files or binary ones.
The bottom line here is that you should not use git to keep track
of large files like this.

What if you already committed a large file and now all your git
commands are running super slowly? Fear not, there is a solution.
GitHub has a good guide [here](https://help.github.com/en/articles/removing-sensitive-data-from-a-repository). There are 2 tools you can use for
this: `BFG repo cleaner` and `git-filter-branch`. BFG is much
easier to use, but you do have to download it. To use
`git-filter-branch`, use something like:

    git filter-branch --tree-filter 'rm -rf path/to/your/file' HEAD

IMPORTANT: `filter-branch` rewrites your git history. Make sure
that you fully understand what the command is doing before you
run a command like this.


<a id="org8cc17f1"></a>

### Tags

After working on a project for a while, you'll probably want to
specify a version that you'll release to the public. You can do
this using git's `tag` feature, which lets you give special
labels to certain commits. You can do this easily:

    git tag 1.0.0 # Give my current commit a tag of 1.0.0
    git tag -l # List tagged commits for my repository
    git tag -d 1.0.0 # Delete the tag 1.0.0
    git tag 0.9.0 ac54b4 # Give commit ac54b4 the tag of 0.9.0
    git push origin 1.0.0 # You have to manually push tags by name


<a id="org59da0ca"></a>

### Stashing

Stashing lets you save your changes when you make a pull from a
remote repository. You use the `git stash` command to stash your
uncommited changes, and if you ever want them back, you
can use the `git stash apply` command to apply them back onto
your repository in its current state.


<a id="orgc0f6355"></a>

### Git Config File

If you start working with git a lot, you might want to start
editing your git config file, which is located at `~/.gitconfig`.
This allows you to configure git aliases and add additional
useful information that git keeps track of. Below is an excerpted
example of what I keep in my `~/.gitconfig` file.

    [user]
    		# Personal Information
    		email = zach.maas@gmail.com
    		name = Zach Maas
    [alias]
    		# Useful aliases
    		lg = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
    		ll = log --graph --format=format:'%C(yellow)%h%C(red)%d%C(reset) - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)'
    [diff]
    		# Use vimdiff by default
    		tool = vimdiff
    [difftool]
    		# Don't ask before starting difftool
    		prompt = false
    [merge]
    		# Avoids actual merges
    		ff = only 
    		# Both sides of diff plus original
    		conflictstyle = diff3
    [push]
    		# Push branch to the usual other branch
    		default = simple
    		# Push tags too because I'm lazy
    		followTags = true
    [status]
    		# Show untracked files in a new folder
    		showUntrackedFiles = all
    [transfer]
    		# Do more verification when downloading repository
    		fsckobjects = true
    [help]
    		# Try to correct spelling flubs
    		autocorrect = 1


<a id="org4dcb64c"></a>

## Advanced Topics

These topics are roughly ordered by how frequently you might use
them in the real world.


<a id="orgf2749b0"></a>

### Repositories inside Repositories

1.  Submodule

    Depending on your workflow, sometimes you might want to have code
    from another different project inside your repository. The
    submodule set of commands let you manage sub-repositories added
    in this way.

2.  Subtree

    If you want to actually change the code from a different project
    when you include it in your own, the subtree command allows you
    to 'graft' another repository onto yours by adding it as its own
    directory. This works well, but can complicate the merge
    process.


<a id="org8a226eb"></a>

### Bisect

Sometimes you mess something up badly a few commits back, but
you're not really sure where. Bisecting lets you do a binary
search through old versions of your code to find where a bug was
introduced.


<a id="org007c055"></a>

### Cherry-pick

Cherry picking lets you select a single commit from another
branch and add it to your won. This is super useful if someone
else made a single change that you want to get without having to
deal with the complexities of merging.


<a id="org90128c7"></a>

### Filter-branch

Filter-branch is a powerful command that lets you rewrite the
history of a repository by applying a command to every commit in
the past. This could be used to remove a large file that was
mistakenly committed, or a secret that definitely shouldn't be
there.


<a id="orgf584f7a"></a>

### Email Patches

Certain large projects (like the Linux Kernel) require that you
submit changes to them using git's built-in patch format. You can
do this using `git format-patch`, which will create a branch diff
in the standard `mbox` format. This also works well with `git
		 send-email` to automatically send in your patches.


<a id="orgc3d28a8"></a>

### Rerere

You can configure `rerere.enabled true` in your gitconfig to have
git remember your choices for resolving hunk conflicts so that
you don't have to keep repeating them. This is most useful if
you're doing a lot of merging, like if you're a maintainer for a
big project.


<a id="org6b922d8"></a>

## Making a Pull Request

Now that you've reviewed all these basic git topics, you're ready
to try contributing to someone else's repository. To complete this
module, you'll need to add your name to the `participants.md` file
that is in the same directory as this file. We'll go over how to do
this step-by-step:

-   Fork the Repository: Go to this repository's home page on
    GitHub and click the `fork` button to create your own fork of
    the repository.
-   Clone Your Fork: Go to your newly forked repository and clone
    it to your local machine.
-   Create a Branch: Create a branch to put your new changes into.
-   Add Your Name: Edit the file
    `$REPOSITORY_ROOT/git/participants.md` by adding your name to it.
-   Commit Your Changes: Commit your changes to the list with a
    good description.
-   Push Your Branch: Push your branch to your GitHub fork
-   Open a Pull Request: Go to your fork. It should have a
    notification at the top asking if you want to make a Pull
    Request. Otherwise, go to the **original** repository under 'Pull
    Requests' and open a pull request to merge your branch into the
    master one. Make sure you add a detailed description of your
    changes in the Pull Request.
-   Wait for a maintainer to accept and merge the Pull Request

If everything went smoothly, your pull request should be accepted
and you'll be able to see your name on the list of contributors in
the `participants.md` file!

