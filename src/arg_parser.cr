require "./arg_parser/*"

class ArgParser
  include Iterator(String)

  @current_arg : String?
  @quoted : Bool
  @quote_char : Char
  @escaped : Bool
  @args_chars : Array(Char)

  def initialize(args : String)
    @args_chars = args.chars
    @quoted = false
    @quote_char = '"'
    @escaped = false
  end

  def next
    return stop if @args_chars.empty?

    String.build do |current_arg|
      loop do
        current_char = @args_chars.shift?
        if current_char == nil
          break
        elsif !@escaped && @quoted && current_char == @quote_char
          @quoted = false
        elsif !@escaped && !@quoted && current_char == '"' || current_char == '\''
          @quoted = true
          @quote_char = current_char.not_nil!
        elsif !@escaped && !@quoted && current_char == ' '
          while @args_chars.first == ' '
            @args_chars.shift
          end
          break
        elsif current_char == '\\'
          current_arg << current_char if @escaped
          @escaped = !@escaped
        else
          @escaped = false
          current_arg << current_char
        end
      end
    end
  end

  def self.parse(args)
    new(args).to_a
  end
end
