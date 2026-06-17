# Recommendations — next plan iteration (post iter-028)

## State entering iter-029
- **01EO comparison chain is COMPLETE.** `cech_eq_cohomology_of_basis` + L4 + L3 + per-face SES + the
  two defs all landed axiom-clean this iter (beyond the hedge); L1/L2 landed iter-027. The whole
  `CechToCohomology.lean` is 0 sorry, build green, all targets `lean_verify`-clean.
- Project sorry = 2 (both frozen/superseded: `CechHigherDirectImage.lean:679`,
  `CechAcyclic.lean:110`). `gaps` = 0.
- Root barrel imports both `AbsoluteCohomology` and `CechToCohomology` (iter-027 must-fix resolved).

## HIGH — blueprint reconciliation (HARD-GATE prerequisites before 02KG provers)
These are blueprint-side must-fix from lvb `cechtocohom-iter028`. They gate any prover that consumes
the 01EO chapter content (i.e. the 02KG lane).

1. **`def:basis_cov_system` prose ⟂ Lean encoding.** The Lean `BasisCovSystem` carries `CovDatum`
   (`Σ ι, ι → Opens X`) + TWO sheaf-theoretic fields `surj_of_vanishing` (the *output* of
   `ses_cech_h1` + cofinality, not raw cofinality) and `injective_acyclic` (the `injective_cech_acyclic`
   output). The blueprint prose still says condition (2) is "raw cofinality stated in the shape
   `ses_cech_h1` consumes" and **does not mention the `injective_acyclic` field at all**; its claim of
   "no derived-functor machinery in `BasisCovSystem`" is now false for the Lean. → blueprint-writer:
   rewrite the def prose to the two-field shape (this matches the effort-breaker's intent and the
   strategy-critic ruling that the predicate stays abstract / `Q` not assumed QCoh).
2. **`[EnoughInjectives X.Modules]` hypothesis missing from blueprint statements** of
   `lem:absolute_cohomology_pos_vanishing` (L4) and `lem:cech_to_cohomology_on_basis` (top). The Lean
   carries it as an explicit typeclass argument because the instance is genuinely absent in Mathlib
   (would need `IsGrothendieckAbelian (SheafOfModules R)`). → blueprint-writer: add the hypothesis to
   both statements with a one-line note that it is carried (P5a convention), citing `analogies/p5a.md`.

## MEDIUM — coverage debt (`archon dag-query unmatched` = 4)
Four new `lean_aux` helpers have no blueprint entry. Bundle each name into a related decl's `\lean{...}`
list (per the doctrine "when there is Lean there must be tex"):
- `AlgebraicGeometry.sectionsFunctor` (def, the `Γ(V,-) : X.Modules ⥤ Ab` composite) → bundle into
  `lem:face_ses_of_sheaf_ses`'s `\lean{...}`.
- `AlgebraicGeometry.CovDatum` (abbrev, `Σ ι, ι → Opens X`) → bundle into `def:basis_cov_system`.
- `AlgebraicGeometry.injSES` and `AlgebraicGeometry.injSES_shortExact` (private injective-embedding SES
  helpers; `private` is NOT `unmatched`-exempt) → bundle both into
  `lem:absolute_cohomology_pos_vanishing`'s `\lean{...}`.

## Next frontier — 02KG affine Serre vanishing (the lane to dispatch after the blueprint reconcile)
Instantiate `BasisCovSystem` at affine opens / standard covers and feed it to
`cech_eq_cohomology_of_basis`. Discharge obligations:
- `surj_of_vanishing` via `ses_cech_h1` + standard-cover cofinality.
- `injective_acyclic` via `injective_cech_acyclic`.
- **Cover-representation bridge required**: `injective_cech_acyclic` is stated for `X.OpenCover` /
  `coverOpen 𝒰` with `Finite 𝒰.I₀`, whereas `CovDatum` is a raw `ι → Opens X`. A small bridge lemma
  between the two cover representations is needed — flag this to the effort-breaker if it proves large.
- The 02KG lemma will also carry `[EnoughInjectives X.Modules]` until that instance is built globally.

## LOW — non-blocking cleanups (queue for the next prover that opens `CechToCohomology.lean`)
From lean-auditor `iter028` (4 minor, all cosmetic, none affect correctness):
- Stale module header (L9-14) says "L1/L2 chain"; file now contains L1-L4 + top.
- `cech_eq_cohomology_of_basis` name implies an iso but proves vanishing (docstring is accurate).
- 4× `show` → `change` (`style.show` linter) at L57/70/135/180.
- Line-length > 100 at L79.
Review cannot edit `.lean`; these are not worth a dedicated lane — fold into the next touch of the file.

## Do NOT re-assign
- `EnoughInjectives X.Modules` synthesis: confirmed whnf-timeout even at `maxHeartbeats 2000000`; the
  instance is genuinely absent in Mathlib. Do not retry synthesis — keep it as a carried hypothesis
  until `IsGrothendieckAbelian (SheafOfModules R)` is built (a separate, large infrastructure task:
  needs `Abelian` ✓ + AB5/`HasColimits` + `HasSeparator`).
- The 01EO chain decls are done and axiom-clean — do not re-prove.
