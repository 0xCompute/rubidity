

def sig( *args, returns: nil )
    pp args
    method = args[-1]
    pp method
    pp method.class.name

end

def transact( *args )
    pp args
end

def view( *args )
    pp args
end

def returns( *args )
    pp args
    [:output, *args]
end

def input( *args )
    pp args
    [:input, *args]
end

def output( *args )
    pp args
    [:output, *args]
end

def in( *args )
    pp args
    [:input, *args]
end

def out( *args )
    pp args
    [:output, *args]
end


sig [],        ### returns: String,
def hello
    puts "hello"
end


transact [String, Integer],
def hello2
    puts "hello2"
end


view input(String, Integer), 
     output( String ), 
def hello2
    puts "hello2"
end

view [[String, Integer] => String],  
def hello2
    puts "hello2"
end

# view [String, Integer] => String,  
# def hello2
#     puts "hello2"
# end


## sig [String, Integer],


__END__

view params( String, Integer), 
     returns( String ), 
def hello3
    puts "hello2"
end

view { input: [ String, Integer], 
       output: [String] }, 
def hello2
    puts "hello2"
end



def view2( *more_args, input: [], output: []  )
    pp input
    pp output
end

view2 input: [String], output: [String],
def hello4
    puts "hello4"
end

