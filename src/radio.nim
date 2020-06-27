# simple commandline web radio player
# Copyright (c) 2016,2017,2018,2019,2020, nikita <nikita@n0.is>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

# This is a translation of a script previously in Bash. It serves as a
# learning project for Nim.

import threadpool # for spawn
import osproc, strutils

# todo: read from configuration file
# # maybe use a seq.
var stations = ["http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio1_mf_p",
                "http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio2_mf_p",
                "http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio3_mf_p",
                "http://bbcmedia.ic.llnwd.net/stream/bbcmedia_radio4fm_mf_p",
                "http://www.radiofeeds.co.uk/bbcradio4extra.pls",
                "http://www.radiofeeds.co.uk/bbc5live.pls",
                "rtmp://wsliveflash.bbc.co.uk:1935/live/eneuk_live@6512",
                "http://192.168.1.33:9001",
                "http://www.radiofeeds.co.uk/talksport.m3u",
                "http://67.212.233.124:8014",
                "http://67.212.233.124:8002",
                "http://icy-e-bl-04-cr.sharp-stream.com:8000/clyde1.mp3.m3u",
                "http://icy-e-bl-04-cr.sharp-stream.com:8000/clyde2.mp3.m3u",
                "http://media-ice.musicradio.com/CapitalEdinburghMP3.m3u",
                "http://99.198.112.59:8000",
                "http://media-ice.musicradio.com/LBCLondonMP3Low.m3u",
                "http://uk1.internet-radio.com:4086",
                "http://zenradio.fr:8800",
                "http://stream-sd.radioparadise.com:9000/rp_128.mp3",
                "http://smoothjazz.com/streams/smoothjazz_128.pls",
                "http://listen.sky.fm/public1/pianojazz.pls",
                "http://listen.sky.fm/public1/smoothjazz.pls",
                "http://bluefm.net/listen.pls",
                "mmsh://wms-rly.181.fm/181-breeze?MSWMExt=.asf",
                "http://yp.shoutcast.com/sbin/tunein-station.pls?id=506392",
                "http://online.radiodifusion.net:8020/listen.pls",
                "http://listen.sky.fm/public3/salsa.pls",
                "http://cc.net2streams.com/tunein.php/reggaeton/playlist.pls",
                "http://grupomedrano.com.do/suave107/suave107.m3u",
                "http://sc-rly.181.fm:80/stream/1094",
                "http://www.977music.com/tunein/web/classicrock.asx",
                "http://listen.sky.fm/public3/the80s.pls",
                "http://provisioning.streamtheworld.com/pls/KDFCFM.pls",
                "http://media-ice.musicradio.com/ClassicFMMP3.m3u",
                "http://www.ibiblio.org/wcpe/wcpe.pls",
                "http://cinemix.us/cine.asx",
                "http://listen.sky.fm/public1/soundtracks.pls",
                "http://listen.sky.fm/public1/classical.pls",
                "http://www.radioparadise.com/musiclinks/rp_128aac.m3u",
                "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1280356",
                "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1377285",
                "http://listen.sky.fm/public1/tophits.pls",
                "http://lin2.ash.fast-serv.com:9022/listen.pls",
                "http://live.wnar-am.com:8500/listen.pls",
                "http://listen.sky.fm/public1/oldies.pls",
                "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1275050",
                "http://yp.shoutcast.com/sbin/tunein-station.pls?id=1288934",
                "http://somafm.com/metal.pls",
                "http://somafm.com/brfm.pls",
                "http://somafm.com/groovesalad.pls",
                "http://somafm.com/fluid.pls",
                "http://somafm.com/seventies.pls",
                "http://somafm.com/defcon.pls",
                "http://somafm.com/spacestation.pls",
                "http://somafm.com/dronezone.pls",
                "http://somafm.com/lush.pls",
                "http://somafm.com/digitalis.pls",
                "http://somafm.com/indiepop.pls",
                "http://somafm.com/bagel.pls",
                "http://somafm.com/thistle.pls",
                "http://somafm.com/folkfwd.pls",
                "http://somafm.com/bootliquor.pls",
                "http://somafm.com/7soul.pls",
                "http://somafm.com/earwaves.pls",
                "http://somafm.com/missioncontrol.pls",
                "http://somafm.com/illstreet.pls",
                "http://somafm.com/beatblender.pls",
                "http://somafm.com/sf1033.pls",
                "http://somafm.com/doomed.pls",
                "http://somafm.com/covers.pls",
                "http://somafm.com/u80s.pls",
                "http://somafm.com/thetrip.pls",
                "http://somafm.com/cliqhop.pls",
                "http://somafm.com/dubstep.pls",
                "http://somafm.com/poptron.pls",
                "http://somafm.com/secretagent.pls",
                "http://somafm.com/sonicuniverse.pls",
                "http://somafm.com/suburbsofgoa.pls",
                "http://somafm.com/deepspaceone.pls",
                "http://listen.sky.fm/public1/country.pls",
                "mmsh://wms-rly.181.fm/181-us181?MSWMExt=.asf",
                "mmsh://wms-rly.181.fm/181-realcountry?MSWMExt=.asf",
                "mmsh://wms-rly.181.fm/181-highway?MSWMExt=.asf",
                "http://www.country108.com/listen.pls",
                "http://jbstream.net/tunein.php/blackoutworm/playlist.asx",
                "http://jblive.fm/",
                "http://sh4.audio-stream.com/tunein.php/pleonard/playlist.pls",
                "http://wbez.ic.llnwd.net/stream/wbez_91_5_fm.pls",
                "http://rbb-mp3-fritz-m.akacast.akamaistream.net/7/799/292093/v1/gnl.akacast.akamaistream.net/rbb_mp3_fritz_m",
                "http://s2.onlinestream.de:6640",
                "http://anonradio.net:8000/anonradio",
                "http://www.wdr.de/wdrlive/media/mp3/wdr5.m3u",
                "https://wdr-cosmo-live.icecastssl.wdr.de/wdr/cosmo/live/mp3/128/stream.mp3",
                "http://jungletrain.net/24kbps.pls",
                "http://jungletrain.net/64kbps.pls",
                "http://jungletrain.net/128kbps.pls",
                "http://stream.chipbit.net:8000/autodj.m3u",
                "https://rainwave.cc/tune_in/4.ogg.m3u",
                "http://www.kohina.com/kohinasolanum.m3u",
                "http://www.slayradio.org/tune_in.php/128kbps/slayradio.128.m3u",
                "http://www.slayradio.org/tune_in.php/24kbps/slayradio.24.m3u",
                "http://nectarine.from-de.com/necta192.m3u",
                "http://www.8bitx.com/listen.m3u",
                "http://95.175.98.253:8000/listen.pls",
                "https://radiovest.cast.addradio.de/radiovest/simulcast/high/stream.mp3"]

# curses or any other tui would be good to have...
proc listStations(): string =
  for i in stations.low .. stations.high:
    result.add($i & "\t\t" & stations[i] & "\n")

while true:
  # output radio station list to screen
  echo(listStations())
  
  # play selection
  var c = stdin.readLine()
  var playBack = stations[parseInt(c)]
  # TODO: actually replace this with reading keypress.
  let readKey = spawn stdin.readLine()

  var outp = execCmd("mpv --vd=null --vo=null " & playBack)
 
  if ^readKey == "q":
    quit()

  echo outp
