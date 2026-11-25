// ============================================================
// Polycopié — Cours 3 : Outils de build et gestionnaires de paquets
// Université de Rennes · IRISA / DiverSE
// Olivier Barais
// ============================================================

#set document(
  title: "Cours 3 — Outils de build et gestionnaires de paquets",
  author: "Olivier Barais",
  date: datetime(year: 2026, month: 9, day: 1),
)

#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm),
  header: context {
    if counter(page).get().first() > 1 [
      #set text(size: 8pt, fill: luma(130))
      #grid(columns: (1fr, 1fr),
        [DevSecOps — Cours 3 · Université de Rennes],
        align(right)[Olivier Barais]
      )
      #line(length: 100%, stroke: 0.5pt + luma(200))
    ]
  },
  footer: context [
    #set text(size: 8pt, fill: luma(130))
    #line(length: 100%, stroke: 0.5pt + luma(200))
    #v(2pt)
    #grid(columns: (1fr, 1fr),
      [IRISA / DiverSE · 2026],
      align(right)[Page #counter(page).display("1")]
    )
  ]
)

#set text(font: "New Computer Modern", size: 10.5pt, lang: "fr")
#set par(justify: true, leading: 0.65em, spacing: 1.2em)
#set heading(numbering: "1.1")

#show heading.where(level: 1): it => {
  v(1.5em)
  block(
    fill: rgb("#1e40af"),
    radius: 4pt,
    inset: (x: 10pt, y: 6pt),
    width: 100%,
    text(fill: white, size: 14pt, weight: "bold")[#it.body]
  )
  v(0.5em)
}

#show heading.where(level: 2): it => {
  v(0.8em)
  text(size: 12pt, weight: "bold", fill: rgb("#1d4ed8"))[#it.body]
  v(0.3em)
}

#show heading.where(level: 3): it => {
  v(0.5em)
  text(size: 11pt, weight: "bold", fill: rgb("#374151"))[#it.body]
  v(0.2em)
}

// Boîte d'alerte
#let alert(color: red, icon: "⚠", body) = block(
  fill: color.lighten(90%),
  stroke: 0.8pt + color,
  radius: 4pt,
  inset: 10pt,
  width: 100%,
)[
  #text(weight: "bold")[#icon  ] #body
]

// Boîte d'exemple
#let example(title, body) = block(
  fill: rgb("#f0f9ff"),
  stroke: (left: 3pt + rgb("#0ea5e9")),
  inset: (left: 12pt, right: 10pt, top: 8pt, bottom: 8pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#0369a1"))[Exemple — #title] \
  #v(4pt)
  #body
]

// Boîte de définition
#let definition(term, body) = block(
  fill: rgb("#f5f3ff"),
  stroke: (left: 3pt + rgb("#7c3aed")),
  inset: (left: 12pt, right: 10pt, top: 8pt, bottom: 8pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#6d28d9"))[Définition — #term] \
  #v(4pt)
  #body
]

// Boîte de retenir
#let keypoint(body) = block(
  fill: rgb("#fff7ed"),
  stroke: (left: 3pt + rgb("#ea580c")),
  inset: (left: 12pt, right: 10pt, top: 8pt, bottom: 8pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#c2410c"))[À retenir] \
  #v(4pt)
  #body
]

// Style des blocs de code
#show raw.where(block: true): it => block(
  fill: rgb("#0f172a"),
  radius: 4pt,
  inset: 10pt,
  width: 100%,
)[#text(fill: rgb("#94a3b8"), size: 9pt, font: "New Computer Modern")[#it]]

// ============================================================
// PAGE DE TITRE
// ============================================================

#align(center)[
  #v(2cm)
  #block(
    fill: rgb("#1e3a8a"),
    radius: 8pt,
    inset: 20pt,
    width: 90%,
  )[
    #text(fill: white, size: 11pt)[DevSecOps — Université de Rennes · IRISA / DiverSE]
    #v(8pt)
    #text(fill: white, size: 20pt, weight: "bold")[Cours 3]
    #v(4pt)
    #text(fill: rgb("#93c5fd"), size: 15pt)[Outils de build et gestionnaires de paquets]
    #v(4pt)
    #text(fill: rgb("#bfdbfe"), size: 11pt)[Maven · JavaScript · Python · Rust · Sécurité de la supply chain]
  ]

  #v(1.5cm)

  #text(size: 11pt, weight: "bold")[Olivier Barais]
  #linebreak()
  #text(size: 10pt, fill: luma(80))[Professeur des Universités · Université de Rennes]
  #linebreak()
  #text(size: 10pt, fill: luma(80))[IRISA UMR 6074 · Équipe DiverSE · INRIA]

  #v(1cm)
  #text(size: 9pt, fill: luma(100))[Année universitaire 2026–2027]

  #v(2cm)
]

#outline(
  title: "Table des matières",
  indent: 1em,
  depth: 2,
)

#pagebreak()

// ============================================================
// 1. INTRODUCTION
// ============================================================

= Introduction

== Pourquoi des outils de build ?

Le développement logiciel moderne est une activité industrielle impliquant de nombreux contributeurs, des milliers de dépendances, et des cibles de déploiement variées. Sans infrastructure de build structurée, chaque développeur opère dans son propre contexte, rendant la collaboration difficile et les déploiements fragiles.

#definition("Outil de build")[
  Un outil de build est un logiciel qui automatise la transformation du code source en artefacts déployables (exécutables, bibliothèques, images Docker…). Il prend en charge la compilation, l'exécution des tests, le packaging, et la gestion des dépendances.
]

Les problèmes qu'un outil de build doit résoudre sont multiples :

- *Reproductibilité* — le même code source doit produire exactement le même artefact, quel que soit le développeur ou la machine. L'absence de reproductibilité est une source majeure de vulnérabilités (@humble2010).
- *Gestion des dépendances* — un projet moderne dépend de centaines, voire de milliers de bibliothèques tierces. Résoudre automatiquement les versions compatibles et télécharger les artefacts depuis des dépôts centralisés est devenu indispensable.
- *Standardisation* — une structure de projet et un cycle de vie communs réduisent le temps d'intégration des nouveaux développeurs et facilitent la mise en place d'intégration continue.

== Le défi de la supply chain logicielle

Le code que nous écrivons directement ne représente qu'une fraction de ce qui s'exécute en production. Une application web moderne peut transitivement embarquer des centaines de bibliothèques tierces. Cette réalité fait de l'écosystème de paquets un vecteur d'attaque majeur.

Selon le rapport annuel de Sonatype @sonatype-ssc-2023, le nombre de paquets malveillants publiés sur les registres publics (npm, PyPI, Maven Central) a augmenté de 245 % entre 2021 et 2023. Comprendre les outils de build est donc indissociable de comprendre comment sécuriser la chaîne d'approvisionnement logicielle.

#keypoint[
  Ce cours présente les outils de build et les gestionnaires de paquets des quatre principaux écosystèmes (Java, JavaScript, Python, Rust), puis explique comment les utiliser de manière sécurisée dans le cadre d'une démarche DevSecOps, dont les principes sont détaillés dans le DevOps Handbook (@kim2016devops).
]

#pagebreak()

// ============================================================
// 2. MAVEN — L'ÉCOSYSTÈME JAVA
// ============================================================

= Maven — L'écosystème Java

== Présentation générale

Apache Maven est l'outil de build de référence pour l'écosystème Java. Créé en 2004 par Jason van Zyl au sein de la communauté Jakarta, il a imposé un paradigme nouveau résumé par la formule « Convention over Configuration » : plutôt que de décrire explicitement chaque étape du build, le développeur se conforme à une structure standard et Maven prend en charge le reste @apache-maven.

Maven remplit trois rôles complémentaires :

+ *Outil de build* — compilation des sources, exécution des tests, génération des rapports, packaging en JAR/WAR/EAR.
+ *Gestionnaire de dépendances* — résolution et téléchargement automatiques des bibliothèques depuis des dépôts distants, avec gestion des dépendances transitives.
+ *Outil de documentation* — génération de sites de projet incluant javadoc, rapports de tests, métriques de couverture.

== Le Project Object Model (POM)

Le cœur de Maven est le fichier `pom.xml` (Project Object Model), qui décrit le projet de façon déclarative. C'est l'unique source de vérité pour la configuration du build.

```xml
<project>
  <modelVersion>4.0.0</modelVersion>

  <!-- Coordonnées Maven du projet -->
  <groupId>fr.univ-rennes.devsecops</groupId>
  <artifactId>mon-application</artifactId>
  <version>1.0.0</version>
  <packaging>jar</packaging>

  <!-- Propriétés -->
  <properties>
    <maven.compiler.source>21</maven.compiler.source>
    <maven.compiler.target>21</maven.compiler.target>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
  </properties>

  <!-- Dépendances -->
  <dependencies>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
      <version>3.2.0</version>
    </dependency>
    <dependency>
      <groupId>org.junit.jupiter</groupId>
      <artifactId>junit-jupiter</artifactId>
      <version>5.10.1</version>
      <scope>test</scope>
    </dependency>
  </dependencies>
</project>
```

Les coordonnées Maven (`groupId`, `artifactId`, `version`) identifient un artefact de façon unique dans l'univers des dépôts publics. Ces trois éléments, appelés « GAV », sont le système d'adressage universel de Maven Central.

== L'organisation standard des répertoires

Maven impose une structure de répertoires standard que tous les projets Java utilisent :

```
mon-projet/
├── pom.xml
└── src/
    ├── main/
    │   ├── java/          ← Sources Java de production
    │   └── resources/     ← Ressources (properties, XML…)
    └── test/
        ├── java/          ← Sources Java de test
        └── resources/     ← Ressources de test
```

Cette convention présente deux avantages importants. D'une part, un développeur familier de n'importe quel projet Maven peut immédiatement s'orienter dans un projet inconnu. D'autre part, les outils (IDEs, CI, scanners de sécurité) connaissent cette structure et peuvent opérer sans configuration supplémentaire @maven-getting-started.

== Le cycle de vie Maven

Maven définit un cycle de vie composé de phases ordonnées. Exécuter une phase déclenche automatiquement toutes les phases précédentes @maven-lifecycle.

#figure(
  table(
    columns: (auto, 1fr),
    stroke: 0.5pt,
    fill: (col, row) => if row == 0 { rgb("#dbeafe") } else if calc.odd(row) { rgb("#f8fafc") } else { white },
    [*Phase*], [*Action*],
    [`clean`], [Supprime le répertoire `target/` (artefacts précédents)],
    [`validate`], [Vérifie que le POM est correct et complet],
    [`compile`], [Compile les sources Java de `src/main/java/`],
    [`test`], [Exécute les tests unitaires (JUnit, TestNG)],
    [`package`], [Emballe le code compilé en JAR, WAR ou EAR],
    [`verify`], [Exécute les tests d'intégration et vérifie les résultats],
    [`install`], [Installe l'artefact dans le dépôt local (`~/.m2/`)],
    [`deploy`], [Copie l'artefact vers le dépôt distant partagé],
  ),
  caption: "Phases principales du cycle de vie Maven",
)

== Les dépôts d'artefacts

Maven repose sur un système hiérarchique de dépôts @maven-getting-started :

+ *Le dépôt local* (`~/.m2/repository/`) — cache sur la machine du développeur. Maven y cherche d'abord avant tout téléchargement réseau.
+ *Les dépôts distants* — serveurs HTTP hébergeant des artefacts. Maven Central (`https://repo.maven.apache.org/maven2/`) est le dépôt public de référence.
+ *Le dépôt d'entreprise* (Nexus, Artifactory) — proxy interne qui centralise et filtre les artefacts.

#alert(color: rgb("#0369a1"), icon: "ℹ")[
  Toutes les URLs de dépôts Maven doivent être en HTTPS. Les URLs en HTTP sont désactivées par défaut depuis Maven 3.8.1 (2021) pour prévenir les attaques de type « man-in-the-middle » sur les artefacts téléchargés.
]

== La gestion des dépendances

=== Scopes de dépendances

Le scope d'une dépendance détermine dans quelles phases elle est disponible :

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-web</artifactId>
  <version>3.2.0</version>
  <scope>compile</scope>   <!-- disponible partout, incluse dans le JAR -->
</dependency>

<dependency>
  <groupId>org.junit.jupiter</groupId>
  <artifactId>junit-jupiter</artifactId>
  <version>5.10.1</version>
  <scope>test</scope>      <!-- uniquement pour les tests, exclue du JAR -->
</dependency>

<dependency>
  <groupId>javax.servlet</groupId>
  <artifactId>javax.servlet-api</artifactId>
  <version>4.0.1</version>
  <scope>provided</scope>  <!-- fournie par le serveur, exclue du JAR -->
</dependency>
```

=== Dépendances transitives

Maven résout automatiquement les dépendances transitives : si votre projet dépend de A, et que A dépend de B, Maven télécharge A et B. Cette fonctionnalité est puissante mais constitue aussi un vecteur d'attaque : une vulnérabilité dans B vous affecte même si vous n'avez jamais entendu parler de B.

```xml
<!-- Exclure une dépendance transitive problématique -->
<dependency>
  <groupId>org.apache.logging.log4j</groupId>
  <artifactId>log4j-core</artifactId>
  <version>2.20.0</version>
  <exclusions>
    <exclusion>
      <groupId>org.apache.logging.log4j</groupId>
      <artifactId>log4j-api</artifactId>
    </exclusion>
  </exclusions>
</dependency>
```

== Plugins Maven essentiels

Les plugins Maven étendent le cycle de vie. Voici les plugins pertinents pour un projet DevSecOps :

```xml
<build>
  <plugins>
    <!-- Compiler Java 21 -->
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-compiler-plugin</artifactId>
      <version>3.12.1</version>
      <configuration>
        <source>21</source>
        <target>21</target>
      </configuration>
    </plugin>

    <!-- Tests : rapport Surefire -->
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-surefire-plugin</artifactId>
      <version>3.2.5</version>
    </plugin>

    <!-- Couverture de code : JaCoCo -->
    <plugin>
      <groupId>org.jacoco</groupId>
      <artifactId>jacoco-maven-plugin</artifactId>
      <version>0.8.11</version>
    </plugin>

    <!-- Analyse statique : SpotBugs -->
    <plugin>
      <groupId>com.github.spotbugs</groupId>
      <artifactId>spotbugs-maven-plugin</artifactId>
      <version>4.8.3.0</version>
    </plugin>

    <!-- Vulnérabilités : OWASP Dependency-Check -->
    <plugin>
      <groupId>org.owasp</groupId>
      <artifactId>dependency-check-maven</artifactId>
      <version>9.0.9</version>
    </plugin>

    <!-- SBOM : CycloneDX -->
    <plugin>
      <groupId>org.cyclonedx</groupId>
      <artifactId>cyclonedx-maven-plugin</artifactId>
      <version>2.7.11</version>
    </plugin>
  </plugins>
</build>
```

#alert(color: rgb("#dc2626"), icon: "⚠")[
  L'OWASP Dependency-Check (@owasp-dc) compare les dépendances de votre projet aux CVE (Common Vulnerabilities and Exposures) de la base NVD du NIST. Son intégration dans le pipeline CI/CD est la pratique minimale pour un projet DevSecOps.
]

#pagebreak()

// ============================================================
// 3. L'ÉCOSYSTÈME JAVASCRIPT
// ============================================================

= L'écosystème JavaScript

== Présentation

L'écosystème JavaScript est le plus grand écosystème de paquets au monde. Le registre npm (Node Package Manager) hébergeait plus de 2,5 millions de paquets en 2024, avec plus de 100 milliards de téléchargements mensuels @npm-docs. Cette taille fait de npm le registre à la fois le plus utile et le plus attaqué.

L'écosystème JS se structure autour de trois catégories d'outils :

+ *Gestionnaires de paquets* — npm, Yarn, pnpm, Bun : gèrent les dépendances et leurs lock files.
+ *Bundlers et build tools* — Vite, esbuild, Rollup, Webpack : transforment, optimisent et empaquettent les sources.
+ *Scaffolding* — `create-vite`, `create-next-app`, JHipster : génèrent la structure initiale d'un projet.

== Les gestionnaires de paquets

=== npm — le gestionnaire historique

npm est fourni avec Node.js et reste le gestionnaire de référence. Le fichier `package.json` déclare les dépendances du projet :

```json
{
  "name": "mon-application",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.2",
    "react": "^18.2.0"
  },
  "devDependencies": {
    "vite": "^5.0.0",
    "vitest": "^1.0.0"
  }
}
```

Les commandes essentielles :

```bash
npm install express --save        # ajoute à dependencies
npm install vite --save-dev       # ajoute à devDependencies
npm install                       # installe depuis package.json
npm ci                            # installe depuis package-lock.json (CI/CD)
npm run build                     # exécute le script "build"
npm audit                         # analyse les vulnérabilités connues
```

#alert(color: rgb("#0369a1"), icon: "ℹ")[
  La différence entre `npm install` et `npm ci` est critique en CI/CD. `npm install` peut mettre à jour le lock file si `package.json` a changé. `npm ci` refuse d'exécuter si le lock file est incohérent et supprime `node_modules/` avant d'installer. C'est toujours `npm ci` qu'il faut utiliser en pipeline (@npm-docs).
]

=== pnpm — efficacité et rigueur

pnpm (@pnpm-docs) résout deux problèmes structurels de npm :

*Le problème d'espace disque* : npm duplique les paquets dans chaque `node_modules/`. pnpm maintient un store global et crée des liens symboliques. Sur un poste de développement avec de nombreux projets, le gain peut atteindre un facteur 10.

*Le problème des dépendances fantômes* : npm (et Yarn) placent les dépendances transitives directement dans `node_modules/`, ce qui permet au code applicatif d'importer un paquet non déclaré dans `package.json`. pnpm l'interdit par construction.

```bash
npm install -g pnpm
pnpm install
pnpm add express
pnpm install --frozen-lockfile   # équivalent de npm ci
```

=== Bun — rapidité extrême

Bun (@bun-docs) est à la fois un runtime JavaScript (alternative à Node.js) et un gestionnaire de paquets. Écrit en Zig, il annonce des installations jusqu'à 20 fois plus rapides que npm (chiffres annoncés par ses auteurs). Il est compatible avec `package.json` et peut remplacer npm sans modification du projet.

```bash
bun install         # installe depuis package.json
bun add express     # ajoute une dépendance
bun run build       # exécute le script "build"
```

== Les lock files en JavaScript

Chaque gestionnaire génère un lock file qui épingle les versions exactes de toutes les dépendances (directes et transitives) :

#figure(
  table(
    columns: (auto, auto, 1fr),
    stroke: 0.5pt,
    fill: (col, row) => if row == 0 { rgb("#dbeafe") } else if calc.odd(row) { rgb("#f8fafc") } else { white },
    [*Gestionnaire*], [*Lock file*], [*Format*],
    [npm], [`package-lock.json`], [JSON (verbose, déterministe)],
    [Yarn], [`yarn.lock`], [Format propriétaire Yarn],
    [pnpm], [`pnpm-lock.yaml`], [YAML],
    [Bun], [`bun.lockb`], [Binaire (très compact)],
  ),
  caption: "Lock files selon le gestionnaire de paquets JS",
)

#keypoint[
  Toujours committer le lock file dans le dépôt Git. Il documente l'état exact des dépendances qui a produit un build réussi. Sans lui, les dépendances transitives peuvent silencieusement changer d'une version à l'autre, ouvrant la porte aux attaques de type « dependency confusion » ou « typosquatting ».
]

== Les bundlers modernes

Les bundlers transforment le code source (TypeScript, JSX, SASS…) en fichiers optimisés pour le navigateur ou Node.js. L'ère Grunt/Gulp (2013–2018) est révolue ; voici les outils actuels :

=== Vite

Vite (@vite-docs), créé par Evan You (auteur de Vue.js), est devenu le standard de facto pour le développement front-end en 2023. Son approche repose sur les ES modules natifs du navigateur pendant le développement (pas de bundling → démarrage instantané) et sur Rollup pour la production.

```bash
npm create vite@latest mon-app -- --template react
cd mon-app && npm install
npm run dev      # serveur de développement avec HMR
npm run build    # build de production via Rollup
```

=== esbuild

esbuild (@esbuild-docs), écrit en Go par Evan Wallace (cofondateur de Figma), est le moteur de transformation le plus rapide disponible. Il est utilisé en interne par Vite, Parcel et de nombreux autres outils. Son API permet de l'intégrer dans des pipelines de build personnalisés.

=== Tableau comparatif

#figure(
  table(
    columns: (auto, 1fr, auto),
    stroke: 0.5pt,
    fill: (col, row) => if row == 0 { rgb("#dbeafe") } else if calc.odd(row) { rgb("#f8fafc") } else { white },
    [*Outil*], [*Usage principal*], [*Performance*],
    [Vite], [Applications front-end, dev server HMR], [⚡ Très rapide],
    [esbuild], [Transpilation et bundling, pipeline CI], [⚡⚡ Extrêmement rapide],
    [Rollup], [Bibliothèques, tree-shaking fin], [Rapide],
    [Webpack], [Applications complexes, héritage], [Lent mais très configurable],
    [Turbopack], [Successeur Webpack pour Next.js], [⚡⚡],
  ),
  caption: "Comparaison des bundlers JavaScript en 2024",
)

#pagebreak()

// ============================================================
// 4. L'ÉCOSYSTÈME PYTHON
// ============================================================

= L'écosystème Python

Python est l'un des langages les plus utilisés au monde, notamment pour la data science, l'IA et les scripts d'automatisation. Cependant, la gestion des dépendances Python a longtemps été une source de difficultés par rapport à des environnements plus récents comme Rust ou JavaScript.

== pip et requirements.txt

pip est l'installeur de paquets officiel de Python, fourni avec toute installation de Python depuis la version 3.4. Les dépendances sont déclarées dans un fichier `requirements.txt` :

```
redis==2.10.6
rq==0.13
flask>=2.0.0,<3.0.0
```

```bash
pip install -r requirements.txt
```

Il est recommandé d'utiliser des versions exactes (opérateur `==`) pour garantir la reproductibilité des builds. Les plages de versions (`>=`, `<`) peuvent conduire à des builds non déterministes.

== Les problèmes structurels de pip

=== L'isolation des environnements

pip installe les paquets dans le Python système ou dans un environnement virtuel. Sans virtualenv, tous les projets Python de la machine partagent le même jeu de paquets, ce qui conduit à des conflits de versions.

```bash
# Créer un environnement virtuel
python3 -m venv .venv
source .venv/bin/activate    # Linux/macOS
.venv\Scripts\activate       # Windows

pip install -r requirements.txt
```

=== Les dépendances incompatibles

pip ne résout pas les conflits de dépendances avant l'installation. L'exemple suivant illustre le problème avec deux paquets incompatibles :

```
redis==2.10.6
rq==0.13
```

```bash
$ pip install -r requirements.txt
Collecting redis==2.10.6
  Using cached redis-2.10.6-py2.py3-none-any.whl
Collecting rq==1.0
  Using cached rq-1.0-py2.py3-none-any.whl
ERROR: rq 1.0 has requirement redis>=3.0.0, but you'll have redis 2.10.6 which is incompatible.
Installing collected packages: redis, click, rq
Successfully installed click-7.0 redis-2.10.6 rq-1.0
```

Pip affiche une erreur mais installe quand même les paquets dans un état incohérent. Le paquet `rq` est inutilisable et le développeur doit résoudre manuellement la compatibilité.

=== Les paquets résiduels

Supprimer une dépendance de `requirements.txt` ne la désinstalle pas. Ces paquets résiduels peuvent :
- Créer une fausse dépendance implicite (le code utilise un paquet non déclaré)
- Altérer silencieusement le comportement d'autres paquets

Le seul remède fiable est de supprimer le virtualenv et de relancer une installation propre.

== Les alternatives modernes

=== pip-tools

pip-tools (@pip-tools) résout les problèmes de mise à jour et de paquets résiduels avec un workflow en deux fichiers :

- `requirements.in` — liste des dépendances *directes* seulement
- `requirements.txt` — généré par pip-tools, liste toutes les dépendances (directes + transitives) avec versions exactes

```bash
pip install pip-tools

# requirements.in
# flask>=2.0
# redis>=3.0

pip-compile requirements.in     # génère requirements.txt avec versions épinglées
pip-sync requirements.txt        # synchronise l'environnement (désinstalle les résidus)
```

=== Pipenv

Pipenv (@pipenv-docs) est l'outil officiel de la Python Packaging Authority (PyPA). Il crée et gère automatiquement un virtualenv pour chaque projet et génère un `Pipfile.lock` pour les builds déterministes.

```bash
pip install pipenv

pipenv install flask     # ajoute au Pipfile et met à jour Pipfile.lock
pipenv install --dev pytest  # dépendance de développement
pipenv install           # installe depuis Pipfile.lock
pipenv shell             # active le virtualenv
```

=== Poetry

Poetry (@poetry-docs) est devenu l'outil le plus populaire pour les projets Python modernes. Il combine gestion des dépendances, environnements virtuels, et publication de paquets.

```bash
# Installation
curl -sSL https://install.python-poetry.org | python3 -

# Créer un projet
poetry new mon-projet
cd mon-projet

# Gérer les dépendances
poetry add flask             # production
poetry add pytest --group dev  # développement

# Build reproductible
poetry install               # depuis poetry.lock si présent
poetry update                # met à jour et régénère poetry.lock
poetry build                 # crée les distributions wheel et sdist
```

Le fichier `pyproject.toml` (PEP 518, 2016) est devenu le standard de configuration Python moderne, utilisé par Poetry, Flit, Hatch et d'autres outils.

=== uv — la nouvelle génération

uv (@uv-docs), développé par Astral en Rust, est un gestionnaire de paquets et de projets Python conçu pour unifier, en un seul outil et beaucoup plus rapidement, pip, pip-tools, virtualenv, pipenv, pyenv et Poetry. C'est l'approche « tout-en-un » que l'écosystème Node.js connaît déjà avec les gestionnaires modernes.

```bash
uv init mon-projet        # crée un projet (pyproject.toml)
cd mon-projet
uv add requests           # met à jour pyproject.toml + verrouille uv.lock
uv run python main.py     # crée l'environnement isolé puis exécute
uv sync                   # installe l'environnement exactement d'après uv.lock
```

Les atouts de uv en matière de reproductibilité et de sécurité :

- *Vitesse* — la résolution et l'installation sont généralement 10 à 100 fois plus rapides que pip.
- *Un seul verrou* — `uv.lock` est un fichier de verrouillage déterministe et multi-plateformes, avec versions épinglées et *checksums* SHA-256 vérifiés des artefacts téléchargés.
- *Compatibilité pip* — deux modes coexistent : le mode « projet » (`uv add`, `uv sync`) et le mode « pip » (`uv pip install -r requirements.txt`), ce qui rend la migration progressive et sans rupture.
- *Audit intégré* — `uv audit` compare les dépendances à une base de vulnérabilités connues.

C'est un modèle « lock file comme mécanisme de sécurité » au même titre que `package-lock.json` côté Node.js.

#figure(
  table(
    columns: (auto, auto, auto, auto),
    stroke: 0.5pt,
    fill: (col, row) => if row == 0 { rgb("#dbeafe") } else if calc.odd(row) { rgb("#f8fafc") } else { white },
    [*Outil*], [*Lock file*], [*Virtualenv auto*], [*Résolution de conflits*],
    [pip], [Non], [Non], [Non],
    [pip-tools], [`requirements.txt`], [Non], [Partiel],
    [Pipenv], [`Pipfile.lock`], [Oui], [Oui],
    [Poetry], [`poetry.lock`], [Oui], [Oui],
    [uv], [`uv.lock`], [Oui], [Oui],
  ),
  caption: "Comparaison des gestionnaires de paquets Python",
)

#pagebreak()

// ============================================================
// 5. L'ÉCOSYSTÈME RUST
// ============================================================

= L'écosystème Rust

== Cargo : build system et gestionnaire de paquets

Rust est livré avec Cargo (@cargo-docs), un outil qui fait figure de modèle dans le monde des gestionnaires de paquets. Cargo est à la fois :

- Le *build system* (compilation, tests, benchmarks, documentation)
- Le *gestionnaire de paquets* (dépendances via crates.io)
- Le *gestionnaire d'environnements* (pas besoin de virtualenv)

```bash
cargo new mon-projet         # crée un nouveau projet
cargo build                  # compile en mode debug
cargo build --release        # compile en mode optimisé
cargo test                   # exécute les tests
cargo doc --open             # génère et ouvre la documentation
cargo publish                # publie sur crates.io
```

La publication des nouvelles crates se fait sur le registre communautaire crates.io (@crates-io).

== Le manifeste Cargo.toml

Le fichier `Cargo.toml` décrit le projet et ses dépendances avec la syntaxe TOML :

```toml
[package]
name = "mon-application"
version = "0.1.0"
edition = "2021"

[dependencies]
serde = { version = "1.0", features = ["derive"] }
tokio = { version = "1", features = ["full"] }
reqwest = { version = "0.11", features = ["json"] }

[dev-dependencies]
tokio-test = "0.4"
```

Les versions suivent le Semantic Versioning (@semver). La spécification `"1.0"` dans Cargo.toml est équivalente à `>=1.0.0, <2.0.0` : Cargo peut mettre à jour vers 1.5.0, mais pas vers 2.0.0.

== Cargo.toml vs Cargo.lock

La distinction entre ces deux fichiers est fondamentale :

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    stroke: 0.5pt,
    fill: (col, row) => if row == 0 { rgb("#dbeafe") } else if calc.odd(row) { rgb("#f8fafc") } else { white },
    [*Fichier*], [*Cargo.toml*], [*Cargo.lock*],
    [Auteur], [Le développeur], [Cargo (automatique)],
    [Contenu], [Contraintes de version SemVer], [Versions exactes + checksums],
    [Git], [Toujours committer], [Binaire → oui, Lib → non],
    [Rôle], [Spécification des besoins], [Reproductibilité garantie],
  ),
  caption: "Comparaison Cargo.toml / Cargo.lock",
)

Le `Cargo.lock` contient les *checksums cryptographiques* (SHA-256) de chaque paquet téléchargé. Cargo vérifie ces checksums à chaque build, ce qui détecte toute altération du contenu d'un paquet sur crates.io.

```toml
[[package]]
name = "serde"
version = "1.0.197"
source = "registry+https://github.com/rust-lang/crates.io-index"
checksum = "3fb1c873e1b9b056a4dc4c0c198b24c3ffa059243875552b2bd0933b1aee4ce2"
```

#keypoint[
  *Binaires* : toujours committer `Cargo.lock` pour garantir que tous les développeurs et le CI/CD utilisent exactement les mêmes versions.
  *Bibliothèques* : ne pas committer `Cargo.lock` pour permettre aux consommateurs de résoudre leurs propres contraintes.
]

#pagebreak()

// ============================================================
// 6. SÉCURISER SES DÉPENDANCES
// ============================================================

= Sécuriser ses dépendances

La supply chain logicielle est devenue un vecteur d'attaque majeur. Les analyses empiriques des réseaux de dépendances montrent l'ampleur du phénomène à l'échelle des écosystèmes (@decan2019npm). L'étude de Zimmermann et al. @zimmermann2019malicious a montré que 40 % des paquets npm les plus populaires dépendent d'au moins un paquet maintenu par une seule personne, ce qui en fait une cible de choix.

== Incidents notables

=== event-stream (2018)

En 2018, un attaquant a convaincu le mainteneur légitime du paquet `event-stream` (2 millions de téléchargements/semaine) de lui céder la maintenance. Il a ensuite ajouté une dépendance malveillante, `flatmap-stream`, qui ciblait spécifiquement les portefeuilles Copay (Bitcoin) @event-stream-postmortem.

L'attaque est restée non détectée pendant deux mois car :
- Le code malveillant était chiffré (obfusqué en base64)
- Il ne s'activait que dans un environnement très spécifique (Copay)
- Les lock files n'étaient pas vérifiés systématiquement

=== ua-parser-js (2021)

Le paquet `ua-parser-js` (8 millions de téléchargements/semaine) a été compromis via le vol du compte npm de son mainteneur. Trois versions malveillantes ont été publiées en quelques heures, installant un mineur de crypto-monnaie et un cheval de Troie @ua-parser-attack.

=== colors.js et faker.js (2022)

Marak Squires, mainteneur des bibliothèques `colors.js` et `faker.js` (utilisées par des millions de projets), a *volontairement* publié des versions sabotées en signe de protestation contre l'exploitation des développeurs open source @colors-sabotage. Cet incident a illustré la fragilité de la dépendance à un seul mainteneur.

=== node-ipc (2022)

Le mainteneur du paquet `node-ipc` a inséré du code qui, s'il détectait une adresse IP russe ou biélorusse, effaçait des fichiers sur le système @node-ipc-attack. Ce type d'attaque, appelé « protestware », illustre que la menace peut venir du mainteneur légitime lui-même.

#alert(color: rgb("#dc2626"), icon: "⚠")[
  Ces incidents partagent un point commun : ils ont touché des projets avec des milliers de dépendants parce que l'écosystème repose sur une chaîne de confiance implicite. Vos dépendances directes sont rarement le problème — ce sont leurs dépendances transitives qui vous exposent.
]

== Le typosquatting

Le typosquatting consiste à publier un paquet malveillant avec un nom presque identique à un paquet légitime et populaire, dans l'espoir que des développeurs commettent une faute de frappe lors de l'installation.

```
# Packages légitimes vs imposteurs courants
requests  →  requestes, python-request, request
django    →  djang0, Djang0, djangoo
numpy     →  numpay, num-py, numpi
lodash    →  1odash, Iodash, lodahs
```

Selon le rapport Sonatype @sonatype-ssc-2023, le nombre de paquets typosquattés détectés a augmenté de 315 % en 2023 par rapport à 2022.

*Mécanismes de défense :*

- Vérifier soigneusement l'orthographe et le nombre de téléchargements avant d'installer un paquet
- Utiliser un registre privé qui bloque les paquets non approuvés (voir section 6.5)
- Activer la protection de namespace (npm Organizations)
- Lire les changelogs avant une mise à jour majeure

== Les lock files comme mécanisme de sécurité

Le lock file n'est pas qu'un outil de reproductibilité : c'est une *ligne de défense contre la supply chain*.

```bash
# npm : utiliser npm ci, jamais npm install en CI/CD
npm ci

# Yarn : refuser si le lock file est incohérent
yarn install --frozen-lockfile

# pnpm
pnpm install --frozen-lockfile

# Rust : Cargo vérifie les checksums automatiquement
cargo build

# Python : utiliser pip-sync (pip-tools) ou poetry install
pip-sync requirements.txt
poetry install
```

*Ce que le lock file empêche :*
- La résolution d'une version différente (et potentiellement compromise) lors d'un rebuild
- L'injection silencieuse d'une nouvelle version d'une dépendance transitive
- Les variations de comportement entre environnements (dev / CI / prod)

== Les audits de dépendances

Chaque écosystème dispose d'un outil d'audit qui compare les dépendances aux bases de vulnérabilités connues (CVE/NVD) :

```bash
# JavaScript / Node.js
npm audit
npm audit fix                # corrige automatiquement si possible
npm audit --audit-level=high # échec CI si vulnérabilité haute ou critique

# Python
pip install pip-audit
pip-audit -r requirements.txt
pip-audit --fix

# Rust
cargo install cargo-audit
cargo audit
cargo audit fix

# Java / Maven
mvn org.owasp:dependency-check-maven:check
```

Chaque écosystème dispose de son outil dédié, documenté auprès du registre correspondant : `npm audit` (@npm-audit), `pip-audit` (@pip-audit), `cargo audit` (@cargo-audit) et l'OWASP Dependency-Check pour Maven (@owasp-dc).

Ces commandes interrogent la base NVD (National Vulnerability Database) du NIST (@owasp-dc) et renvoient la liste des CVE affectant vos dépendances avec leur score CVSS (Common Vulnerability Scoring System).

Pour la production conteneurisée, l'audit des dépendances se prolonge au niveau des images applicatives : des scanners de registre comme Trivy ou Grype analysent les images Docker (système, dépendances, binaries) au moment du build, ce qui complète la chaîne de défense au-delà du code source.

#keypoint[
  Intégrer ces commandes dans le pipeline CI/CD est la pratique minimale pour un projet DevSecOps. Un build doit échouer si des vulnérabilités de sévérité « haute » ou « critique » sont détectées dans les dépendances.
]

== Les SBOMs — Software Bill of Materials

Un SBOM est une liste machine-readable de *tous les composants* d'une application : dépendances directes, transitives, versions, licences, hachages. C'est l'équivalent logiciel d'une liste d'ingrédients alimentaire.

*Pourquoi c'est devenu incontournable :*
- L'Executive Order américain 14028 (mai 2021) @us-eo-sbom exige des SBOMs pour tout logiciel vendu au gouvernement fédéral américain.
- Le Cyber Resilience Act européen @eu-cra (adopté en mars 2024) impose des exigences similaires pour les produits numériques mis sur le marché de l'UE.

*Formats standards :*
- *CycloneDX* (OWASP, @cyclonedx-spec) — le plus adopté dans la communauté sécurité, formats JSON et XML.
- *SPDX* (Linux Foundation, @spdx-spec) — standard ISO/IEC 5962:2021, historiquement orienté licences.

CycloneDX est supporté sur tous les écosystèmes, y compris via le plugin Maven dédié (@cyclonedx-maven) :

```bash
# Maven → CycloneDX
mvn cyclonedx:makeBom

# npm → SBOM SPDX
npm sbom --sbom-format spdx

# Python → CycloneDX
pip install cyclonedx-bom && cyclonedx-py requirements

# Rust → CycloneDX
cargo install cargo-cyclonedx && cargo cyclonedx
```

== Les registres privés

En entreprise, interposer un registre privé entre les développeurs et les registres publics est une défense essentielle :

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    stroke: 0.5pt,
    fill: (col, row) => if row == 0 { rgb("#dbeafe") } else if calc.odd(row) { rgb("#f8fafc") } else { white },
    [*Fonctionnalité*], [*Nexus Repository* (@nexus-repo)], [*Artifactory* (@artifactory)],
    [Proxy des registres publics], [Oui], [Oui],
    [Scan de vulnérabilités], [Via Sonatype Lifecycle], [Via JFrog Xray],
    [Blocage de paquets], [Oui], [Oui],
    [Formats supportés], [npm, Maven, pip, Cargo…], [Tous (universel)],
    [Rétention hors-ligne], [Oui], [Oui],
  ),
  caption: "Comparaison des principaux registres privés",
)

Un registre privé remplit plusieurs fonctions de sécurité :
- *Bloque les paquets non approuvés* : seuls les paquets validés par l'équipe de sécurité sont accessibles.
- *Détecte les typosquats* : les noms de paquets sont vérifiés avant approbation.
- *Maintient la disponibilité* : le code peut être construit même si le registre public est inaccessible (panne de npm, retrait de paquet…).
- *Scan continu* : les nouvelles CVE sont vérifiées sur les paquets déjà en cache.

```bash
# Configurer npm pour utiliser un registre privé
npm config set registry https://nexus.monentreprise.fr/repository/npm-proxy/

# pip
pip install --index-url https://nexus.monentreprise.fr/repository/pypi-proxy/simple/ flask
```

== Dependabot et Renovate — les mises à jour automatisées

Maintenir les dépendances à jour manuellement est une tâche fastidieuse que personne ne fait régulièrement. Dependabot (@dependabot-docs) et Renovate (@renovate-docs) automatisent ce travail en ouvrant des Pull Requests dès qu'une nouvelle version est disponible.

=== Dependabot (intégré à GitHub)

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 5
    groups:
      dev-dependencies:
        patterns: ["*"]
        dependency-type: "development"

  - package-ecosystem: "maven"
    directory: "/"
    schedule:
      interval: "weekly"

  - package-ecosystem: "cargo"
    directory: "/"
    schedule:
      interval: "weekly"
```

=== Renovate

Renovate (@renovate-docs) est une alternative open source, plus configurable que Dependabot. Il supporte plus de gestionnaires de paquets (Terraform, Docker, Helm…) et peut être auto-hébergé.

```json
{
  "extends": ["config:recommended"],
  "schedule": ["before 6am on monday"],
  "automerge": true,
  "automergeType": "pr",
  "packageRules": [
    {
      "matchUpdateTypes": ["minor", "patch"],
      "automerge": true
    },
    {
      "matchUpdateTypes": ["major"],
      "automerge": false,
      "labels": ["major-update"]
    }
  ]
}
```

L'option `automerge: true` pour les mises à jour mineures et de patch est sûre lorsque le pipeline CI/CD est robuste : si les tests passent, la PR est fusionnée automatiquement.

== Le framework SLSA

SLSA (Supply-chain Levels for Software Artifacts, @slsa-framework) est un framework de l'Open Source Security Foundation (OpenSSF) qui définit quatre niveaux de maturité pour la sécurité de la supply chain :

- *Niveau 1* — Le processus de build est documenté et automatisé.
- *Niveau 2* — Le build est déclenché par un service d'intégration continue vérifiable.
- *Niveau 3* — Le build est isolé et les sources sont tracées.
- *Niveau 4* — Revues de code, builds hermétiques, reproductibles.

La plupart des projets open source majeurs visent SLSA 2 ou 3 en 2024.

#pagebreak()

// ============================================================
// 7. CONCLUSION
// ============================================================

= Conclusion

== Synthèse par écosystème

Les gestionnaires de paquets des différents écosystèmes ont convergé vers un ensemble de fonctionnalités communes : déclaration déclarative des dépendances, résolution automatique des dépendances transitives, lock files pour la reproductibilité, et commandes de build standardisées.

#figure(
  table(
    columns: (auto, auto, auto, auto),
    stroke: 0.5pt,
    fill: (col, row) => if row == 0 { rgb("#dbeafe") } else if calc.odd(row) { rgb("#f8fafc") } else { white },
    [*Écosystème*], [*Outil principal*], [*Lock file*], [*Audit sécurité*],
    [Java], [Maven], [Non natif\ (pom.xml + BOM)], [`dependency-check-maven`],
    [JavaScript], [npm / pnpm], [`package-lock.json`\ `pnpm-lock.yaml`], [`npm audit`],
    [Python], [Poetry / Pipenv], [`poetry.lock`\ `Pipfile.lock`], [`pip-audit`],
    [Rust], [Cargo], [`Cargo.lock`], [`cargo-audit`],
  ),
  caption: "Synthèse des outils par écosystème",
)

== Les bonnes pratiques DevSecOps

+ *Toujours committer le lock file* et utiliser la commande « frozen » en CI/CD (`npm ci`, `cargo build`, `poetry install`).
+ *Intégrer les audits de dépendances* (`npm audit`, `pip-audit`, `cargo audit`, OWASP Dependency-Check) dans le pipeline CI/CD et faire échouer le build sur les vulnérabilités « haute » et « critique ».
+ *Générer des SBOMs* (CycloneDX ou SPDX) à chaque release et les archiver avec l'artefact.
+ *Utiliser un registre privé* (Nexus, Artifactory) en entreprise pour filtrer les paquets et maintenir la disponibilité.
+ *Automatiser les mises à jour* avec Dependabot ou Renovate pour ne pas accumuler de dette de sécurité.
+ *Vérifier soigneusement les noms* de paquets avant installation pour éviter le typosquatting.

#alert(color: rgb("#dc2626"), icon: "⚠")[
  La sécurité de la supply chain n'est pas un outil unique mais une couche de défense : lock files + audits + SBOM + registre privé + mises à jour automatisées. L'absence de l'une de ces pratiques laisse une fenêtre ouverte.
]

== Perspectives

Le framework SLSA (@slsa-framework) et l'initiative Sigstore (@sigstore) définissent les pratiques de la prochaine génération : signatures cryptographiques de tous les artefacts de build, attestations vérifiables de provenance, et builds hermétiques reproductibles. Ces approches permettront de répondre à des attaques encore plus sophistiquées, où l'outil de build lui-même serait compromis (attaque de type SolarWinds).

La réglementation (@eu-cra, @us-eo-sbom) va également durcir les exigences : d'ici 2026, tout produit logiciel mis sur le marché européen devra fournir un SBOM et démontrer un processus de gestion des vulnérabilités actif.

// ============================================================
// BIBLIOGRAPHIE
// ============================================================

#pagebreak()

#bibliography("refs.bib", title: "Références", style: "ieee")
