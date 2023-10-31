pragma :rubidity, "1.0.0"

contract :HelloWorld do
  function :printHelloWorld, {}, :public, :view, returns: :string do
    return "Hello, world!"
  end
end

