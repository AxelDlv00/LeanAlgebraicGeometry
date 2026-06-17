# Iter 081 — Objectives detail

## Lane 1 — GrassmannianQuot.lean :: tautologicalQuotient_epi (L2470) [prove]
- Last sorry in the file. Unblocked iter-080 (keystone `isIso_glueRestrictionHom` → 0-sorry).
- Route: epi of the tautological quotient via joint reflection across the chart cover
  (`pullback_map_jointly_faithful` engine, DONE). Blueprint `lem:tautologicalQuotient_epi`.
- Done ⇒ GrassmannianQuot 0-sorry, GR-quot route complete.

## Lane 2 — SectionGradedRing.lean :: SNAP graded assembly (9 stubs) [prove]
- Bricks: `sectionsCast` (1843), `sectionsCast_refl` (1849), `gradedMonoid_eq_of_cast` (1856),
  `GMul.mul` (1862), `GOne.one` (1867), then 4 coherence Eqs (1874/1882/1892/1901).
- Then NEW (unscaffolded): `GMonoid`/`GSemiring`/`GCommSemiring`/`Gmodule` instances, field-for-field
  per `TensorPower.Basic` (`gnpow` defaulted, bilinearity free).
- Recipe: `analogies/snap-gcomm.md`, `snap-assoc.md`; scaffolder handoff at SectionGradedRing.lean
  L1807–1830 (e.g. `GMul.mul` body = `(tensorPowAdd L i j).hom.val.app (op ⊤) (sectionsMul …)`).
- Hazard: carrier `AddCommGrpCat`; coherence = FOUR cast-mediated component Eqs.

## Lane 3 — FlatBaseChangeGlobal.lean :: baseChangeGammaPullbackEquiv (L274) [prove]
- Stub landed this phase (analogist-verified sig). Proof per blueprint `thm:fbcb_global_direct` 3-step:
  start at `baseChangeGammaEquiv F U hU B` (its domain = the LHS verbatim) → transport RHS eqLocus to
  `gammaModA F' ⊤` via `gammaTopEquivEqLocus` on `F'=(Modules.pullback g').obj F` + base-changed cover,
  legs identified by `pullback_spec_tilde_iso` (01I9) + `affine_base_change_pushforward`.
- RHS `B`-module = `restrictScalars` along `pullbackGroundRingAlg B`. Design: `analogies/fbcb-pullback-equiv-sig.md`.
- Do NOT touch FlatBaseChange.lean (frozen named legs = next-iter discharge).

## Pre-prover state (sorry counts)
GrassmannianQuot 1 · SectionGradedRing 11 (9 real + 2 comment) · FlatBaseChangeGlobal 1 ·
GlueDescent 0 · FlatBaseChange 14 (off-path mate) · QuotScheme 8 (blocked). Global real ≈ 11.
