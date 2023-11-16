# SPDX-License-Identifier: Public Domain


class HelloWorld < Contract  

  storage greet: String
 
  sig []
  def constructor
    @greet = "Hello World!"
  end
end
