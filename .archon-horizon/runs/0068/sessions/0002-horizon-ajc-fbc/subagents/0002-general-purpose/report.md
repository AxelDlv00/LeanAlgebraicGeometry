I have everything needed. No project files were edited; all work is in `/tmp/fbcprobe/`.

## Verdict

**`pullback_preservesMonomorphisms` is NOT provable today as stated (arbitrary modules), but it is much closer than the file's docstring claims, and two adjacent open targets in the project DO close now.** All snippets below compiled sorry-free and axiom-clean (`[propext, Classical.choice, Quot.sound]`) against the project at HEAD.

### A. Stalk of the module pullback in mathlib: NOT FOUND

Confirmed by exhaustive grep. `Mathlib/Algebra/Category/ModuleCat/{Presheaf,Sheaf}/**` contains **zero** occurrences of `stalk` and zero of `tensor` outside `Monoidal`. `SheafOfModules.pullback` / `PresheafOfModules.pullback` are `(pushforward φ).leftAdjoint`, built purely by corepresentability (`pullbackObjIsDefined_eq_top` via `freeYoneda`); there is no pointwise, section-level, or stalk description anywhere.

Decisive confirmation that `PresheafOfModules.pullback` has **no API beyond left-adjointness**: outside its own defining file, mathlib references it in exactly **zero** places. Only `pullbackId`, `pullbackComp`, the associativity/unitality coherences, and (in `PullbackFree.lean`) `pullbackObjFreeIso` exist. `TopCat.Presheaf.stalkPullbackIso` (Stalks.lean:330) is about `TopCat.Presheaf.pullback`, and nothing connects it to the module-level pullback.

### B. Route B (sheafification/stalk) — reduction verified, but it inherits the same gap

I proved the reduction to the presheaf factor is the right categorical move; both outer factors of `pullbackIso` preserve monos on the scheme site (`SheafOfModules.forget` and `PresheafOfModules.sheafification` both via `preservesMonomorphisms_of_preservesLimitsOfShape` on their existing `PreservesFiniteLimits` instances). But step (i) — relating the underlying Ab-presheaf of `PresheafOfModules.pullback` to `TopCat.Presheaf.pullback` — has **no handle at all**, per A. Route B is a genuine dead end at the same place.

### The productive finding: the stalk route is fully assembled except ONE lemma

`/tmp/fbcprobe/FINAL_STALK.lean` proves, sorry-free:

- `stalkMapₗ` — `𝒪_{X,x}`-linearity of the Ab-stalk map, for **arbitrary schemes** (the project only has this tilde-specific, in `TildeExactness.lean:185`). Built from `PresheafOfModules.germ_smul` + `Scheme.Modules.Hom.app_smul`.
- `pullbackStalkHom g M y : M_{g y} ⟶ (g^*M)_y` — the canonical stalk comparison (unit + `stalkPushforward`), **plus its naturality in `M`** (this needed a hand proof; mathlib has no naturality lemma for `stalkPushforward` in the presheaf variable).
- `baseChange_injective_of_flat` — the algebraic core, via `Module.Flat.lTensor_preserves_injective_linearMap`.
- `pullback_preservesMonomorphisms_of_stalkBaseChange` — **the target theorem**, conditional on one hypothesis.

The single missing piece, exactly as a Lean statement:

```lean
def StalkBaseChange {X Y : Scheme.{u}} (g : Y ⟶ X) (M : X.Modules) (y : Y) : Prop :=
    letI algI := (g.stalkMap y).hom.toAlgebra
    letI modI : Module (X.presheaf.stalk (g.base y))
        (((Scheme.Modules.pullback g).obj M).presheaf.stalk y) :=
      Module.compHom _ (g.stalkMap y).hom
    letI twI : IsScalarTower (X.presheaf.stalk (g.base y)) (Y.presheaf.stalk y)
        (((Scheme.Modules.pullback g).obj M).presheaf.stalk y) :=
      .of_algebraMap_smul fun _ _ => rfl
    ∃ f : (M.presheaf.stalk (g.base y)) →ₗ[X.presheaf.stalk (g.base y)]
        ((Scheme.Modules.pullback g).obj M).presheaf.stalk y,
      (∀ m, f m = pullbackStalkHom g M y m) ∧ IsBaseChange (Y.presheaf.stalk y) f
```

That is, `(g^*M)_y ≅ M_{g y} ⊗_{𝒪_{X,g y}} 𝒪_{Y,y}`. Everything else — flatness of the stalk map (`AlgebraicGeometry.Flat.stalkMap`, which does apply and typechecks), stalkwise mono detection, the tensor algebra, the naturality square — is done. This is the smallest missing piece, and it is **not** provable from current mathlib for arbitrary `M`, because it is precisely a pointwise description of a functor that has none.

### C. Route C — the affine-chart route: locality WORKS, but only quasi-coherently

Two separate results, both sorry-free:

1. `/tmp/fbcprobe/FINAL_ROUTEC_LOCAL.lean` — **mono-preservation of `g^*` genuinely is local on the source**, unconditionally and for arbitrary modules: `pullback_preservesMonomorphisms_of_affine_charts` reduces the target to the affine-over-affine case `g.resLE V W : W ⟶ V`. Supporting pieces: `mono_of_mono_restrict` (mono is local) and `restrictPullbackIso` (the factorization `g^* ∘ restrict_W ≅ restrict_V ∘ (g.resLE)^*`, built from `pullbackComp` + `resLE_comp_ι`).

2. `/tmp/fbcprobe/FINAL_ROUTEC_QCOH.lean` — `pullback_mono_of_qcoh`: **flat pullback preserves monos between quasi-coherent modules**, complete and sorry-free, via the project's `pullback_app_isoTensor_baseMap_sectionLinearEquiv` (which I verified is axiom-clean) + `flat_appLE` + `Module.Flat.lTensor_preserves_injective_linearMap`. I had to re-derive the private `pullback_app_isoTensor_baseMap_naturality` (~15 lines, reproduces cleanly outside the private scope).

**The decisive negative you asked me to state plainly: route C handles ONLY quasi-coherent modules.** The section formula carries `[N.IsQuasicoherent]` irremovably — over an affine scheme `Scheme.Modules` is not `ModuleCat Γ(S,⊤)`, only the quasi-coherent ones are, so there is no affine section model for a general module. Route C cannot reach the instance as stated.

### Recommendation

The statement as written (all modules) is blocked on `StalkBaseChange`, which is a real mathlib gap, not a glue gap. Two bounded options:

- **Weaken the hypothesis** to `[M.IsQuasicoherent] [N.IsQuasicoherent]` and land `pullback_mono_of_qcoh` today. Worth checking whether the Čech consumers only ever need quasi-coherent monos — `CechComplex` is built from quasi-coherent sheaves, and `pullback_isQuasicoherent_hom` already exists, so this may well suffice downstream and would remove the `sorryAx` leak entirely.
- Keep the general statement and land the `StalkBaseChange`-conditional version, which converts a three-functor sheafification obligation into one concrete stalk formula.

### Bonus: two currently-open project targets close now

`/tmp/fbcprobe/FINAL_TILDE.lean` proves both sorry-free from the project's existing `stalkMapₗ_injective`:
- `tilde_preservesMonomorphisms`
- `tildePreservesFiniteLimits` — **the named open target of `Cohomology/TildeExactness.lean`**

That file's docstring says ~100–150 LOC remain and prescribes a `JointlyReflectIsomorphisms` route. That is stale: mono-preservation plus the existing `preservesFiniteLimits_of_preservesMonomorphisms` closes it in about 15 lines, with no stalkwise-isomorphism upgrade needed. Note this is `TildeExactness.lean`, in the Cohomology lane.
