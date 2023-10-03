# SPDX-License-Identifier: MIT
# pragma: rubidity 0.0.1

class HelloWorld < Contract  

  storage greet: String
 
  sig :construct, []
  def constructor
    @greet = "Hello World!"
  end
end
