# FreeboxBridgeIPV4Checker
Permet de vérifier la connectivité IPV4 d'une Freebox en mode bridge et de la rétablir si besoin.

## Principe de fonctionnement

Un ping est effectué régulièrement vers une adresse IPV4 distante.

Si ce ping ne répond pas ou passe la Freebox en mode routeur puis de retour en mode bridge.

Cela a pour effet de rétablir automatiquement la connectivité IPV4 avec une coupure plutôt faible (moins d'une minute).

## Installation
Copier les fichier sur un hôte linux disposant d'un accès Internet IPV4 + IPV6.

IPV6 est indispensable car sans IPV4 c'est le seul moyen d'accéder à la Freebox en mode bridge.

S'assurer que curl est installé.

### Obtenir un accès à l'API de la Freebox

Pour la variable FREEBOX_URL renseigner l'adresse IPV6 (2a01:xxxx:xxxx:xxx0::1) de la Freebox ainsi que le port (ppppp) d'accès distant (privilégier HTTPS).

```
# source freeboxos_bash_api.sh
# FREEBOX_URL=https://[2a01:xxxx:xxxx:xxx0::1]:ppppp
# authorize_application 'ipv4Checker.app' 'IPV4 Checker' '1.0.0' 'IPV4 Checker'
Please grant/deny access to the application on the Freebox LCD...
```

Il faut maintenant se rendre face à la Freebox et appuyer sur la flèche vers la droite pour autoriser la nouvelle application

```
Authorization granted
MY_APP_ID="ipv4Checker.app"
MY_APP_TOKEN="azerty"
```

Bien noter les valeurs de MY_APP_ID et MY_APP_TOKEN.

### Édition de la clé d'API

Se rendre sur l'interface Freebox OS puis accéder à "Paramètres de la Freebox".

S'assurer d'être sur "Mode avancé".

Accéder à "Gestion des accès" puis sur l'onglet "Applications" éditer "ipv4Checker.app" pour ne lui autoriser que "Modification des réglages de la Freebox".

![Token API Freebox](https://i.imgur.com/uT9f5HR.png)

### Lancer le script avec la commande suivante

Exécuter le script, si possible avec screen pour ne pas avoir une console ouverte tout le temps. Écrire si besoin dans un fichier de log.

```
./checkIPV4.sh https://[2a01:xxxx:xxxx:xxx0::1]:ppppp y.y.y.y <MY_APP_ID> "<MY_APP_TOKEN>" > /root/checkIPV4.log
```

Exemple

```
./checkIPV4.sh https://[2a01:abcd:abcd:abc0::1]:12345 1.2.3.4 ipv4Checker.app "azerty" > /root/checkIPV4.log
```
