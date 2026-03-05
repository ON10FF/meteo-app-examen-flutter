# 🌤️ Météo Sénégal — L3GL ISI 2026

Application Flutter développée dans le cadre de l'examen de Développement Mobile L3GL ISI 2026.

---

## 👥 Membres du groupe

| Nom complet |
|-------------|
| Evelyn Sydney Siopathis |
| Babacar Tall |
| Papa Cheikh Sylla |

---

## 📱 Aperçu de l'application

Application Flutter qui récupère des données météo en temps réel pour 5 villes sénégalaises, avec une jauge de progression animée et une visualisation détaillée par ville.

---

## ✅ Fonctionnalités réalisées

### 🏠 Écran d'accueil
- Message d'accueil avec design thématique sénégalais
- Soleil animé avec effet de pulse
- Bouton stylisé pour lancer l'expérience
- Affichage des 5 villes surveillées

### 📊 Écran principal
- Jauge de progression animée qui se remplit automatiquement
- Appels API météo séquentiels pour 5 villes via Retrofit
- Messages d'attente dynamiques en boucle :
    - *Nous téléchargeons les données…*
    - *C'est presque fini…*
    - *Plus que quelques secondes avant d'avoir le résultat…*
- Tableau interactif des données météo après chargement
- Bouton **Recommencer** pour relancer l'expérience

### 🌍 Interactions avancées
- Page de détail par ville (température, ressenti, humidité, vent, coordonnées)
- Gestion des erreurs API avec possibilité de réessayer
- Mode sombre et clair avec toggle

### 🔄 Navigation
- Retour à l'écran d'accueil via le bouton back
- Navigation vers le détail de chaque ville

---

## 🏗️ Architecture

```
lib/
├── data/
│   ├── models/
│   │   └── weather_model.dart
│   └── services/
│       └── weather_service.dart
├── providers/
│   ├── theme_provider.dart
│   └── weather_provider.dart
├── views/
│   ├── splash/
│   │   └── home_screen.dart
│   ├── main_screen/
│   │   ├── main_screen.dart
│   │   └── widgets/
│   │       ├── weather_table.dart
│   │       ├── animated_gauge.dart
│   │       └── loading_message.dart
│   └── detail/
│       └── city_detail_screen.dart
├── app.dart
└── main.dart
```

**Pattern :** Provider + architecture en couches (data / providers / views)

---

## 🛠️ Spécifications techniques

| Critère | Implémentation |
|---------|---------------|
| Appels API | Retrofit + Dio + OpenWeatherMap |
| Gestion d'état | Provider |
| Animations | flutter_animate + AnimationController |
| Design | Material 3 + thème custom sénégalais |
| Sécurité | Clé API via flutter_dotenv (`.env`) |
| Navigation | Routes nommées |

---

## 📦 Dépendances principales

| Package | Usage |
|---------|-------|
| `provider ^6.1.1` | Gestion d'état |
| `dio ^5.4.0` | Requêtes HTTP |
| `retrofit ^4.1.0` | Client API typé |
| `flutter_dotenv ^5.1.0` | Variables d'environnement |
| `flutter_animate ^4.3.0` | Animations |
| `percent_indicator ^4.2.3` | Jauge de progression |
| `go_router ^13.0.0` | Navigation |

---

## 🚀 Installation

1. **Cloner le dépôt**
```bash
git clone https://github.com/votre-username/meteo-senegal.git
cd meteo-senegal
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Configurer la clé API**

Créer un fichier `.env` à la racine :
```env
WEATHER_API_KEY=votre_cle_openweathermap
```

4. **Lancer l'application**
```bash
flutter run
```

---

## 🌍 API utilisée

[OpenWeatherMap](https://openweathermap.org/api) — `data/2.5/weather`
- Unité : métrique (°C)
- Langue : français
- Villes : Dakar, Mbour, Kaffrine, Kaolack, Thiès

---

## 🔐 Sécurité

La clé API est stockée dans un fichier `.env` non commité (listé dans `.gitignore`), chargé au démarrage via `flutter_dotenv`.

---

*Examen de Développement Mobile — L3GL ISI 2026*