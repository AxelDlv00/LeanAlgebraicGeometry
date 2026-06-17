# Directive: lean-scaffolder — create two new downstream files (stubs only)

Create TWO new Lean files with declaration stubs (`sorry` bodies) + rich `/- Planner strategy: … -/`
comment blocks, and wire both into the build root. Do NOT attempt any proof. Each stub must compile
(`sorry` warning is fine). Verify referenced decl names exist via Lean search before using them.

Blueprint source of truth: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` — you MAY
read it for the exact statements (`lem:cech_augmented_resolution`,
`lem:open_immersion_pushforward_comp`).

## File 1 — `AlgebraicJacobian/Cohomology/CechAugmentedResolution.lean`

### Imports (these supply every ingredient of the proof route; placing the theorem here breaks the
### import cycle that blocked it in CechHigherDirectImage.lean):
```
import AlgebraicJacobian.Cohomology.CechHigherDirectImage   -- the object layer: cechAugmentedComplex et al.
import AlgebraicJacobian.Cohomology.CechAcyclic             -- sectionCech_homology_exact_of_localizationAway, sectionCechComplex
import AlgebraicJacobian.Cohomology.HigherDirectImagePresheaf -- PresheafOfModules.homologyIsoSheafify
import AlgebraicJacobian.Cohomology.AffineSerreVanishing    -- affineCoverSystem, standard_cover_cofinal
import AlgebraicJacobian.Cohomology.QcohTildeSections       -- qcoh_iso_tilde_sections
```
Namespace `AlgebraicGeometry`. Open whatever the object layer uses (`CategoryTheory`,
`CategoryTheory.Limits`).

### Declaration to stub: `cechAugmented_exact`
Pinned in the blueprint as `\lean{AlgebraicGeometry.cechAugmented_exact}`. It asserts the augmented
Čech complex `cechAugmentedComplex 𝒰 F` (already defined in `CechHigherDirectImage.lean`, line ~745)
is **exact / acyclic** — every homology object is zero. Produce a faithful signature:
- the cover `𝒰 : X.OpenCover` with `[Finite 𝒰.I₀]`;
- `F : X.Modules` quasi-coherent (`(hF : F.IsQuasicoherent)` or `[F.IsQuasicoherent]` — match the
  convention used by `cech_computes_higherDirectImage` in CechHigherDirectImage.lean, line ~773);
- whatever **affineness** hypothesis the route needs: the route uses `qcoh_iso_tilde_sections`, which
  requires each cover open (and its intersections) to be affine. Read how `affineCoverSystem` /
  `qcoh_iso_tilde_sections` phrase affineness and mirror it (e.g. a hypothesis `∀ i, IsAffineOpen
  (𝒰.obj i …)` or that 𝒰 is an affine cover). Do NOT invent a weaker hypothesis — the lemma is FALSE
  without affineness.
- Conclusion: `∀ i, CategoryTheory.Limits.IsZero ((cechAugmentedComplex 𝒰 F).homology i)` (or the
  Mathlib `HomologicalComplex` exactness predicate — pick the form the downstream consumer
  `lem:cech_term_pushforward_acyclic` will want; if unsure, the `∀ i, IsZero (homology i)` form is
  safest and the most directly provable). Body: `sorry`.

### `/- Planner strategy: … -/` block above the stub (inject verbatim, prose only):
> Route: sections + sheafification (NOT stalks — `SheafOfModules.stalk` is absent from Mathlib).
> Step 1: reflect `IsZero (homology p)` through the faithful additive forgetful functor
> `SheafOfModules.toSheaf` (it preserves zero morphisms, so it reflects the zero object). Step 2:
> the homology SHEAF = sheafification of the PRESHEAF homology, via the project engine
> `PresheafOfModules.homologyIsoSheafify` (HigherDirectImagePresheaf.lean). Step 3: the presheaf
> homology is `V ↦ Ȟᵖ(V,F)`, locally zero on the affine basis — over each basic affine `D(g) ⊆ Uᵢ`,
> `qcoh_iso_tilde_sections` gives `F|_{D(g)} ≅ ~M` and
> `sectionCech_homology_exact_of_localizationAway` (CechAcyclic.lean) kills positive-degree homology;
> the basic affines are cofinal (`standard_cover_cofinal` / `affineCoverSystem`), so the map
> `0 → presheaf-homology` is locally bijective, hence its sheafification (= the homology sheaf) is
> zero. The reusable abelian-sheaf site lemmas `isZero_presheafToSheaf_obj_of_W` /`_of_W_isZero`/
> `_of_isLocallyBijective` (in CechHigherDirectImage.lean, importable) discharge the site-theory half.
> The ONE bridge to build here: connect the module-level `homologyIsoSheafify` to those abelian-sheaf
> site lemmas via the sheafification square `toSheaf ∘ sheafification ≅ presheafToSheaf ∘ forget`
> (cf. `PresheafOfModules.sheafificationCompToSheaf`, used in AffineSerreVanishing.lean; see
> `analogies/tosheaf-epi.md` and the iter-053 mathlib-analogist report on the toSheaf-reflection
> bridge). Diamond-prone — work with `.hom` not `.val`, defeq/`change` not `rw`. Step 4: the
> degree-0 augmentation node uses the same spanning-family exactness (`exact_of_isLocalized_span` /
> `combDifferential_exact`). Blueprint: `lem:cech_augmented_resolution`.

## File 2 — `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`

### Imports:
```
import AlgebraicJacobian.Cohomology.AffineSerreVanishing      -- affine_serre_vanishing (unconditional)
import AlgebraicJacobian.Cohomology.HigherDirectImagePresheaf -- higher_direct_image_presheaf, higherDirectImage_iso_sheafify_presheafHomology
import AlgebraicJacobian.Cohomology.AcyclicResolution         -- acyclic-resolution comparison (P4)
```
Namespace `AlgebraicGeometry`.

### Declaration to stub: `higherDirectImage_openImmersion_comp`
Pinned `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp}`. READ the blueprint block
`lem:open_immersion_pushforward_comp` (≈ lines 7389–7476) for the precise two-part statement:
(1) for an open immersion `j : U ↪ X` of an affine open `U` into a separated `X`, `R^q j_* H = 0`
for `q ≥ 1` and qcoh `H`; (2) `R^k f_*(j_* H) ≅ R^k (f∘j)_* H` for any `f : X → S`. Produce a
faithful Lean signature mirroring the blueprint hypotheses (X separated, U affine open, j the open
immersion, H quasi-coherent). If the two parts are cleanest as two declarations, create both (e.g.
`higherDirectImage_openImmersion_acyclic` for (1) and `higherDirectImage_openImmersion_comp` for (2),
with (2) the pinned name). Bodies: `sorry`.

### `/- Planner strategy: … -/` block (prose only):
> Part (1): `R^q j_* H` is the sheafification of `V ↦ H^q(j⁻¹V, H)` (presheaf description
> `higher_direct_image_presheaf`, Stacks 01XJ); for affine `V`, `j⁻¹V = U ∩ V` is affine (U affine,
> X separated), so `affine_serre_vanishing` kills `H^q` for `q ≥ 1`; affine opens are a basis ⇒
> `R^q j_* H = 0`. Part (2): take an injective resolution `H → I•`; `j_* I•` is a resolution of
> `j_* H` (each `j_* Iⁿ` is `j_*`-acyclic by (1)) and each `j_* Iⁿ` is `f_*`-acyclic (same presheaf
> + Serre-vanishing argument on `U ∩ f⁻¹V`); so `j_* I•` is an `f_*`-acyclic resolution of `j_* H`,
> and the P4 acyclic-resolution comparison (`acyclic_resolution_computes_derived` /
> `rightDerivedIsoOfAcyclicResolution`) with `G = f_*` gives `R^k f_*(j_* H) ≅ H^k(f_*(j_* I•)) =
> H^k((f∘j)_* I•) = R^k (f∘j)_* H`, using `f_* ∘ j_* = (f∘j)_*`. Blueprint:
> `lem:open_immersion_pushforward_comp`. Source: Stacks `lemma-relative-affine-vanishing`.

## Build wiring (REQUIRED)
Add both import lines to the build root `AlgebraicJacobian.lean` (after the existing
`import AlgebraicJacobian.Cohomology.QcohTildeSections` line, preserving ordering style):
```
import AlgebraicJacobian.Cohomology.CechAugmentedResolution
import AlgebraicJacobian.Cohomology.OpenImmersionPushforward
```

## Verification before you finish
Run `lake env lean` on each new file (or `lake build`) and confirm it compiles with only the
expected `sorry`/`declaration uses sorry` warnings — no errors, no unresolved imports, no unknown
identifiers. Report the exact final signatures you produced for both pinned declarations.
