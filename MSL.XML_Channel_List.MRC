on *:connect: timer_xml  0 600 glist 
alias glist  Lusers | List -min 75 
raw 254:*: hadd -m XML_list kanallar $2
raw 266:*global*users*: hadd -m XML_list kullanicilar $iif($regex($2-,/(\s\d+)/ig),$regml(1),-)
raw 322:*: hadd -m XML_list $2 $2-
raw 323:*/list*: {
  var %xml_file write XML_list-temp.xml
  var %json_file write JSON_list-temp.json
  %xml_file <?xml version="1.0" encoding="UTF-8"?> <ccrc_kanal_list>
  var %i 1
  %json_file {
  %json_file "kanallar": [
  while  %i <= $hget(XML_list,0).item {
    if $regex($hget(XML_list,%i).item,/^#/ig) {
      %xml_file <kanal><knal> $hget(XML_list,%i).item </knal> <kullanici> $gettok($hget(XML_list,%i).data,2,32) </kullanici> $&
        <mod> $gettok($hget(XML_list,%i).data,3,32) </mod><baslik> $encode($gettok($hget(XML_list,%i).data,4-,32),m) </baslik> </kanal>
      var %kanal "{"
      %kanal = %kanal $qt(knal) : $qt($hget(XML_list,%i).item) ,
      %kanal = %kanal $qt(kullanici) : $qt($gettok($hget(XML_list,%i).data,2,32)) ,
      %kanal = %kanal $qt(mod) : $qt($gettok($hget(XML_list,%i).data,3,32)) ,
      %kanal = %kanal $qt(baslik) : $qt($encode($gettok($hget(XML_list,%i).data,4-,32),m))
      %kanal = %kanal "}"
   if (%i < $hget(XML_list,0).item) %kanal = %kanal ,
      %json_file %kanal
    }
    inc %i
  }
  %json_file ],
  %json_file "kullanicilar": $qt($hget(xml_list,kullanicilar)),
  %json_file "kanallar": $qt($hget(xml_list,kanallar)),
  %json_file "guncelleme": $qt($date - $time)
  %json_file }
  %xml_file <kullanicilar> $hget(xml_list,kullanicilar) </kullanicilar>
  %xml_file <kanallar> $hget(xml_list,kanallar) </kanallar>
  %xml_file <guncelleme> $date - $time </guncelleme> </ccrc_kanal_list>
  .copy -o XML_list-temp.xml XML_list.xml | write -c XML_list-temp.xml
  .copy -o JSON_list-temp.json JSON_list.json | write -c JSON_list-temp.json
  hfree xml_list 
}
