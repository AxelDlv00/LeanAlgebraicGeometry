# iter-035 review

## Overall progress this iter
- **Total sorry**: 2 → 2 (no regression). Both frozen/superseded (`CechAcyclic.affine` dead,
  `CechHigherDirectImage.lean:~679` frozen P5b). Both prover files 0-sorry.
- **Build**: GREEN. `QcohRestrictBasicOpen.lean` (NEW) + `TildeExactness.lean` both `lake env lean … EXIT 0`,
  diagnostics empty; all 9 new decls axiom-clean `{propext, Classical.choice, Quot.sound}` (the 3 TildeExactness
  "opaque" source-scan hits are the English word in docstrings — false positives, confirmed by lean-auditor).
- **Lanes planned 2, ran 2** (both `mathlib-build`). **+9 axiom-clean decls** (Lane A +5 new file, Lane B +4);
  0 new sorries.
- `archon dag-query`: **gaps = 0**, **unmatched = 8** (1 pre-existing dead `CechAcyclic.affine` + 7 new helpers).

## Headline: P1a L1 fully delivered (new file); tilde sub-step (A) fully delivered; two genuine deep blockers named
- **Lane A `QcohRestrictBasicOpen.lean` (NEW, 01I8 P1a L1) — both named targets SOLVED axiom-clean.**
  `modulesRestrictBasicOpen` (the `F|_{D(f)}`→`O_{Spec R_f}`-module transport, iterated Mathlib restriction) +
  `modulesRestrictBasicOpenIso` (comparison iso to the pullback), plus the `specAwayToSpec_eq` feeder that
  reduces L2 to a single clean gap. lvb-qcoh: both faithfully realize `lem:modules_restrict_basicOpen`.
- **Lane B `TildeExactness.lean` (01I8 P3, sub-step A) — 4 helpers SOLVED axiom-clean.** The precise partial
  the plan named: `stalkMapₗ` (the `Ab`-stalk map packaged as a genuine `R`-linear map — the `map_smul'` field
  is the new content), `stalkMapₗ_eq` (identifies it with `IsLocalizedModule.map` — a genuine identification,
  not a tautology, per both auditor and lvb), `stalkMapₗ_injective`, and the `tilde_germ_algebraMap_smul`
  germ-linearity lemma driving them.

## Both stops are clean and land on genuine absent-Mathlib infrastructure
- **L2 `tilde_restrict_basicOpen`** = Stacks 01I8 `lemma-widetilde-pullback`: base-change/pullback
  compatibility of `tilde`. Confirmed ABSENT from Mathlib (`loogle`/`leansearch` empty). Multi-hundred-LOC.
  L3 transitively blocked.
- **Named target `tildePreservesFiniteLimits`** is a multi-decl categorical build, not one step. Infra blocker:
  `Scheme.Modules.toSheaf` does not exist, so the jointly-reflecting-stalk route off `toPresheaf` (presheaves)
  collapses to the sheaf-condition equalizer, not a single localisation.

## This iter's analysis
- **No forced mathematics; clean stops with named obstructions.** The `mathlib-build` no-sorry invariant held;
  both lanes delivered their provable leaves and stopped on real, precisely-characterized gaps.
- **No Lean-side must-fix from any of the three reviewers.** All 9 new decls genuine, non-vacuous, axiom-clean.
- **All findings are structural/coverage, not correctness:** (1) the new file is unimported (→ no `\leanok` on
  `lem:modules_restrict_basicOpen` despite being proven; sync ran iter 35, added 0/removed 0, consistent); (2)
  the chapter lacks a `% archon:covers` entry for the new file; (3) 7 helper decls are DAG-invisible; (4) stale
  docstring fragments in both files (auditor minor). Items (1)–(2) are the same "new file not wired in" issue
  the planner already flagged (plan.md item 79) — promote to a refactor + header edit next iter.

## Markers / coverage
- **Manual marker edit (1 `% NOTE`)**: `lem:modules_restrict_basicOpen` — records that both named Lean targets
  are formalized + axiom-clean but `\leanok` is pending only on the root-import wiring, with the planner action
  (wire import + add covers entry). No `\leanok` touched. No `\mathlibok` (all new decls are project theorems).
  No `\lean{}` rename (names match). No stale `\notready`.
- **Coverage debt = 8 unmatched**: 7 new helpers (3 QcohRestrictBasicOpen + 4 TildeExactness) + dead
  `CechAcyclic.affine`. Listed in recommendations for the planner to blueprint.

## Blueprint-doctor
Clean — every chapter `\input`'d, every `\ref`/`\uses` resolves, no new `axiom` decls.

## Subagent skips
- (none — all three highly-recommended review subagents dispatched: lean-auditor + 2× lean-vs-blueprint-checker.)
