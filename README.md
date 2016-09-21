README.md

# Gollum Wiki Notes

    git clone https://github.com/i8degrees-net/gollum-wiki-notes gollum-wiki-notes.git

## Usage

**IMPORTANT(jeff):** charlock_holmes needs to be installed with the following
when being installed on FreeBSD,

    gem install bundle
    gem install charlock_holmes -- --with-icu-include=/usr/local/include --with-icuil18nlib=/usr/local/lib --with-icu-lib=/usr/local/lib
    bundle install

    tail -f logs/notes.log
    gollum-server

### Development

    npm install

## TODO

- [ ] rc.d script
- [ ] Provide a ```.env.defaults``` configuration
- [ ] Finish [bundle](http://bundler.io/v1.13/man/bundle.1.html) configuration
- [ ] Setup appropriate error handling for production servers
- [ ] Rename project and its related files to **gollum-wiki-notes**
- [ ] Move project source files to ```src```
- [ ] Rename ```public``` to ```dist```
- [ ] Finish up gulp file for browser sync and so forth
- [ ] Consider removing config.rb ..?
