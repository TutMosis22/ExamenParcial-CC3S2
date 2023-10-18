#------------------------------------------------------------------------------------#
# CALAGUA MALLQUI JAIRO ANDRE - DESARROLLO DE SOFTWARE - CESAR LARA
#------------------------------------------------------------------------------------#

class OpenClosed
  # Este método devuelve una lista de métodos de instancia de una clase, incluyendo los privados.
  def self.meths(m)
    m.instance_methods + m.private_instance_methods
  end
end

# Sobreescribo el método 'include'
class Class
  alias_method :original_include, :include

  def include(*modules)
    if modules.any? { |m| (self.meths(self) & OpenClosed.meths(m)).any? }
      raise "Error: Intento de incluir módulo con métodos que se superponen."
    else
      original_include(*modules)
    end
  end
end

# Sobreescribo el método 'extend'
class Object
  alias_method :original_extend, :extend

  def extend(*modules)
    if modules.any? { |m| (self.singleton_class.meths(self.singleton_class) & OpenClosed.meths(m)).any? }
      raise "Error: Intento de extender objeto con módulo que contiene métodos superpuestos."
    else
      original_extend(*modules)
    end
  end
end

# Define un método para controlar el evento method_added
class Class
  def method_added(method_name)
    if method_name.to_s[0] == "_"
      if self.meths(self).include?(method_name)
        raise "Error: Intento de sobreescribir el método #{method_name} con alias."
      end
    end
  end
end

# Pruebas
module MyModule
  def my_method
    puts "Mi metodo"
  end
end

class MyClass
  include MyModule
end

# Esto provocará una excepción ya que el módulo se incluye con un método que se superpone.
module AnotherModule
  def my_method
    puts "Otro metodo"
  end
end

begin
  class MyClass2
    include AnotherModule
  end
rescue => e
  puts e.message
end

# Esto también provocará una excepción ya que se intenta sobreescribir el método 'my_method' con alias.
class MyClass3
  def my_method
    puts "Metodo original"
  end

  def _my_method
    puts "Metodo con alias"
  end
end

# Si se intenta modificar un objeto con un módulo que contiene métodos superpuestos provocará una excepción.
obj = Object.new

begin
  obj.extend(AnotherModule)
rescue => e
  puts e.message
end