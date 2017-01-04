// This is an example proxy configuration file
// If you're using a proxy like privoxy and multiple browsers it's a nice solution
// for easy setup.

// Save this file as /var/www/htdocs/proxy.pac
// And let all browsers point to that file via a url.
// I suppose you can also save it to a localfile

// For finer details read here:
// http://wp.netscape.com/eng/mozilla/2.0/relnotes/demo/proxy-live.html

function FindProxyForURL(url, host) {
    if (dnsDomainIs(host, "cr.yp.to") ||
	dnsDomainIs(host, "news.bbc.co.uk") ||
	dnsDomainIs(host, "www.boetes.org") ||
        isInNet(host, "172.16.11.0", "255.255.255.0") ||
        isInNet(host, "192.168.0.0","255.255.0.0") ||
        shExpMatch(url, "https:*") )
        return "DIRECT";
    else
        return "PROXY 172.16.11.1:8118; DIRECT";
}
