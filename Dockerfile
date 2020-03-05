FROM alpine:3.10.4
ENV user user1
ENV userpass password
ENV rootpass password

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
        git bash openssh-server openssh-client \
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
&& sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config \
 && ssh-keygen -t rsa -P "" -f /etc/ssh/ssh_host_rsa_key \
 && ssh-keygen -t ecdsa -P "" -f /etc/ssh/ssh_host_ecdsa_key \
 && ssh-keygen -t ed25519 -P "" -f /etc/ssh/ssh_host_ed25519_key \
 && echo "root:${rootpass}" | chpasswd \
 && useradd ${username} -G ssh -p ${userpass} && mkdir -p /home/${username}/.ssh \
&& cd ~ \                                                                                                               
&& git clone https://github.com/wklken/k-vim.git \                                                                      
&& cd k-vim/ \                                                                                                          
&& sh -x install.sh   
RUN /usr/sbin/sshd -D
EXPOSE 22
