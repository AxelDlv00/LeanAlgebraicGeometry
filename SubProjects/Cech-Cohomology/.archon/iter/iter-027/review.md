# iter-027 review

## Overall progress this iter
- **Total sorry**: 2 → 2 (no regression). Both intentional/frozen: superseded relative-form
  `CechAcyclic.lean:110` (`affine`) + frozen P5b `CechHigherDirectImage.lean:679`. Both new files 0 sorry.
- **Build**: GREEN. `AbsoluteCohomology.lean` and `CechToCohomology.lean` both `lake env lean … EXIT 0`,
  diagnostic-clean. All probed targets `lean_verify`-clean (`{propext, Classical.choice, Quot.sound}`).
- **Lanes planned 2, ran 2** (AbsoluteCohomology naturality; new `CechToCohomology.lean` — parallel
  mathlib-build). **Both lanes landed their targets in full.**
- **+17 axiom-clean declarations** (5 + 12); **0 new sorries**; **3 named blueprint targets landed**.
- `archon dag-query`: **gaps = 0**, **unmatched = 14** (all new helpers).

## The headline: both lanes closed; the 01EO chain is half-built first try
The fourth consecutive strong iter. Two parallel lanes, both full axiom-clean convergence, zero churn,
zero blockers on what was attempted — exactly the low-risk decomposition the iter-027 plan scoped.

- **Lane 1 — `absoluteCohomologyZeroAddEquiv_naturality`** (AbsoluteCohomology, +5). Naturality of the
  landed H⁰≅Γ iso in the coefficient sheaf, solved first attempt via layer-by-layer naturality of the
  composite `AddEquiv`. The load-bearing fact: `toPresheafOfModules X` is *definitionally*
  `SheafOfModules.forget ⋙ restrictScalars (𝟙 _)` (`rfl`), so `Adjunction.homEquiv_naturality_right` of
  the sheafification adjunction applies directly; carriers folded by plain `rfl` (the defeq-carrier
  obstacle class did not bite). This is precisely the surjectivity-transfer hinge L3 needs (AddEquiv ⇒
  `g_U` surjective ⇒ `H⁰(U,g)` surjective).
- **Lane 2 — new `CechToCohomology.lean`, L1+L2** (+12). Section-Čech functoriality bricks (no Mathlib
  functoriality existed), the `cechCohomology` accessor (effort-breaker's flagged naming item, now real),
  the AB4* keystone `shortExact_piMap`, and the two chain lemmas. L1 = degreewise reduction +
  `shortExact_piMap`; L2 = δIso dimension shift `Hᵖ(Q) ≅ Hᵖ⁺¹(F)=0`.

## This iter's analysis
- **Honest, clean convergence.** No new mathematics was forced — the dominant cost was Lean-engineering
  (composite-AddEquiv naturality plumbing; the AB4* `Epi (Pi.map φ)` elementwise proof, which is NOT a
  typeclass instance). Both are now Knowledge-Base patterns.
- **No Lean-side must-fix from any audit.** lean-auditor: 0 critical / 0 major / 3 minor on both files,
  `shortExact_piMap` and the naturality square independently confirmed genuine (not vacuous). lvb
  `abscohom`: CLEAN, 0 red flags.
- **The one real must-fix is blueprint-side, not Lean.** lvb `cechtocohom` flagged that the landed L1/L2
  are COVER-LOCAL / PRESHEAF-level (`U : ι → Opens X`, `ShortComplex X.PresheafOfModules`, per-face
  `hface`) — strictly more general and correct — while the chapter prose still describes the cover-global
  `(B,Cov)` / sheaf form. The Lean is right; the prose lags. I added `% NOTE:` flags to both blocks; the
  prose rewrite is the planner's blueprint-writer job and is a HARD-GATE prerequisite before L3/L4 provers
  (the consolidated chapter gates them). Plus two substantive helpers (`shortExact_piMap`,
  `cechHomology_quotient_vanishing`) want blueprint blocks (major coverage).

## The carried-anomaly status — resolved this iter
The iter-025/026 `\leanok` mis-removal on `lem:ses_cech_h1` / `lem:injective_cech_acyclic` appears
**resolved**: `sync_leanok` iter=27 = added 10 / removed 2 (net positive), CechBridge untouched. Not
re-flagged. If it recurs, the cause remains a build-timeout in the sync window on CechBridge's
`maxHeartbeats 2000000` decl.

## Frontier ahead
Lane-1 done; L1/L2 done. After the bookkeeping (root import #1, blueprint prose #2–#3, coverage #4):
the ready frontier is the **per-face SES derivation** (feeds L1's `hface`), **L3** (now unblocked by the
naturality landing), then **L4 + top** induction over the abstract `HasVanishingHigherCech` class — the
chain that re-enables the frozen P5b `cech_computes_higherDirectImage`. `gaps` = 0, foundation sound.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:cech_ses_of_basis`: added `% NOTE:` (cover-local/presheaf
  landed signature vs cover-global/sheaf prose — lvb cechtocohom must-fix #1).
- `Cohomology_CechHigherDirectImage.tex`, `lem:quotient_vanishing_cech`: added `% NOTE:` (cover-local
  signature with explicit hSES/hI/hF vs "I injective" prose — lvb must-fix #2).
- No `\mathlibok` / `\lean{}` rename / `\notready` changes (all pins matched; no Mathlib re-exports).

## Subagent dispatches
- lean-auditor `iter027` (both files): 0 must-fix.
- lean-vs-blueprint-checker `abscohom`: CLEAN.
- lean-vs-blueprint-checker `cechtocohom`: 2 blueprint-side must-fix + 2 major coverage (queued for planner).
