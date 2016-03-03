# Totally Lazy for Ruby

This is a port of the java functional library [Totally Lazy](https://code.google.com/p/totallylazy/) to the ruby language.

### Status
[![Build Status](https://travis-ci.org/raymanoz/totally_lazy.svg?branch=master)](https://travis-ci.org/raymanoz/totally_lazy)
[![Gem Version](https://badge.fury.io/rb/totally_lazy.svg)](https://badge.fury.io/rb/totally_lazy)

### Summary

* Tries to be as lazy as possible
* Supports method chaining
* Is primarily based on ruby Enumerators
* For function, can use blocks or lambdas (some places require lambdas, eg. when 2 functions need to be passed in)

### Install

This gem requires ruby >= 2.0.0

In your bundler Gemfile

```ruby
 gem totally_lazy, '~>0.1.54' (or latest) 
```

Or with rubygems

```
 gem install totally_lazy
```

### Examples

The following are some simple examples of the currently implemented functionality.

```ruby
require 'totally_lazy'

sequence(1, 2, 3, 4).filter(even)           # lazily returns 2,4
sequence(1, 3, 5).find(even)                # eagerly returns none()
sequence(1, 2, 3).contains?(2)              # eagerly returns true
sequence(1, 2, 3).exists?(even)             # eagerly return true
sequence(1, 2).map(to_string)               # lazily returns "1","2"
sequence(1, 2).map_concurrently(to_string)  # lazily distributes the work to background threads
sequence(1, 2, 3).take(2)                   # lazily returns 1,2
sequence(1, 2, 3).drop(2)                   # lazily returns 3
sequence(1, 2, 3).tail                      # lazily returns 2,3
sequence(1, 2, 3).head                      # eagerly returns 1
sequence(1, 2, 3).reduce(sum)               # eagerly return 6
sequence(1, 2, 3).for_all(odd)              # eagerly returns false;
sequence(1, 2, 3).fold_left(0, add)         # eagerly returns 6
some(sequence(1, 2, 3)).get_or_else(empty)  # eagerly returns value or else empty sequence
sequence(1, 2, 3, 4, 5).filter(greater_than(2).and(odd))
                                            # lazily returns 3,5
sequence(pair(1, 2), pair(3, 4)).filter(where(first, equal_to?(3))) 
                                            # lazily returns pair(3,4)
sequence(1, 2, 3).to_s                      # eagerly returns "[1,2,3]"
```
