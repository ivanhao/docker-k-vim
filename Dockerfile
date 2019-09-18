FROM alpine:latest
RUN echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" > /etc/apk/repositories \
&& echo "http://mirrors.aliyun.com/alpine/latest-stable/community/" >> /etc/apk/repositories \
&& apk update \
&& apk add  build-base \
        ctags \
        git \
        libx11-dev \
        libxpm-dev \
        libxt-dev \
        make \
        ncurses-dev \
        python \
        python-dev \
        build-essential \
        cmake \
        clang \
#build vim
&& cd /tmp \
&& git clone https://github.com/vim/vim \
&& cd /tmp/vim \
&& ./configure \
--disable-gui \
--disable-netbeans \
--enable-multibyte \
--enable-pythoninterp \
--prefix /usr \
--with-features=big \
--with-python-config-dir=/usr/lib/python2.7/config \
&& make install \                                                                                                       
&& cp /usr/share/vim/vim80/vimrc_example.vim  ~/.vimrc \                                                                
&& git clone --depth 1  https://github.com/Valloric/YouCompleteMe /root/.vim/bundle/YouCompleteMe \                     
&& cd /root/.vim/bundle/YouCompleteMe \                                                                                 
&& git submodule update --init --recursive \                                                                            
&& ./install.py --clang-completer \                                                                                     
&& cp ~/.vim/bundle/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py ~/.vim/ \                                
&& cd ~/.vim/bundle/YouCompleteMe  && cp -r autoload plugin third_party python /root/.vim \                             
&& cp /usr/lib/libclang.so.4.0 ~/.vim/third_party/ycmd/ \                                                               
&& cd ~ \                                                                                                               
&& git clone https://github.com/wklken/k-vim.git \                                                                      
&& cd k-vim/ \                                                                                                          
&& sh -x install.sh   
