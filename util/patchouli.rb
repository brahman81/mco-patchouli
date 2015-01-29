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

            def self.get_updates()
                require 'open3'
                output = {:packages => []}
                Open3.popen3('apt-get update && apt-get upgrade --just-print') do |stdin, stdout, stderr, wait_thr|
                    stdout.each do |line|
                        if (match = line.match(/Inst\s+([\w,-]+)\s+\[(?:\d+:)?([\w,\.,-]+)\]\s+\(((?:\d+:)?([\w,\.,-]+))/)) then
                            output[:packages].push("#{match[1]} - installed: #{match[2]} available: #{match[3]}")
                        elsif (match = line.match(/(\d+)\s+upgraded,\s+(\d+)\s+newly\s+installed,\s+(\d+)\s+to\s+remove\s+and\s+(\d+)\s+not\s+upgraded\./)) then
                            if match.length() > 4 then
                            output[:upgradable]     = match[1]
                            output[:new_installs]   = match[2]
                            output[:removed]        = match[3]
                            output[:held_back]      = match[4]
                            else
                                return false
                            end
                        end
                    end
                end
                return output
            end

            def self.updates_available?(type = :upgradable)
                updates = self.get_updates()
                if updates[type.to_sym].to_i > 0 then
                    return true
                else
                    return false
                end
            end

            def self.apt_parse_updates(verbose = false)
                require 'open3'
                output = "\n" # prefix with a newline
                if updates = self.get_updates() then
                    if verbose then
                        output << updates[:packages].join("\n")
                    end
                    output << "\n#{updates[:upgradable]} packages available"
                    output << "\n#{updates[:held_back]} packages held back"
                end
                return output
            end

            def self.apt_upgrade
                require 'open3'
                output = "\n" # prefix with a newline
                # assume yes, upgrade config only if it has not been modified locally.
                Open3.popen3('export DEBIAN_FRONTEND=noninteractive; apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"') do |stdin, stdout, stderr, wait_thr|
                    stdout.read()
                    unless self.updates_available? then
                        output << "upgrade successful"
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
                    stdout.read()
                    unless self.updates_available?('held_back') then
                        output << "dist-upgrade successful"
                    else
                        output << "some errors were encountered please perform a manual check on this node"
                    end
                end
                return output
            end
        end
    end
end
