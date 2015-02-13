#
#   Author: Tom Llewellyn-Smith <tom@onixconsulting.co.uk>
#   Copyright: © Onix Consulting Limited 2012-2015. All rights reserved.
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
module MCollective
    class Application
        class Patchouli<MCollective::Application
            option :list,
                :description    => "List Packages (upgradable, held back)",
                :arguments      => ["-l", "--list"],
                :type           => :bool,
                :required       => false

            option :upgrade,
                :description    => "Upgrade all packages",
                :arguments      => ["-u", "--upgrade"],
                :type           => :bool,
                :required       => false

            option :dist,
                :description    => "Dist upgrade all packages",
                :arguments      => ["--dist"],
                :type           => :bool,
                :required       => false

            option :full,
                :description    => "full package list",
                :arguments      => ["-f", "--full"],
                :type           => :bool,
                :required       => false

            def main
                patchouli = rpcclient("patchouli")
                if configuration[:list] then
                    if configuration[:full] then
                        resp = patchouli.list(:full => configuration[:full])
                    else
                        resp = patchouli.list()
                    end
                elsif configuration[:upgrade] then
                    resp = patchouli.upgrade()
                elsif configuration[:dist] then
                    resp = patchouli.dist()
                else
                    puts 'error: requires an action'
                end
                resp.each do |result|
                    print result[:sender] + ':'
                    puts result[:data][:output]
                end
                printrpcstats :summarize => true, :caption => "%s results" % configuration[:command]
            end
        end
    end
end
