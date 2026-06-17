# blueprint-clean directive — slug clean072

Target: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

Action: purity pass focused on the recently-added blocks (the chapter was edited by an
effort-breaker and a blueprint-writer since the last clean): the three new sub-lemma blocks
`lem:coreIso_comm_leg` (~line 8783), `lem:coreIso_comm_coface` (~8830), `lem:coreIso_comm_sum`
(~8861), the rewritten `lem:coreIso_comm` proof (~8894), and the `sectionCechAugV`-related
blocks near `lem:cechSection_complex_iso` / `lem:cechSection_contractible`. Strip Lean-tactic
leakage and project-history phrasing; keep operator-style names (`\operatorname{...}`) that
denote project declarations. Quick LaTeX sanity scan of the rest of the chapter only.

Constraints: do NOT alter any `\label{}`, `\lean{}`, `\uses{}` content or any marker. Do NOT
restructure proofs or change mathematical content. No new blocks.
