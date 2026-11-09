# Junos pour Zed

Extension [Zed](https://zed.dev) pour les configurations Juniper Junos :

- format hiérarchique (`system { host-name r1; }`)
- format `display set` (`set system host-name r1`, `delete`, `deactivate`, …) et bannières `[edit …]`
- coloration : hiérarchies, valeurs, chaînes, commentaires `#` / `/* */`, IPv4/IPv6/préfixes, MAC, noms d'interfaces, variables `$junos-*`, wildcards `<*>`, actions (`accept`, `discard`, …), statut `inactive:`/`protect:`
- outline (Ctrl+Shift+O), indentation automatique, appariement des accolades

Extensions de fichiers reconnues : `.junos`, `.jcfg`, `.jnpr`. Zed détecte aussi le
contenu via la première ligne (`## Last commit`, `version …`, `set system …`).

## Structure

```
extension.toml          manifeste Zed
languages/junos/        config.toml + requêtes tree-sitter (highlights, brackets, indents, outline)
grammar/                grammaire tree-sitter (grammar.js) + tests
examples/               fichiers d'exemple
```

## Prérequis

- [Git](https://git-scm.com/)
- [Node.js](https://nodejs.org/) (pour `tree-sitter generate`)
- Visual Studio Build Tools (MSVC) pour `tree-sitter test` sous Windows
- `tree-sitter` CLI : installé localement via `cd grammar; npm install` (s'utilise avec `npx`)

## Développement

```powershell
cd grammar
npx tree-sitter generate      # produit grammar/src/parser.c (à committer)
npx tree-sitter test          # lance les tests du corpus
npx tree-sitter parse ..\examples\sample.junos
cd ..
git init; git add -A; git commit -m "Initial Junos extension"
git rev-parse HEAD        # copier ce hash dans extension.toml -> rev
```

Ensuite dans Zed : palette de commandes → **zed: install dev extension** → choisir ce dossier.
Après chaque modification de la grammaire : régénérer, committer, mettre à jour `rev`,
puis **zed: rebuild dev extension** (ou réinstaller).

## Publication

1. Pousser le dépôt sur GitHub et remplacer `repository` / `rev` dans `extension.toml`
   (`repository = "https://github.com/<vous>/zed-junos"`).
2. Remplir `authors` et le copyright de `LICENSE`.
3. Ouvrir une PR sur [zed-industries/extensions](https://github.com/zed-industries/extensions).
