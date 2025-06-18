require 'prawn'
require "prawndown/version"
require "prawndown/parser"
require 'json'

module PrawndownExt

  module Interface
  
		class CommandInterface

			COMMAND = {
				"text" => -> (args, pdf, options) { cl_text(args, pdf, options) },
				"img" => -> (args, pdf, options) { cl_img(args, pdf, options) },
				"quote" => -> (args,pdf, options) { cl_text_box(args, pdf, options) },
				"header1" => -> (args,pdf, options) { cl_text_box(args, pdf, options) },
				"header2" => -> (args,pdf, options) { cl_text_box(args, pdf, options) },
				"header3" => -> (args,pdf, options) { cl_text_box(args, pdf, options) },
				"header4" => -> (args,pdf, options) { cl_text_box(args, pdf, options) },
				"header5" => -> (args,pdf, options) { cl_text_box(args, pdf, options) },
				"header6" => -> (args,pdf, options) { cl_text_box(args, pdf, options) },
				"newpage" => -> (args,pdf, options) { cl_newline(args, pdf, options) }
			}
			
			def self.cl_text args, pdf, options
			
				pdf.text args["text"], inline_format: true, leading: options["default_line_spacing"].to_f
				
			end
			
			def self.cl_text_box args, pdf, options
				if !options.key?(args["command"] + "_line_spacing")
					options[args["command"] + "_line_spacing"] = 0
				end

				if !options.key?(args["command"] + "_horizontal_margin")
					options[args["command"] + "_horizontal_margin"] = 0
				end
				
				if !options.key?(args["command"] + "_vertical_margin")
					options[args["command"] + "_vertical_margin"] = 0
				end

				margin = (options[args["command"] + "_horizontal_margin"] * 0.5).floor
				half_margin = (options[args["command"] + "_vertical_margin"] * 0.5).floor
			
				pdf.pad half_margin do
					pdf.indent margin, margin do
						pdf.text args["text"], inline_format: true, leading: options[args["command"] + "_line_spacing"].to_f
					end
				end
				
			end
			
			def self.cl_img args, pdf, options
				if options.key?("no_image")
					if options["no_image"]
						return
					end
				end
				
				width = nil
				height = nil
				
				if options.key?("image_width")
					width = options["image_width"].to_i
				end
				
				if options.key?("image_height")
					height = options["image_height"].to_i
				end
				
				if width.nil? && height.nil?
					width = pdf.bounds.width
				end
				
				if !width.nil?
					width = [pdf.bounds.width, width].min
				end
				
				if args["path"][0] == "/"
					args["path"] = args["path"][1..-1]
				end
				
				file = options["image_dir"] + "/" + args["path"]
				
				if !File.file?(file)
					file = "." + options["image_dir"] + "/" + args["path"]
				end
				
				if File.extname(file) != ".gif"
					if !(height.nil? && width.nil?)
					
						if !options.key?("image_pad")
							options["image_pad"] = 0
						end
					
						pdf.pad options["image_pad"] do
							if height.nil? && !width.nil?
								pdf.image(file,
												width: [pdf.bounds.width, width].min,
												position: :center)
							elsif !height.nil? && width.nil?
								pdf.image(file,
												height: height,
												position: :center)
							else
								pdf.image(file,
												width: [pdf.bounds.width, width].min,
												height: height,
												position: :center)
							end
						end
					end
				end
			end
			
			def self.cl_newline args, pdf, options
				if pdf.bounds.instance_of? Prawn::Document::ColumnBox 
					pdf.bounds.move_past_bottom
				else
					pdf.start_new_page
				end
			end
			
			
			def exec args, pdf, options
				if args.key?("command")
					if COMMAND.include?(args["command"])

						COMMAND[args["command"]].call(args, pdf, options)
						
					end
				end
				
			end
		
		end
  
		def unescape_text text
			text = text.gsub('\\"', '"')
		end
  
    # Renders Markdown in the current document
    #
    # It supports header 1-6, bold text, italic text, strikethrough and links
    # It supports the same options as +Prawn::Document#text+
    #
    #   Prawn::Document.generate('markdown.pdf') do
    #     markdown '# Welcome to Prawndown!'
    #     markdown '**Important:** We _hope_ you enjoy your stay!'
    #   end
    def markdown(string, options: {})
    
				if !options.key?("default_line_spacing")
					options["default_line_spacing"] = 0
				end

      	processed = PrawndownExt::Parser.new(string, options).to_prawn

				processed.each do |output|	
					
					begin
						object = JSON.parse(output.strip)
					
						CommandInterface.new.exec object, self, options
					rescue
						text unescape_text(output), inline_format: true, leading: options["default_line_spacing"].to_f
					end
      		
      	end
    end
    
  end
end

Prawn::Document.extensions << PrawndownExt::Interface
