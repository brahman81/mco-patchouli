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
metadata    :name        => "Patchouli Mcollective Agent",
            :description => "Patch servers via Mcollective",
            :author      => "Tom Llewellyn-Smith",
            :license     => "GPLv3",
            :version     => "0.1",
            :url         => "https://github.com/brahman81/mco-patchouli",
            :timeout     => 600

action 'list', :description => "patchouli list available updates" do
    display :always  # supported in 0.4.7 and newer only

    input   :full,
            :description    => 'Show full package list',
            :prompt         => 'Full Package List',
            :type           => :boolean,
            :default        => false,
            :optional       => true
 
    output  :reply,
            :description => "available package updates",
            :display_as  => "updates",
            :default     => "n/a"
end

action 'upgrade', :description => "patchouli install available updates" do
    display :always  # supported in 0.4.7 and newer only

    output  :reply,
            :description => "confirmation message",
            :display_as  => "message",
            :default     => "n/a"
end

action 'dist', :description => "patchouli install held back updates" do
    display :always  # supported in 0.4.7 and newer only

    output  :reply,
            :description => "confirmation message",
            :display_as  => "message",
            :default     => "n/a"
end
