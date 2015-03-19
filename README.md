# ConvertYoutube

> **Current status**: viddl-rb Youtube plugin is currently semi-broken. Downloading and trascondig (some) videos works but not playlists.

ConvertYoutube is a minimalistic RoR application that given an url for a video ~~or playlist~~ from Youtube will convert all available videos to m4a (with cover art and title tag) ~~and archive them into a downloadable zip file~~.

### Dependencies:
* Redis
* resque
* viddl-rb
* id3_tags