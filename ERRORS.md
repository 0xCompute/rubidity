#  Notes on Errors

for core rubysol only use built-in expections and errors - why? why not?

ruby error / exception hierarchy:

```
Exception
  NoMemoryError
  ScriptError
    LoadError
    NotImplementedError
    SyntaxError
  SecurityError
  SignalException
    Interrupt
  StandardError    <-- default for rescue
    ArgumentError
      UncaughtThrowError
    EncodingError
    FiberError
    IOError
      EOFError
    IndexError
      KeyError
      StopIteration
    LocalJumpError
    NameError
      NoMethodError
    RangeError
      FloatDomainError
    RegexpError
    RuntimeError    <-- default for raise
    SystemCallError
      Errno::*
    ThreadError
    TypeError
    ZeroDivisionError
  SystemExit
  SystemStackError
```

references:
- https://www.honeybadger.io/blog/understanding-the-ruby-exception-hierarchy/
- https://www.honeybadger.io/blog/ruby-exception-vs-standarderror-whats-the-difference/


## custom errors in contracts

derived from custom Error (and StandardErrr)

``` ruby
assert condition, "error message"
```

should be translated to 

``` ruby
if !condition 
  revert CustomError 
end

revert CustomError    if !condition
```


references:
-  https://soliditylang.org/blog/2021/04/21/custom-errors/


