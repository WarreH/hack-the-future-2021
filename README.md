# Hack The Future 2021

## Algemene informatie

Dit is een lege Drupal 9 installatie als basis voor de deelnemers van Hack The
Future 2021.

## Setup

1. Kloon deze repository op je lokale computer op de plek waar je wilt starten
2. Start een lokale ontwikkel omgeving volgens je eigen kennis
3. Importeer de database die je kan vinden in deze repository in
   `db/htf_2021_student.sql.gz`
4. Kopieer `web/sites/example.settings.local.php` naar
   `web/sites/default/settings.local.php` en vul de juiste database gegevens in
   `web/sites/default/settings.local.php` aan

## Frontend App

De frontend App is beschikbaar op `<url>/app`

## FAQ

### Keuze van lokale ontwikkel omgeving?
Deze mag je zelf kiezen en kan bijvoorbeeld een MAMP/XAMP/WAMP/... setup zijn,
mag ook een omgeving zijn gebaseerd op docker met lando/ddev/..., native of nog
andere. Hou er rekening mee dat je zelf verantwoordelijk bent voor uw lokale
ontwikkel omgeving. Wij kunnen proberen te helpen waar nodig, maar ga er niet
vanuit dat wij alles vanbuiten kennen.

### Wat zijn de database gegevens?

```php
$databases['default']['default'] = [
  'database' => '<database>',
  'username' => '<username>',
  'password' => '<password>',
  'prefix' => '',
  'host' => '<host>',
  'port' => '',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
];
```

### Wat zijn de login gegevens?

| Key      | Value     |
| -------- | --------- |
| Username | calibrate |
| Paswoord | calibrate |

