# Blueprint Writer Directive

## Slug
gr-existence

## Target chapter
blueprint/src/chapters/Picard_GrassmannianCells.tex

## Strategy context
`Grassmannian.isProper` (`lem:gr_proper`, `sec:gr_proper`) is proved via the valuative criterion. This iter
it was reduced to the SINGLE obligation `ValuativeCriterion.Existence (toSpecZ d r)` by the landed theorem
`isProper_of_valuativeExistence` together with three cheap ingredients (quasi-compact, locally-of-finite-
type, quasi-separated) and the uniqueness half (free from separatedness). The chapter's `sec:gr_proper`
currently holds only `lem:gr_proper` (with the full Nitsure existence argument inline) and has NO blocks
for the 7 properness-scaffold declarations landed this iter (checker iter-035 major finding), and the
existence argument is not decomposed into formalizable sub-lemmas.

## Required content

1. **Add coverage-debt blocks under `sec:gr_proper`** for the 7 landed declarations (each: informal
   statement, `\label`, `\lean`, accurate `\uses`, one-line proof sketch). `\uses`-wire to `lem:gr_separated`
   and `def:gr_glued_scheme` (use the real labels in the chapter):
   - `\lean{AlgebraicGeometry.Grassmannian.compactSpace_scheme}` — `CompactSpace (scheme d r)`: finite chart
     index `{I : Finset (Fin r) // I.card = d}`, each chart `Spec`-affine ⟹ compact;
     `GlueData.openCover.compactSpace`.
   - `\lean{AlgebraicGeometry.Grassmannian.quasiCompact_toSpecZ}` — `QuasiCompact (toSpecZ d r)`: `Spec ℤ`
     affine + `compactSpace_scheme` via `HasAffineProperty`. `\uses{lem:gr_compactSpace_scheme}`.
   - `\lean{AlgebraicGeometry.Grassmannian.locallyOfFiniteType_toSpecZ}` —
     `LocallyOfFiniteType (toSpecZ d r)`: `IsZariskiLocalAtSource.of_openCover` + `ι_toSpecZ` + each
     `ℤ → R^I` of finite type. `\uses{def:gr_glued_scheme}` (+ the `ι_toSpecZ` label).
   - `\lean{AlgebraicGeometry.Grassmannian.quasiSeparated_toSpecZ}` — `QuasiSeparated (toSpecZ d r)`: from
     `isSeparatedToSpecZ` (`IsSeparated → QuasiSeparated`). `\uses{lem:gr_separated}`.
   - `\lean{AlgebraicGeometry.Grassmannian.valuativeUniqueness_toSpecZ}` —
     `ValuativeCriterion.Uniqueness (toSpecZ d r)`: free from separatedness via
     `IsSeparated.valuativeCriterion`. `\uses{lem:gr_separated}`.
   - `\lean{AlgebraicGeometry.Grassmannian.transitionPreMap_minorDet_mul}` — the minor-ratio identity
     `θ̃_{I,J}(P^J_{K'}) · (algebraMap) P^I_J = (algebraMap) P^I_{K'}` in `R^I_J` (generalises
     `transitionPreMap_minorDet_swap_mul`): via `transitionPreMap_minorDet` + `mul_submatrix_col` +
     `Matrix.det_mul` + `universalMinorInv_mul_cancel`. The algebraic core of existence step E3.
     `\uses` the existing transition/minor blocks.
   - `\lean{AlgebraicGeometry.Grassmannian.isProper_of_valuativeExistence}` — the reduction:
     `(hE : ValuativeCriterion.Existence (toSpecZ d r)) → IsProper (toSpecZ d r)`, bundling the three cheap
     ingredients + uniqueness via `IsProper.of_valuativeCriterion` + `ValuativeCriterion.iff`. This is the
     keystone reduction: `lem:gr_proper` becomes the one-liner over it + the existence obligation.
     `\uses{lem:gr_compactSpace_scheme, lem:gr_quasiCompact_toSpecZ, lem:gr_locallyOfFiniteType_toSpecZ,
     lem:gr_quasiSeparated_toSpecZ, lem:gr_valuativeUniqueness_toSpecZ}`.
   (Pick `\label` names consistent with the chapter's existing `lem:gr_*` convention.)

2. **Decompose the existence obligation into E1–E4 sub-lemma blocks** (the prover builds E1 first; E1 gates
   the rest). A `ValuativeCommSq` gives a valuation ring `R`, fraction field `K`,
   `i₁ : Spec K ⟶ scheme d r`, `i₂ : Spec R ⟶ Spec ℤ` with `i₁ ≫ toSpecZ = Spec.map(algebraMap R K) ≫ i₂`;
   one must produce `Spec R ⟶ scheme d r` filling both triangles.
   - **E1 — chart factorization** (`lem:gr_existence_chart_factorization`, the PRIMARY missing ingredient):
     `Spec K` is a single point (K a field), so `i₁` lands in the range of some chart `ι_I = (theGlueData
     d r).ι I` (`theGlueData.ι_jointly_surjective`); since `ι_I` is an open immersion, `i₁` factors uniquely
     as `i₁ = j ≫ ι_I` for `j : Spec K ⟶ affineChart d r I`, hence (affine) a ring hom
     `f : R^I = MvPolynomial (Fin d × {q // q ∉ I}) ℤ → K`. The Mathlib gap: factoring a morphism out of
     `Spec` of a local/field ring through a member of an open cover whose range contains the image point
     (search `Scheme.OpenCover` + `IsLocalRing` factorization / `IsOpenImmersion` lift API; else build via
     the topological point + `Scheme.Hom.appLE`/stalk).
   - **E2 — minimal-valuation selection** (`lem:gr_existence_minimal_valuation`): with
     `v := ValuationRing.valuation R K`, over the finite index `{J // J.card = d}` choose `J` MAXIMIZING
     `v (f (minorDet d r I J))` (multiplicative convention; Nitsure's "minimal ν" = "maximal v").
     Nonemptiness: `I` is a candidate, `minorDet I I = 1` gives `v = 1`, so the max is `≥ 1 > 0`, whence
     `f (minorDet I J) ≠ 0`. `\uses` `minorDet_self` and the minor blocks.
   - **E3 — entries land in `R`, factor `g` through `R`** (`lem:gr_existence_factor_through_valuation_ring`):
     define `g := f' ∘ transitionPreMap d r I J` where `f' : R^I_J → K` extends `f` (via
     `IsLocalization.Away.lift`, valid since `f (minorDet I J)` is a unit by E2). Then
     `g(minorDet J K') = f(minorDet I K') / f(minorDet I J)` (apply `f'` to
     `transitionPreMap_minorDet_mul`); by E2's maximality `v(g(minorDet J K')) ≤ 1`, so `g(P^J_{K'}) ∈ R`.
     Each generator `x^J_{p,q}` (q ∉ J) equals `± P^J_{K'}` for `K' = (J\{j_p}) ∪ {q}` (entry-as-minor,
     since `X^J_J = I`), so every `g(x^J_{p,q}) ∈ R`; hence `g = (algebraMap R K) ∘ g'` for a unique
     `g' : R^J → R`. `\uses{lem:gr_transitionPreMap_minorDet_mul, lem:gr_existence_minimal_valuation}` +
     `transitionPreMap_minorDet`/`isUnit_incl_transitionPreMap_cross`. (The entry-as-minor sign bookkeeping
     is the one sub-step with no existing scaffold — call it out in prose.)
   - **E4 — lift construction + triangles** (`lem:gr_existence_lift`): the filler is
     `Spec.map (CommRingCat.ofHom g') ≫ (theGlueData d r).ι J : Spec R ⟶ scheme d r`; verify
     `CommSq.LiftStruct` — top triangle from `g = algebraMap ∘ g'` + the E1 factorization + `ι_toSpecZ`;
     bottom triangle from `specZIsTerminal.hom_ext`. `HasLift` from a single `LiftStruct` via
     `CommSq.HasLift.mk`. `\uses{lem:gr_existence_chart_factorization, lem:gr_existence_factor_through_valuation_ring}`.
   - A short top-level block (or extend `lem:gr_proper`'s proof) stating
     `ValuativeCriterion.Existence (toSpecZ d r)` follows from E1–E4 (one `ValuativeCommSq` → the E4 lift),
     and `isProper` is then the one-liner over `isProper_of_valuativeExistence` + existence.

3. Update `lem:gr_proper`'s proof prose to reference the new E1–E4 + `isProper_of_valuativeExistence`
   decomposition (so its `\uses` reflects the real structure), without deleting the existing Nitsure quote.

## Out of scope
- GR-quot (tautological rank-d quotient), GR-repr (representability).
- The private architectural helpers `rotMid`, `transitionInvImageMatrix`, `transitionInvPair` — exempt, no
  block owed.
- Any `\leanok` marker.

## References
- `references/nitsure-hilbert-quot.md` → `references/nitsure-hilbert-quot.pdf` / `-src/*.tex`: §1
  "Properness" (the valuative-criterion existence argument: chart selection by minimal valuation, the
  `g(X^J) = f((X^I_J)^{-1} X^I)` map, entries-land-in-`R`). Cite the §1 properness statement/proof verbatim
  for the E1–E4 blocks (the existing `lem:gr_proper` block already quotes Nitsure §1 — reuse / extend that
  verbatim source quote across the sub-lemmas; do not fabricate).

## Expected outcome
`sec:gr_proper` has blocks for the 7 landed properness-scaffold declarations and a `\uses`-linked E1–E4
decomposition of the existence obligation (E1 = chart factorization, the primary missing Mathlib API, the
iter-036 prover target), with `lem:gr_proper` reframed as the one-liner over `isProper_of_valuativeExistence`
+ existence. Verbatim Nitsure §1 source quotes throughout. No `\leanok` touched.
