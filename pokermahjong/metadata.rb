name              'pokermahjong'
maintainer        'Spiralworks PokerMahjong'
maintainer_email  'devops@spiralwks.com'
license           'Private'
description       'Sets up PokerMahjong stack'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '0.0.1'

depends 'spiral'

%{ ubuntu debian }.each do |os|
  supports os
end
