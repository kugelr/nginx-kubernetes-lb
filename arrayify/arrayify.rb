
#	Copyright 2016, Google, Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'webrick'
require 'redis'
require 'socket'

server = WEBrick::HTTPServer.new(:Port => 80)
$redis = Redis.new(:host => "<IP-ADRESSE>", :port => 6379)

class MyServlet < WEBrick::HTTPServlet::AbstractServlet
    def do_GET (request, response)
    	if request.query["str"]
    		strArray = []
			request.query["str"].each_char do |char|
				strArray.push(char)
			end
			time = Time.new
			key = "arrayify--" + time.min.to_s + "--" + time.sec.to_s + "--" + time.usec.to_s
			$redis.set(key, strArray.to_s)
			response.body = strArray.to_s
		else
			response.body = ""
    	end
    end	
end

server.mount "/", MyServlet

trap "INT" do server.shutdown end

server.start