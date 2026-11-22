---
theme: seriph
background: https://cover.sli.dev
class: text-center
highlighter: shiki
lineNumbers: false
info: |
  ## Outils de build et gestionnaires de paquets
drawings:
  persist: false
transition: slide-left
title: Outils de build et gestionnaires de paquets
mdc: true
---

# Outils de build et gestionnaires de paquets

<div class="pt-12">
  <span @click="$slidev.nav.next" class="px-2 py-1 rounded cursor-pointer" hover="bg-white bg-opacity-10">
    Appuyez sur Espace pour continuer <carbon:arrow-right class="inline"/>
  </span>
</div>

<div class="abs-br m-6 flex gap-2">
  <button @click="$slidev.nav.openInEditor()" title="Open in Editor" class="text-xl slidev-icon-btn opacity-50 !border-none !hover:text-white">
    <carbon:edit />
  </button>
  <a href="https://github.com/barais/courses" target="_blank" alt="GitHub" title="Open in GitHub"
    class="text-xl slidev-icon-btn opacity-50 !border-none !hover:text-white">
    <carbon-logo-github />
  </a>
</div>

---
transition: fade-out
---

# Pourquoi des outils de build ?

Appliquer des patterns à l'infrastructure de build pour obtenir une vue cohérente des projets logiciels.

Aide à gérer :

- **Les compilations** et la génération des artefacts
- **Les dépendances** (téléchargement, résolution, mise à jour)
- **La gestion de configuration logicielle**
- La documentation et les rapports
- Les releases

---
layout: default
---

# Objectifs

- Rendre le processus de développement visible et transparent
- Faciliter l'évaluation de la santé et l'état d'un projet
- Réduire le temps de formation des nouveaux développeurs
- Regrouper les outils nécessaires de manière uniforme
- Prévenir les configurations incohérentes entre environnements
- Fournir une infrastructure de build standard à l'ensemble des projets
- **Permettre aux équipes de se concentrer sur l'écriture du code**

---
layout: center
class: text-center
---

# Maven (Java)

Un exemple historique fondateur

---
layout: default
---

# Qu'est-ce que Maven ?

- Un **outil de build** (compilation, packaging, tests)
- Un **gestionnaire de dépendances** (binaires)
- Un **outil de documentation** (site, rapports)

<div class="flex justify-center">
<img src="/maven.svg" class="max-w-150 max-h-72"/>
</div>

---
layout: default
---

# Format commun de métadonnées : le POM

- POM = Project Object Model = `pom.xml`
- Contient les métadonnées du projet
- Répertoires, développeurs, dépendances, dépôts, etc.

```xml
<project>
  <modelVersion>4.0.0</modelVersion>
  <groupId>fr.univ-rennes</groupId>
  <artifactId>mon-application</artifactId>
  <name>Mon Application</name>
  <version>1.0.0</version>
  <packaging>jar</packaging>
  <dependencies/>
  <build/>
</project>
```

---
layout: default
zoom: 0.95
---

# Organisation standard des répertoires

Convention over configuration : un développeur familier d'un projet Maven se retrouve immédiatement dans un autre.

<div grid="~ cols-2 gap-2" m="-t-2">

<img border="rounded" src="/structurelayout1.png" alt="">
<img border="rounded" src="/structurelayout.png" alt="">
</div>

<v-click>

<div class="absolute left-80px top-270px">
<Transform :scale="0.7">
<svg width="800" height="600" xmlns="http://www.w3.org/2000/svg">
 <g>
  <title>Layer 1</title>
  <path stroke="#000" id="svg_1" d="m397.00001,349.81252l-181.52499,0l0,-105.5l27.82499,0l-55.64999,-52.74999l-55.65001,52.74999l27.82501,0l0,158.25l237.17499,0l0.00001,-52.75001z" fill="#fff"/>
  <text stroke="#000" xml:space="preserve" text-anchor="start" font-family="Noto Sans JP" font-size="7" stroke-width="0" id="svg_2" y="384.5" x="422" fill="#FF0000">Convention over configuration</text>
 </g>
</svg>
</Transform></div>
</v-click>

---
layout: default
---

# Cycle de vie Maven

<Transform :scale="0.9">
<div class="">
<img src="/mojo.svg"/>
</div>
</Transform>

---
layout: default
---

# Phases principales du cycle de vie

- **clean** – nettoie le projet (supprime `target/`)
- **validate** – vérifie que le projet est correct
- **compile** – compile les sources
- **test** – exécute les tests unitaires
- **package** – emballe le code compilé (JAR, WAR…)
- **integration-test** – déploie et lance les tests d'intégration
- **verify** – vérifie les résultats des tests d'intégration
- **install** – installe dans le dépôt local (`~/.m2`)
- **deploy** – copie le package vers le dépôt distant partagé

---
layout: default
---

# Dépôts d'artefacts (1/2)

<div class="absolute left-100px bottom-20px">
<img src="/mavenrepo.svg"/>
</div>

- Stockent tous types d'artefacts : JARs, EARs, WARs, plugins…
- Toutes les interactions du projet passent par le dépôt
  - Fini les chemins relatifs !
  - Partage simplifié entre membres de l'équipe

```xml
<repositories>
  <repository>
    <id>central</id>
    <name>Maven Central</name>
    <url>https://repo.maven.apache.org/maven2</url>
  </repository>
</repositories>
```

---
layout: default
---

# Dépôts d'artefacts (2/2)

Dépôts publics de référence

<div class="absolute left-100px bottom-0px">
<img src="/mavenrepo2.svg"/>
</div>

---
layout: two-cols
---

# Gestion des dépendances

- Maven utilise des dépendances binaires

<div class="absolute left-50px top-120px">
<img src="/dependenciesmaven.svg"/>
</div>

::right::

<div style="height:50px;"></div>

```xml
<dependencies>
  <dependency>
    <groupId>com.acme</groupId>
    <artifactId>lib-b</artifactId>
    <version>[1.0,2.0)</version>
    <scope>compile</scope>
  </dependency>
</dependencies>
```

<div class="absolute left-150px bottom-330px">
<img src="/dependenciesmaven2.svg"/>
</div>

<Transform :scale="1.6">
<div class="absolute right-150px top-30px">
<img src="/dependenciesmaven1.svg"/>
</div>
</Transform>

---
layout: two-cols
---

# Gestion des dépendances transitives

- Dépendances transitives résolues automatiquement
  - Possibilité d'exclure des dépendances
- Gestion des SNAPSHOTs (toujours la dernière version)
- Mises à jour automatiques configurables (par défaut : quotidiennes)
- **⚠️ Attention** : les dépendances transitives sont un vecteur d'attaque majeur sur la supply chain

::right::

<div style="height:50px;"></div>

<Transform :scale="1.2">
<div class="absolute right-100px top-30px">
<img src="/mavendependencies3.svg"/>
</div>
</Transform>

---
layout: default
---

# Plugins Maven utiles aujourd'hui

```xml
<build>
  <plugins>
    <!-- Compiler Java 21 -->
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-compiler-plugin</artifactId>
      <configuration>
        <source>21</source>
        <target>21</target>
      </configuration>
    </plugin>
    <!-- Tests : Surefire -->
    <!-- Couverture : JaCoCo -->
    <!-- Analyse statique : SpotBugs -->
    <!-- Vulnérabilités : OWASP Dependency-Check -->
    <!-- SBOM : CycloneDX -->
  </plugins>
</build>
```

---
layout: two-cols-header
---

# Ce que Maven apporte

::left::

**Points forts**
- Standardisation et réutilisabilité
- Gestion des dépendances transitives
- Cycle de vie défini et extensible
- Grand écosystème de plugins
- Support IDE universel
- Structure de projet partagée
- Dépôt central mondial (Maven Central)
- Builds reproductibles via versions épinglées

::right::

**Limites**
- Configuration XML verbeuse
- Courbe d'apprentissage des plugins
- Lenteur sur les grands projets (Gradle est souvent préféré)
- Résolution de dépendances parfois complexe
- Outils de sécurité à ajouter explicitement (OWASP DC, CycloneDX)

---
layout: default
---

# Références Maven

- [Maven Home](https://maven.apache.org/)
- [Maven Getting Started Guide](https://maven.apache.org/guides/getting-started/index.html)
- [Maven Central](https://central.sonatype.com/)
- [OWASP Dependency-Check](https://jeremylong.github.io/DependencyCheck/dependency-check-maven/)
- [CycloneDX Maven Plugin](https://github.com/CycloneDX/cyclonedx-maven-plugin)

---
layout: center
class: text-center
---

# L'écosystème JavaScript

---
layout: default
---

# L'écosystème JS : vue d'ensemble

L'écosystème JavaScript a connu une évolution rapide. Trois catégories d'outils coexistent :

- **Gestionnaires de paquets** : npm, Yarn, pnpm, Bun
  - Gèrent les dépendances et leurs lock files
- **Bundlers / build tools** : Vite, esbuild, Rollup, Webpack
  - Transforment, optimisent et empaquètent les sources
- **Scaffolding** : `create-vite`, `create-next-app`, JHipster…
  - Génèrent la structure initiale d'un projet

---
layout: default
---

# Gestionnaires de paquets JS

Tous s'appuient sur `package.json` pour déclarer les dépendances.

```bash
npm install express --save      # dépendance de production
npm install jest --save-dev     # dépendance de développement
npm install                     # installe depuis package.json
npm ci                          # installe depuis le lock file (CI/CD)
```

- **npm** : gestionnaire historique, fourni avec Node.js
- **Yarn** : parallélise les téléchargements, workspace monorepo
- **pnpm** : stockage par liens symboliques → économie de disque × 10, strict par défaut (empêche les dépendances fantômes)
- **Bun** : runtime + gestionnaire ultra-rapide (écrit en Zig), drop-in replacement de npm

---
layout: default
---

# Lock files : le contrat de reproductibilité

Chaque gestionnaire génère un **lock file** qui épingle les versions exactes de **toutes** les dépendances (directes + transitives) :

| Gestionnaire | Lock file |
|---|---|
| npm | `package-lock.json` |
| Yarn | `yarn.lock` |
| pnpm | `pnpm-lock.yaml` |
| Bun | `bun.lockb` |

```bash
npm ci   # utilise package-lock.json, refuse si incohérent
```

> **⚠️ Toujours committer le lock file.** Il empêche les mises à jour silencieuses de dépendances transitives, qui sont le vecteur d'attaques supply chain.

---
layout: default
---

# Bundlers et build tools modernes

L'ère Grunt/Gulp (2013–2018) est révolue. Les outils actuels :

| Outil | Usage | Perf |
|---|---|---|
| **Vite** | Dev server HMR + build prod (Rollup) | ⚡ très rapide |
| **esbuild** | Bundler/transpiler Go | ⚡⚡ extrêmement rapide |
| **Rollup** | Bibliothèques, tree-shaking fin | rapide |
| **Webpack** | Applications complexes, héritage | lent mais configurable |
| **Turbopack** | Successor Webpack (Vercel/Next.js) | ⚡⚡ |

```bash
# Créer un projet Vite
npm create vite@latest mon-app -- --template react
cd mon-app && npm install && npm run dev
```

---
layout: default
---

# Scaffolding moderne

Les générateurs d'aujourd'hui :

```bash
# Vite (React, Vue, Svelte, Lit, Vanilla…)
npm create vite@latest

# Next.js (React SSR/SSG)
npx create-next-app@latest

# JHipster (fullstack Java + JS/TS)
npm install -g generator-jhipster
jhipster

# Nuxt.js (Vue SSR/SSG)
npx nuxi@latest init mon-projet
```

> Yeoman (2012) et Bower (2012, déprécié en 2017) appartiennent à l'histoire. Grunt et Gulp ont été supplantés par les bundlers natifs ES modules.

---
layout: center
class: text-center
---

# L'écosystème Python

---
layout: default
---

# L'écosystème Python

> Python est un langage fantastique, mais il y a un point qui laisse à désirer par rapport aux environnements plus récents comme Node.js ou Rust : le gestionnaire de paquets.

---
layout: default
---

# Pip

Pour déclarer les dépendances d'une application Python, on utilise un fichier `requirements.txt` listant tous les paquets nécessaires avec leur version :

```txt
redis==2.10.6
rq==0.13
```

- Version exacte (ex. `redis==2.10.6`)
- Ou des bornes : `redis>=2.1.3,<3` accepte les versions entre 2.1.3 et 3.0.0

> Il est vivement recommandé d'utiliser des versions exactes pour éviter que les versions sélectionnées par Pip changent sans prévenir.

```bash
pip install -r requirements.txt
```

---
layout: default
---

# Les problèmes de Pip

- **L'isolation des applications**
- **Les jeux de dépendances multiples**

---
layout: default
---

# L'isolation des applications

Pip n'a pas de notion d'application ou de projet :
- Si on l'utilise naïvement depuis deux applications, Pip mélange les dépendances et crée un système généralement inutilisable.
- Pour isoler chaque application, il faut un autre outil : **virtualenv**, ce qui complique la création de l'environnement de développement et l'installation en production.

---
layout: default
---

# Les jeux de dépendances multiples

### Les mises à jour

Comme toutes les versions doivent être spécifiées manuellement, il est facile de créer des incompatibilités. Pip, s'il détecte le problème, n'aide pas à le résoudre.

```txt
redis==2.10.6
rq==0.13
```

> Ces deux paquets sont incompatibles car `rq` dépend de `redis>=3.0.0`. Voilà le comportement de Pip :

```bash
$ pip install -r requirements.txt
Collecting redis==2.10.6 (from -r requirements.txt (line 1))
  Using cached redis-2.10.6-py2.py3-none-any.whl
Collecting rq==1.0 (from -r requirements.txt (line 2))
  Using cached rq-1.0-py2.py3-none-any.whl
ERROR: rq 1.0 has requirement redis>=3.0.0, but you'll have redis 2.10.6 which is incompatible.
Installing collected packages: redis, click, rq
Successfully installed click-7.0 redis-2.10.6 rq-1.0
```

---
layout: default
---

# Les jeux de dépendances multiples

### Les mises à jour (suite)

Pip affiche un message d'erreur, mais le paquet `rq` est maintenant inutilisable. Il faut trouver à la main, par essai-erreur, une combinaison de versions qui fonctionne.

> On se retrouve généralement dans cette situation en essayant de faire une mise à jour : on modifie la version d'un paquet et la nouvelle version introduit une incompatibilité. Ce problème rend les mises à jour de versions dans les fichiers requirements **pénibles** et **dangereuses**.

<AutoFitText :max="30" :min="30" modelValue="Risque important pour la sécurité"/>

---
layout: default
---

# Les jeux de dépendances multiples

### Les paquets résiduels

> Au fil du temps, les dépendances d'une application vont évoluer : on va en ajouter mais aussi en supprimer, et Pip ne fournit aucun moyen utilisable pour supprimer une dépendance.

En pratique, le seul moyen de s'assurer que l'environnement ne contient pas de paquets résiduels est de supprimer le virtualenv et de relancer l'installation complète. Ces paquets résiduels peuvent induire deux types d'erreurs :

- On utilise sans s'en rendre compte un paquet non déclaré dans `requirements.txt` : tout fonctionne jusqu'à la création d'un nouvel environnement
- La simple présence d'un paquet peut altérer le comportement d'un autre

---
layout: default
zoom: 0.95
---

# Les contre-mesures

### Pip-tools (https://github.com/jazzband/pip-tools)

Un ensemble d'outils pour maintenir les paquets pip à jour, même épinglés. Produit des builds prédictibles et déterministes.

<Transform :scale="0.9">
<div class="absolute right-100px top-30px">
<img src="https://github.com/jazzband/pip-tools/raw/main/img/pip-tools-overview.svg"/>
</div>
</Transform>

---
layout: default
---

# Les contre-mesures

### Pip-tools (https://github.com/jazzband/pip-tools)

Les pip-tools adressent uniquement les problèmes de mise à jour de versions et de paquets résiduels.
Pour isoler l'environnement et gérer différents jeux de dépendances, il faudra recourir aux mêmes techniques qu'avec Pip (virtualenv).

---
layout: default
---

# Les contre-mesures

### Pipenv (https://github.com/pypa/pipenv)

Pipenv est un outil de gestion d'environnements virtuels Python qui fait le pont entre pip, python et virtualenv.

Pipenv crée et gère automatiquement un virtualenv pour vos projets, et gère les paquets via un `Pipfile`. Il génère un `Pipfile.lock` pour des builds déterministes.

---
layout: default
---

# Les contre-mesures

### Poetry (https://python-poetry.org/)

> Python packaging and dependency management made easy

- **Résolveur de dépendances exhaustif** : trouve toujours une solution si elle existe
- **Isolation automatique** : crée ses propres virtualenvs, toujours isolé du système
- **Commandes intuitives** avec des défauts raisonnables
- Génère un `poetry.lock` pour des builds reproductibles

```bash
poetry new mon-projet
poetry add requests
poetry add pytest --group dev
poetry install          # depuis poetry.lock si présent
poetry update           # met à jour et régénère poetry.lock
```

---
layout: default
---

# uv (Python) : la nouvelle génération

> uv est un gestionnaire de paquets et de projets Python écrit en **Rust** par [Astral](https://astral.sh/). Il vise à remplacer, de manière unifiée et beaucoup plus rapide, pip, pip-tools, virtualenv, pipenv, pyenv et Poetry.

- **Très rapide** : 10 à 100x plus rapide que pip (résolution et installation)
- **Un seul outil** pour créer l'environnement, gérer les versions de Python, les dépendances et les builds
- **Cache global** adressé par contenu, partagé entre tous les projets
- **Résolution universelle** : un seul fichier de verrouillage multi-plateformes

---
layout: default
---

# uv : le projet en pratique

uv s'appuie sur `pyproject.toml` pour déclarer le projet et sur `uv.lock` pour épingler exactement les versions.

```bash
uv init mon-projet
cd mon-projet
uv add requests          # met à jour pyproject.toml + verrouille uv.lock
uv run python main.py    # crée l'environnement isolé puis exécute dans le bon contexte
```

- `uv add` / `uv remove` gèrent les dépendances sans fichier `requirements.txt` manuel
- `uv sync` installe l'environnement **exactement** d'après `uv.lock`
- `uv run` crée automatiquement un virtualenv isolé si besoin

---
layout: default
---

# Reproductibilité et sécurité avec uv

- `uv.lock` : **un seul verrou** déterministe et multi-plateformes, avec versions épinglées (pas de divergence Windows / Linux / macOS)
- Vérification des **sommes de contrôle (SHA-256)** des artefacts téléchargés
- `uv audit` : audit des dépendances connues vulnérables (base Astral)
- Sources de paquets contrôlables (index par défaut, index privés, sources multiples)

> Véritablement un modèle "lock file comme mécanisme de sécurité", au même titre que `package-lock.json` côté Node.js.

---
layout: default
---

# uv : versions de Python et compatibilité pip

**Gérer les interpréteurs Python** (remplace pyenv) :

```bash
uv python install 3.12   # télécharge un interpréteur isolé
uv python pin 3.12       # choisit la version du projet (.python-version)
```

**Compatibilité avec le workflow pip existant** :

```bash
uv pip install -r requirements.txt
uv pip freeze > requirements.txt
```

> Deux modes coexistent : le mode "projet" (uv add / uv sync) et le mode "pip" (`uv pip`), ce qui rend la migration depuis des habitudes pip progressive et sans rupture.

---
layout: cover
---

# L'écosystème Rust

---
layout: default
---

# L'écosystème Rust

Rust est un langage remarquable. Il est livré avec un outil souvent mal compris : **Cargo**.

---
layout: default
---

# Qu'est-ce que Cargo ?

Cargo est le **système de build** et le **gestionnaire de paquets** de Rust.

Avec Cargo, le build est reproductible car les paquets Rust déclarent leurs dépendances dans le manifeste `Cargo.toml`.

Cargo :
- **Télécharge** les dépendances
- **Compile** les paquets
- **Publie** vers le registre Rust officiel, **crates.io**

```bash
cargo new mon-projet
cargo build
cargo test
cargo publish
```

---
layout: default
---

# Cargo.toml vs Cargo.lock

**Cargo.toml** (écrit par le développeur) :
```toml
[dependencies]
serde = "1.0"
tokio = { version = "1", features = ["full"] }
```

**Cargo.lock** (maintenu par Cargo) :
```toml
[[package]]
name = "serde"
version = "1.0.197"
source = "registry+https://github.com/rust-lang/crates.io-index"
checksum = "3fb1c873e1b9b056a4dc4c0c198b24c3ffa059243875552b2bd0933b1aee4ce2"
```

> `Cargo.toml` stocke des versions SemVer. `Cargo.lock` épingle la version exacte utilisée lors d'un build réussi, avec son **checksum cryptographique**. C'est le mécanisme de base contre la substitution de paquets.

---
layout: default
---

# Cargo.lock : toujours committer ?

| Type de projet | Committer Cargo.lock ? |
|---|---|
| Application binaire (bin) | **Oui** — garantit la reproductibilité |
| Bibliothèque (lib) | Non — les consommateurs ont leur propre lock |

> **⚠️ Sécurité** : le checksum dans `Cargo.lock` détecte toute altération d'un paquet sur crates.io. Sans lock file, une mise à jour malveillante d'une dépendance peut s'installer silencieusement.

---
layout: center
class: text-center
---

# Sécuriser ses dépendances

La supply chain logicielle comme vecteur d'attaque

---
layout: default
---

# Les attaques supply chain : exemples réels

Ces attaques ont compromis des milliers de projets :

| Incident | Année | Vecteur |
|---|---|---|
| **event-stream** | 2018 | Mainteneur légitime cède le package à un attaquant |
| **ua-parser-js** | 2021 | Compte npm compromis → code malveillant injecté |
| **colors.js** | 2022 | Mainteneur sabote volontairement son propre package |
| **node-ipc** | 2022 | Mainteneur insère du code wiper (Ukraine/Russie) |
| **PyPI typosquatting** | 2023 | `requestes`, `djang0`, `colourama` → malware |

> Ces incidents visaient des dépendances utilisées par des millions de projets. Votre `package.json` ou `requirements.txt` est une surface d'attaque.

---
layout: default
---

# Typosquatting : les imposteurs de paquets

Le typosquatting consiste à publier un paquet malveillant avec un nom proche d'un paquet légitime et populaire.

```bash
# Packages légitimes vs imposteurs
requests    →  requestes, request, python-requests
django      →  djang0, Djang0
numpy       →  numpay, num-py
lodash      →  1odash, 1odahs
```

**Mécanismes de défense :**
- Vérifier soigneusement les noms avant `npm install` / `pip install`
- Utiliser un registre privé (Nexus, Artifactory) qui bloque les paquets non approuvés
- Activer la protection de namespace (npm Organizations)
- Lire les changelogs avant une mise à jour majeure

---
layout: default
---

# Lock files comme mécanisme de sécurité

Le lock file n'est pas qu'un outil de reproductibilité : c'est une **ligne de défense contre la supply chain**.

```bash
# ✅ CI/CD : toujours utiliser l'équivalent "ci" du gestionnaire
npm ci                    # npm
yarn install --frozen-lockfile   # Yarn
pnpm install --frozen-lockfile   # pnpm
cargo build               # utilise Cargo.lock automatiquement
pip install -r requirements.txt  # + vérifier le hash avec pip-audit
```

**Ce que le lock file empêche :**
- La résolution d'une version différente (et potentiellement compromise) lors d'un rebuild
- L'injection silencieuse d'une nouvelle version d'une dépendance transitive
- Les variations de comportement entre environnements (dev / CI / prod)

---
layout: default
---

# Audits de dépendances

Chaque écosystème dispose d'un outil d'audit qui compare les dépendances aux bases de vulnérabilités connues (CVE) :

```bash
# JavaScript / Node.js
npm audit
npm audit fix            # corrige automatiquement si possible
npm audit --audit-level=high  # échec CI si vulnérabilité haute

# Python
pip install pip-audit
pip-audit -r requirements.txt
pip-audit --fix          # met à jour les versions vulnérables

# Rust
cargo install cargo-audit
cargo audit

# Java / Maven
mvn org.owasp:dependency-check-maven:check
```

> Intégrer ces commandes dans le pipeline CI/CD est la pratique minimale pour un projet DevSecOps.

---
layout: default
zoom: 0.95
---

# SBOMs : Software Bill of Materials

Un SBOM est une liste machine-readable de **tous les composants** d'une application : dépendances directes, transitives, versions, licences, hachages.

**Formats standards :**
- **CycloneDX** (OWASP) — le plus adopté, JSON/XML
- **SPDX** (Linux Foundation) — standard ISO/IEC 5962:2021

```bash
# Maven → CycloneDX
mvn cyclonedx:makeBom

# npm → SBOM SPDX
npm sbom --sbom-format spdx

# Python → CycloneDX
pip install cyclonedx-bom
cyclonedx-py requirements

# Rust → CycloneDX
cargo install cargo-cyclonedx
cargo cyclonedx
```

> Les SBOMs sont désormais exigés par la réglementation (Executive Order US 2021, Cyber Resilience Act EU).

---
layout: default
---

# Registres privés

En entreprise, utiliser un registre privé intermédiaire est une défense essentielle contre la supply chain :

<div grid="~ cols-2 gap-2">

<div>

**Nexus Repository** (Sonatype)
- Proxy des registres publics (npm, PyPI, Maven Central, crates.io)
- Scan de vulnérabilités intégré (Sonatype Lifecycle)
- Blocage des paquets non approuvés
- Rétention : fonctionne même si le registre public est down

</div>
<div>

**Artifactory** (JFrog)
- Mêmes fonctionnalités + multi-cloud
- JFrog Xray pour l'analyse des dépendances
- Supporte tous les gestionnaires (npm, Maven, pip, Cargo…)

</div>

</div>

```bash
# Configurer npm pour utiliser un registre privé
npm config set registry https://nexus.monentreprise.fr/repository/npm-proxy/

# pip
pip install --index-url https://nexus.monentreprise.fr/repository/pypi-proxy/simple/ requests
```

---
layout: default
zoom: 0.9
---

# Dependabot et Renovate

Ces outils automatisent les mises à jour de dépendances en ouvrant des **Pull Requests automatiques** dès qu'une nouvelle version est disponible.

**Dependabot** (intégré à GitHub) :

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 5
  - package-ecosystem: "maven"
    directory: "/"
    schedule:
      interval: "weekly"
```

**Renovate** (Mend, open source) :
- Plus configurable que Dependabot
- Supporte Gitea, GitLab, Bitbucket en plus de GitHub
- Regroupe les mises à jour par type pour réduire le bruit

---
layout: default
---

# Approvisionnement sécurisé : vue d'ensemble

```
   Développeur                CI/CD                   Production
       │                        │                          │
  package.json            npm ci (lock file)          Registre privé
  Cargo.toml              cargo audit                 (Nexus/Artifactory)
  pom.xml                 npm audit                        │
       │                  pip-audit                   Images scannées
  Lock file ◄─────────── OWASP DC                    (Trivy, Grype)
       │                  SBOM généré ──────────────► SBOM archivé
  Dependabot/                 │
  Renovate ──────────── PR automatique
```

> La sécurité de la supply chain est une **couche de défense**, pas un outil unique.

---
layout: center
class: text-center
---

# Conclusion

---
layout: default
---

# Conclusion

Les gestionnaires de paquets convergent sur les fonctionnalités :
- **Gestion des dépendances** (téléchargement, résolution, épinglage)
- **Reproductibilité** via les lock files
- **Orchestration du build**
- **Publication** vers des registres

**La supply chain logicielle est un vecteur d'attaque majeur** :
- Toujours committer les lock files
- Intégrer les audits (`npm audit`, `pip-audit`, `cargo audit`, OWASP DC) dans le pipeline CI/CD
- Générer des SBOMs (CycloneDX / SPDX) pour la traçabilité
- Utiliser un registre privé en entreprise (Nexus, Artifactory)
- Automatiser les mises à jour de sécurité (Dependabot, Renovate)


---
layout: section
---

# ❓ Questions ?

<div class="mt-6 text-xl opacity-80">

Des questions sur les différents gestionnaires de dépendances ?

</div>

<div class="mt-8 text-sm opacity-50">
Olivier Barais · Module DevSecOps
</div>

