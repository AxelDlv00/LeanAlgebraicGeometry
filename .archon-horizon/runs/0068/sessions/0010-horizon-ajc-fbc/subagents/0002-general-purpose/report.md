You are attempting ONE Lean 4 proof obligation in an existing formalization. Report honestly whether it closes; a precise negative with the blocking goal state is as valuable as a success. DO NOT introduce any new `sorry` into the library file. Work in a SCRATCH file at the project root.

## Setup

Project: /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge
Build from there with `lake env lean <file>` (the module olean is already built and current).
Scratch file naming: use `probe_<something>.lean` at the project ROOT — that pattern is gitignored, so never move it into AlgebraicJacobian/.

Load the lean-check skill's loop: use the `lean-lsp` MCP tools (`lean_goal`, `lean_diagnostic_messages`, `lean_multi_attempt`, `lean_hover_info`, `lean_local_search`, `lean_loogle`, `lean_leansearch`) against your scratch file for the edit loop. NOTE: `lean_diagnostic_messages` on the big library file can take 10+ minutes; on a small scratch file it is fast. Prefer a small scratch file with a single `import`.

Start your scratch file with:
```lean
import AlgebraicJacobian.Cohomology.CechHigherDirectImageUnconditional
open CategoryTheory Limits AlgebraicGeometry
namespace AlgebraicGeometry
universe u
variable {S S' X X' : Scheme.{u}}
```

## THE OBLIGATION

In `AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean` there is a `Prop`-valued definition `TwistedPerSigmaDeltaCompat` (search for it; ~line 2985). Your job is to try to PROVE it, i.e. produce a theorem of this shape (all names exist and are sorry-free unless noted):

```lean
theorem attempt (f : X ⟶ S) (g : S' ⟶ S) (f' : X' ⟶ S') (g' : X' ⟶ X)
    (h : IsPullback g' f' f g) (𝒰 : X.OpenCover) [IsSeparated f] [IsAffine S]
    [∀ i, IsAffine (𝒰.X i)] (F : X.Modules) (hF : F.IsQuasicoherent) :
    TwistedPerSigmaDeltaCompat f g f' g' h 𝒰 F hF := by
  ...
```

Unfolding it, for every `p : ℕ`, `k : Fin (p+2)` and `σ' : Fin (p+2) → 𝒰.I₀` you must show

  (twisted_cech_nerve_per_sigma f g f' g' h 𝒰 F hF (σ' ∘ (SimplexCategory.δ k).toOrderHom)).hom
      ≫ pushPullMap ((Scheme.Modules.pullback g').obj F) (interLegHom 𝒰' σ' k)
    = (Scheme.Modules.pullback g').map (pushPullMap F (interLegHom 𝒰 σ' k))
        ≫ (twisted_cech_nerve_per_sigma f g f' g' h 𝒰 F hF σ').hom

where `𝒰' = (Scheme.Pullback.openCoverOfLeft 𝒰 f g).pushforwardIso h.isoPullback.symm.hom`.
(Useful fact just proved in the file: `baseChangedCover_I₀` says `𝒰'.I₀ = 𝒰.I₀` **by rfl**, so tuples into `𝒰.I₀` can be used for `𝒰'` with no transport.)

Mathematically this says: **base-change-then-restrict = restrict-then-base-change** for the intersection-open inclusions `U_{σ'} ⊆ U_{σ'∘δᵏ}` and their base changes along `g'`.

## WHAT THE INGREDIENTS ARE

`twisted_cech_nerve_per_sigma` (same file, ~line 2143, sorry-free) is defined as a composite of exactly two things:
1. `openImmersion_beckChevalley g' (coverInterOpen_isAffine f 𝒰 σ) (pullback.fst g' (ι U_σ)) (pullback.snd g' (ι U_σ)) (restrictedCartesianAffinePushout g' 𝒰 σ) F hF`
2. `≪≫ pushPullObjCongr _ (Over.isoMk (IsOpenImmersion.isoOfRangeEq ...) (IsOpenImmersion.isoOfRangeEq_hom_fac ...))` — a slice transport along an `isoOfRangeEq` between two open immersions with the same range, the range equality coming from `coverInterOpen_baseChange_eq`.

Read its full body in the file before starting.

Key helper facts (all in the project, verify names/signatures with `#check`):
- `pushPullObjCongr F e : pushPullObj F Y ≅ pushPullObj F Y'` for `e : Y ≅ Y'`, with `.hom = pushPullMap F e.inv` and `.inv = pushPullMap F e.hom` (CechSectionIdentificationBase.lean:907).
- `pushPullMap_comp F g h : pushPullMap F (h ≫ g) = pushPullMap F g ≫ pushPullMap F h` (contravariant!).
- `pushPullMap_id`.
- `interLegHom 𝒰 σ' k : Over.mk (ι (coverInterOpen 𝒰 σ')) ⟶ Over.mk (ι (coverInterOpen 𝒰 (σ' ∘ δᵏ)))` is `Over.homMk (X.homOfLE ...)` — an open inclusion of intersection opens (CechSectionIdentificationLeg.lean:704), and `interLegHom_eq_openOverHomOfLE` (LegTop.lean:425, `private`) says it is `openOverHomOfLE` by `rfl`.
- `coverInterOpen_baseChange_eq` (~line 1384): `coverInterOpen 𝒰' σ = g' ⁻¹ᵁ coverInterOpen 𝒰 σ`.
- `openImmersion_beckChevalley` (~line 1837).
- `openImmersion_bareBC`, `openImmersion_bc_telescope`, `openImmersion_bareBC_app_eq` (the mate factorization).

## PLAN, and please follow this order

**STEP 1 — the cheap probes first.** Before any real work, test whether the whole thing is definitional or nearly so. In a scratch file, state the goal and try, each on its own: `rfl`, `Over.OverMorphism.ext; rfl`, `simp`, `aesop_cat`, `cat_disch`. Use `lean_multi_attempt`. Report exactly what each says. (This tree has repeatedly found obligations that were `rfl`.)

**STEP 2 — locate where the equation must come from.** Both sides are maps between `pushPullObj`s. Note that `openImmersion_beckChevalley` is an `Iso` built from `asIso` of a mate component plus a telescope; the composite of the two sides differs by which order the "restrict along an inclusion" and "base change along g'" steps are applied. Try to reduce the goal to a statement purely about the `Over`-category morphisms (i.e. that two composites of `Over.homMk`s agree), which `Over.OverMorphism.ext` + `pullback.hom_ext`/`WidePullback.hom_ext`-style reasoning can close. Specifically investigate whether the goal follows from NATURALITY of `openImmersion_bareBC` (it is a `mateEquiv` of a natural transformation, hence natural in the module argument — but here the *square* changes, not the module, which is the crux). Report what you find.

**STEP 3 — if it does not close, identify the minimal missing lemma PRECISELY.** State it in Lean (as a `theorem ... := sorry` in your SCRATCH file only), and say exactly which goal it would close and why the existing lemmas cannot. In particular determine whether the crux is:
 (a) naturality of `openImmersion_beckChevalley` with respect to a morphism of cartesian squares (i.e. the two restricted squares over `U_{σ'}` and `U_{σ'∘δᵏ}` are related by an inclusion, and the Beck-Chevalley isos must commute with it), or
 (b) compatibility of the `isoOfRangeEq` slice transports with the inclusions, or
 (c) something else.
This determination is the single most valuable thing you can report if the proof does not close.

## Reporting

Report: (i) what STEP 1's probes said, verbatim; (ii) how far you got, with the exact remaining goal state if unclosed; (iii) the STEP-3 determination (a)/(b)/(c) with evidence; (iv) any lemma you DID prove, with its full statement and proof text so I can paste it into the library. Be explicit about what you machine-checked versus reasoned about. Delete your scratch files when done, or tell me their paths.
