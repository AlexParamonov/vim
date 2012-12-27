#
# Cookbook Name:: vim
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
temp = "/tmp"
source_location = "#{temp}/vim73"
source_archive = "vim-7.3.tar.bz2"

execute "install-dependency" do
  command "apt-get install -y python-dev libncurses5-dev ruby ruby-dev libperl-dev ctags"
  user "root"
end

execute "download-sources" do
  cwd temp
  command "wget ftp://ftp.vim.org/pub/vim/unix/#{source_archive}; \
  tar -xf #{source_archive}"
end

execute "install-build-dep" do
  command "apt-get install -y make"
  user "root"
end

execute "compile-from-sources" do
  cwd source_location
  command "./configure --without-x --enable-perlinterp --enable-pythoninterp --enable-rubyinterp --enable-cscope  --with-features=huge --prefix=/home/vagrant; \
  make; \
  make install"
end

execute "cleanup-build-dep" do
  command "apt-get remove -y make"
  user "root"
end

execute "cleanup-temp-files" do
  cwd temp
  command "rm -r #{source_location}; \
  rm #{source_archive}"
  user "root"
end

# TODO move to separate book
execute "install-custom-settings" do
  home_dir = "/home/vagrant"
  cwd "/home/vagrant"
  user "vagrant"

  command "git clone git://github.com/AlexParamonov/config.git #{home_dir}/config; \
  cd #{home_dir}/config; \
  ln -s #{home_dir}/config/.vimrc #{home_dir}/; \
  ln -s #{home_dir}/config/.vim #{home_dir}/; \
  git clone git://github.com/gmarik/vundle.git #{home_dir}/.vim/bundle/vundle; \
  vim -c BundleInstall! -c q -c q -u #{home_dir}/.vim/.vim-bundles.vim"
end
