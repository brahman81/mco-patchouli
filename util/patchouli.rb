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
    module Util
        class Patchouli
            # add useful definitions here
            def self.packagemanager
                if File.exists?('/usr/bin/apt-get')
                    return :apt
                end
            end

            def self.updates
                manager = packagemanager
                if manager == :apt
                    return apt_parse_updates
                end
            end

            def self.upgrade
                manager = packagemanager
                if manager == :apt
                    return apt_upgrade
                end
            end

            def self.dist_upgrade
                manager = packagemanager
                if manager == :apt
                    return apt_dist_upgrade
                end
            end

            def self.apt_parse_updates
                require 'open3'
                output = "\n" # prefix with a newline
                Open3.popen3('apt-get update && apt-get upgrade --just-print') do |stdin, stdout, stderr, wait_thr|
                    stdout.each do |line|
                        if (match = line.match(/Inst\s+(\w+)\s+\[(?:\d+:)?([\w,\.,-]+)\]\s+\(((?:\d+:)?([\w,\.,-]+))/)) then
                            output << "#{match[1]} - installed: #{match[2]} available: #{match[3]}\n"
                        end
                    end
                end
                return output
            end

            def self.apt_upgrade
                require 'open3'
                output = "\n" # prefix with a newline
                # assume yes, upgrade config only if it has not been modified locally.
                Open3.popen3('export DEBIAN_FRONTEND=noninteractive; apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"') do |stdin, stdout, stderr, wait_thr|
                    if stderr.to_s.empty? then
                        output << "packages updated successfully"
                    else
                        output << "some errors were encountered please perform a manual check on this node"
                    end
                end
                return output
            end

            def self.apt_dist_upgrade
                require 'open3'
                output = "\n" # prefix with a newline
                # assume yes, upgrade config only if it has not been modified locally.
                Open3.popen3('export DEBIAN_FRONTEND=noninteractive; apt-get dist-upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"') do |stdin, stdout, stderr, wait_thr|
                    if stderr.to_s.empty? then
                        output << "packages updated successfully"
                    else
                        output << "some errors were encountered please perform a manual check on this node"
                    end
                end
                return output
            end
        end
    end
end
