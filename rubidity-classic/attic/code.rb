
###
#  hack: allow function body (block) lookup in contract
#   
class Contract  
  def self.functions
    @functions ||= {}
  end
end   # class Contract      




#...

contract.functions.each do |function_name, function_args|
  print "function #{function_name}"
  pp function_args
  
  if function_name == :constructor 
    puts "==> add constructor..."
    input_types = function_args[:args].values.map { |type| spec_to_type(type) } 
    contract_class.sig input_types
    ## add unsafe method
    
    kwargs  = function_args[:args].keys.map {|arg| "#{arg}:" }.join( ', ' )
    args    = function_args[:args].keys.join( ', ' )
    puts "  kwargs: #{kwargs}"
    puts "  args: #{args}"
    contract_class.functions[function_name] = function_args[:body]

    code =<<RUBY
      def constructor( #{kwargs} ) 
         puts "==> calling #{contract_class.name}.constructor..."
         puts "  self: \#{self.class.name}"
         instance_exec( *[#{args}], &#{contract_class.name}.functions[:#{function_name}] )
      end
RUBY
    puts "  code:"
    puts code
    contract_class.class_eval( code )

    # contract_class.define_method( function_name ) do |**kwargs|
    #   ## todo/fix: assume kwargs order SAME as args -fix-fix-fix-
    #    instance_exec( *kwargs.values, &body )
    # end
  else

  end
end


##
# handle methods with **kwargs (only) e.g.
#   [[:keyrest, :kwargs]]
#  keys:
#    [:kwargs]

