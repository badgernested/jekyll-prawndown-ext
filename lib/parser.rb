module PrawndownExt
  # Markdown to Prawn parser
  class Parser
    MATCHERS = {
      #/^> (.+)/                  => '<quote>\1</quote>', # Quote
      /^# (.+)/                  => '<font size="HEADER1_SIZE"><b>\1</b></font>', # Header 1
      /^## (.+)/                 => '<font size="HEADER2_SIZE"><b>\1</b></font>', # Header 2
      /^### (.+)/                => '<font size="HEADER3_SIZE"><b>\1</b></font>', # Header 3
      /^#### (.+)/               => '<font size="HEADER4_SIZE"><b>\1</b></font>', # Header 4
      /^##### (.+)/              => '<font size="HEADER5_SIZE"><b>\1</b></font>', # Header 5
      /^###### (.+)/             => '<font size="HEADER6_SIZE"><b>\1</b></font>', # Header 6
      #/!\[([^\[]+)\]\(([^\)]+)\)/ => '<img href="\2" alt="\1">',        # Image
      /!\[([^\[]+)\]\(([^\)]+)\)/ => '',        # Images removed for now
      /<iframe ([^\[]+)<\/iframe>/ => '',        # Embeds are just removed
      /\[([^\[]+)\]\(([^\)]+)\)/ => '<link href="\2">\1</link>',        # Link
      /(\*\*|__)(.*?)\1/         => '<b>\2</b>',                        # Bold
      /(\*|_)(.*?)\1/            => '<i>\2</i>',                        # Italic
      /\~\~(.*?)\~\~/            => '<strikethrough>\1</strikethrough>' # Strikethrough
    }

    # Initialize a new +Prawndown::Parser+.
    # +text+ must a a valid Markdown string that only contains supported tags.
    #
    # Supported tags are: Header 1-6, bold, italic, strikethrough and link.
    def initialize(text, options)

      @text = text.to_s
	@header1_size = 28
	@header2_size = 24
	@header3_size = 20
	@header4_size = 18
	@header5_size = 16
	@header6_size = 14

	if !options.nil?
		if options.key?(:header1)
			@header1_size = options[:header1]
		end
		if options.key?(:header2)
			@header2_size = options[:header2]
		end
		if options.key?(:header3)
			@header3_size = options[:header3]
		end
		if options.key?(:header4)
			@header4_size = options[:header4]
		end
		if options.key?(:header5)
			@header5_size = options[:header5]
		end
		if options.key?(:header6)
			@header6_size = options[:header6]
		end
	end
	
    end

    # Parses the Markdown text and outputs a Prawn compatible string
    def to_prawn
    
    	# variable replacement
      _match = Marshal.load(Marshal.dump(MATCHERS))
      
      _match.each {
      	|x| puts 
      	x[1].gsub!("HEADER1_SIZE", @header1_size.to_s)
      	x[1].gsub!("HEADER2_SIZE", @header2_size.to_s)
      	x[1].gsub!("HEADER3_SIZE", @header3_size.to_s)
      	x[1].gsub!("HEADER4_SIZE", @header4_size.to_s)
      	x[1].gsub!("HEADER5_SIZE", @header5_size.to_s)
      	x[1].gsub!("HEADER6_SIZE", @header6_size.to_s)
      }

      result = _match.inject(@text) do |final_string, (markdown_matcher, prawn_tag)|
        final_string.gsub(markdown_matcher, prawn_tag)
      end
      
    
    result
      
    end
  end
end
