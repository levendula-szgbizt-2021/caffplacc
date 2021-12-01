caffplacc
=========

Számítógép-biztonság (`BUTEVIHIMA06`) házi feladat megoldás  
_levendula_ csapat



Használat
---------


### Repository

Ez a repository git _submodule_-okat használ az egyes komponensek
összeemeléséhez.
A klónozáshoz a következő parancs használata javasolt, amely az
almodulokat is lehúzza:

    git clone --recurse-submodules $REPO_URL

(A `$REPO_URL` helyére természetesen a megfelelő URL kerül.)

Amennyiben már nem rekurzívan klónoztad a repot, a következő paranccsal
is frissítheted (letöltheted) a szubmodulokat hozzá:

    git submodule update --init --recursive


### Függőségek

A következőkre a natív komponens fordíthatósága miatt van szükség:

* (Unix) `make`
* valamilyen C fordító (pl `clang`)
* `libjpeg` könyvtár (`sudo apt install libjpeg-dev`)
* ImageMagick 6 core és wand könyvtárak
  (`sudo apt install libmagickwand-6.q16-dev`)

Amennyiben Dockerrel futtatnád az alkalmazást és nem szeretnéd a natív
komponenseket a gazdagépen telepíteni, ne felejtsd el a `maven`nel való
fordítás során megadni a `-DskipTest` opciót, ugyanis a tesztek
meghívják a natív komponenst is.
Így is teljesen működő Docker alapú rendszert fogsz kapni
végeredményként.

Önaláírt tanúsítvány generálásához továbbá szükséged lesz `openssl`re.

Dockeres futtatáshoz szükség lesz a Dockerre (telepítését lásd oldalán)
és `docker-compose`ra is (`sudo apt install docker-compose`).

Általánosságban a Java komponesekhez szükség lesz 11-es JDK-ra (`sudo
apt install adoptopenjdk-11-jdk`).


### Build

Az teljes alkalmazás legegyszerűbben _Dockerrel_ használható.
Egyébként persze lehetséges telepítve a szükséges dependenciákat,
lefordítva az egyes komponenseket és végül manuálisan elindítva őket is
működtetni a rendszert.

#### Dockerrel

1. Készítsd elő a környezetet

   * A _Függőségek_ fejezet értelmében telepítsd a szükséges eszközöket
     és könyvtárakat, vagy ne – a továbbiakban azt az esetet nézzük,
     hogy telepítetted ezeket.

   * Környezettől függően változhat, milyen C fordítót használsz, hova
     szeretnéd telepíteni a natív komponenst és hogy hova kerülnek
     bizonyos könyvtárak.
     Ezért mindenképpen állítsd be a `CC` és a `PREFIX` környezeti
     változókat.

     ```
     export CC=cc PREFIX=/usr/local
     ```

   * Szükséges lehet az is (pl Debian 11-en annak tűnik), hogy megadj
     további fordító opciókat:

     ```
     export CFLAGS='-I/usr/include/ImageMagick-6 -I/usr/include/x86_64-linux-gnu/ImageMagick-6'
     ```

   * Természetesen szükséged lesz működő `docker`re és
     `docker-compose`-ra is.

2. Futtasd a `prepare.sh` scriptet

   * Eldöntheted, kívánod-e helyileg lefordítani és telepíteni a natív
     komponenseket (valószínűleg igen).

   * Ezután a script előkészít egy alap docker imaget, illetve a backend
     komponens docker imagét

   * Végül lehetőséged van egy önaláírt tanúsítványt generálni, ami
     automatikusan a helyére kerül.
     A továbbiakban úgy vesszük, hogy ezt legeneráltad, vagy manuálisan
     elhelyeztél egy `nginx.key` nevű privát kulcsot és egy `nginx.crt`
     nevű publikus tanúsítványt a `cert/` alkönyvtárban.

3. Indítsd el az alkalmazást a `docker-compose up` segítségével.

4. Az alkalmazás a `docker-compose.yml` alapján, alapértelmezés szerint
   a gazdagép bármelyik interfészének `10443` portján érhető el.


#### Manuálisan

1. Telepítsd a `ciff` könyvtárat:  
   (Ehhez szükséges a `libjpeg` könyvtár függőség)

   ```
   $ cd ciff/
   $ make clean all
   # make install
   ```

2. Telepítsd a `caff` könyvtárat:  
   (Ehhez szükségs az `imagemagick` könyvtár függőség és a `libciff`)

   ```
   $ cd caff/
   $ make clean all
   # make install
   ```

3. Készítsd elő az adatbázist (PostgreSQL):

   * Add meg a megfelelő adatokat a `caffplacc-backend` komponens
     `caffplacc-backend-core` almoduljának `applcation.yml`
     konfigurációjában!

4. Indítsd el a backend komponenst:  
   (Ehhez JDK 11 kell)

   ```
   $ cd caffplacc-backend/
   $ ./mvnw clean install
   $ ./mvnw -pl caffplacc-backend-core exec:java -Dexec.mainClass=hu.bme.szgbizt.levendula.caffplacc.CaffplaccApplication
   ```

5. Fordítsd le a frontend komponenst:  
   (Ehhez `ng` (Angular CLI) kell)

   ```
   $ cd caffplacc-frontend/
   $ ng compile
   ```

6. Szolgáld ki a következő könvytár tartalmát:
   `cafplacc-frontend/dist/`
