# Virs Pipeline

This repository contains the solution for the [Virs Pipeline](https://homework.adhoc.team/virs_pipeline/).

## Getting Started

This solution uses Ruby 3.2 and Bundler 2.4.19. Verify your local setup with:

```bash
ruby -v
bundler -v
```

Install gems, set up the database and import CSVs.
```
bundle install
bundle exec rake db:create
bundle exec rake db:import
```

