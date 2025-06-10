module PrawndownExt
  # Markdown to Prawn parser
  class Parser
  
  	DEFAULT_OPTIONS = {
			"header1_size" => 28,
			"header2_size" => 24,
			"header3_size" => 20,
			"header4_size" => 18,
			"header5_size" => 16,
			"header6_size" => 14,
			"quote_size" => 14,
			"quote_font_spacing" => nil,
			"quote_font" => nil,
			"quote_margin" => 20,
  	}
  
    MATCHERS = {
      ## Regular markdown
      /^# (.+)/                  => '<font size="HEADER1_SIZE"><b>\1</b></font>', # Header 1
      /^## (.+)/                 => '<font size="HEADER2_SIZE"><b>\1</b></font>', # Header 2
      /^### (.+)/                => '<font size="HEADER3_SIZE"><b>\1</b></font>', # Header 3
      /^#### (.+)/               => '<font size="HEADER4_SIZE"><b>\1</b></font>', # Header 4
      /^##### (.+)/              => '<font size="HEADER5_SIZE"><b>\1</b></font>', # Header 5
      /^###### (.+)/             => '<font size="HEADER6_SIZE"><b>\1</b></font>', # Header 6
      /<iframe ([^\[]+)<\/iframe>/ => '',        # Embeds are just removed
      /(\*\*|__)(.*?)\1/         => '<b>\2</b>',                        # Bold
      /(\*|_)(.*?)\1/            => '<i>\2</i>',                        # Italic
      /\~\~(.*?)\~\~/            => '<strikethrough>\1</strikethrough>', # Strikethrough
      
      # Command Break items
      # These split into multiple commands for output
      
      # Images
      /!\[([^\[]+)\]\(([^\)]+)\)/ => '<command_break>{"command":"img", "alt":"\1", "path":"\2"}<command_break>',
      /^> (.+)/                  => '<command_break>{"command":"quote","margin":QUOTE_MARGIN,"text":"<font name=\'QUOTE_FONT\' character_spacing=\'QUOTE_FONT_SPACING\' size=\'QUOTE_SIZE\'>\\1</font>"}<command_break>', # Quote
      
      # Stuff to process last
      /\[([^\[]+)\]\(([^\)]+)\)/ => '<link href="\2">\1</link>',        # Link
    }

		def escape_text text
			text = text.gsub('"', '\\"')
		end

    # Initialize a new +Prawndown::Parser+.
    # +text+ must a a valid Markdown string that only contains supported tags.
    def initialize(text, options)

			#@text = text.to_s
		  @text = escape_text text.to_s
		  
		  # this way a default is always loaded so no weird crashes
		  @options = Marshal.load(Marshal.dump(DEFAULT_OPTIONS))
		  
		  options.keys.each do |key|
		  	@options[key] = options[key]
		  end
	
    end

		def replace_options text
			# remove quote font if it doesnt exist
			if @options["quote_font"].nil?
				text = text.gsub("name='QUOTE_FONT' ", "")
				@options.delete("quote_font")
			end
			
			# remove quote spacing if it doesnt exist
			if @options["quote_font_spacing"].nil?
				text = text.gsub("character_spacing='QUOTE_FONT_SPACING' ", "")
				@options.delete("quote_font_spacing")
			end
		
			DEFAULT_OPTIONS.keys.each do |replacer|
				if @options.key?(replacer)
					text = text.gsub(replacer.upcase, @options[replacer].to_s)
				end
			end
			
			text
		end

    # Parses the Markdown text and outputs a Prawn compatible string
    def to_prawn
    
    	# variable replacement
      _match = Marshal.load(Marshal.dump(MATCHERS))

      result = _match.inject(@text) do |final_string, (markdown_matcher, prawn_tag)|
        final_string.gsub(markdown_matcher, prawn_tag)
      end
    
    result = replace_options result
    
    result = result.split("<command_break>")

    result
      
    end
  end
end
