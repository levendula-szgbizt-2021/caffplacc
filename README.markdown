caffplacc
=========

Számítógép-biztonság (`BUTEVIHIMA06`) házi feladat megoldás  
_levendula_ csapat

Használat
---------

Ez a repository git _submodule_-okat használ az egyes komponensek
összeemeléséhez.
A klónozáshoz a következő parancs használata javasolt, amely az
almodulokat is lehúzza:

    git clone --recurse-submodules $REPO_URL

(A `$REPO_URL` helyére természetesen a megfelelő URL kerül.)

Amennyiben már nem rekurzívan klónoztad a repot, a következő paranccsal
is frissítheted (letöltheted) a szubmodulokat hozzá:

    git submodule update --init --recursive
