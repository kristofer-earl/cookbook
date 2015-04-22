name              'pokermahjong'
maintainer        'Spiralworks PokerMahjong'
maintainer_email  'devops@spiralwks.com'
license           'Private'
description       'Sets up PokerMahjong stack'
version           '0.0.1'

depends 'spiral'

%{ ubuntu debian }.each do |os|
  supports os
end
