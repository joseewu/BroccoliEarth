platform :ios, '10.0'
use_frameworks!
def main_sources
#define your pod resources
pod 'Alamofire'
pod 'ARCL'
pod "Floaty", "~> 4.1.0"

end
def test_sources
#define your pod resources for unit test

end
target 'BroccoliEarth' do
main_sources

  target 'BroccoliEarthTests' do
    inherit! :search_paths
    test_sources
  end

  target 'BroccoliEarthUITests' do
    inherit! :search_paths
    test_sources
  end

end
