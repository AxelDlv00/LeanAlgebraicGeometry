# lean-vs-blueprint-checker — CechHigherDirectImage (iter-262)

**Lean file:** `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`
**Blueprint chapter:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Part (a): Lean decls vs blueprint statements

### Declaration inventory and `\leanok` status

| Blueprint label | `\lean{...}` name | `\leanok`? | Lean body | Sorry? |
|---|---|---|---|---|
| `def:cech_nerve` | `AlgebraicGeometry.CechNerve` | yes | `sorry` | **YES** |
| `def:cech_complex` | `AlgebraicGeometry.CechComplex` | yes | `relativeCechComplexOfNerve f (CechNerve 𝒰 F)` | transitively (via CechNerve) |
| `lem:cech_acyclic_affine` | `AlgebraicGeometry.CechAcyclic.affine` | yes | `sorry` | **YES** |
| `lem:cech_computes_cohomology` | `AlgebraicGeometry.cech_computes_higherDirectImage` | yes | `sorry` | **YES** |
| `def:cech_higher_direct_image` | `AlgebraicGeometry.cechHigherDirectImage` | yes | `(CechComplex f 𝒰 F).homology i` | transitively |
| `lem:cech_flat_base_change` | `AlgebraicGeometry.cech_flatBaseChange` | yes | `sorry` | **YES** |

**`\leanok` discrepancy.** All six blueprint nodes carry `\leanok`, but four of them (`CechNerve`, `CechAcyclic.affine`, `cech_computes_higherDirectImage`, `cech_flatBaseChange`) have `sorry` bodies in Lean. If `\leanok` means "axiom-clean proof complete" (standard leanblueprint semantics), then these four annotations are **incorrect**. If the project's blueprint configuration interprets `\leanok` as "statement formalized / Lean name registered", the annotations are acceptable. Either way, it is a potential source of confusion in the progress display.

### CechComplex body: genuine reduction, not a disguised sorry

`CechComplex` is defined as:
```lean
relativeCechComplexOfNerve f (CechNerve 𝒰 F)
```
where `relativeCechComplexOfNerve` itself has a genuine body:
```lean
(AlgebraicTopology.alternatingCofaceMapComplex S.Modules).obj
  (((CosimplicialObject.whiskering X.Modules S.Modules).obj
      (Scheme.Modules.pushforward f)).obj
    (CosimplicialObject.Augmented.drop.obj N))
```
This is real, coherence-free plumbing. The body composes standard Mathlib functors (`alternatingCofaceMapComplex`, `CosimplicialObject.whiskering`, `Scheme.Modules.pushforward`, `CosimplicialObject.Augmented.drop`) and carries **no sorry**. `CechComplex`'s sorry transitivity flows entirely through `CechNerve`. As the Lean file states, an axiom-clean `CechNerve` would immediately yield an axiom-clean `CechComplex`.

Similarly, `cechHigherDirectImage := (CechComplex f 𝒰 F).homology i` is a genuine one-liner with no hidden sorry; its sorry-transitivity again flows only through `CechNerve`.

### Signature matches

- **CechNerve:** `(𝒰 : X.OpenCover) → (F : X.Modules) → CosimplicialObject.Augmented X.Modules`. Blueprint says "augmented cosimplicial object of O_X-modules" in the module-level doc and chapter header (correct), but the definition body text uses the phrase "augmented *simplicial* object in QCoh(X)" — a terminology error in the blueprint body. A Čech nerve is cosimplicial (faces `[p] → [p+1]`), not simplicial. The Lean type `CosimplicialObject.Augmented` is **correct**; the blueprint body is inconsistent.

- **CechComplex:** `(f : X ⟶ S) → (𝒰 : X.OpenCover) → (F : X.Modules) → CochainComplex S.Modules ℕ`. Blueprint: "relative Čech complex in QCoh(S)". Match.

- **CechAcyclic.affine:** Lean: `[IsAffine X] (f : X ⟶ S) [IsAffineHom f] (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (F : X.Modules) (hF : F.IsQuasicoherent) (p : ℕ) (hp : 1 ≤ p) : IsZero ((CechComplex f 𝒰 F).homology p)`. Blueprint: Čech cohomology vanishes in positive degrees. Signatures align.

- **cech_computes_higherDirectImage:** Lean: `[HasInjectiveResolutions X.Modules] ... : Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)`. Blueprint: "for every i ≥ 0 there is a canonical isomorphism ... ≅ Rⁱ f_* F". Two deviations:
  1. The hypothesis `[HasInjectiveResolutions X.Modules]` appears in the Lean signature but is not mentioned in the blueprint statement. (It is needed to reference the derived-functor `higherDirectImage`.)
  2. The Lean wraps the iso in `Nonempty (…)` rather than producing a direct iso; the blueprint says "canonical isomorphism" without qualification. This weakening is documented in the Lean docstring ("We state the isomorphism as `Nonempty (… ≅ …)`") but the blueprint is silent on it.

- **cechHigherDirectImage:** Lean: `(CechComplex f 𝒰 F).homology i`. Blueprint definition: `H^i(Č•(𝒰, F))`. Match.

- **cech_flatBaseChange:** Lean wraps the iso in `Nonempty (…)`, same issue as above. The cartesian-square setup, flatness hypothesis, and conclusion shape all match the blueprint.

### Project-local helpers not in the blueprint

Three axiom-clean declarations (`coverArrow`, `coverCechNerve`, `relativeCechComplexOfNerve`) have no corresponding blueprint nodes. They are correctly described as "Project-local" in the Lean module doc and are not referenced in the blueprint at all. They do not cause broken `\uses` links, but they represent formalization work invisible to the blueprint dependency graph.

---

## Part (b): Blueprint adequacy for the remaining work

### CechNerve push-pull functor G build

The blueprint is **too thin to guide** the `CechNerve` build. Specifically, the chapter has zero coverage of:

1. **The backbone/functor decomposition strategy.** The Lean file's "Project-local Mathlib supplement" section (L99–124) spells out a two-step plan: (i) geometric backbone via `Arrow.augmentedCechNerve` (axiom-clean, done), then (ii) a push-pull functor `G : (Over X)ᵒᵖ ⥤ X.Modules`, `(Y, p) ↦ p_* p^* F`, whose composition coherence is the hard part. The blueprint has no such decomposition.

2. **The eqToHom-along-Over-triangle + pushforwardComp/pullbackComp coherence wall.** The Lean file identifies this explicitly as the sole remaining obstacle ("its `map_comp` requires the `pushforwardComp` / `pullbackComp` coherence isomorphisms, the same coherence quagmire active in `Picard/TensorObjSubstrate.lean`"). The blueprint is completely silent on this wall and gives no strategies for navigating it.

3. **What `coverArrow`, `coverCechNerve`, `relativeCechComplexOfNerve` accomplish.** These project-local bricks enable the nerve-to-complex passage to be "coherence-free plumbing" (the key architectural insight). A prover approaching `CechNerve` from the blueprint alone would not know this strategy exists, would not know the backbone is already clean, and would not know the only gap is the push-pull functor's `map_comp`.

**Net assessment:** A prover working from the blueprint chapter alone cannot make progress on `CechNerve`. The Lean file's "Project-local Mathlib supplement" section (L99–157) is the only adequate guide and should be promoted to a blueprint section.

### Three downstream theorems (CechAcyclic.affine, cech_computes_higherDirectImage, cech_flatBaseChange)

The blueprint's mathematical descriptions are accurate and the Stacks references are correct. The `\uses` dependency chains are internally consistent and non-circular:

```
def:cech_nerve ← def:cech_complex ← lem:cech_acyclic_affine
                                   ↖
                    lem:cech_computes_cohomology ← def:cech_higher_direct_image
                                                 ↖
                                         lem:cech_flat_base_change
```

However, all three sorry'd theorems require Mathlib-absent infrastructure that the blueprint does not flag:

- **CechAcyclic.affine:** Requires the explicit localisation description of `CechComplex` on affines (connecting `CochainComplex S.Modules ℕ` to the concrete localization complex) and a module-level contracting homotopy construction for `Scheme.Modules`. Neither exists in Mathlib.

- **cech_computes_higherDirectImage:** Requires the Čech-to-cohomology spectral sequence for `Scheme.Modules` and the Leray spectral sequence for separated quasi-compact morphisms. Neither is in Mathlib for the `Scheme.Modules` setting.

- **cech_flatBaseChange:** Requires term-wise affine base change for the relative Čech complex (i.e., that `(f|_{U_{i_0…i_p}})_* (F|_{U_{i_0…i_p}}) ⊗_A B ≅ (f'|_{(U_{i_0…i_p})_B})_* (F'|_{(U_{i_0…i_p})_B})`) and exactness of `- ⊗_A B` on `Scheme.Modules`. Both absent.

The blueprint proofs read as if these Stacks arguments transfer directly to Lean, but they don't without substantial Mathlib scaffolding. The blueprint should document these as explicit Mathlib gaps.

### `\uses` broken links

No broken `\uses` links found. All referenced labels exist within the same chapter. The `def:cech_higher_direct_image \uses{lem:cech_computes_cohomology}` link is a logical (not technical) dependency — the Lean `cechHigherDirectImage` does not actually import `cech_computes_higherDirectImage` — but this is acceptable blueprint practice for documenting justification.

---

## Summary

**Part (a):**
- `CechComplex` and `cechHigherDirectImage` have genuine bodies (real reductions, not disguised sorries); the sole sorry-transitivity flows through `CechNerve`.
- `\leanok` on all six blueprint nodes is misleading: four currently have sorry bodies.
- Blueprint body uses "simplicial" for a cosimplicial object — terminology error.
- `cech_computes_higherDirectImage` has an undocumented `[HasInjectiveResolutions X.Modules]` hypothesis and both comparison theorems use `Nonempty (≅)` without blueprint documentation.

**Part (b):**
- Blueprint is **inadequate** for the `CechNerve` push-pull functor build: backbone/functor decomposition, the eqToHom+coherence wall, and the project-local helper strategy are entirely absent.
- Three downstream sorries have mathematically correct blueprint statements but no documentation of the substantial Mathlib-absent infrastructure each requires.
- `\uses` chains are internally consistent; no broken links.
- Recommended blueprint additions: a section on the backbone/functor decomposition and the pushforwardComp/pullbackComp coherence obstacle; Mathlib-gap flags on all three sorry'd theorems.
