


module Library

   def self.extended(base)
      puts " turn (extend) module  >#{base.name}< into library"
      base.extend( ClassMethods )
      base.include( InstanceMethods )
    end


   # def self.included(base)
   #   base.extend( ClassMethods )
   #   base.include( InstanceMethods )
   # end

    module InstanceMethods
      HELLO = 'hello hello'
    end
    module ClassMethods
     def sigs_unnamed   ## unnamed sigs stack 
        @sigs_unnamed ||= []
     end 
     ## ignore this methods; 
     ##   do NOT (auto-)generate wrapper method popping (unnamed) sig from stack!!! 
     def sigs_exclude
       @sigs_exclude ||= []
     end
    
     def sig( *args )
        sigs_unnamed.push( args )
     end


     def method_added( name )
        puts "==> method added #{name}"
   
        return if sigs_exclude.include?( name )
   
        pp name
        pp name.class.name
   
        # m = method( name )
        # pp m.name
        # pp m.parameters
        # pp m
   
        raise "no unnamed sig on stack for method >#{name}< in module >#{self.name}<; sorry"   if sigs_unnamed.size == 0
        sig_unnamed = sigs_unnamed.pop
        pp sig_unnamed
   
   
        ## note: alias method results in method_add callback!!!!
        sigs_exclude <<  :"#{name}_unsafe" 
        alias_method :"#{name}_unsafe", name 
        ## redifine - triggers method_add callback again!!!!
        sigs_exclude << name 
        define_method name do
             send( :"#{name}_unsafe" )
        end
   
        ## make into module functions!!!
        module_function name
        module_function :"#{name}_unsafe"
      end
   end
end  # module Library


module LibHello
  
    def before
       puts 'before'
    end
 
    extend Library

    puts HELLO

    sig ['hello']
    def hello
      puts 'hello'
    end
 
    sig ['hi']
    def hi
       puts 'hi'
    end
 
   # def hola
   #    puts 'hola'
   # end
 
    def self.hola
       puts 'hola'
    end
     
 end
 
 
 
LibHello.hello
LibHello.hi
LibHello.hello_unsafe
LibHello.hi_unsafe
 
 
 
 puts "bye"