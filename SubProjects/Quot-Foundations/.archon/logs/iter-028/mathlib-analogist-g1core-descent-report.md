# Mathlib Analogist Report

## Mode
api-alignment

## Slug
g1core-descent

## Iteration
028

## Question
Build, axiom-clean, `Scheme.Modules.isLocalizedModule_basicOpen_of_isQuasicoherent` (QC `M` on
`Spec R`, `f : R` ⟹ `Γ(M,⊤) → Γ(M,D(f))` is `IsLocalizedModule (powers f)`; Stacks 01HA /
Hartshorne II.5.2). Is the planned explicit finite-cover + flat-equalizer descent (Route E) the
cheapest realisation, or does Mathlib make a shorter affine descent cheap? Give the lemma names for
the chosen route.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Globalization: finite-equalizer/flat-descent (E) vs. pointwise-existence + compact-open gluing (F) | ALIGN_WITH_MATHLIB (use F) | major (in-proposal) |
| `IsLocalizedModule` assembly via 3-field constructor (not a localized-equalizer `≃ₗ`) | ALIGN_WITH_MATHLIB | major (in-proposal) |
| `QuasicoherentData` → finite basic-open tilde cover (shared step 1) | NEEDS_MATHLIB_GAP_FILL | informational |
| Direct `IsQuasicoherent → IsIso fromTildeΓ` / shorter stalk or Γ-adjunction path | NEEDS_MATHLIB_GAP_FILL (none exists) | informational |

**Bottom line: there IS a shorter idiom than Route E.** Mathlib proves the structure-sheaf twin of
this statement — `isLocalization_basicOpen_of_qcqs` (the "Qcqs lemma", QuasiSeparated.lean:389)
[verified] — and proves it WITHOUT an equalizer object and WITHOUT flatness: it assembles
`IsLocalization` from its three pointwise axioms, each a pointwise existence lemma proved by
`compact_open_induction_on` + sheaf gluing. The target `IsLocalizedModule` unfolds to the *same*
three axioms (LocalizedModule/Basic.lean:525) [verified], so the module keystone is the module
analogue of that proof. Do **not** dispatch Route E.

## Major

- **Globalization method (Route F, not E).** `isLocalization_basicOpen_of_qcqs`
  (`Mathlib/AlgebraicGeometry/Morphisms/QuasiSeparated.lean:389`) [verified] is the canonical
  realisation of exactly this descent. Route E reinvents a flat-descent of a finite module limit that
  Mathlib's own proof was written to avoid; crucially there is **no single lemma** "localization
  commutes with a finite equalizer of modules" (you would hand-chain `IsLocalization.flat`
  `Mathlib/RingTheory/Flat/Localization.lean:36` → `Module.Flat.lTensor`-exactness → kernel
  preservation). Route F replaces that step with the 3-field `IsLocalizedModule` constructor fed by
  two `compact_open_induction_on` lemmas; its inductive step is the *generic* module Mayer-Vietoris
  `TopCat.Sheaf.isLimitPullbackCone` (PairwiseIntersections.lean:391) [verified] +
  `existsUnique_gluing`/`eq_of_locally_eq'` (UniqueGluing.lean:180,224) [verified], which hold for any
  concrete sheaf and so apply to `modulesSpecToSheaf.obj M : (Spec R).Sheaf (ModuleCat R)`.
- **`IsLocalizedModule` assembly.** Build `⟨map_units, surj, exists_of_eq⟩` directly
  (LocalizedModule/Basic.lean:525) [verified], never naming a localized-equalizer object — exactly as
  the qcqs proof builds `IsLocalization.Away`.

### Route F — the concrete target list for the prover

`isLocalizedModule_basicOpen_of_isQuasicoherent := ⟨map_units, surj, exists_of_eq⟩`, where:

1. **map_units** [verified ingredients]: `IsUnit (algebraMap R (Module.End R Γ(M,D(f))) (f^n))` from
   `RingedSpace.isUnit_res_basicOpen` (RingedSpace/Basic.lean:161) — the R-action on `Γ(M,D(f))`
   factors through the unit `f|_{D(f)} ∈ Γ(O,D(f))`. Cheap.
2. **surj** [expected — port]: module analogue of
   `exists_eq_pow_mul_of_isCompact_of_isQuasiSeparated` (QuasiSeparated.lean:306) [verified], via
   `compact_open_induction_on` (QuasiCompact.lean:235) [verified]. Base: `M|_{D g} ≅ tilde N_g`
   from `AlgebraicGeometry.Modules.isIso_fromTildeΓ_of_presentation` (Tilde.lean:398) [verified] on
   the transported presentation, then the affine tilde instance
   `IsLocalizedModule (.powers f) (toOpen M (basicOpen f)).hom` (Tilde.lean:115) [verified] +
   project `isLocalizedModule_tilde_restrict` for sub-basic-opens. Step: the module Mayer-Vietoris
   above.
3. **exists_of_eq** [expected — port]: module analogue of
   `exists_pow_mul_eq_zero_of_res_basicOpen_eq_zero_of_isCompact` (QuasiSeparated.lean) [verified],
   same induction.

Then the existing project glue `isIso_fromTildeΓ_iff_isLocalizedModule_restrict`
(`AlgebraicJacobian/Picard/QuotScheme.lean:653`) closes gap1.

## Informational

- **No direct `IsQuasicoherent M → IsIso M.fromTildeΓ` on affine.** Confirmed: `fromTildeΓ` /
  `isIso_fromTildeΓ` occur only in `Mathlib/AlgebraicGeometry/Modules/Tilde.lean`; nothing connects
  `IsQuasicoherent` to it. `isIso_fromTildeΓ_of_presentation` (Tilde.lean:398) needs a **global**
  presentation. (Matches the iter-026 grep and `analogies/quot-qcoh-affine-globalization.md`.)
- **No `QuasicoherentData → finite basic-open presentation cover` helper.** The
  `QuasicoherentData` API (Quasicoherent.lean:201) offers only `shrink`, `localGeneratorsData`,
  `bind`, `ofIsIso`, `IsQuasicoherent.of_coversTop`, `Presentation.map`/`Presentation.ofIsIso`. The
  cover refinement (basic-open basis `PrimeSpectrum.isBasis_basic_opens`; finite subcover via
  `CompactSpace (PrimeSpectrum R)`; transport `(M.over (X i)).Presentation` across `D(g) ≅ Spec R_g`
  by `Presentation.ofIsIso`) is manual and is the only way to reach the QC hypothesis
  (`IsQuasicoherent = Nonempty QuasicoherentData`). **This step 1 is shared by E and F** and is the
  irreducible core — the right first prover dispatch — but Route F sheds two of E's obligations: no
  explicit equalizer/limit object, and no "the `g_a` generate the unit ideal" proof.
- **No one-step "flat localizes a finite equalizer of modules".** Confirmed; this is an argument
  *against* Route E, not a tool for it.
- **`over`/site idiom is right, but only for local data.** Use `QuasicoherentData` to get the
  per-affine tilde isos; do the globalisation on the topological side `modulesSpecToSheaf.obj M`
  with the generic sheaf condition (as the qcqs lemma uses `X.sheaf`). The stalk route
  (`M.stalk p = N_p`) shares step 1 and adds a colimit layer, so it is not shorter.

## Persistent file
- `analogies/g1core-affine-descent.md` — route map (Route F vs Route E, full lemma list with
  verified/expected tags, the 3-target split for the prover).

Overall verdict: a shorter, Mathlib-idiomatic descent exists — realise G1-core as the module
analogue of `isLocalization_basicOpen_of_qcqs` (3-field `IsLocalizedModule` from two
`compact_open_induction_on` existence lemmas), NOT the explicit finite-equalizer + flat-descent;
the shared `QuasicoherentData` → finite basic-open tilde cover (step 1) is the irreducible core and
the correct first dispatch.
</content>
