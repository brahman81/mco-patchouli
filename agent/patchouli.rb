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

# load our Util class
MCollective::Util.loadclass("MCollective::Util::Patchouli")

module MCollective
    module Agent
        class Patchouli<RPC::Agent
            metadata    :name        => "Patchouli Mcollective Agent",
            :description => "Patch servers via Mcollective",
            :author      => "Tom Llewellyn-Smith",
            :license     => "GPLv3",
            :version     => "0.1",
            :url         => "https://github.com/brahman81/mco-patchouli",
            :timeout     => 600

            action 'list' do
                begin
                    reply[:output] = Util::Patchouli.updates(request[:full])
                rescue => error
                    reply.fail! "error: #{error}"
                end
            end

            action 'upgrade' do
                begin
                    reply[:output] = Util::Patchouli.upgrade
                rescue => error
                    reply.fail! "error: #{error}"
                end
            end

            action 'dist' do
                begin
                    reply[:output] = Util::Patchouli.dist
                rescue => error
                    reply.fail! "error: #{error}"
                end
            end
        end
    end
end
