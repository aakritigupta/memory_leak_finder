memory_leak_finder
==================

Find memory leaks in your ruby code. Works with ruby 2.1 or higher.

Installation
============

```
gem install memory_leak_finder
```

Usage
=====

Let's asume, there is a method that leaks memory.

```
require "rubygems"
require "memory_leak_finder"

def add_numbers(a, b)
  @result = []
  @result << a
  @result << b
  return @result.reduce(:+)
end

MemoryLeakFinder.trace do
  add_numbers(23, 42)
end
```

Outputs `LEAK! Array [23, 42] allocated at test:5: approx. 0 bytes`
and returns false. Because the variable `@result` can still be accessed
after the method returns, it leaks memory.

Let's fix the leak:

```
def add_numbers(a, b)
  result = []
  result << a
  result << b
  return result.reduce(:+)
end

MemoryLeakFinder.trace do
  add_numbers(23, 42)
end
```

The variable `result` cannot be accessed after the method returns and
therefore is freed by the garbage collector. No memory leaks anymore.
