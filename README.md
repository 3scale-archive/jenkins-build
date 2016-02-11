# jenkins-build


## Installation

Install it from rubygems.org:

```shell
gem install jenkins-build
```

## Usage

First, you need to get your user and API Key for Jenkins. To do that you need to
log in, in the right corner click your name, then click Configure in the left
sidebar and finally press 'Show API Token'. You'll need later both the User ID
and API Token.

Then you have to configure `jenkins-build` to use your jenkins server and
project. Do that by running:

```shell
jenkins-build configure --api-key JENKINS_API_TOKEN --user JENKINS_USER_ID --server JENKINS_SERVER_URL --project JENKINS_PROJECT_NAME
```

And then you can trigger build by running:

```shell
jenkins-build trigger
```

Or you can get failures from specific build:

```shell
jenkins-build failures --build=2372
```

If you don't supply build number, it will try to detect it via `hub` command from github status.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release` to create a git tag for the version, push git commits
and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/3scale/jenkins-build/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
