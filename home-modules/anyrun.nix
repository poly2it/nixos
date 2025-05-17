{ pkgs, inputs, ... }:

{
  programs.anyrun = {
    enable = true;
    config = {
      x = { fraction = 0.5; };
      y = { fraction = 0.2; };
      width = { fraction = 0.3; };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = false;
      showResultsImmediately = false;
      maxEntries = 16;

      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        symbols
        rink
        shell
      ];
    };

    extraCss = ''
      #window {
        background: transparent;
        font-family: "Arimo";
      }

      #entry {
        background: transparent;
        border: none;

        color: black;
        caret-color: black;
        font-size: 24px;

        padding: 0;
        margin: 12px;
        margin-bottom: 12px;
        transition: 0;
      }

      #entry:focus {
        outline: none;
        border: none;
        box-shadow: none;
      }

      box#main {
        background-color: rgba(243, 241, 240, 0.31);
        border: 1px solid rgba(117, 121, 120, 0.8);
        border-radius: 20px;
        box-shadow: 0px 15px 48px 6px rgba(0,0,0,0.3);
      }

      list {
        background: transparent;
        padding: 0;
        margin: 0;
      }

      list > #plugin:hover {
        background: inherit;
      }

      list > #plugin {
        border-top: 1px solid rgba(85, 89, 105, 0.3);
        padding: 12px;
        background: inherit;
      }

      list > #plugin:last-child {
        border-radius: 0 0 20px 20px;
      }

      #plugin > label {
        font-weight: bold;
      }

      #plugin separator {
        background-color: rgba(85, 89, 105, 0.3);
      }

      #match-title,
      #match-desc {
        font-weight: normal;
      }

      #match {
        background: transparent;
        transition: 0;
      }

      #match:hover {
        background: inherit;
      }

      #match:selected {
        border-radius: 8px;
        color: black;
        background-color: rgba(85, 89, 105, 0.3);
      }
    '';

    extraConfigFiles = {
      "applications.ron".text = ''
        Config(
          desktop_actions: true,
          max_entries: 10,
          terminal: Some(Terminal(
            command: "kitty",
            args: "{}",
          )),
        )
      '';

      "symbols.ron".text = ''
        Config(
          prefix: "",
          symbols: {
            // "name": "text to be copied"
            "shrug": "¯\\_(ツ)_/¯",
            // Country flags.
            "Andorra": "🇦🇩",
            "United Arab Emirates": "🇦🇪",
            "Afghanistan": "🇦🇫",
            "Antigua and Barbuda": "🇦🇬",
            "Anguilla": "🇦🇮",
            "Albania": "🇦🇱",
            "Armenia": "🇦🇲",
            "Angola": "🇦🇴",
            "Antarctica": "🇦🇶",
            "Argentina": "🇦🇷",
            "American Samoa": "🇦🇸",
            "Austria": "🇦🇹",
            "Australia": "🇦🇺",
            "Aruba": "🇦🇼",
            "Åland Islands": "🇦🇽",
            "Azerbaijan": "🇦🇿",
            "Bosnia and Herzegovina": "🇧🇦",
            "Barbados": "🇧🇧",
            "Bangladesh": "🇧🇩",
            "Belgium": "🇧🇪",
            "Burkina Faso": "🇧🇫",
            "Bulgaria": "🇧🇬",
            "Bahrain": "🇧🇭",
            "Burundi": "🇧🇮",
            "Benin": "🇧🇯",
            "Saint Barthélemy": "🇧🇱",
            "Bermuda": "🇧🇲",
            "Brunei Darussalam": "🇧🇳",
            "Bolivia": "🇧🇴",
            "Bonaire, Sint Eustatius and Saba": "🇧🇶",
            "Brazil": "🇧🇷",
            "Bahamas": "🇧🇸",
            "Bhutan": "🇧🇹",
            "Bouvet Island": "🇧🇻",
            "Botswana": "🇧🇼",
            "Belarus": "🇧🇾",
            "Belize": "🇧🇿",
            "Canada": "🇨🇦",
            "Cocos (Keeling) Islands": "🇨🇨",
            "Congo": "🇨🇩",
            "Central African Republic": "🇨🇫",
            "Congo": "🇨🇬",
            "Switzerland": "🇨🇭",
            "Côte D'Ivoire": "🇨🇮",
            "Cook Islands": "🇨🇰",
            "Chile": "🇨🇱",
            "Cameroon": "🇨🇲",
            "China": "🇨🇳",
            "Colombia": "🇨🇴",
            "Costa Rica": "🇨🇷",
            "Cuba": "🇨🇺",
            "Cape Verde": "🇨🇻",
            "Curaçao": "🇨🇼",
            "Christmas Island": "🇨🇽",
            "Cyprus": "🇨🇾",
            "Czech Republic": "🇨🇿",
            "Germany": "🇩🇪",
            "Djibouti": "🇩🇯",
            "Denmark": "🇩🇰",
            "Dominica": "🇩🇲",
            "Dominican Republic": "🇩🇴",
            "Algeria": "🇩🇿",
            "Ecuador": "🇪🇨",
            "Estonia": "🇪🇪",
            "Egypt": "🇪🇬",
            "Western Sahara": "🇪🇭",
            "Eritrea": "🇪🇷",
            "Spain": "🇪🇸",
            "Ethiopia": "🇪🇹",
            "Finland": "🇫🇮",
            "Fiji": "🇫🇯",
            "Falkland Islands (Malvinas)": "🇫🇰",
            "Micronesia": "🇫🇲",
            "Faroe Islands": "🇫🇴",
            "France": "🇫🇷",
            "Gabon": "🇬🇦",
            "United Kingdom": "🇬🇧",
            "Grenada": "🇬🇩",
            "Georgia": "🇬🇪",
            "French Guiana": "🇬🇫",
            "Guernsey": "🇬🇬",
            "Ghana": "🇬🇭",
            "Gibraltar": "🇬🇮",
            "Greenland": "🇬🇱",
            "Gambia": "🇬🇲",
            "Guinea": "🇬🇳",
            "Guadeloupe": "🇬🇵",
            "Equatorial Guinea": "🇬🇶",
            "Greece": "🇬🇷",
            "South Georgia": "🇬🇸",
            "Guatemala": "🇬🇹",
            "Guam": "🇬🇺",
            "Guinea-Bissau": "🇬🇼",
            "Guyana": "🇬🇾",
            "Hong Kong": "🇭🇰",
            "Heard Island and Mcdonald Islands": "🇭🇲",
            "Honduras": "🇭🇳",
            "Croatia": "🇭🇷",
            "Haiti": "🇭🇹",
            "Hungary": "🇭🇺",
            "Indonesia": "🇮🇩",
            "Ireland": "🇮🇪",
            "Israel": "🇮🇱",
            "Isle of Man": "🇮🇲",
            "India": "🇮🇳",
            "British Indian Ocean Territory": "🇮🇴",
            "Iraq": "🇮🇶",
            "Iran": "🇮🇷",
            "Iceland": "🇮🇸",
            "Italy": "🇮🇹",
            "Jersey": "🇯🇪",
            "Jamaica": "🇯🇲",
            "Jordan": "🇯🇴",
            "Japan": "🇯🇵",
            "Kenya": "🇰🇪",
            "Kyrgyzstan": "🇰🇬",
            "Cambodia": "🇰🇭",
            "Kiribati": "🇰🇮",
            "Comoros": "🇰🇲",
            "Saint Kitts and Nevis": "🇰🇳",
            "North Korea": "🇰🇵",
            "South Korea": "🇰🇷",
            "Kuwait": "🇰🇼",
            "Cayman Islands": "🇰🇾",
            "Kazakhstan": "🇰🇿",
            "Lao People's Democratic Republic": "🇱🇦",
            "Lebanon": "🇱🇧",
            "Saint Lucia": "🇱🇨",
            "Liechtenstein": "🇱🇮",
            "Sri Lanka": "🇱🇰",
            "Liberia": "🇱🇷",
            "Lesotho": "🇱🇸",
            "Lithuania": "🇱🇹",
            "Luxembourg": "🇱🇺",
            "Latvia": "🇱🇻",
            "Libya": "🇱🇾",
            "Morocco": "🇲🇦",
            "Monaco": "🇲🇨",
            "Moldova": "🇲🇩",
            "Montenegro": "🇲🇪",
            "Saint Martin (French Part)": "🇲🇫",
            "Madagascar": "🇲🇬",
            "Marshall Islands": "🇲🇭",
            "Macedonia": "🇲🇰",
            "Mali": "🇲🇱",
            "Myanmar": "🇲🇲",
            "Mongolia": "🇲🇳",
            "Macao": "🇲🇴",
            "Northern Mariana Islands": "🇲🇵",
            "Martinique": "🇲🇶",
            "Mauritania": "🇲🇷",
            "Montserrat": "🇲🇸",
            "Malta": "🇲🇹",
            "Mauritius": "🇲🇺",
            "Maldives": "🇲🇻",
            "Malawi": "🇲🇼",
            "Mexico": "🇲🇽",
            "Malaysia": "🇲🇾",
            "Mozambique": "🇲🇿",
            "Namibia": "🇳🇦",
            "New Caledonia": "🇳🇨",
            "Niger": "🇳🇪",
            "Norfolk Island": "🇳🇫",
            "Nigeria": "🇳🇬",
            "Nicaragua": "🇳🇮",
            "Netherlands": "🇳🇱",
            "Norway": "🇳🇴",
            "Nepal": "🇳🇵",
            "Nauru": "🇳🇷",
            "Niue": "🇳🇺",
            "New Zealand": "🇳🇿",
            "Oman": "🇴🇲",
            "Panama": "🇵🇦",
            "Peru": "🇵🇪",
            "French Polynesia": "🇵🇫",
            "Papua New Guinea": "🇵🇬",
            "Philippines": "🇵🇭",
            "Pakistan": "🇵🇰",
            "Poland": "🇵🇱",
            "Saint Pierre and Miquelon": "🇵🇲",
            "Pitcairn": "🇵🇳",
            "Puerto Rico": "🇵🇷",
            "Palestinian Territory": "🇵🇸",
            "Portugal": "🇵🇹",
            "Palau": "🇵🇼",
            "Paraguay": "🇵🇾",
            "Qatar": "🇶🇦",
            "Réunion": "🇷🇪",
            "Romania": "🇷🇴",
            "Serbia": "🇷🇸",
            "Russia": "🇷🇺",
            "Rwanda": "🇷🇼",
            "Saudi Arabia": "🇸🇦",
            "Solomon Islands": "🇸🇧",
            "Seychelles": "🇸🇨",
            "Sudan": "🇸🇩",
            "Sweden": "🇸🇪",
            "Singapore": "🇸🇬",
            "Saint Helena, Ascension and Tristan Da Cunha": "🇸🇭",
            "Slovenia": "🇸🇮",
            "Svalbard and Jan Mayen": "🇸🇯",
            "Slovakia": "🇸🇰",
            "Sierra Leone": "🇸🇱",
            "San Marino": "🇸🇲",
            "Senegal": "🇸🇳",
            "Somalia": "🇸🇴",
            "Suriname": "🇸🇷",
            "South Sudan": "🇸🇸",
            "Sao Tome and Principe": "🇸🇹",
            "El Salvador": "🇸🇻",
            "Sint Maarten (Dutch Part)": "🇸🇽",
            "Syrian Arab Republic": "🇸🇾",
            "Swaziland": "🇸🇿",
            "Turks and Caicos Islands": "🇹🇨",
            "Chad": "🇹🇩",
            "French Southern Territories": "🇹🇫",
            "Togo": "🇹🇬",
            "Thailand": "🇹🇭",
            "Tajikistan": "🇹🇯",
            "Tokelau": "🇹🇰",
            "Timor-Leste": "🇹🇱",
            "Turkmenistan": "🇹🇲",
            "Tunisia": "🇹🇳",
            "Tonga": "🇹🇴",
            "Turkey": "🇹🇷",
            "Trinidad and Tobago": "🇹🇹",
            "Tuvalu": "🇹🇻",
            "Taiwan": "🇹🇼",
            "Tanzania": "🇹🇿",
            "Ukraine": "🇺🇦",
            "Uganda": "🇺🇬",
            "United States Minor Outlying Islands": "🇺🇲",
            "United States": "🇺🇸",
            "Uruguay": "🇺🇾",
            "Uzbekistan": "🇺🇿",
            "Vatican City": "🇻🇦",
            "Saint Vincent and The Grenadines": "🇻🇨",
            "Venezuela": "🇻🇪",
            "Virgin Islands, British": "🇻🇬",
            "Virgin Islands, U.S.": "🇻🇮",
            "Viet Nam": "🇻🇳",
            "Vanuatu": "🇻🇺",
            "Wallis and Futuna": "🇼🇫",
            "Samoa": "🇼🇸",
            "Yemen": "🇾🇪",
            "Mayotte": "🇾🇹",
            "South Africa": "🇿🇦",
            "Zambia": "🇿🇲",
            "Zimbabwe": "🇿🇼",
          },
          max_entries: 5,
        )
      '';

      "shell.ron".text = ''
        Config(
          prefix: ":sh",
          shell: "kitty",
        )
      '';
    };
  };
}

