on *:connect: timer_xml  0 600 glist 
alias glist  Lusers | List -min 75 
raw 254:*: hadd -m XML_list kanallar $2
raw 266:*global*users*: hadd -m XML_list kullanicilar $iif($regex($2-,/(\s\d+)/ig),$regml(1),-)
raw 322:*: hadd -m XML_list $2 $2-
raw 323:*/list*: {
  var %w write XML_list-temp.xml
  %w <?xml version="1.0" encoding="UTF-8"?> <ccrc_kanal_list>
  var %i 1 
  while  %i <= $hget(XML_list,0).item {
    if $regex($hget(XML_list,%i).item,/^#/ig) {
      ;echo : $hget(XML_list,%i).data
      %w <kanal><knal> $hget(XML_list,%i).item </knal> <kullanici> $gettok($hget(XML_list,%i).data,2,32) </kullanici> $&
        <mod> $gettok($hget(XML_list,%i).data,3,32) </mod><baslik> $encode($gettok($hget(XML_list,%i).data,4-,32),m) </baslik> </kanal>
    }
    inc %i
  }
  %w <kullanicilar> $hget(xml_list,kullanicilar) </kullanicilar>
  %w <kanallar> $hget(xml_list,kanallar) </kanallar>
  %w <guncelleme> $date - $time </guncelleme> </ccrc_kanal_list>
  .copy -o XML_list-temp.xml XML_list.xml | write -c XML_list-temp.xml |  hfree xml_list 
}
