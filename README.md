# Virs Pipeline

This repository contains the solution for the [Virs Pipeline](https://homework.adhoc.team/virs_pipeline/).

## Getting Started

This solution uses Ruby 3.2 and Bundler 2.4.19. Verify your local setup with:

```bash
ruby -v
bundler -v
```

Install gems, set up the database and import data.
```
bundle install
bundle exec rake db:create
bundle exec rake db:import
```

Run reporting functionality.

```
bundle exec rake report:write
bundle exec rake report:print
```

You may also run tests by running:

```
bundle exec rake spec
```

## Technical Considerations

The data model can be found in `database.rb`. The three models are `Vehicle`, `Organization` and `Inspection`. Foreign keys and primary keys were 
created according to instructions (e.g. composite primary key for inspection).

When importing, data is ingested utilizing these models. As historical is not required, we overwrite records when new data becomes available (e.g. for updating a vehicle owner or a companies name). 

The report is generated using a raw SQL query that groups organizations and their vehicle inspections and retrieves those with the highest relative number of failed inspections. I utilize the built in CSV library for convenience when reading and generating files.
