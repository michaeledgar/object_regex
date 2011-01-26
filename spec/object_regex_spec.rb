require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

if RUBY_VERSION < "1.9"
  describe 'ObjectRegex' do
    it 'will raise upon loading under Ruby 1.8' do
      expect { require 'object_regex' }.to raise_error(RuntimeError)
    end
  end
else
  require 'object_regex'
  class Token < Struct.new(:type, :contents)
    def reg_desc
      type.to_s
    end
  end

  describe ObjectRegex do
    context 'with a small input alphabet' do
      before do
        @input = [Token.new(:str, '"hello"'),
                  Token.new(:str, '"there"'),
                  Token.new(:int, '2'),
                  Token.new(:str, '"worldagain"'),
                  Token.new(:str, '"highfive"'),
                  Token.new(:int, '5'),
                  Token.new(:str, 'jklkjl'),
                  Token.new(:int, '3'),
                  Token.new(:comment, '#lol'),
                  Token.new(:str, ''),
                  Token.new(:comment, '#no pairs'),
                  Token.new(:str, 'jkl'),
                  Token.new(:eof, '')]
      end

      it 'matches a simple token stream with a simple search pattern' do
        matches = ObjectRegex.new('(str int)+').all_matches(@input)
        matches.should == [@input[1..2], @input[4..7]]
      end
      
      it "matches the 'anything' dot" do
        ObjectRegex.new('int .').all_matches(@input).should ==
            [@input[2..3], @input[5..6], @input[7..8]]
      end
      
      it 'works with ranges ([xyz] syntax)' do
        ObjectRegex.new('str [int comment]').all_matches(@input).should ==
            [@input[1..2], @input[4..5], @input[6..7], @input[9..10]]
      end
      
      it 'works with count syntax (eg {1,2})' do
        ObjectRegex.new('str{2,3}').all_matches(@input).should ==
            [@input[0..1], @input[3..4]]
      end
    end
  end
end