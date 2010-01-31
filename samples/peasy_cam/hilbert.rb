############################
# hilbert.rb
###########################
class Hilbert
  include Processing::Proxy

  attr_reader :grammar, :axiom, :production, :premis, :rule, 
  :theta, :scale_factor, :distance, :phi, :len
  
  def initialize(len) 
    @axiom = "X"
    @grammar = Grammar.new(axiom)
    @production = axiom
    @premis = "X"
    @rule = "^<XF^<XFX-F^>>XFX&F+>>XFX-F>X->"
    @len = len
    @distance = len/12      # distance value relative to screen height
    @theta = Math::PI/180 * 90
    @phi = Math::PI/180 * 90
    grammar.add_rule(premis, rule)
    no_stroke()
  end

  def render()
    translate(-len/42, len/42, -len/42)  # use the "answer?" to center the Hilbert 
    fill(0, 75, 152) 
    light_specular(204, 204, 204) 
    specular(255, 255, 255) 
    shininess(1.0) 
    production.scan(/./) do |ch| 
      case(ch)
      when "F"     
        translate(0, distance/-2, 0)
        box(distance/9 , distance, distance/9)
        translate(0, distance/-2, 0)
      when "+"
        rotateX(-theta)
      when "-"
        rotateX(theta)
      when ">"
        rotateY(theta)
      when "<"
        rotateY(-theta)
      when "&"
        rotateZ(-phi)
      when "^"
        rotateZ(phi)
      when "X"
      else
        puts("character '#{ch}' not in grammar")
      end
    end
  end
  ##############################
  # create grammar from axiom and
  # rules (adjust scale)
  ##############################
  
  def create_grammar(gen)
    @distance *= 0.5**gen
    @production = @grammar.generate gen
  end
end


