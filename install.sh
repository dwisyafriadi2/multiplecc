#!/bin/bash

# Download dan tampilkan logo
print_banner() {
  clear
  echo -e """
    ____                       
   / __ \____ __________ ______
  / / / / __ \`/ ___/ __ \`/ ___/
 / /_/ / /_/ (__  ) /_/ / /    
/_____/_\\__,_/____/\\__,_/_/      

    ____                       __
   / __ \\___  ____ ___  __  __/ /_  ______  ____ _
  / /_/ / _ \\/ __ \`__ \\/ / / / / / / / __ \\/ __ \`/
 / ____/  __/ / / / / / /_/ / / /_/ / / / / /_/ / 
/_/    \\___/_/ /_/ /_/\\__,_/_/\\__,_/_/ /_/\\__, /  
                                         /____/    

====================================================
     Automation         : Auto Install Node 
     Telegram Channel   : @dasarpemulung
     Telegram Group     : @parapemulung
====================================================
"""
}

# Call the print_banner function
print_banner
sleep 5

# Warna untuk output
RED='\033[0;31m'
LIGHT_GREEN='\033[1;32m'
YELLOW='\033[0;33m'
LIGHT_BLUE='\033[1;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No color

# 🖥️ Cek arsitektur Linux
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    CLIENT_URL="https://cdn.app.multiple.cc/client/linux/x64/multipleforlinux.tar"
elif [[ "$ARCH" == "aarch64" ]]; then
    CLIENT_URL="https://cdn.app.multiple.cc/client/linux/arm64/multipleforlinux.tar"
else
    echo -e "${RED}❌ Arsitektur tidak didukung: $ARCH${NC}"
    exit 1
fi

echo ""
echo -e "${CYAN}🔽 Mengunduh client dari $CLIENT_URL...${NC}"
wget $CLIENT_URL -O multipleforlinux.tar
echo ""

echo -e "${MAGENTA}📦 Mengekstrak paket instalasi...${NC}"
tar -xvf multipleforlinux.tar
echo ""

# Masuk ke direktori hasil ekstraksi
cd multipleforlinux
echo ""

echo -e "${YELLOW}🔧 Mengatur izin yang diperlukan...${NC}"
chmod +x multiple-cli
chmod +x multiple-node
echo ""

# Menambahkan PATH ke .bashrc
echo -e "${LIGHT_BLUE}⚙️ Mengonfigurasi PATH...${NC}"
echo "PATH=\$PATH:$(pwd)" >> ~/.bashrc
source ~/.bashrc
echo ""

# Membuat folder logs jika belum ada
if [ ! -d "logs" ]; then
    echo -e "${CYAN}📂 Membuat folder logs...${NC}"
    mkdir -p logs
fi

# Menyiapkan IDENTIFIER dan PIN
echo -e "${CYAN}📝 Masukkan informasi yang diperlukan:${NC}"
read -p "Masukkan IDENTIFIER Anda: " IDENTIFIER
read -p "Masukkan PIN Anda (tidak disembunyikan): " PIN
echo ""

# Validasi IDENTIFIER dan PIN
if [ -z "$IDENTIFIER" ] || [ -z "$PIN" ]; then
    echo -e "${RED}❌ ERROR: IDENTIFIER dan PIN tidak boleh kosong.${NC}"
    exit 1
fi

# Opsi dinamis untuk bandwidth dan storage
echo -e "${CYAN}⚙️ Masukkan opsi dinamis untuk bandwidth dan storage:${NC}"
read -p "Masukkan kapasitas storage (dalam GB): " STORAGE_CAPACITY
echo ""

# Validasi input untuk bandwidth dan storage
if [[ -z "$DOWNLOAD_BANDWIDTH" || -z "$UPLOAD_BANDWIDTH" || -z "$STORAGE_CAPACITY" ]]; then
    echo -e "${RED}❌ ERROR: Semua opsi bandwidth dan storage harus diisi.${NC}"
    exit 1
fi

# Menjalankan multiple-node
echo -e "${LIGHT_GREEN}🚀 Menjalankan multiple-node...${NC}"
nohup ./multiple-node > logs/output.log 2>&1 &

# Cek apakah multiple-node berjalan
sleep 3
NODE_PID=$(pgrep -f multiple-node)
if [[ -n "$NODE_PID" ]]; then
    echo -e "${LIGHT_GREEN}✅ multiple-node berjalan dengan PID: $NODE_PID.${NC}"
else
    echo -e "${RED}❌ multiple-node tidak berjalan. Periksa logs untuk detail.${NC}"
    exit 1
fi

# Mengikat akun dengan IDENTIFIER dan PIN
echo -e "${YELLOW}🔗 Mengikat akun dengan IDENTIFIER dan PIN...${NC}"
./multiple-cli bind --bandwidth-download 100 --identifier "$IDENTIFIER" --pin "$PIN" --storage 100 --bandwidth-upload 100
echo ""
# join Telegram
echo -e "${LIGHT_GREEN}✅ Proses selesai.${NC}"
echo -e "${CYAN}📱 Gabung ke channel Telegram untuk pembaruan: https://t.me/dasarpemulung${NC}"