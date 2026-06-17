# Iter 058 — Objectives detail

## Lane 1 — GF `FlatteningStratification.lean` (close `genericFlatness`)
- Single sorry `flatV : Module.Flat Γ(S,V) Γ(F, D g)` @ L~3285. `hfree` per-patch freeness retained;
  base-descent already discharged via epi route (`gf_flat_of_isEpi`/`gf_isEpi_restrict_of_affine_le`).
- 4-step localization-algebra recipe in PROGRESS lane 1 + blueprint flatV sketch L2348–2445.
- Residual = `IsScalarTower`/`IsLocalizedModule` threading; ~150–250 LOC. NO Mathlib gap.
- Prior status: PARTIAL iter-056 (keystone closed, reduced to flatV). progress-critic CONVERGING.

## Lane 2 — SNAP `SectionGradedRing.lean` (capitalize carrier refactor)
- 4 functoriality sorries 473/474 (`relTensorDomainPresheaf`), 490/491 (`relTensorTriplePresheaf`) —
  trivial via `induction_on` + `objRestrict_apply` (refactor landed `objRestrict`, L~448, private).
- Build `relTensorActL` (+`relTensorActR`): `actLmap` component; naturality = `map_smul` +
  `presheaf_map_apply_coe`; `map_tmul` now unifies (carriers aligned). Iter-056 wall removed by refactor.
- Stretch: `relTensorProj` → colimit lift → `relativeTensorCoequalizerIso`.
- Reversal signal: if `map_tmul` still won't unify post-`objRestrict` → escalate (Handle 3, Mathlib lemma).

## Deferred this iter
- GR `GrassmannianQuot.lean`: scaffold GL_d bundle-cocycle (iter-059; blueprint written iter-058).
- QUOT `QuotScheme.lean`: annihilator reverse-incl + P2 (after GF closes; import race).
- FBC: PARKED.
