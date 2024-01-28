

class Contract

   def self.sigs_unnamed   ## unnamed sigs stack 
      @sigs_unnamed ||= []
   end 
   ## ignore this methods; 
   ##   do NOT (auto-)generate wrapper method popping (unnamed) sig from stack!!! 
   def self.sigs_exclude
     @sigs_exclude ||= []
   end
  
   def self.sig( *args )
      sigs_unnamed.push( args )
   end

 
   def before
      puts 'before'
   end


   def self.method_added( name )
     puts "==> method added #{name}"

     return if sigs_exclude.include?( name )

     pp name
     pp name.class.name

     m = method( :name )
     pp m.name
     pp m.parameters
     pp m

     raise "no unnamed sig on stack for method >#{name}< in class >#{self.name}<; sorry"   if sigs_unnamed.size == 0
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
   end


   sig ['hello']
   def hello
     puts 'hello'
   end

   sig ['hi']
   def hi
      puts 'hi'
   end

   def hola
      puts 'hola'
   end

end


puts "bye"