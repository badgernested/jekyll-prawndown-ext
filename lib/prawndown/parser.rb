module PrawndownExt
  # Markdown to Prawn parser
  class Parser
  
  	# These are used as a collection of nil properties
  	# for font names.
  	DELETE_NAMES = [
			"quote_font",
			"header1_font",
			"header2_font",
			"header3_font",
			"header4_font",
			"header5_font",
			"header6_font",
  	]
  
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
			"header1_font" => nil,
			"header2_font" => nil,
			"header3_font" => nil,
			"header4_font" => nil,
			"header5_font" => nil,
			"header6_font" => nil,
			"quote_margin" => 20,
			"header1_margin" => 4,
			"header2_margin" => 4,
			"header3_margin" => 4,
			"header4_margin" => 4,
			"header5_margin" => 4,
			"header6_margin" => 4,
			"img_dir" => "",
  	}
  
    MATCHERS = {
    	# Removes carriage returns, they cause issues
    	/\r/ => '',
      /<iframe ([^\[]+)<\/iframe>/ => '',        # Embeds are just removed
      /(\*\*|__)(.*?)\1/         => '<b>\2</b>',                        # Bold
      /(\*|_)(.*?)\1/            => '<i>\2</i>',                        # Italic
      /\~\~(.*?)\~\~/            => '<strikethrough>\1</strikethrough>', # Strikethrough
      ## Regular markdown
      ## Header 1
      /(^# )(.+)/                => '<command_break>{"command":"header1","margin":HEADER1_MARGIN,"text":"<font name=\'HEADER1_FONT\' size=\'HEADER1_SIZE\'><b>\2</b></font>"}<command_break>', 
      ## Header 2
      /(^## )(.*)/                 => '<command_break>{"command":"header2","margin":HEADER2_MARGIN,"text":"<font name=\'HEADER2_FONT\' size=\'HEADER2_SIZE\'><b>\2</b></font>"}<command_break>',
      ## Header 3
      /(^### )(.*)/                => '<command_break>{"command":"header3","margin":HEADER3_MARGIN,"text":"<font name=\'HEADER3_FONT\' size=\'HEADER3_SIZE\'><b>\2</b></font>"}<command_break>',
      ## Header 4
      /(^#### )(.*)/               => '<command_break>{"command":"header4","margin":HEADER4_MARGIN,"text":"<font name=\'HEADER4_FONT\' size=\'HEADER4_SIZE\'><b>\2</b></font>"}<command_break>',
      ## Header 5
      /(^##### )(.*)/              => '<command_break>{"command":"header5","margin":HEADER5_MARGIN,"text":"<font name=\'HEADER5_FONT\' size=\'HEADER5_SIZE\'><b>\2</b></font>"}<command_break>',
      ## Header 6
      /(^###### )(.*)/             => '<command_break>{"command":"header6","margin":HEADER6_MARGIN,"text":"<font name=\'HEADER6_FONT\' size=\'HEADER6_SIZE\'><b>\2</b></font>"}<command_break>',
      
      # Command Break items
      # These split into multiple commands for output
      
      # Images
      /!\[([^\[]+)\]\(([^\)]+)\)/ => '<command_break>{"command":"img", "alt":"\1", "path":"\2"}<command_break>',
      /^> (.+)/                  => '<command_break>{"command":"quote","margin":QUOTE_MARGIN,"text":"<font name=\'QUOTE_FONT\' character_spacing=\'QUOTE_FONT_SPACING\' size=\'QUOTE_SIZE\'>\1</font>"}<command_break>', # Quote
      
      # Stuff to process last
      /\[([^\[]+)\]\(([^\)]+)\)/ => '<link href="\2">\1</link>',        # Link
      
      # Special commands exclusive to prawndown-ext to control output
      # Two breaks in a row signifies a new page
      /<br><br>/ => '<command_break>{"command":"newpage"}<command_break>'
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
			# remove nil options if it doesnt exist
			
			DELETE_NAMES.each do |option|
				if @options.key?(option)
					if @options[option].nil?
						text = text.gsub("name='" + option.upcase + "' ", "")
						@options.delete(option)
					end
				end
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
