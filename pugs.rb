require 'sinatra'
require 'rest_client'
require 'json'

get '/' do
  pug_urls = JSON.parse(RestClient.get('http://pugme.herokuapp.com/bomb?count=100'))['pugs']
    .select do |pug|
      pug =~ %r{^http://\d+.media.tumblr.com/[^>]*\..{3}$}
    end.first(80)

    pug_content = pug_urls.reduce([]) do |memo, pug|
      memo << %Q{<div style="background-image: url(#{pug})"></div>}
    end.join('')

  <<EOF
 <html>
 <head>
   <title>PUGBOMB</title>
   <style type="text/css">
      div {
        width: 25%;
        padding-top: 25%;
        display: inline-block;
      }
   </style>
   <meta property="og:url" content="http://pugbomb.chinigo.net/" />
   <meta property="og:title" content="Pugbomb!" />
   <meta property="og:description" content="Pugs! Pugs! Pugs!" />
   <meta property="og:image" content="#{pug_urls.first}" />
   <meta property="og:image:width" content="500" />
   <meta property="og:image:height" content="500" />
 </head>
 <body>
   #{pug_content}
    <script>
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

      ga('create', 'UA-41380034-1', 'auto');
      ga('send', 'pageview');

    </script>
 </body>
 </html>
EOF
end
