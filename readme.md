# Dokku Alt extentsion for Agile Toolkit

This add-on provides number of models, which you can use from your
Agile Toolkit application. 

## Installation

Inside `composer.json` add:

    "require": {
        "romaninsh\/dokku_alt": "1.*@dev"
    }

Inside your Application class add:

    $this->add('dokku_alt/Initiator');

If you use `Controller_Migrator` it will automatically find and execute
migrations.
