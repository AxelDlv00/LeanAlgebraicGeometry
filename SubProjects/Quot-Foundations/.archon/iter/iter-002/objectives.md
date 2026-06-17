# Iter 002 — Objectives detail

## Dispatched this iter (2 lanes, both `prove`)

### Lane GF — `AlgebraicJacobian/Picard/FlatteningStratification.lean`
Blueprint `chapters/Picard_FlatteningStratification.tex`.
- (a) Create `AlgebraicGeometry.genericFlatnessAlgebraic` with the chapter's `% INTENDED LEAN
  SIGNATURE` (noeth domain A, finite-type A-algebra B, finite B-module M via scalar tower →
  ∃ f≠0, `Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)`). Attempt the
  Nitsure §4 dévissage body (reduces to the proved `GenericFreeness.exists_free_localizationAway_of_finite`
  at the bottom); partial progress acceptable.
- (b) Re-sign `genericFlatness` (+`[F.IsQuasicoherent] [F.IsFiniteType]`).
- (c) Prove `genericFlatness` (GF-geo wrapper) via (a), modulo (a)'s sorry.

### Lane FBC-A — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
Blueprint `chapters/Cohomology_FlatBaseChange.tex`. Follow the blueprint (NEW route), not the stale
inline comments (old mate/Čech route).
- (a) Create + prove `AlgebraicGeometry.pushforward_base_change_mate_cancelBaseChange` (affine–affine
  section value = `cancelBaseChange`; orientation `Γ(α)=cancelBaseChange⁻¹`; 4-step generator trace).
- (b) Create + prove `AlgebraicGeometry.base_change_map_affine_local` (locality reduction; 3-step
  naturality derivation now in the chapter).
- (c) Prove `affineBaseChange_pushforward_iso` (replace sorry@742) by assembling (a)+(b).
- `flatBaseChange_pushforward_isIso` (FBC-B) — do not churn; later iter.

## Queued for iter-003+

1. **QUOT predicate track** (in order): mathlib-analogist (api-alignment) on schematic-support/
   proper-support + rank-`r` local-freeness shapes → blueprint-writer adds decl blocks with
   `\lean{}` to `Picard_QuotScheme.tex` → `[prover-mode: mathlib-build]` builds them → re-sign the
   four QUOT stubs + define `Grassmannian := QuotFunctor (𝟙 S) V Φ_d`.
2. **SNAP** (`def:hilbert_polynomial`): effort-break the coherent-sheaf Euler-char + Snapper build
   (S1, S2) before any prover; Mathlib `Polynomial.hilbertPoly` is a building block.
3. **FBC-B** (`flatBaseChange_pushforward_isIso`): H⁰-as-equalizer / finite-affine-cover sheaf
   packaging for `SheafOfModules` + flat-`−⊗B`-preserves-equalizer (`tensorEqLocusEquiv`).
4. **GF dévissage** continuation / effort-break if `genericFlatnessAlgebraic` stalled.
5. **Coverage debt:** thin blueprint blocks for the 4 isolated `lean_aux` helpers (3 GenericFreeness
   in FlatteningStratification, 1 in FlatBaseChange) — fold into the next writer pass.
6. **RelativeSpec:** pull the missing `% SOURCE QUOTE PROOF:` for `thm:relative_spec_univ` (soon);
   decide the `RepresentableBy` strengthening before GR-repr.

## Gate status (carry to iter-003 mandatory blueprint-review)
- `Cohomology_FlatBaseChange.tex` — complete + correct (cleared via fast path this iter).
- `Picard_FlatteningStratification.tex` — complete + correct.
- `Picard_QuotScheme.tex` — complete + correct (blueprint); QUOT prover work gated on predicate track.
- `Picard_RelativeSpec.tex` — complete + correct (soon: missing SOURCE QUOTE PROOF).
