gh-publisher
============

This is a small package of software which will help you configure an
automated build and publish process, using Travis CI and GitHub Pages.

gh-publisher was originally designed for academic and scientific papers
written in LaTeX.  Each change to the LaTeX triggers an automated build to
re-generate the PDF and then publish it.  You can easily extend gh-publisher
to perform different build processes, as described below.

The publishing template is also configured to receive feedback on your work
through GitHub Issues.

This is entirely dependent on GitHub and Travis CI.

Installation
------------

I assume that you have a git repository of your own, containing whatever
project it is that you want to build.  If you haven't already done so,
you need to host that repository on GitHub, and you need a local clone of it
on your machine.  If you don't know how to do that, see
https://help.github.com.

The instructions below use the following references.  Substitute the correct
value whenever you see one of these:

1. `$PROJECT_DIR`: the directory containing your local clone of your project.
2. `$GITHUB_USERNAME`: your GitHub username.
3. `$REPO_NAME`: the name of your project's git repository.

### Enable issue tracking on GitHub

1. Visit your repository settings at
https://github.com/$GITHUB_USERNAME/$REPO_NAME/settings.
2. In the Features section, ensure that Issues is checked.

### Enable automated builds on Travis CI

1. Sign in to Travis CI using your GitHub credentials at https://travis-ci.org.
2. Visit your Travis CI profile page at
https://travis-ci.org/profile/$GITHUB_USERNAME.
3. Click Sync now to refresh the list of repositories.
3. Enable builds on your repository by flicking the appropriate switch.

### Allow Travis CI to publish to GitHub Pages on your behalf

You need to generate a GitHub access token.  You are going to give this to
Travis CI, which will grant it access to publish on your behalf.

1. Visit your GitHub application settings at
https://github.com/settings/applications.
2. Under Personal access tokens, click "Generate new token".  GitHub will ask
for your password if you haven't entered it recently.
3. Set the Token description to "Travis CI" (or whatever you want).
4. Check "public_repo" as the scope, and uncheck all the other scopes.  This
limits Travis CI so that it is only able to publish to your public GitHub
repositories, and can't modify anything else.
5. Click Generate token.
6. You will see a new token -- a long string of numbers and letters.  Leave
this window open for now -- this is the only time that you will see this token.
7. In a new window, visit
https://travis-ci.org/$GITHUB_USERNAME/$REPO_NAME/settings/env_vars.
8. Click "Add a new variable".
9. Set the Name to `GH_TOKEN`.
10. Set the Value to that long string of numbers and letters in the other
window.
11. Leave "Display value in build logs" turned off.
12. Click "Add".
13. You can close the window with your GitHub access token now, you're done.

### Configure the name and email address used on git commits

You can optionally set the name and email address used on the git commits
when pages are published.  If you don't do this, they will come out as
`"Automated build by gh-publisher <not.a.real.person@example.com>"`.

1. Visit https://travis-ci.org/$GITHUB_USERNAME/$REPO_NAME/settings/env_vars.
2. Click "Add a new variable".
3. Set the Name to `GIT_NAME`.
4. Set the Value to `"<Your name> [automatic build]"`, or whatever you want.
5. Click "Add".
6. Repeat for `GIT_EMAIL`, also set to whatever you want.

### Configure your project

1. Copy the `gh-publisher-scripts` directory and all its contents from this
repository into `$PROJECT_DIR`.
2. Copy `gh-publisher-scripts/example.travis.yml`, and place it in
`$PROJECT_DIR/.travis.yml`.  Note that the name of this file is critical:
it needs to be at the top level of your project, and it needs to be named
`.travis.yml` -- with a period at the front and no period at the end.
3. Commit the entire contents of `gh-publisher-scripts` and your new
`.travis.yml` to your repository, and push to GitHub.
4. After a few minutes you should see your build begin, by looking at your
status page on https://travis-ci.org.

### Configure the front matter

You can optionally set the title and authors for the front section on the
generated website.  If you don't do this, default values will be inserted,
derived from the project details.  It will look a lot better if you set
these values though.

1. Edit `gh-publisher-scripts/front-matter.yml` to taste.
2. Commit the changes and push to GitHub.

### Check that it's all worked

1. Visit http://$GITHUB_USERNAME.github.io/$REPO_NAME/.  Hopefully you have
a page here now!  This can take up to ten minutes to appear the first time
(future builds are instant).

Configuring other kinds of builds
---------------------------------

The packages used for building are installed by `.travis.yml`.  You can edit
the list at the end if you need other packages as part of your build.

You can also edit `gh-publisher-scripts/build.sh` and
`gh-publisher-scripts/copy.sh` to change what is built and what is copied
before it is published.

Acknowledgments
---------------

gh-publisher was inspired by Phil Marshall, as part of Science Hack Day
San Francisco 2014.  https://github.com/drphilmarshall.
http://sciencehackday.org.

The publishing template is derived from GitHub's automatic page generator,
using the Minimal theme.  https://github.com/orderedlist/minimal.


License
-------

index.html, scale.fix.js, pygment_trac.css, styles.css: these are modified
versions of https://github.com/orderedlist/minimal, which is licensed under a
Creative Commons Attribution-ShareAlike 3.0 Unported License.
http://creativecommons.org/licenses/by-sa/3.0/.

The remaining files in this repository are by Ewan Mellor, and are dedicated
to the public domain.
To the extent possible under law, Ewan Mellor has waived all copyright and
related or neighboring rights to this work.
http://creativecommons.org/publicdomain/zero/1.0/.
