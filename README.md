# Jekyll::Version::Docs

> :warning: Please note that this plugin is **NOT** supported by GitHub pages. Here is a [list of all plugins supported](https://pages.github.com/versions/). However you can follow [this GitHub guide](https://help.github.com/articles/adding-jekyll-plugins-to-a-github-pages-site/) to enable it or by using [Travis CI](https://ayastreb.me/deploy-jekyll-to-github-pages-with-travis-ci/). GitLab supposedly supports [any plugin](https://about.gitlab.com/comparison/gitlab-pages-vs-github-pages.html).

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/jekyll/version/docs`. To experiment with that code, run `bin/console` for an interactive prompt.

This gem was made specifically for Jekyll 3 or higher. This plugin aims to facilitate the documentation of projects with multiple versions

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jekyll-version-docs'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install jekyll-version-docs

## Usage

The main commands of this plugin are:

`bundle exec jekyll vdoc <VERSION>`

Creates a version to be used as documentation

See the main tags:

- `{% doc_version %}` Shows the latest version
- `{% doc_versions %}` Shows all versions

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/reinanhs/jekyll-version-docs. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/reinanhs/jekyll-version-docs/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Jekyll::Version::Docs project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/reinanhs/jekyll-version-docs/blob/master/CODE_OF_CONDUCT.md).
