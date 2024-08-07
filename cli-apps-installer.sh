#!/bin/bash

# Check for Bash version 4.0 or higher
if [[ "${BASH_VERSINFO:-0}" -lt 4 ]]; then
  echo "This script requires Bash version 4.0 or higher."
  exit 1
fi

# Declare apps_by_category in the global scope
declare -A apps_by_category

# Function to install necessary dependencies
install_dependencies() {
  echo "Installing necessary dependencies..."
  sudo apt-get update
  sudo apt-get install -y snapd npm python3-pip whiptail golang ruby build-essential python3-full python3.11-venv python3.11-distutils
  python3 -m pip install pipx --break-system-packages
  export PATH="$HOME/.local/bin:$PATH"
  pipx ensurepath
}

# Function to display categories and get user selection (CLI)
select_category_cli() {
  echo "Select a category:"
  select category in "${categories[@]}"; do
    if [[ -n "$category" ]]; then
      echo "You selected: $category"
      selected_category=$category
      break
    else
      echo "Invalid selection. Please try again."
    fi
  done
}

# Function to display categories and get user selection (GUI)
select_category_gui() {
  local options=()
  for i in "${!categories[@]}"; do
    options+=("$i" "${categories[$i]}")
  done
  category=$(whiptail --title "Select a category" --menu "Choose a category" 20 60 10 "${options[@]}" 3>&1 1>&2 2>&3)
  if [[ $? -ne 0 ]]; then
    return 1
  fi
  selected_category=${categories[$category]}
}

# Function to display apps in a category and get user selection (CLI)
select_apps_cli() {
  echo "Select apps to install (separate by space):"
  for i in "${!apps[@]}"; do
    echo "$i) ${apps[$i]}"
  done
  read -p "Enter numbers: " -a selected_apps
}

# Function to display apps in a category and get user selection (GUI)
select_apps_gui() {
  local options=()
  for i in "${!apps[@]}"; do
    options+=("${apps[$i]}" "" OFF)
  done
  choices=$(whiptail --title "Select apps" --checklist "Choose apps to install" 20 60 10 "${options[@]}" 3>&1 1>&2 2>&3)
  if [[ $? -ne 0 ]]; then
    return 1
  fi
  selected_apps=($choices)
}

# Function to install selected apps
install_apps() {
  local selected_apps=("$@")
  for app in "${selected_apps[@]}"; do
    app=$(echo "$app" | xargs)

    case "$app" in
      "football-cli")
        npm install -g footballcli
        ;;
    "pockyt")
        pip install -U pockyt   
        ;;
    "newsboat")
        sudo snap install newsboat
        ;;
    "cmus")
        sudo apt-get install -y cmus
        ;;
    "Instant-Music-Downloader")
        pip install instantmusic
        ;;
    "itunes-remote")
        npm install --global itunes-remote
        ;;
    "pianobar")
        sudo apt-get install -y pianobar
        ;;
    "mpd")
        sudo apt-get install -y mpd
        ;;
    "ncmpcpp")
        sudo apt-get install -y ncmpcpp
        ;;
    "moc")
        sudo apt-get install -y moc
        ;;
    "beets")
        pip install beets
        ;;
    "spotify-tui")
        snap install spt
        ;;
    "swaglyrics-for-spotify")
        pip install swaglyrics
        ;;
    "dzr")
        snap install --edge dzr
        ;;
    "radio-active")
        pip install --upgrade radio-active
        sudo apt install ffmpeg
        ;;
    "facebook-cli")
        sudo gem install facebook-cli
        ;;
    "Rainbowstream")
        pipx install rainbowstream
        ;;
    "tuir") 
        pipx install tuir
        ;;
    "WeeChat")
        sudo apt-get install -y weechat
        ;;
    "youtube-dl")
        sudo -H pip install --upgrade youtube-dl
        ;;
    "streamlink")
        sudo apt-get install streamlink
        ;;
    "yewtube")
        pipx install yewtube
        ;;
    "mpv")
        sudo apt-get install -y mpv
        ;;
    "editly") #until here
        npm install -g editly
        ;;
    "yt-dlp")
        pip install yt-dlp
        ;;
    "moviemon")
        pip install moviemon
        ;;
    "movie")
        pip install movie
        ;;
    "Dwarf Fortress")
        wget https://archive.org/download/dwarf-fortress-0.47.05-linux-x86_64/dwarf-fortress-0.47.05-linux-x86_64.tar.gz
        tar -xzf dwarf-fortress-0.47.05-linux-x86_64.tar.gz
        sudo mv dwarf-fortress /opt/
        ;;
    "Cataclysm-DDA")
        sudo add-apt-repository ppa:cataclysm-dda-team/cdda
        sudo apt-get update
        sudo apt-get install -y cataclysm-dda
        ;;
    "pokete")
        git clone https://github.com/someuser/pokete.git
        cd pokete
        sudo python3 setup.py install
        ;;
    "epr")
        pip install epr
        ;;
    "Bible.Js CLI")
        npm install -g bible-js-cli
        ;;
    "SpeedRead")
        pip install speedread
        ;;
    "medium-cli")
        pip install medium-cli
        ;;
    "legit")
        pip install legit
        ;;
    "mklicense")
        pip install mklicense
        ;;
    "rebound")
        pip install rebound
        ;;
    "foy")
        pip install foy
        ;;
    "just")
        curl -fsSL https://github.com/casey/just/releases/download/v0.13.0/just-0.13.0-x86_64-unknown-linux-musl.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/just /usr/local/bin/
        ;;
    "bcal")
        sudo apt-get install -y bcal
        ;;
    "bitwise")
        pip install bitwise
        ;;
    "cgasm")
        pip install cgasm
        ;;
    "grex")
        cargo install grex
        ;;
    "gdb-dashboard")
        pip install gdb-dashboard
        ;;
    "iola")
        pip install iola
        ;;
    "add-gitignore")
        pip install add-gitignore
        ;;
    "is-up-cli")
        pip install is-up-cli
        ;;
    "reachable")
        pip install reachable
        ;;
    "loadtest")
        npm install -g loadtest
        ;;
    "diff2html-cli")
        npm install -g diff2html-cli
        ;;
    "emacs")
        sudo apt-get install -y emacs
        ;;
    "vim")
        sudo apt-get install -y vim
        ;;
    "neovim")
        sudo apt-get install -y neovim
        ;;
    "kakoune")
        sudo apt-get install -y kakoune
        ;;
    "micro")
        sudo apt-get install -y micro
        ;;
    "o")
        curl -sL 'https://github.com/xyproto/orbiton/releases/download/v2.65.12/orbiton-2.65.12-linux_armv7_static.tar.xz' | tar JxC /tmp && sudo install -Dm755 /tmp/orbiton-2.65.12-linux_armv7_static/o /usr/bin/o && sudo install -Dm644 /tmp/orbiton-2.65.12-linux_armv7_static/o.1.gz /usr/share/man/man1/o.1.gz
        ;;
    "helix")
        curl -fsSL https://github.com/helix-editor/helix/releases/download/24.07/helix-24.07-aarch64-linux.tar.xz | tar xzf - -C /tmp && sudo mv /tmp/helix /usr/local/bin/
        ;;
    "caniuse-cmd")
        npm install -g caniuse-cmd
        ;;
    "strip-css-comments-cli")
        npm install -g strip-css-comments-cli
        ;;
    "viewport-list-cli")
        npm install -g viewport-list-cli
        ;;
    "surge")
        npm install -g surge
        ;;
    "mobicon-cli")
        npm install -g mobicon-cli
        ;;
    "mobisplash-cli")
        npm install -g mobisplash-cli
        ;;
    "deviceframe")
        npm install -g deviceframe
        ;;
    "mycli")
        pip install mycli
        ;;
    "pgcli")
        pip install pgcli
        ;;
    "sqlline")
        curl -fsSL https://github.com/julianhyde/sqlline/releases/download/1.9.0/sqlline-1.9.0-bin.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/sqlline/bin/sqlline /usr/local/bin/
        ;;
    "iredis")
        pip install iredis
        ;;
    "usql")
        curl -fsSL https://github.com/xo/usql/releases/download/v0.11.0/usql_0.11.0_linux_amd64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/usql /usr/local/bin/
        ;;
    "htconvert")
        pip install htconvert
        ;;
    "SAWS")
        pip install awscli
        pip install saws
        ;;
    "s3cmd")
        sudo apt-get install -y s3cmd
        ;;
    "pm2")
        npm install -g pm2
        ;;
    "ops")
        curl -fsSL https://github.com/nickgerace/ops/releases/download/v0.3.0/ops-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/ops /usr/local/bin/
        ;;
    "flog")
        pip install flog
        ;;
    "k9s")
        curl -fsSL https://github.com/derailed/k9s/releases/download/v0.27.0/k9s_Linux_x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/k9s /usr/local/bin/
        ;;
    "PingMe")
        pip install pingme
        ;;
    "ipfs-deploy")
        npm install -g ipfs-deploy
        ;;
    "Discharge")
        npm install -g discharge
        ;;
    "updatecli")
        curl -fsSL https://github.com/updatecli/updatecli/releases/download/v0.21.0/updatecli-linux-amd64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/updatecli /usr/local/bin/
        ;;
    "lstags")
        npm install -g lstags
        ;;
    "dockly")
        npm install -g dockly
        ;;
    "lazydocker")
        curl -fsSL https://github.com/jesseduffield/lazydocker/releases/download/v0.16.0/lazydocker_0.16.0_Linux_x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/lazydocker /usr/local/bin/
        ;;
    "docker-pushrm")
        pip install docker-pushrm
        ;;
    "release-it")
        npm install -g release-it
        ;;
    "clog")
        npm install -g clog
        ;;
    "np")
        npm install -g np
        ;;
    "release")
        npm install -g release
        ;;
    "semantic-release")
        npm install -g semantic-release
        ;;
    "npm-name-cli")
        npm install -g npm-name-cli
        ;;
    "npm-user-cli")
        npm install -g npm-user-cli
        ;;
    "npm-home")
        npm install -g npm-home
        ;;
    "pkg-dir-cli")
        npm install -g pkg-dir-cli
        ;;
    "npm-check-updates")
        npm install -g npm-check-updates
        ;;
    "updates")
        npm install -g updates
        ;;
    "wipe-modules")
        npm install -g wipe-modules
        ;;
    "yo")
        npm install -g yo
        ;;
    "boilr")
        curl -fsSL https://github.com/boilr/boilr/releases/download/v0.3.0/boilr-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/boilr /usr/local/bin/
        ;;
    "cookiecutter")
        pip install cookiecutter
        ;;
    "mevn-cli")
        npm install -g mevn-cli
        ;;
    "scaffold-static")
        npm install -g scaffold-static
        ;;
    "serve")
        npm install -g serve
        ;;
    "simplehttp")
        pip install simplehttp
        ;;
    "shell2http")
        go install github.com/ant0ine/shell2http@latest
        ;;
    "HTTPie")
        pip install httpie
        ;;
    "HTTP Prompt")
        pip install http-prompt
        ;;
    "ain")
        npm install -g ain
        ;;
    "curlie")
        curl -fsSL https://github.com/rs/curlie/releases/download/v1.7.0/curlie-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/curlie /usr/local/bin/
        ;;
    "doing")
        pip install doing
        ;;
    "ffscreencast")
        sudo apt-get install -y ffmpeg
        #to investigate
        ;;
    "meetup-cli")
        npm install -g meetup-cli
        ;;
    "NeoMutt")
        sudo apt-get install -y neomutt
        ;;
    "terjira")
        npm install -g terjira
        ;;
    "ipt")
        npm install -g ipt
        ;;
    "uber-cli")
        npm install -g uber-cli
        ;;
    "Buku")
        pip install buku
        ;;
    "papis")
        pip install papis
        ;;
    "pubs")
        pip install pubs
        ;;
    "fjira")
        pip install fjira
        ;;
    "Timetrap")
        gem install timetrap
        ;;
    "moro")
        curl -fsSL https://github.com/moro/moro/releases/download/v0.6.0/moro-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/moro /usr/local/bin/
        ;;
    "Timewarrior")
        sudo apt-get install -y timewarrior
        ;;
    "Watson")
        pip install watson
        ;;
    "utt")
        pip install utt
        ;;
    "Bartib")
        curl -fsSL https://github.com/bartib/bartib/releases/download/v0.5.0/bartib-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/bartib /usr/local/bin/
        ;;
    "idea")
        pip install idea
        ;;
    "geeknote")
        pip install geeknote
        ;;
    "Taskwarrior")
        sudo apt-get install -y taskwarrior
        ;;
    "Terminal velocity")
        git clone https://github.com/vhp/terminal_velocity.git && cd terminal_velocity && sudo python3 setup.py install
        ;;
    "eureka")
        pip install eureka
        ;;
    "sncli")
        pip install simplenote-cli
        ;;
    "td-cli")
        npm install -g td-cli
        ;;
    "taskell")
        curl -fsSL https://github.com/taskell/taskell/releases/download/v1.0.0/taskell-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/taskell /usr/local/bin/
        ;;
    "taskbook")
        npm install -g taskbook
        ;;
    "dnote")
        curl -fsSL https://github.com/dnote/dnote/releases/download/v1.0.0/dnote-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/dnote /usr/local/bin/
        ;;
    "nb")
        pip install nb
        ;;
    "obs")
        curl -fsSL https://github.com/obsidianmd/obsidian-releases/releases/download/v0.15.6/Obsidian-0.15.6.AppImage -o /tmp/obsidian.AppImage
        chmod +x /tmp/obsidian.AppImage
        sudo mv /tmp/obsidian.AppImage /usr/local/bin/obs
        ;;
    "ledger")
        sudo apt-get install -y ledger
        ;;
    "hledger")
        sudo apt-get install -y hledger
        ;;
    "moeda")
        pip install moeda
        ;;
    "cash-cli")
        npm install -g cash-cli
        ;;
    "cointop")
        curl -fsSL https://github.com/cointop-sh/cointop/releases/download/v1.7.0/cointop-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/cointop /usr/local/bin/
        ;;
    "ticker")
        curl -fsSL https://github.com/sdcoffey/financial/releases/download/v1.0.0/ticker_linux_amd64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/ticker /usr/local/bin/
        ;;
    "WOPR")
        curl -fsSL https://github.com/wopr/wopr/releases/download/v0.1.0/wopr-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/wopr /usr/local/bin/
        ;;
    "decktape")
        npm install -g decktape
        ;;
    "mdp")
        sudo apt-get install -y mdp
        ;;
    "sent")
        pip install sent
        ;;  
    "slides")
        npm install -g slides
        ;;
    "calcurse")
        sudo apt-get install -y calcurse
        ;;
    "gcalcli")
        pip install gcalcli
        ;;
    "khal")
        pip install khal
        ;;
    "vdirsyncer")
        pip install vdirsyncer
        ;;
    "remind")
        sudo apt-get install -y remind
        ;;
    "birthday")
        pip install birthday
        ;;
    "aria2")
        sudo apt-get install -y aria2
        ;;
    "bitly-client")
        pip install bitly-client
        ;;
    "deadlink")
        pip install deadlink
        ;;
    "crawley")
        pip install crawley
        ;;
    "kill-tabs")
        # Assuming kill-tabs is a Node.js tool or similar
        npm install -g kill-tabs
        ;;
    "alex")
        npm install -g alex
        ;;
    "clevercli")
        npm install -g @clevercli/cli
        ;;
    "gotty")
        curl -fsSL https://github.com/tsl0922/ttyd/releases/download/v1.6.0/ttyd_1.6.0_linux_amd64.deb -o /tmp/gotty.deb
        sudo dpkg -i /tmp/gotty.deb
        ;;
    "localtunnel")
        npm install -g localtunnel
        ;;
    "mosh")
        sudo apt-get install -y mosh
        ;;
    "ngrok")
        curl -fsSL https://bin.equinox.io/c/4b4f5d1f6c44/ngrok-stable-linux-amd64.zip -o /tmp/ngrok.zip
        unzip /tmp/ngrok.zip -d /tmp
        sudo mv /tmp/ngrok /usr/local/bin/
        ;;
    "tmate")
        sudo apt-get install -y tmate
        ;;
    "warp")
        curl -fsSL https://github.com/warpdotdev/warp/releases/download/v1.2.1/warp-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/warp /usr/local/bin/
        ;;
    "OverTime")
        pip install overtime
        ;;
    "get-port-cli")
        npm install -g get-port-cli
        ;;
    "is-reachable-cli")
        npm install -g is-reachable-cli
        ;;
    "acmetool")
        curl -fsSL https://github.com/hoermann/acmetool/releases/download/v0.3.0/acmetool-linux-amd64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/acmetool /usr/local/bin/
        ;;
    "certificate-ripper")
        pip install certificate-ripper
        ;;
    "neoss")
        pip install neoss
        ;;
    "splash-cli")
        npm install -g splash-cli
        ;;
    "wallpaper-cli")
        npm install -g wallpaper-cli
        ;;
    "themer")
        npm install -g themer
        ;;
    "JackPaper")
        pip install jackpaper
        ;;
    "pywal")
        sudo apt-get install -y pywal
        ;;
    "QuickWall")
        npm install -g quickwall
        ;;
    "oh-my-posh")
        sudo apt-get install -y oh-my-posh
        ;;
    "has")
        npm install -g has
        ;;
    "Ultimate Plumber")
        pip install ultimate-plumber
        ;;
    "fkill-cli")
        npm install -g fkill-cli
        ;;
    "task-spooler")
        sudo apt-get install -y task-spooler
        ;;
    "undollar")
        npm install -g undollar
        ;;
    "pipe_exec")
        npm install -g pipe_exec
        ;;
    "neofetch")
        sudo apt-get install -y neofetch
        ;;
    "battery-level-cli")
        pip install battery-level-cli
        ;;
    "brightness-cli")
        pip install brightness-cli
        ;;
    "yank")
        pip install yank
        ;;
    "screensaver")
        sudo apt-get install -y xscreensaver
        ;;
    "google-font-installer")
        curl -fsSL https://github.com/google/fonts/archive/main.zip -o /tmp/google-fonts.zip
        unzip /tmp/google-fonts.zip -d /tmp && sudo mv /tmp/fonts-main /usr/share/fonts
        ;;
    "glances")
        pip install glances
        ;;
    "tiptop")
        sudo apt-get install -y tiptop
        ;;
    "gzip-size-cli")
        npm install -g gzip-size-cli
        ;;
    "DocToc")
        npm install -g doctoc
        ;;
    "grip")
        pip install grip
        ;;
    "mdv")
        pip install mdv
        ;;
    "glow")
        curl -fsSL https://github.com/charmbracelet/glow/releases/download/v1.4.0/glow_linux_amd64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/glow /usr/local/bin/
        ;;
    "gtree")
        pip install gtree
        ;;
    "pass")
        sudo apt-get install -y pass
        ;;
    "gopass")
        curl -fsSL https://github.com/gopasspw/gopass/releases/download/v1.12.0/gopass-linux-amd64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/gopass /usr/local/bin/
        ;;
    "xiringuito")
        curl -fsSL https://github.com/robertdavidgraham/xiringuito/releases/download/v1.1.0/xiringuito-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/xiringuito /usr/local/bin/
        ;;
    "hasha-cli")
        npm install -g hasha-cli
        ;;
    "ots")
        npm install -g ots
        ;;
    "mdlt")
        npm install -g mdlt
        ;;
    "Qalculate")
        sudo apt-get install -y qalculate
        ;;
    "wttr.in")
        # No installation needed; wttr.in is a web service
        echo "Use wttr.in directly via the web or curl command."
        ;;
    "wego")
        curl -fsSL https://github.com/schachmat/wego/releases/download/v2.2.0/wego_linux_amd64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/wego /usr/local/bin/
        ;;
    "weather-cli")
        npm install -g weather-cli
        ;;
    "s")
        npm install -g s
        ;;
    "hget")
        pip install hget
        ;;
    "mapscii")
        npm install -g mapscii
        ;;
    "nasa-cli")
        npm install -g nasa-cli
        ;;
    "getnews.tech")
        curl -fsSL https://github.com/getnews-tech/getnews.tech/releases/download/v1.0.0/getnews.tech-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/getnews.tech /usr/local/bin/
        ;;
    "trino")
        npm install -g trino
        ;;
    "translate-shell")
        sudo apt-get install -y translate-shell
        ;;
    "speedtest-net")
        sudo apt-get install -y speedtest-cli
        ;;
    "speed-test")
        npm install -g speed-test
        ;;
    "speedtest-cli")
        sudo apt-get install -y speedtest-cli
        ;;
    "bandwhich")
        curl -fsSL https://github.com/imsnif/bandwhich/releases/download/v0.19.0/bandwhich_0.19.0_amd64.deb -o /tmp/bandwhich.deb
        sudo dpkg -i /tmp/bandwhich.deb
        ;;
    "cmdchallenge")
        pip install cmdchallenge
        ;;
    "explainshell")
        pip install explainshell
        ;;
    "howdoi")
        pip install howdoi
        ;;
    "how2")
        npm install -g how2
        ;;
    "The Fuck")
        pip install thefuck
        ;;
    "tldr")
        npm install -g tldr
        ;;
    "Wat")
        pip install wat
        ;;
    "teachcode")
        npm install -g teachcode
        ;;
    "navi")
        npm install -g navi
        ;;
    "yai")
        npm install -g yai
        ;;
    "visidata")
        pip install visidata
        ;;
    "jq")
        sudo apt-get install -y jq
        ;;
    "yq")
        pip install yq
        ;;
    "dasel")
        curl -fsSL https://github.com/derailed/dasel/releases/download/v1.13.0/dasel_linux_amd64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/dasel /usr/local/bin/
        ;;
    "yaml-cli")
        npm install -g yaml-cli
        ;;
    "ramda-cli")
        npm install -g ramda-cli
        ;;
    "xq")
        pip install xq
        ;;
    "jp")
        sudo apt-get install -y jp
        ;;
    "fx")
        npm install -g fx
        ;;
    "vj")
        npm install -g vj
        ;;
    "underscore-cli")
        npm install -g underscore-cli
        ;;
    "strip-json-comments-cli")
        npm install -g strip-json-comments-cli
        ;;
    "GROQ")
        curl -fsSL https://github.com/someuser/groq/releases/download/v1.0.0/groq-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/groq /usr/local/bin/
        ;;
    "gron")
        curl -fsSL https://github.com/stanaka/gron/releases/download/v0.7.0/gron_0.7.0_linux_amd64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/gron /usr/local/bin/
        ;;
    "dyff")
        curl -fsSL https://github.com/homeport/dyff/releases/download/v0.6.0/dyff_0.6.0_linux_amd64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/dyff /usr/local/bin/
        ;;
    "parse-columns-cli")
        npm install -g parse-columns-cli
        ;;
    "q")
        curl -fsSL https://github.com/harelba/q/releases/download/v1.6.0/q_1.6.0_linux_amd64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/q /usr/local/bin/
        ;;
    "figlet")
        sudo apt-get install -y figlet
        ;;
    "stegcloak")
        npm install -g stegcloak
        ;;
    "ranger")
        sudo apt-get install -y ranger
        ;;
    "midnight-commander")
        sudo apt-get install -y mc
        ;;
    "Vifm")
        sudo apt-get install -y vifm
        ;;
    "nnn")
        sudo apt-get install -y nnn
        ;;
    "lf")
        curl -fsSL https://github.com/gokcehan/lf/releases/download/v0.34/lf-linux-amd64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/lf /usr/local/bin/
        ;;
    "fff")
        curl -fsSL https://github.com/dylanaraps/fff/releases/download/v1.2.2/fff-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/fff /usr/local/bin/
        ;;
    "clifm")
        curl -fsSL https://github.com/cli/cli/releases/download/v1.0.0/clifm-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/clifm /usr/local/bin/
        ;;
    "far2l")
        curl -fsSL https://github.com/feh/feh/releases/download/v1.0.0/far2l-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/far2l /usr/local/bin/
        ;;
    "trash-cli")
        sudo apt-get install -y trash-cli
        ;;
    "empty-trash-cli")
        sudo apt-get install -y trash-cli
        ;;
    "del-cli")
        npm install -g del-cli
        ;;
    "cpy-cli")
        npm install -g cpy-cli
        ;;
    "rename-cli")
        npm install -g rename-cli
        ;;
    "renameutils")
        sudo apt-get install -y renameutils
        ;;
    "diskonaut")
        curl -fsSL https://github.com/fiatjaf/diskonaut/releases/download/v1.0.0/diskonaut-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/diskonaut /usr/local/bin/
        ;;
    "chokidar-cli")
        npm install -g chokidar-cli
        ;;
    "file-type-cli")
        npm install -g file-type-cli
        ;;
    "bat")
        sudo apt-get install -y bat
        ;;
    "NCDu")
        sudo apt-get install -y ncdu
        ;;
    "unix-permissions")
        npm install -g unix-permissions
        ;;
    "transmission-cli")
        sudo apt-get install -y transmission-cli
        ;;
    "webtorrent-cli")
        npm install -g webtorrent-cli
        ;;
    "entr")
        sudo apt-get install -y entr
        ;;
    "organize-cli")
        npm install -g organize-cli
        ;;
    "organize-rt")
        npm install -g organize-rt
        ;;
    "RecoverPy")
        pip install recoverpy
        ;;
    "rclone")
        curl -fsSL https://downloads.rclone.org/rclone-current-linux-amd64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/rclone-*/rclone /usr/local/bin/
        ;;
    "ffsend")
        curl -fsSL https://github.com/ffsend/ffsend/releases/download/v0.2.0/ffsend-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/ffsend /usr/local/bin/
        ;;
    "share-cli")
        npm install -g share-cli
        ;;
    "google-drive-upload")
        npm install -g google-drive-upload
        ;;
    "gdrive-downloader")
        npm install -g gdrive-downloader
        ;;
    "portal")
        npm install -g portal
        ;;
    "shbin")
        npm install -g shbin
        ;;
    "sharing")
        npm install -g  sharing
        ;;
    "ncp")
        npm install -g ncp
        ;;
    "alder")
        npm install -g alder
        ;;
    "eza")
        curl -fsSL https://github.com/eza/eza/releases/download/v0.8.0/eza-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/eza /usr/local/bin/
        ;;
    "tre")
        npm install -g tre
        ;;
    "ll")
        npm install -g ll
        ;;
    "lsd")
        curl -fsSL https://github.com/lsd/lsd/releases/download/v0.19.0/lsd_0.19.0_amd64.deb -o /tmp/lsd.deb && sudo dpkg -i /tmp/lsd.deb
        ;;
    "autojump")
        sudo apt-get install -y autojump
        ;;
    "pm")
        npm install -g pm
        ;;
    "z")
        sudo apt-get install -y z
        ;;
    "PathPicker")
        npm install -g pathpicker
        ;;
    "fz")
        npm install -g fz
        ;;
    "goto")
        npm install -g goto
        ;;
    "z.lua")
        curl -fsSL https://github.com/skywind3000/z.lua/releases/download/v1.10/z.lua-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/z.lua /usr/local/bin/
        ;;
    "zoxide")
        curl -fsSL https://github.com/ajeetdsouza/zoxide/releases/download/v0.9.0/zoxide-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/zoxide /usr/local/bin/
        ;;
    "tere")
        npm install -g tere
        ;;
    "happyfinder")
        npm install -g happyfinder
        ;;
    "find-up-cli")
        npm install -g find-up-cli
        ;;
    "ripgrep")
        sudo apt-get install -y ripgrep
        ;;
    "fzf")
        curl -fsSL https://github.com/junegunn/fzf/releases/download/0.27.0/fzf-0.27.0-linux_amd64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/fzf /usr/local/bin/
        ;;
    "fselect")
        curl -fsSL https://github.com/jonas/ghz/releases/download/v0.7.0/fselect_0.7.0_linux_amd64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/fselect /usr/local/bin/
        ;;
    "fd")
        sudo apt-get install -y fd-find
        ;;
    "broot")
        curl -fsSL https://github.com/Canop/broot/releases/download/v1.14.0/broot-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/broot /usr/local/bin/
        ;;
    "rare")
        npm install -g rare
        ;;
    "skim")
        curl -fsSL https://github.com/lotabout/skim/releases/download/v0.10.0/skim_0.10.0_linux_amd64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/skim /usr/local/bin/
        ;;
    "ast-grep")
        curl -fsSL https://github.com/ast-grep/ast-grep/releases/download/v1.0.0/ast-grep-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/ast-grep /usr/local/bin/
        ;;
    "SnowFS")
        curl -fsSL https://github.com/snowfs/snowfs/releases/download/v1.0.0/snowfs-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/snowfs /usr/local/bin/
        ;;
    "git")
        sudo apt-get install git
        ;;
    "git commander")
        npm install -g git-commander
        ;;
    "git-stats")
        npm install -g git-stats
        ;;
    "dev-time")
        npm install -g dev-time
        ;;
    "tig")
        sudo apt-get install -y tig
        ;;
    "grv")
        curl -fsSL https://github.com/derailed/grv/releases/download/v0.8.0/grv-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/grv /usr/local/bin/
        ;;
    "git-standup")
        npm install -g git-standup
        ;;
    "git-secret")
        sudo apt-get install -y git-secret
        ;;
    "gitlab-cli")
        npm install -g gitlab-cli
        ;;
    "git-extras")
        sudo apt-get install -y git-extras
        ;;
    "gita")
        npm install -g gita
        ;;
    "readme-md-generator")
        npm install -g readme-md-generator
        ;;
    "semantic-git-commit-cli")
        npm install -g semantic-git-commit-cli
        ;;
    "import-github-labels-cli")
        npm install -g import-github-labels-cli
        ;;
    "git-all-branches")
        npm install -g git-all-branches
        ;;
    "czg")
        npm install -g czg
        ;;
    "shallow-backup")
        npm install -g shallow-backup
        ;;
    "Lazygit")
        curl -fsSL https://github.com/jesseduffield/lazygit/releases/download/v0.35.1/lazygit_0.35.1_Linux_x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/lazygit /usr/local/bin/
        ;;
    "CLI GitHub")
        npm install -g github-cli
        ;;
    "hub")
        sudo apt-get install -y hub
        ;;
    "git-labelmaker")
        npm install -g git-labelmaker
        ;;
    "gitmoji-cli")
        npm install -g gitmoji-cli
        ;;
    "gitmoji-changelog")
        npm install -g gitmoji-changelog
        ;;
    "emoj")
        npm install -g emoj
        ;;
    "emoji-finder")
        npm install -g emoji-finder
        ;;
    "oji")
        npm install -g oji
        ;;
        "SVGO")
        npm install -g svgo
        ;;
    "carbon-now-cli")
        npm install -g carbon-now-cli
        ;;
    "imgur-uploader-cli")
        npm install -g imgur-uploader-cli
        ;;
    "pageres-cli")
        npm install -g pageres-cli
        ;;
    "gifgen")
        curl -fsSL https://github.com/gifgen/gifgen/releases/download/v1.0.0/gifgen-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/gifgen /usr/local/bin/
        ;;
    "gifsicle")
        sudo apt-get install -y gifsicle
        ;;
    "ttygif")
        npm install -g ttygif
        ;;
    "ttystudio")
        npm install -g ttystudio
        ;;
    "asciinema")
        sudo apt-get install -y asciinema
        ;;
    "givegif")
        npm install -g givegif
        ;;
    "imagemagick")
        sudo apt-get install -y imagemagick
        ;;
    "imgp")
        curl -fsSL https://github.com/herrbischoff/imgp/releases/download/v0.2.0/imgp-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/imgp /usr/local/bin/
        ;;
    "korkut")
        npm install -g korkut
        ;;
    "cmatrix")
        sudo apt-get install -y cmatrix
        ;;
    "pipes.sh")
        curl -fsSL https://github.com/scrollb/scrollb/releases/download/v1.0.0/pipes.sh-linux-x86_64.tar.gz | tar xzf - -C /tmp && sudo mv /tmp/pipes.sh /usr/local/bin/
        ;;
    "YuleLog")
        npm install -g yulelog
        ;;
    "cli-fireplace")
        npm install -g cli-fireplace
        ;;
     "cli-mandelbrot")
        npm install -g cli-mandelbrot
        ;;
    "sparkly-cli")
        npm install -g sparkly-cli
        ;;
    "pastel")
        npm install -g pastel
        ;;
    "lowcharts")
        npm install -g lowcharts
        ;;
    "quote-cli")
        npm install -g quote-cli
        ;;
    "fortune")
        sudo apt-get install -y fortune
        ;;
    "ponysay")
        sudo apt-get install -y ponysay
        ;;
    "yosay")
        npm install -g yosay
        ;;
    "lolcat")
        gem install lolcat
        ;;
    "text-meme")
        npm install -g text-meme
        ;;
    "dankcli")
        npm install -g dankcli
        ;;
    "ricksay")
        npm install -g ricksay
        ;;
    "quote-cli")
        npm install -g quote-cli
        ;;
    "fortune")
        sudo apt-get install -y fortune
        ;;
    "ponysay")
        sudo apt-get install -y ponysay
        ;;
    "yosay")
        npm install -g yosay
        ;;
    "lolcat")
        gem install lolcat
        ;;
    "text-meme")
        npm install -g text-meme
        ;;
    "dankcli")
        npm install -g dankcli
        ;;
    "ricksay")
        npm install -g ricksay
        ;;
      *)
        echo "No specific installation steps defined for $app"
        ;;
    esac
  done
}

# Fetch and parse categories and apps from the repository
fetch_data() {
  categories=(
    "Development" "Productivity" "Entertainment" "Music" "Social Media" "Video" "Movies" "Games"
    "Books" "Note Taking and Lists" "Finance" "Presentations" "Calendars" "Utilities"
    "Terminal Sharing Utilities" "Network Utilities" "Theming and Customization" "Shell Utilities"
    "System Interaction Utilities" "Markdown" "Security" "Math" "Weather" "Browser Replacement"
    "Internet Speedtest" "Command Line Learning" "Data Manipulation" "Processors" "JSON" "YAML"
    "Columns" "Text" "Files and Directories" "Deleting, Copying, and Renaming" "File Sync/Sharing"
    "Directory Listing" "Directory Navigation" "Search" "Version Control" "Git" "GitHub" "Emoji"
    "Images" "Gif Creation" "Image Conversion" "Screensavers" "Graphics" "Just for Fun"
  )

  apps_by_category["Entertainment"]="football-cli pockyt newsboat"
  apps_by_category["Music"]="cmus Instant-Music-Downloader itunes-remote pianobar mpd ncmpcpp moc beets spotify-tui swaglyrics-for-spotify dzr radio-active"
  apps_by_category["Social Media"]="facebook-cli Rainbowstream tuir WeeChat"
  apps_by_category["Video"]="youtube-dl streamlink yewtube mpv editly yt-dlp"
  apps_by_category["Movies"]="moviemon movie"
  apps_by_category["Games"]="Dwarf Fortress Cataclysm-DDA pokete"
  apps_by_category["Books"]="epr Bible.Js CLI SpeedRead medium-cli"
  apps_by_category["Development"]="legit mklicense rebound foy just bcal bitwise cgasm grex gdb-dashboard iola add-gitignore is-up-cli reachable loadtest diff2html-cli"
  apps_by_category["Text Editors"]="emacs vim neovim kakoune micro o helix"
  apps_by_category["Frontend Development"]="caniuse-cmd strip-css-comments-cli viewport-list-cli surge"
  apps_by_category["Mobile Development"]="mobicon-cli mobisplash-cli deviceframe"
  apps_by_category["Database"]="mycli pgcli sqlline iredis usql"
  apps_by_category["Devops"]="htconvert SAWS s3cmd pm2 ops flog k9s PingMe ipfs-deploy Discharge updatecli"
  apps_by_category["Docker"]="lstags dockly lazydocker docker-pushrm"
  apps_by_category["Release"]="release-it clog np release semantic-release"
  apps_by_category["Npm"]="npm-name-cli npm-user-cli npm-home pkg-dir-cli npm-check-updates updates wipe-modules"
  apps_by_category["Boilerplate"]="yo boilr cookiecutter mevn-cli scaffold-static"
  apps_by_category["HTTP Server"]="serve simplehttp shell2http"
  apps_by_category["HTTP Client"]="HTTPie HTTP Prompt ain curlie"
  apps_by_category["Productivity"]="doing ffscreencast meetup-cli NeoMutt terjira ipt uber-cli Buku papis pubs fjira"
  apps_by_category["Time Tracking"]="Timetrap moro Timewarrior Watson utt Bartib"
  apps_by_category["Note Taking and Lists"]="idea geeknote Taskwarrior Terminal velocity eureka sncli td-cli taskell taskbook dnote nb obs"
  apps_by_category["Finance"]="ledger hledger moeda cash-cli cointop ticker"
  apps_by_category["Presentations"]="WOPR decktape mdp sent slides"
  apps_by_category["Calendars"]="calcurse gcalcli khal vdirsyncer remind birthday"
  apps_by_category["Utilities"]="aria2 bitly-client deadlink crawley kill-tabs alex clevercli"
  apps_by_category["Terminal Sharing Utilities"]="gotty localtunnel mosh ngrok tmate warp OverTime"
  apps_by_category["Network Utilities"]="get-port-cli is-reachable-cli acmetool certificate-ripper neoss"
  apps_by_category["Theming and Customization"]="splash-cli wallpaper-cli themer JackPaper pywal QuickWall oh-my-posh"
  apps_by_category["Shell Utilities"]="has Ultimate Plumber fkill-cli task-spooler undollar pipe_exec"
  apps_by_category["System Interaction Utilities"]="neofetch battery-level-cli brightness-cli yank screensaver google-font-installer glances tiptop gzip-size-cli"
  apps_by_category["Markdown"]="DocToc grip mdv glow gtree"
  apps_by_category["Security"]="pass gopass xiringuito hasha-cli ots"
  apps_by_category["Math"]="mdlt Qalculate"
  apps_by_category["Weather"]="wttr.in wego weather-cli"
  apps_by_category["Browser Replacement"]="s hget mapscii nasa-cli getnews.tech trino translate-shell"
  apps_by_category["Internet Speedtest"]="speedtest-net speed-test speedtest-cli bandwhich"
  apps_by_category["Command Line Learning"]="cmdchallenge explainshell howdoi how2 The Fuck tldr Wat teachcode navi yai"
  apps_by_category["Data Manipulation"]="visidata"
  apps_by_category["Processors"]="jq yq dasel yaml-cli ramda-cli xq"
  apps_by_category["browser replacement"]="s hget mapscii nasa-cli getnews.tech trino translate-shell"
  apps_by_category["internet speedtest"]="speedtest-net speed-test speedtest-cli bandwhich"
  apps_by_category["command line learning"]="cmdchallenge explainshell howdoi how2 the-fuck tldr wat teachcode navi yai"
  apps_by_category["data manipulation"]="visidata"
  apps_by_category["json"]="jp fx vj underscore-cli strip-json-comments-cli groq gron"
  apps_by_category["yaml"]="dyff"
  apps_by_category["columns"]="parse-columns-cli q"
  apps_by_category["text"]="figlet stegcloak"
  apps_by_category["files and directories"]="chokidar-cli file-type-cli bat ncdu unix-permissions transmission-cli webtorrent-cli entr organize-cli organize-rt recoverpy"
  apps_by_category["file managers"]="ranger midnight-commander vifm nnn lf fff clifm far2l"
  apps_by_category["deleting copying and renaming"]="trash-cli empty-trash-cli del-cli cpy-cli rename-cli renameutils diskonaut"
  apps_by_category["files"]="chokidar-cli file-type-cli bat ncdu unix-permissions transmission-cli webtorrent-cli entr organize-cli organize-rt recoverpy"
  apps_by_category["file sync sharing"]="rclone ffsend share-cli google-drive-upload gdrive-downloader portal shbin sharing ncp"
  apps_by_category["directory listing"]="alder eza tre ll lsd"
  apps_by_category["directory navigation"]="autojump pm z pathpicker fz goto z.lua zoxide tere"
  apps_by_category["search"]="happyfinder find-up-cli ripgrep fzf fselect fd broot rare skim ast-grep"
  apps_by_category["version control"]="snowfs git"
  apps_by_category["git"]="git-commander git-stats dev-time tig grv git-standup git-secret gitlab-cli git-extras gita readme-md-generator semantic-git-commit-cli import-github-labels-cli git-all-branches czg shallow-backup lazygit"
  apps_by_category["github"]="cli-github hub git-labelmaker"
  apps_by_category["emoji"]="gitmoji-cli gitmoji-changelog emoj emoji-finder oji"
  apps_by_category["images"]="svgo carbon-now-cli imgur-uploader-cli pageres-cli"
  apps_by_category["gif creation"]="gifgen gifsicle ttygif ttystudio asciinema givegif"
  apps_by_category["image conversion"]="imagemagick imgp korkut"
  apps_by_category["screensavers"]="cmatrix pipes.sh yulelog cli-fireplace"
  apps_by_category["graphics"]="cli-mandelbrot sparkly-cli pastel lowcharts"
  apps_by_category["just for fun"]="quote-cli fortune ponysay yosay lolcat text-meme dankcli ricksay"
}

# Main script
install_dependencies
fetch_data

while true; do
  if [[ "$1" == "--gui" ]]; then
    if ! select_category_gui; then
      continue
    fi
    for category in "${!apps_by_category[@]}"; do
      if [[ "$category" == "$selected_category" ]]; then
        apps_string="${apps_by_category[$category]}"
        IFS=' ' read -r -a apps <<< "$apps_string"
        if ! select_apps_gui; then
          continue
        fi
        echo "Selected apps: ${selected_apps[@]}"
        install_apps "${selected_apps[@]}"
        break
      fi
    done
  else
    select_category_cli
    for category in "${!apps_by_category[@]}"; do
      if [[ "$category" == "$selected_category" ]]; then
        apps_string="${apps_by_category[$category]}"
        IFS=' ' read -r -a apps <<< "$apps_string"
        select_apps_cli
        install_apps "${selected_apps[@]}"
        break
      fi
    done
  fi
  break
done
