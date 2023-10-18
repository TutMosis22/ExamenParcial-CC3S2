#------------------------------------------------------------------------------------#
# CALAGUA MALLQUI JAIRO ANDRE - DESARROLLO DE SOFTWARE - CESAR LARA
#------------------------------------------------------------------------------------#
# Comando 'grep' simplificado

def simple_grep(search_string, flags, *files)
  result = []
  files.each do |file|
    begin
      lines = File.readlines(file)
      lines.each_with_index do |line, index|
        match = line.include?(search_string) || (flags.include?('-i') && line.downcase.include?(search_string.downcase))
        match = !match if flags.include?('-v')
        match = line.chomp == search_string if flags.include?('-x')

        if match
          if flags.include?('-l')
            result << file
            break
          else
            output = flags.include?('-n') ? "#{file}:#{index + 1}: " : "#{file}: "
            output += line.chomp
            result << output
          end
        end
      end
    rescue Errno::ENOENT
      result << "File not found: #{file}"
    end
  end

  result
end

# Uso del comando simple_grep
search_string = ARGV.shift
flags = ARGV.select { |arg| arg.start_with?('-') }
files = ARGV.reject { |arg| arg.start_with?('-') }

if search_string.nil? || files.empty?
  puts "Uso: ruby simple_grep.rb <search_string> [flags] <file1> <file2> ..."
else
  result = simple_grep(search_string, flags, *files)
  result.each { |line| puts line }
end