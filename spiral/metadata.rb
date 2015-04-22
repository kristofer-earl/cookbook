name              'spiral'
maintainer        'Spiralworks Core'
maintainer_email  'devops@spiralwks.com'
license           'Private'
description       'Configures basic infrastruture resused within the contexts of many inhouse applications'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '0.0.1'

depends 'apt'
depends 'supervisor'
depends 'build-essential'

%{ ubuntu debian }.each do |os|
  supports os
end
