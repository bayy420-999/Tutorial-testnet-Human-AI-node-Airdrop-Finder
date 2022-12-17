# Tutorial testnet Human-AI node Airdrop Finder

<p style="font-size:14px" align="right">
<a href="https://t.me/airdropfind" target="_blank">Join Telegram Airdrop Finder<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
</p>

<p align="center">
  <img height="auto" width="auto" src="https://raw.githubusercontent.com/bayy420-999/airdropfind/main/NavIcon.png">
</p>

## Referensi

* [Dokumen resmi](https://docs.humans.zone/run-nodes/testnet/joining-testnet.html)
* [Server discord](https://discord.gg/humansdotai)

## Spesifikasi Software & Hardware

### Persyaratan Hardware

| Komponen | Spesifikasi minimal |
|----------|---------------------|
|CPU|4 Cores|
|RAM|8 GB DDR4 RAM|
|Penyimpanan|1 TB HDD|
|Koneksi|10Mbit/s port|

| Komponen | Spesifikasi rekomendasi |
|----------|---------------------|
|CPU|32 Cores|
|RAM|32 GB DDR4 RAM|
|Penyimpanan|2 x 1 TB NVMe SSD|
|Koneksi|1 Gbit/s port|

### Persyaratan Software/OS

| Komponen | Spesifikasi minimal |
|----------|---------------------|
|Sistem Operasi|Ubuntu 16.04|

| Komponen | Spesifikasi rekomendasi |
|----------|---------------------|
|Sistem Operasi|Ubuntu 20.04|

## Setup Node

### Setup otomatis

* Install `screen`, `wget`, dan `curl`
  ```console
  apt-get install screen wget curl
  ```
* Buka terminal baru menggunakan `screen`
  ```console
  screen -Rd human-ai
  ```
  > Setelah terminal baru terbuka lanjutkan langkah berikutnya
* Download script `run.sh`
  ```console
  rm run.sh
  wget -q https://raw.githubusercontent.com/bayy420-999/Tutorial-testnet-Human-AI-node-Airdrop-Finder/main/run.sh
  ```
* Ubah `run.sh` menjadi executable
  ```console
  chmod +x run.sh
  ```
* Jalankan script
  ```console
  ./run.sh
  ```
* Jalankan Node
  ```console
  humansd start
  ```
  > Tutup terminal menggunakan kombinasi <kbd>CTRL</kbd>+<kbd>a</kbd>+<kbd>d</kbd>

* Cek status node
  ```console
  humansd status 2>&1 | jq .SyncInfo
  ```
  > Jika `catching_up` == `false` anda bisa melanjutkan langkah selanjutnya untuk [Mendaftar validator](#Daftar-menjadi-validator)

## Daftar menjadi validator

### Buat & danai dompet
* Buat dompet
  ```console
  humansd keys add <NAMA_DOMPET>
  ```
  > Lalu simpan mnemonic
* Menampilkan alamat dompet
  ```console
  humansd keys show <NAMA_DOMPET> -a
  ```
  > Lalu salin address yang muncul di terminal
* Klaim faucet
  * Join server [discord Human-AI](https://discord.gg/humansdotai)
  * Pergi ke channel `#roles` lalu react dengan emoji ⚔️
  * Lalu pergi ke channel `#testnet-faucet`
  * Kirim pesan seperti berikut
    ```
    $request <HUMAN_ADDRESS>
    ```
    > Ganti <HUMAN_ADDRESS> dengan addressmu
* Cek apakah faucet sudah masuk
  ```console
  humansd query bank balances <HUMAN_ADDRESS>
  ```
  > Ganti <HUMAN_ADDRESS> dengan addressmu

### Daftar menjadi validator

* Daftar menjadi validator
  ```console
  humansd tx staking create-validator \
  --amount 10000000uheart \
  --commission-max-change-rate "0.1" \
  --commission-max-rate "0.20" \
  --commission-rate "0.1" \
  --min-self-delegation "1" \
  --details "Masukan deskripsi disini" \
  --pubkey=$(humansd tendermint show-validator) \
  --moniker $HUMAN_MONIKER \
  --chain-id $HUMAN_CHAIN_ID \
  --gas-prices 0.025uheart \
  --from <NAMA_DOMPET>
  ```
  Salin txhash tadi

  > (Opsional) Ganti deskripsi node di bagian `--details`

* Cek status validator
  Cek txhash tadi di [explorer](https://explorer.humans.zone/humans-testnet)

## Perintah berguna

### Monitoring
* Cek informasi blok
  ```console
  humansd status 2>&1 | jq .SyncInfo
  ```
* Cek informasi node
  ```console
  humansd status 2>&1 | jq .NodeInfo
  ```
* Cek node id
  ```console
  humansd tendermint show-node-id
  ```

### Operasi validator
* Bebaskan (unjail) validator
  ```console
  humansd tx slashing unjail \
  --from=<NAMA_DOMPET> \
  --chain-id=$HUMAN_CHAIN_ID
  ```

### Operasi dompet

* Buat dompet
  ```console
  humansd keys add <NAMA_DOMPET>
  ```
* Recover dompet
  ```console
  humansd keys add <NAMA_DOMPET> --recover
  ```
* Menampilkan address
  ```console
  humansd keys show <NAMA_DOMPET> -a
  ```
* Menampilkan address valoper
  ```console
  humansd keys show <NAMA_DOMPET> --bech val -a
  ```
* Menampilkan list dompet
  ```console
  humansd keys list
  ```
* Menampilkan saldo dompet
  ```console
  humansd query bank balances <HUMAN_ADDRESS>
  ```
* Transfer saldo
  ```console
  humansd tx bank send <ALAMAT_DOMPET_ANDA> <ALAMAT_PENERIMA> <JUMLAH_YANG_AKAN_DITRANSFER>
  ```
* Hapus dompet
  ```console
  humansd keys delete <NAMA_DOMPET>
  ```

### Voting
* Voting
  ```console
  humansd tx gov vote 1 yes --from <NAMA_DOMPET> --chain-id=$HUMAN_CHAIN_ID
  ```

## Troubleshoot