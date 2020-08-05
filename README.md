 ~~~
 This is a coding example working on IRIS 2020.2 and on Caché 2018.1.3 
 It will not be kept in sync with new versions      
 It is also NOT serviced by InterSystems Support !   
~~~ 

The Caché / Ensemble standard distribution contains in namespace SAMPLES    
a nice example of a CSP page consuming WebService as Client.  
I have modified it not only to display the replies but to feed it back into a Global.   
I used the classic Hyperevent to achieve this. 
The replies end up as a log in global^WSREPLY.  
When there is no input anymore the page closes and goes away.  

There are 2 versions with visible and hidden display during operation.   
_WSCSP.reverseVerbose.cls_ and _WSCSP.reverseHidden.cls_  

The message to send is simply passed as hash after the CSP_URL. (Mind URL encoding!)  

You can launch the page using a command pipe or $zf(-1,...) or similar for newer versions  
directly out of your application or from command line.
```
 /// find your browser location
 set browser="""C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"" "
 /// don't forget the # at the end
 set page="http://localhost:57772/csp/samples/WSCSP.reverseVerbose.cls#"
 /// whatever you send to the server
 set msg="hello ALL"
 /// a CPIPE device
 set dev="|CPIPE|22"

 // either
 do $zf(-1,browser_page_msg)

 // or
 open dev:browser_page_msg:0 write $t close dev
 ```
 and what you get on server looks like this:
 ```

^WSREPLY(34)=$lb("2019-02-08 18:03:11","Welcome to Cache WebSocket. NameSpace: SAMPLES")
^WSREPLY(35)=$lb("2019-02-08 18:03:11","'hello ALL' (length=9) recieved on 08 Feb 2019 at 06:03:11PM NameSpace=SAMPLES")
^WSREPLY(36)=$lb("2019-02-08 18:03:21","Timeout after 10 seconds occurred on 08 Feb 2019 at 06:03:21PM")
^WSREPLY(37)=$lb("2019-02-08 18:03:31","Timeout after 10 seconds occurred on 08 Feb 2019 at 06:03:31PM")
^WSREPLY(38)=$lb("2019-02-08 18:03:41","Timeout after 10 seconds occurred on 08 Feb 2019 at 06:03:41PM")
^WSREPLY(39)=$lb("2019-02-08 18:03:41","exit")
 
 ```
This is just a starting point to be adapted to you individual needs.

[Article in DC](https://community.intersystems.com/post/client-websockets-based-csp)
