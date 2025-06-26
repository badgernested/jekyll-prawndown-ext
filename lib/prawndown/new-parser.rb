require 'redcarpet'

module PrawndownExt
	class Render < Redcarpet::Render::Base
	
  	# These are used as a collection of nil properties
  	# for font names.
  	DELETE_NAMES = [
			"quote_font",
			"code_font",
			"header1_font",
			"header2_font",
			"header3_font",
			"header4_font",
			"header5_font",
			"header6_font",
  	]
  
  	DEFAULT_OPTIONS = {
  		"header1_line_space" => 5,
  		"header2_line_space" => 5,
  		"header3_line_space" => 5,
  		"header4_line_space" => 5,
  		"header5_line_space" => 5,
  		"header6_line_space" => 5,
			"header1_size" => 28,
			"header2_size" => 24,
			"header3_size" => 20,
			"header4_size" => 18,
			"header5_size" => 16,
			"header6_size" => 14,
			"quote_size" => 14,
			"quote_font_spacing" => nil,
			"quote_font" => "quote",
			"code_size" => 12,
			"code_font_spacing" => nil,
			"code_font" => "code",
			"header1_font" => "header1",
			"header2_font" => "header2",
			"header3_font" => "header3",
			"header4_font" => "header4",
			"header5_font" => "header5",
			"header6_font" => "header6",
			"quote_margin" => 20,
			"header1_margin" => 4,
			"header2_margin" => 4,
			"header3_margin" => 4,
			"header4_margin" => 4,
			"header5_margin" => 4,
			"header6_margin" => 4,
			"img_dir" => "",
  	}
	
		# custom matchers that are not specific to markdown
    MATCHERS = {
    	/\r/ => '', # Removes carriage returns, they cause issues
    	/<div class=\"webpage-exclude\">([\s|\S]*)<\/div>/ => '\1',  # Web output excluded has tags removed
      /<iframe ([^\[]+)<\/iframe>/ => '',      						   # Embeds are just removed
      /<div class=\"output-exclude\".*>([\s|\S]*)<\/div>/ => '',  # Output excluded also removed
      /<br><br>/ => '<command_break>{"command":"newpage"}<command_break>' # skips to the next section
    }
	
		def block_quote(quote)
		  %(<command_break>{"command":"quote","margin":QUOTE_MARGIN,"text":"<font name=\'QUOTE_FONT\' character_spacing=\'QUOTE_FONT_SPACING\' size=\'QUOTE_SIZE\'>#{quote}</font>"}<command_break>)
		end
		
		def block_code(code)
		  %(<command_break>{"command":"code","margin":CODE_MARGIN,"text":"<font name=\'CODE_FONT\' character_spacing=\'CODE_FONT_SPACING\' size=\'CODE_SIZE\'>#{code}</font>"}<command_break>)
		end
		
		def block_code(code)
		  %(<command_break>{"command":"code","margin":CODE_MARGIN,"text":"<font name=\'CODE_FONT\' character_spacing=\'CODE_FONT_SPACING\' size=\'CODE_SIZE\'>#{code}</font>"}<command_break>)
		end
		
    def footnote_def(content, number)
    	%(\n#{number}. #{content})
    end
    
    def footnote_ref(text)
    	%(<sup>#{text}</sup>)
    end
    
    def footnotes(text)
    	%(#{text})
    end
    
    def header(text, header_level)

    	if header_level <= 3
		  	%(<command_break>{"command":"header#{header_level}","margin":HEADER#{header_level}_MARGIN,"text":"<font name=\'HEADER#{header_level}_FONT\' size=\'HEADER#{header_level}_SIZE\'><b>#{text}</b></font>"}<command_break>)
		  else
		  	%(<command_break>{"command":"header#{header_level}","margin":HEADER#{header_level}_MARGIN,"text":"<font name=\'HEADER#{header_level}_FONT\' size=\'HEADER#{header_level}_SIZE\'>#{text}</font>"}<command_break>)
		  end
    end
		
    def emphasis(text)
      %(<i>#{text}</i>)
    end
    
    def quote(text)
      %(#{text})
    end
    
    def double_emphasis(text)
      %(<b>#{text}</b>)
    end
    
    def triple_emphasis(text)
      %(<i><b>#{text}</b></i>)
    end
    
    def underline(text)
    	%(<u>#{text}</u>)
    end
    
    def strikethrough(text)
    	%(<strikethrough>#{text}</strikethrough>)
    end
    
    def superscript(text)
    	%(<sup>#{text}</sup>)
    end
    
    def link(link, title, content)
   		%(<link href="#{link}">#{content}</link>)
    end
    
    def image(link, title, alt_text)
    	%(<command_break>{"command":"img", "title":"#{title}", "alt":"#{alt_text}", "path":"#{link}"}<command_break>)
    end
    
		def paragraph(text)
			%(#{text}\n\n)
		end
		
    def linebreak
      "\n.LP\n"
    end
		
    # Initialize a new +Prawndown::Parser+.
    # +text+ must a a valid Markdown string that only contains supported tags.
    def set_options(options)
		  
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
			
				text = text.gsub(replacer.upcase, @options[replacer].to_s)
				
			end
			
			text
		end
    
    # Parses the Markdown text and outputs a Prawn compatible string
    def finalize_input input
  
  	# variable replacement
    _match = Marshal.load(Marshal.dump(MATCHERS))

    result = _match.inject(input) do |final_string, (markdown_matcher, prawn_tag)|
      final_string.gsub(markdown_matcher, prawn_tag)
    end

    result = replace_options result

    result = result.split("<command_break>")

    result
      
    end
		
	end
end
