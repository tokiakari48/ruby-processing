require_relative '../lib/core'
require_relative '../lib/rpextras'

Java::ProcessingVecmathArcball::ArcballLibrary.new.load(JRuby.runtime, false)

describe 'arcball new' do
  it 'should give error' do
    expect { Processing::ArcBall.init }.to raise_error
  end
end

describe 'arcball center and radius' do
  let(:applet) { Java::ProcessingCore::PApplet.new }
  it 'center and radius pass' do
    Processing::ArcBall.init(applet, 200, 100, 50)
  end
end

describe 'arcball center' do
  let(:applet) { Java::ProcessingCore::PApplet.new }
  it 'center pass' do
    Processing::ArcBall.init(applet, 200, 100)
  end
end

##############################
# Failed to mock camera version
###############################
