pragma :rubidity, "1.0.0"

contract :HelloWorld do
  function :getHelloWorld, {}, :public, :pure, returns: :string do
    return "Hello, world!"
  end
end

