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

				if !options.key?("margin")
					args["margin"] = 0
				end
			
				pdf.pad args["margin"] do
					pdf.indent args["margin"], args["margin"] do
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
				
				if args["path"][0] == "/"
					args["path"] = args["path"][1..-1]
				end
				
				file = options["image_dir"] + "/" + args["path"]
				
				if !File.file?(file)
					file = "." + options["image_dir"] + "/" + args["path"]
				end
				
				if File.extname(file) != ".gif"
					pdf.image(file,
										width: pdf.bounds.width,
										position: :center)
				end
			end
			
			def self.cl_newline args, pdf, options
				pdf.start_new_page()
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
