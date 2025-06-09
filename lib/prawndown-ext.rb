require 'prawn'
require "prawndown/version"
require "prawndown/parser"
require 'json'

module PrawndownExt

  module Interface
  
		class CommandInterface

			COMMAND = {
				"text" => -> (args, pdf) { cl_text(args, pdf) },
				"img" => -> (args, pdf) { cl_img(args, pdf) },
				"quote" => -> (args,pdf) { cl_text_box(args, pdf) },
			}
			
			def self.cl_text args, pdf
			
				pdf.text args["text"]
				
			end
			
			def self.cl_text_box args, pdf
				w_size = (pdf.bounds.width - args["margin"]).to_i
				position = [((pdf.bounds.width - w_size) * 0.5).to_i, pdf.cursor]
				
				pdf.bounding_box(position, width: w_size) do
				
					pdf.text(args["text"])
				
				end
				
			end
			
			def self.cl_img args, pdf
				pdf.image(args["path"],
									width: pdf.bounds.width,
									position: :center)
			end
			
			
			def exec  args, pdf
			
				if args.key?("command")
					if COMMAND.include?(args["command"])
						COMMAND[args["command"]].call(args, pdf)
					end
				end
				
			end
		
		end
  
		def unescape_text text
			text = text.gsub('\\"', '\"')
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
    def markdown(string, options: nil)
      	processed = PrawndownExt::Parser.new(string, options).to_prawn

				processed.each do |output|
					
					begin
						CommandInterface.new.exec JSON.parse(output.strip), self
						
					rescue
						text unescape_text(output), inline_format: true
					end
      		
      	end
    end
    
  end
end

Prawn::Document.extensions << PrawndownExt::Interface
