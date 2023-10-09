# SPDX-License-Identifier: Public Domain
# pragma: rubidity 0.0.1

class HelloWorld < Contract  

  storage greet: String
 
  sig []
  def constructor
    @greet = "Hello World!"
  end
end
