README.md

# Gollum Wiki Notes

    git clone https://github.com/i8degrees-net/gollum-wiki-notes

## Usage

* Minimum required version of Ruby is version ```2.3.0```.

Setup the environment:

```shell
export RBENV_ROOT=/srv/ruby/rbenv
eval $(rbenv init -)
rbenv install 2.3.0
rbenv local 2.3.0 # .ruby-version
```

Server defaults:

```shell
# Be sure to set these variables up before trying to run the app..!
cp -av .env.defaults .env
```

### Mac OS X 

...

### FreeBSD

```shell
pkg install icu
```

```shell
gem install bundle
# gem install charlock_holmes -- --with-icu-include=/usr/local/include --with-icuil18nlib=/usr/local/lib --with-icu-lib=/usr/local/lib
bundle check
bundle install --deployment
```

### Startup

    tail -f logs/notes.log
    gollum-server

### Development

    bundle install --no-deployment

## TODO

- [ ] finish up build and deploy git hooks and move said hooks to this git repository
  1. http://unix.stackexchange.com/questions/182212/chmod-gs-command
  * https://www.freebsd.org/doc/handbook/fs-acl.html
  * http://askubuntu.com/questions/294736/run-a-shell-script-as-another-user-that-has-no-password
- [x] Provide a ```.env.defaults``` configuration
- [ ] Finish [bundle](http://bundler.io/v1.13/man/bundle.1.html) configuration
- [ ] Setup appropriate error handling for production servers
- [ ] Rename project and its related files to **gollum-wiki-notes**
- [ ] Move project source files to ```src```
- [ ] Rename ```public``` to ```dist```
- [ ] Finish up gulp file for browser sync and so forth
- [ ] Consider removing config.rb ..?

### Imported from SimpleNote

- [ ] take look at gitlab's wiki backend software at https://github.com/gitlabhq/gitlabhq

- [ ] Protect upload files dialog from unauthorized users

- [ ] Share notes by exporting said commit(s) as a gist -- when supported -- or as a plain, flat file.

  - [ ] Use a Markdown converter tool -- i.e.: cmark -- for updating file source links when necessary;

      cmark -t xml /Users/jeff/Projects/notes.git/boobies.md > /tmp/boobies.md

  - [ ] Research HTML or XML parsing with node.js

  - [ ] File sharing can be accomplished many different ways -- everything from a public web server to a personal Dropbox account to even a IMAP store!
    * https://github.com/andreafabrizi/Dropbox-Uploader.git

- [ ] Experiment with modifying the page via Javascript at run-time
  * http://blog.branch14.org/2013/05/11/a-custom-wiki-with-gollum.html

- [ ] Relocate the partial usage guide at https://wiki.imbue.studio/wiki concerning
the wiki backend to this file.

## References

* https://eureka.ykyuen.info/2015/03/11/gollum-add-git-identity-by-running-gollum-as-a-rack-appliaction/

* http://msimav.net/2013/08/01/gollum-a-lightweight-wiki/

* http://stackoverflow.com/questions/13053704/how-to-properly-mount-githubs-gollum-wiki-inside-a-rails-app

## Related Projects

* https://github.com/HSBNE/Wiki-GollumRack
* https://github.com/nog3/Gollum-Rack
* https://github.com/riskanalytics/gollum-rack

* [Vimwiki](https://github.com/vimwiki/vimwiki)
* [notes.vim](http://peterodding.com/code/vim/notes/)
