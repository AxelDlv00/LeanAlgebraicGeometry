# Blueprint Writer Report

## Slug
differentials-iter111

## Status
COMPLETE — all three must-fix items in the `\thm:relative_kaehler_isSheaf`
proof block addressed. The basis-to-opens descent step is honestly tagged
`[gap]` since the search confirmed Mathlib does not currently package a
direct ``sheaf-on-affine-basis ⇒ sheaf'' theorem for
`Scheme.PresheafOfModules`; concrete routes (a) and (b) for the prover
are spelled out instead.

## Target chapter
blueprint/src/chapters/Differentials.tex

## Changes Made

- **Revised** `\thm:relative_kaehler_isSheaf` proof block (lines 28–53)
  — full rewrite of the three-step proof sketch.

### Step-by-step fixes mapped to the directive's must-fix items

**Must-fix #1 (basis-to-opens descent wrong-direction citation).**
Removed the previous citation of
`TopCat.Presheaf.IsSheaf.isSheafUniqueGluing` as a basis-to-opens hook
— that lemma's direction is `IsSheaf → IsSheafUniqueGluing`, not the
converse the recipe needed. Replaced with three named-and-`[verified]`
sheaf-condition characterisations
(`isSheaf_iff_isSheafOpensLeCover`,
 `isSheaf_iff_isSheafPairwiseIntersections`,
 `isSheaf_iff_isSheafEqualizerProducts`),
all checked to be iff-shaped, and made the proof block explicitly
flag the basis-to-opens descent as a `[gap]` requiring prover-side
construction — see "Honest gap" below. Added a closing paragraph
that explicitly disowns the previous wrong-direction reference, so
future readers don't relitigate it.

**Must-fix #2 (wrong Mathlib name for localisation tensor iso).**
The proof now uses
`KaehlerDifferential.isLocalizedModule_map` [verified]
(`Mathlib.RingTheory.Etale.Kaehler`, line 63) as the primary entry
point — exactly as the existing Lean stub in Differentials.lean L72–105
anticipates. The verified signature is:
> `instance (M : Submonoid S) [IsLocalization M T] : IsLocalizedModule M (map R R S T)`

Applied with `R = A`, `S = B`, `M = Submonoid.powers f`, `T = B[1/f]`,
this gives the canonical iso `Ω_{B/A} ⊗_B B[1/f] ≅ Ω_{B[1/f]/A}` as
the universal map of the `IsLocalizedModule` structure. The optional
equivalent route via
`KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale` [verified]
(`Mathlib.RingTheory.Etale.Kaehler`, line 38, signature
`T ⊗[S] Ω[S⁄R] ≃ₗ[T] Ω[T⁄R]` for `[Algebra.FormallyEtale S T]`) is
listed as an equivalent alternative, with the formally-étale instance
supplied by `Algebra.FormallyEtale.of_isLocalization` [verified]
(`Mathlib.RingTheory.Etale.Basic`, line 190). The bare name
`KaehlerDifferential.tensorKaehlerEquiv` (with the
`Algebra.IsPushout` shape) is explicitly disowned in the prose so
future readers don't pick it up by accident.

**Must-fix #3 (unnamed "tensoring preserves exactness" /
"refinement's universality" hand-waves).** The vague descent prose
in the old Step 2 ("tensoring a B-module with the standard sheaf
condition...") is replaced with a clean identification of the
affine-restricted presheaf with Mathlib's quasi-coherent module
sheaf `M~` via `AlgebraicGeometry.Modules.tilde` [verified]
(`Mathlib.AlgebraicGeometry.Modules.Tilde`, line 87), whose `isSheaf`
field provides the sheaf property by construction. This absorbs the
finite-cover exactness verification into Mathlib's existing
`tilde`-sheaf machinery (which internally uses
`structureSheafInType` via the local-predicate sheafification
construction). The previously vague "refinement's universality"
language in old Step 3 is replaced with the explicit
opens-le-cover-cofinality argument naming
`isSheaf_iff_isSheafOpensLeCover` — though the prover still has to
build the cofinality refinement explicitly (this is the honest gap
documented below).

### Verified Mathlib names (all checked against
`.lake/packages/mathlib/`)

- `TopCat.Presheaf.isSheaf_iff_isSheaf_comp` [verified] —
  `Mathlib.Topology.Sheaves.Forget`, line 55. Signature confirmed:
  for `G : C ⥤ D` with `ReflectsIsomorphisms G` and `PreservesLimits G`,
  `F.IsSheaf ↔ (F ⋙ G).IsSheaf`.
- `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen` [verified] —
  `Mathlib.AlgebraicGeometry.AffineScheme`. Provides
  `IsLocalization.Away f Γ(X, X.basicOpen f)`.
- `KaehlerDifferential.isLocalizedModule_map` [verified] —
  `Mathlib.RingTheory.Etale.Kaehler`, line 63.
- `KaehlerDifferential.tensorKaehlerEquivOfFormallyEtale` [verified] —
  `Mathlib.RingTheory.Etale.Kaehler`, line 38.
- `Algebra.FormallyEtale.of_isLocalization` [verified] —
  `Mathlib.RingTheory.Etale.Basic`, line 190.
- `AlgebraicGeometry.Modules.tilde` [verified] —
  `Mathlib.AlgebraicGeometry.Modules.Tilde`, line 87.
- `AlgebraicGeometry.Scheme.isBasis_affineOpens` [verified] —
  `Mathlib.AlgebraicGeometry.AffineScheme`.
- `TopCat.Presheaf.isSheaf_iff_isSheafOpensLeCover` [verified] —
  `Mathlib.Topology.Sheaves.SheafCondition.OpensLeCover`.
- `TopCat.Presheaf.isSheafPairwiseIntersections`,
  `TopCat.Presheaf.isSheaf_iff_isSheafPairwiseIntersections` [verified] —
  `Mathlib.Topology.Sheaves.SheafCondition.PairwiseIntersections`, line 280.
- `TopCat.Presheaf.isSheaf_iff_isSheafEqualizerProducts` [verified] —
  `Mathlib.Topology.Sheaves.SheafCondition.EqualizerProducts`.

### Honest gap (cannot be eliminated by name-search alone)

The basis-to-opens descent step (Step 3 of the proof) is tagged
`[gap]` in the chapter. Mathlib search located **no** packaged
"sheaf-on-affine-basis-of-a-Scheme ⇒ sheaf" theorem for
`Scheme.PresheafOfModules`, and no `TopCat.SheafOnBasis` framework
exists (search returned empty for `SheafOnBasis`, `Presheaf.SheafOnBasis`,
`isSheaf_of_isSheafBasicOpens`, `IsSheafForBasicOpens`,
`isSheaf_basis`, and `Sheaf.*basis` regex). The prose now spells out
two concrete prover-side routes:
- **Route (a):** explicit refinement-cofinality argument against
  `isSheaf_iff_isSheafOpensLeCover`.
- **Route (b):** build the global sheaf as the gluing of affine
  `M~`-sheaves along overlaps `V_α ∩ V_β`.

Both are mathematically standard but require prover-side
construction. This is flagged in the chapter via the `\textbf{[gap]}`
paragraph so the plan agent and prover are not misled into expecting
a one-line `exact ...` close.

## Cross-references introduced
- No new `\uses{...}` cross-references; the existing
  `\uses{def:relative_kaehler_presheaf}` on both the theorem block
  and the proof block remains correct.

## Macros needed (if any)
- None. Macros `\struct`, `\Spec` already exist in the chapter's
  preamble (used elsewhere); `\widetilde{...}` and `\xrightarrow{...}`
  are standard LaTeX.

## Reference-retriever dispatches (if any)
- None. The Mathlib sources under `.lake/packages/mathlib/` provided
  all the verification needed via direct `Grep`/`lean_local_search`
  probes; no external references required.

## Notes for Plan Agent

1. **Mathlib gap is real, not paperwork**: the basis-to-opens descent
   step is genuinely a Mathlib infrastructure gap, not a name-lookup
   miss. The prover-side dispatch for
   `relativeDifferentialsPresheaf_isSheaf` should budget for either
   Route (a) (refinement-cofinality against
   `isSheaf_iff_isSheafOpensLeCover`) or Route (b) (explicit
   affine-cover gluing using `ModuleCat.tilde`). Both are
   non-trivial — likely several sub-lemmas of work. The directive's
   "if you genuinely cannot find a Mathlib lemma for the
   basis-to-opens step, flag it as 'needs Mathlib gap-fill'" clause
   has been exercised.

2. **Lean stub L113–122 is consistent with Route (a)**: the existing
   Lean comment in `AlgebraicJacobian/Differentials.lean` at
   L113–122 says "Strategy: reduce to the underlying presheaf of
   types via `isSheaf_iff_isSheaf_comp`, then verify the sheaf
   condition on affine opens using `KaehlerDifferential.isLocalizedModule_map`."
   The rewritten blueprint Step 1 + Step 2 + Route (a) of the gap
   match this Lean strategy verbatim. The prover can take the
   blueprint's recipe as a direct construction outline. If they
   prefer Route (b), they would need to also rewrite the Lean stub's
   strategy comment.

3. **The `KaehlerDifferential.map_R_R_S_T` signature is
   `R → R → S → T`**: I noted in the blueprint that the canonical
   map is `map A A B (Localization.Away f) : Ω_{B/A} →ₗ[B] Ω_{B[1/f]/A}`
   — the `R → R` repetition is intentional (the base ring `R = R = A`
   does not change). The Lean stub already uses this signature
   implicitly via the `PresheafOfModules` construction, so this
   should not surprise the prover, but it is worth noting.

4. **No cross-chapter inconsistencies spotted**: skimmed the rest of
   the chapter for items that might also need `[verified]` tagging,
   and the L877 `\thm:serre_duality_genus`, L636
   `cotangentExactSeq_structure.h_exact`, and dormant-prose-only
   lemmas at L126–145 are all correctly out-of-scope per the
   directive. L718 `\thm:smooth_iff_locally_free_omega` (L176–193)
   and L735 `\cor:cotangent_at_section` (L195–208) name several
   Mathlib lemmas already (`Algebra.IsStandardSmooth.free_kaehlerDifferential`,
   `KaehlerDifferential.span_range_derivation`,
   `SheafOfModules.pullbackObjFreeIso`) without `[verified]` tags;
   re-tagging those is out of scope for this iter but might be a
   future iter's blueprint-reviewer item.

5. **Step 2 tensor-product formula direction**: I wrote
   `Ω_{B/A} ⊗_B B[1/f] ≃ Ω_{B[1/f]/A}`, matching the formal
   `tensorKaehlerEquivOfFormallyEtale` signature
   `T ⊗[S] Ω[S⁄R] ≃ₗ[T] Ω[T⁄R]`. The previous blueprint had
   `Ω_{B[1/f]/A} ≅ Ω_{B/A} ⊗_B B[1/f]` (reversed). Both are
   equivalent mathematically (just take inverse), but the chosen
   direction here matches the Mathlib equiv's forward direction so
   the prover does not have to apply `.symm`.

## Strategy-modifying findings

None. The basis-to-opens descent gap was already implicit in the
existing Lean stub's `sorry`; surfacing it explicitly in the
blueprint as `[gap]` is consistent with the strategic position the
project has already taken on this theorem (Phase B, named "main
outstanding gap" in the Lean comment). No
`STRATEGY.md` update is required.
