dnf install \
	alsa-lib-devel \
	asio-devel \
	cmake \
	ffmpeg-free-devel \
	fontconfig-devel \
	freetype-devel \
	gcc \
	gcc-c++ \
	gcc-objc \
	git \
	glib2-devel \
	jansson-devel \
	json-devel \
	libavcodec-free-devel \
	libavdevice-free-devel \
	librist-devel \
	libcurl-devel \
	libdatachannel-devel \
	libdrm-devel \
	libglvnd-devel \
	libqrcodegencpp-devel \
	libuuid-devel \
	libva-devel \
	libv4l-devel \
	libX11-devel \
	libXcomposite-devel \
	libXdamage \
	libXinerama-devel \
	libxkbcommon-devel \
	luajit-devel \
	make \
	mbedtls-devel \
	oneVPL-devel \
	pciutils-devel \
	pipewire-devel \
	pulseaudio-libs-devel \
	python3-devel \
	qt6-qtbase-devel \
	qt6-qtbase-private-devel \
	qt6-qtsvg-devel \
	qt6-qtwayland-devel \
	speexdsp-devel \
	srt-devel \
	swig \
	systemd-devel \
	vlc-devel \
	wayland-devel \
	websocketpp-devel \
	x264-devel


wget https://cdn-fastly.obsproject.com/downloads/cef_binary_5060_linux_x86_64_v3.tar.xz
tar -xf ./cef_binary_5060_linux_x86_64_v3.tar.xz

git clone --recursive https://github.com/obsproject/obs-studio.git
cd obs-studio

mkdir build && cd build
cmake -DENABLE_BROWSER=ON -DCEF_ROOT_DIR="../../cef_binary_5060_linux_x86_64" -DENABLE_AJA=OFF -DENABLE_NEW_MPEGTS_OUTPUT=OFF -DENABLE_WEBRTC=OFF -DCMAKE_POSITION_INDEPENDENT_CODE=ON ..
make -j$(nproc)

sudo make install
echo "/usr/local/lib" | sudo tee /etc/ld.so.conf.d/local.conf -a
sudo ldconfig