# Anweisungen für Coding-Agents

Dieses Projekt ist ein Quarkus-Service (Java 21, Maven). Für Coding-Agents (GitHub Copilot, Claude Code und andere) gelten die folgenden Regeln verbindlich.

## Pflicht-Plugin css-baseline

Das Plugin `css-baseline@css-plugins` aus dem Marketplace https://scm.grudligstrasse.ch/css/copilot-plugins ist für dieses Repository vorgeschrieben. Es ist in `.github/copilot/settings.json` und `.claude/settings.json` hinterlegt.

- Prüfe zu Beginn jeder Session, ob die Skills `arc42-docs` und `kafka-event-design` verfügbar sind. Falls nicht: Arbeit an Architekturdoku oder Kafka-Events nicht beginnen, sondern auf `scripts/setup-ai-plugins.sh` hinweisen.
- **Architekturdokumentation:** Jede Änderung unter `docs/architecture/` sowie jede neue ADR erfolgt zwingend mit dem Skill `arc42-docs`.
- **Kafka-Events:** Jedes neue oder geänderte Topic, Event oder Avro-Schema (`src/main/avro/`) erfolgt zwingend mit dem Skill `kafka-event-design`. Namenskonventionen und Kompatibilitätsregeln aus dem Skill haben Vorrang vor eigenen Annahmen.
- Weicht eine Änderung bewusst von einem Skill ab, wird das in der Pull-Request-Beschreibung begründet.

## Build und Tests

- Entwicklung: `./mvnw quarkus:dev`
- Tests: `./mvnw verify`
- Vor jedem Commit müssen alle Tests grün sein.

## Sprache

Doku auf Deutsch in Schweizer Schreibweise (ss statt ß), Tech-Begriffe auf Englisch. Code, Bezeichner und Commit-Messages auf Englisch.
