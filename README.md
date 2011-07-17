# Description

PostgreSQL pg gem has one particularly cool method which is `PGresult#column_values`. It's fast function implemented in C on top of native libpq facilities. This gem is an attempt to put some thin convenience layer around it, to be used with `ActiveRecord` in a way that doesn't break ORM but rather augments it.

When working with Rails back-end applications driven by rich business domains, and trying to squeeze out every bit of performance, there's often a very simple need to pull nothing more than ids for objects that match certain criteria. When certain dataset can be reduced only on later stages of processing, having all rows of it as instantiated `ActiveRecord` objects comes at big cost. Sometimes arrays, hashes and "grouped_by" hashes is all that has to be fetched form DB in order to end up with meaningful response for some domain specific search API call.

`ActiveRecord` connection adapter methods `select_values`, `select_all`, etc are the usual answer to such need. However, if you happen to find yourself in an environment with PostgreSQL, Rails 3, and pg gem, there's better alternative. And you don't have to rewrite your scopes into raw SQL in order to use it.

Here are some benchmarks obtained by spec/support/benchmarks.rb:

    Test sample contains 20000 records
    Benchmarking find
    Time: 34.165s 0.6833s per run
    Benchmarking select_values
    Time: 3.686s 0.0737s per run
    Benchmarking to_int_array
    Time: 2.426s 0.0485s per run

# Usage

The gem adds several methods to `ActiveRecord::Relation`, which can be easily used with scopes:

    book_ids = Book.available.scoped_by_author_id(author.id).to_int_array(:id)

Just like `to_a` method on relations, all column_queries methods should be called last in scope chains. So putting, say `scoped_by_author_id`, after `to_int_array` won't work. The same is true when defining scopes:

    class Book < ActiveRecord::Base
      # this won't work:
      scope :availabile_ids, lambda { where(:available => true).to_int_array(:id) }
      
      # use this instead:
      scope :available, where(:available => true)
      
      def self.available_ids
        available.to_int_array(:id)
      end
    end

Currently, provided methods are: `to_int_array`, `to_columns_as_int_arrays`, `to_int_hash` and `to_int_groups`. They all accept column names for arguments.

`to_int_array(column)` returns result of query `SELECT column FROM ...` as an array of integers. `column` argument can be omitted, the first column of query result would be taken then.

`to_columns_as_int_arrays(*columns)` is similar to `to_int_array` but takes multiple column names. It returns int arrays for all requested columns:

    comment_ids, book_ids = Comment.scoped.to_int_arrays(:id, book_id)

`to_int_hash(keys_column, values_column)` can be used to quickly pull hash mapping between two integer columns:

    books_by_comments = Comment.scoped.to_int_hash(:id, :book_id)

will return a hash which maps comment ids to book ids: `books_by_comments[comment_id] => book_id`.

And `to_int_groups(keys_column, values_column)` returns a hash which is more like `group_by` result. It combines values from the second column that correspond to the same key into an array:

    books_comments = Comment.scoped.to_int_groups(:book_id, :id)

`books_comments[book_id]` in this case will contain an array of all ids of comments for given `book_id`.


NULLs treatment may be surprising: all db `NULL`s are converted into `0`s. The reason behind that is performance. It was very tempting to skip `nil?` check inside of intense loops given the fact that database sequences usually start with `1` and PKs never contain NULL values. Though I'll try to provide better support (and some flexibility) for casting in next versions of the gem. Some methods like `to_int_hash` would benefit a lot from more flexible type casting code. Being able to do something like:

    titles = Book.pricy.to_hash(:id, :title)

would be a nice option to have in certain optimization scenarios.

# Requirements

This gem requires ActiveRecord 3 and pg 0.11.0. Backport to latest versions of Rails 2 is coming soon.

# Install

    gem install column_queries

or with bundler:

    gem "column_queries", "~> <version>"

# License

Copyright Serge Balyuk for Avenue100 Media Solutions Inc.

column_queries gem is released under the MIT license. Please refer to MIT-LICENSE for details.
