require 'sinatra'
require 'rest_client'
require 'json'

get '/' do
  pug_content = JSON.parse(RestClient.get('http://pugme.herokuapp.com/bomb?count=100'))['pugs']
    .select do |pug|
      pug =~ %r{^http://\d+.media.tumblr.com/[^>]*\..{3}$}
    end.first(80).reduce '' do |memo, pug|
      memo + %Q{<div style="background-image: url(#{pug})"></div>}
    end

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
 </head>
 <body>
   #{pug_content}
 </body>
 </html>
EOF
end
