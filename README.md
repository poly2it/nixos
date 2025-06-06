# NixOS Configuration
This is my work-in-progress NixOS configuration.

## Usage
Build VM:  
`nix build .#nixosConfigurations.fractal.config.system.build.vm`  
Run VM:  
`./result/bin/run-nixos-vm`

# Attribution and Thank-Yous
This project inherits the excellent Firefox preferences distributed by
[hnhx](https://github.com/hnhx) in their
[user.js repository](https://github.com/hnhx/user.js).

The I2P add-on included in the I2P profile in Firefox is based on
[i2p_browser_extension](https://github.com/ManeraKai/i2p_browser_extension) by
[ManeraKai](https://github.com/ManeraKai).

Some websites which have been of great help so far with creating this
configuration are:

- https://wiki.nixos.org/
- https://mynixos.com/

The included wallpapers fall under public domain.

- Giuseppe Arcimboldo -
  [Vertumnus](https://en.wikipedia.org/wiki/Vertumnus_(Arcimboldo)), 1591
- Claude Monet - [Springtime](https://www.wikidata.org/wiki/Q7581196), 1872

The configuration for hiding unwanted desktop files was
[borrowed](https://forge.privatevoid.net/max/config/src/commit/502ed1151a5d71934d84728246300630f4577e1b/modules/desktop/hidden-apps.nix)
with permission
from [Max Headroom](https://github.com/max-privatevoid).

The configuration for updating the repository stems from
[forrestjacobs.com](https://github.com/forrestjacobs/forrestjacobs.com).

