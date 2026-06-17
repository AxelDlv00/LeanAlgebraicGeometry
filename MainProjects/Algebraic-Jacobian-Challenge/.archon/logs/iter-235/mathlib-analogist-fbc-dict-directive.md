# Mathlib-analogist directive — iter-235 — FlatBaseChange affine tilde dictionary

## Mode: api-alignment

## Context (self-contained)

We are building, project-side, the affine case of flat base change for `i=0` pushforward of
quasi-coherent sheaves (Stacks 02KH) in
`AlgebraicJacobian/Cohomology/FlatBaseChange.lean`. The target theorem
`affineBaseChange_pushforward_iso` reduces (via a proven affine-open locality criterion) to showing
the base-change comparison map `pushforwardBaseChangeMap` is an iso on each affine open, which in turn
needs an **affine Spec/tilde pushforward/pullback dictionary**. A prover spent iter-234 on the
global-sections fragment of this dictionary and hit a hard typeclass-instance wall, then identified a
recommended element-free route but could not complete it. We need a Mathlib-API analysis before the
next prover round (the lane was just ruled STUCK by the convergence critic; the corrective is this
consult). The informal-LLM agent is unavailable (no API key); use Lean search tools (loogle /
leansearch / local search / declaration inspection) over current Mathlib.

## Confirmed Mathlib facts (from the iter-234 prover, for your orientation — verify/extend)

- `Scheme.Modules` pushforward/pullback: `Mathlib/AlgebraicGeometry/Modules/Sheaf.lean`.
  `pushforward_obj_obj : Γ((pushforward f).obj M, U) = Γ(M, f ⁻¹ᵁ U)` is `rfl`.
- Tilde dictionary: `Mathlib/AlgebraicGeometry/Modules/Tilde.lean` —
  `tilde.functor R : ModuleCat R ⥤ (Spec R).Modules`,
  `moduleSpecΓFunctor : (Spec R).Modules ⥤ ModuleCat R`,
  `tilde.adjunction : tilde.functor R ⊣ moduleSpecΓFunctor` (with `IsIso unit`),
  counit `Scheme.Modules.fromTildeΓ` + `isIso_fromTildeΓ_iff` (iso ⇔ quasicoherent).
  `IsQuasicoherent` appears only as an instance ON `tilde M`.
- `PresheafOfModules.pushforward φ = pushforward₀ F R ⋙ restrictScalars φ`
  (`Mathlib/Algebra/Category/ModuleCat/Presheaf/Pushforward.lean`) — the pushforward module structure
  IS `restrictScalars` along the ring-sheaf map.
- `moduleSpecΓFunctor`'s R-module structure = `Module.compHom` along `(StructureSheaf.globalSectionsIso R).hom`.
- Naturality: `Scheme.ΓSpecIso_naturality` / `Scheme.ΓSpecIso_inv_naturality`
  (`Mathlib/AlgebraicGeometry/Scheme.lean:613/619`).
- `ModuleCat.restrictScalarsComp'App`, `restrictScalarsId'App` (identity-carrier restriction-of-scalars isos).
- `set_option backward.isDefEq.respectTransparency false` is required for any iso between
  restrictScalars-of-Spec-modules to typecheck.

## The two questions to answer with Mathlib idioms

### Q1 — element-free handle for the Γ-fragment iso
The prover's recommended route builds
`(restrictScalars φ.hom).obj ((moduleSpecΓFunctor (R:=R')).obj (tilde M)) ≅
 (moduleSpecΓFunctor (R:=R)).obj ((pushforward (Spec.map φ)).obj (tilde M))`
entirely from identity-carrier isos (`restrictScalarsComp'App` + an `eqToIso` from the RingHom equality
`ΓSpecIso_inv_naturality`), avoiding any element-level `map_smul'` (which hit the instance wall:
intermediate `Module.compHom`/`restrictScalars` actions on the carrier are not synthesizable as named
`SMul`/`Module` instances). The BLOCKER on this route: step (b) needs the explicit pushforward ring map
`ψ : Γ(Spec R,⊤) → Γ(Spec R',⊤)` dug out of `SheafOfModules.pushforward` / `PresheafOfModules.pushforward`
internals — but `(Spec.map φ).toRingCatSheafHom` is an `InducedCategory.Hom` (NOT a `Sheaf.Hom`), so
`.val.app (op ⊤)` does not project.
- **Which Mathlib accessor exposes the ring-sheaf map (and its `app (op ⊤)`) underlying
  `SheafOfModules.pushforward` / `Scheme.Modules.pushforward (Spec.map φ)`?** Name the projection chain
  through `sheafPushforwardContinuous` / `PresheafOfModules.pushforward₀` / `toRingCatSheafHom` /
  `InducedCategory` that lands on a usable `RingHom` (or `CommRingCat`/`RingCat` morphism) at `op ⊤`.
- Is `(Spec.map φ) ⁻¹ᵁ ⊤ = ⊤` true by `rfl`, or only by `simp`? If not `rfl`, name the `eqToHom`/`Opens`
  transport idiom Mathlib uses to align `Γ(tilde M, (Spec.map φ)⁻¹ᵁ ⊤)` with the section at `⊤`.
- Is there an existing Mathlib lemma stating `pushforward (Spec.map φ) (tilde M) ≅ tilde (restrictScalars φ.hom M)`
  directly (an affine-pushforward-of-tilde formula), so the whole element-free dance is unnecessary?
  Search thoroughly — this is the highest-value possible find.

### Q2 — is QC-of-pushforward genuinely Mathlib-absent?
The prover asserts there is NO Mathlib lemma that `pushforward (Spec.map φ)` (or pushforward along an
affine / quasi-compact-quasi-separated morphism) preserves `IsQuasicoherent`. This is a true theorem
(Stacks: pushforward along affine morphism preserves quasi-coherence) and would, if present, supply the
object-level dictionary brick directly.
- **Confirm or refute**: does Mathlib have ANY form of "pushforward preserves quasi-coherent" — for
  affine morphisms, closed immersions, finite morphisms, or `Spec.map`? Check
  `Mathlib/AlgebraicGeometry/Morphisms/QuasiCoherent*`, `.../Modules/`, `IsQuasicoherent` references.
- If genuinely absent: what is the smallest Mathlib-gradient build path (which existing lemmas) to
  construct `IsQuasicoherent ((pushforward (Spec.map φ)).obj (tilde M))` project-side?

## Output wanted
For each question: the Mathlib idiom (if it exists) with exact declaration names + file paths, OR a
clear "genuinely absent" with the cheapest project-side build path. Rank Q1's "direct affine-pushforward-
of-tilde iso exists?" find first if it lands. Persist the rationale to `analogies/<slug>.md`.
