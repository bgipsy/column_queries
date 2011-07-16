# Description

PostgreSQL pg gem has one particularly cool method which is `PGresult#column_values`. It's fast function implemented in C on top of native libpq facilities. This gem is an attempt to put some thin convenience layer around it, to be used with `ActiveRecord` in a way that doesn't break ORM but rather augments it.

When working with Rails back-end applications driven by rich business domains, and trying to squeeze out every bit of performance, there's often a very simple need to pull nothing more than ids for objects that match certain criteria. When certain dataset can be reduced only on later stages of processing, having all rows of it as instantiated `ActiveRecord` objects comes at big cost. Sometimes arrays, hashes and "grouped_by" hashes is all that has to be fetched form DB in order to end up with meaningful response for some domain specific search API call.

`ActiveRecord` connection adapter methods `select_values`, `select_all`, etc are usual answer to such need. However, if you happen to find yourself in an environment with PostgreSQL, Rails 3, and pg gem, there's better alternative. And you don't have to rewrite your scopes into raw SQL in order to use it.

Here are some benchmarks obtained by spec/support/benchmarks.rb:

  Test sample contains 20000 records
  Benchmarking find
  Time: 34.165s 0.6833s per run
  Benchmarking select_values
  Time: 3.686s 0.0737s per run
  Benchmarking to_int_array
  Time: 2.426s 0.0485s per run

# Usage

  TODO
  connection.select_int_values()
  Model.where(...).some_scope(...).to_int_array(:id)
  same for hash
  same for "group_by"

# Requirements

This gem requires ActiveRecord 3 and pg 0.11.0. Backport to latest versions of Rails 2 is coming soon.

# Install

  gem install column_queries

or with bundler:

  gem "column_queries", "~> <version>"

# License

Copyright Serge Balyuk for Avenue100 Media Solutions Inc.

column_queries gem is released under the MIT license. Please refer to MIT-LICENSE for details.
