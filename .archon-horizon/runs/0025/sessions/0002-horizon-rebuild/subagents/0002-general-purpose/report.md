Both deliverables are landed, kernel-green, and axiom-clean. Final report:

## Files created

1. `/home/Axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/SectionsBaseChange.lean` — **359 lines** (brick 1, design §4.4)
2. `/home/Axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/UniversalSections.lean` — **195 lines** (brick 2)

No other file touched. No `sorry` anywhere.

## Key route discovery (deviates from design's expected labor, same statements)

Mathlib v4.31 already contains the flat-base-change-of-sections engine: the `pushoutSection` API in `Mathlib/AlgebraicGeometry/Morphisms/Flat.lean` (`isIso_pushoutSection_of_isAffineOpen`, `isIso_pushoutSection_of_isQuasiSeparated_of_flat_right` — the latter IS the "finite affine ladder + flat ⊗ commutes with finite limits" argument the design foresaw hand-rolling). So brick 2 needs **neither the two-cover equalizer nor TwoCover.lean at all**; both bricks reduce to a thin Over↔pullback bridge plus `ΓSpecIso` corner bookkeeping. Statements are strictly stronger than pinned: `V` may be any **qcqs** open (so `V₀ ⊓ V₁` works directly for the χ-ledger), affine `V` is a wrapper.

## Public declarations (all in namespace `AlgebraicGeometry`)

**SectionsBaseChange.lean:**
- `Over.isPullback_left (X T : Over S) : IsPullback (fst X T).left (snd X T).left X.hom T.hom` — THE bridge (any base scheme `S`); proof is one `simp only [Over.fst_left, Over.snd_left]` away from `IsPullback.of_hasPullback` (the monoidal instance is definitionally `Limits.pullback`).
- `overSpec (k A : Type u) [CommRing k] [CommRing A] [Algebra k A] : Over (Spec (.of k))` := `Over.mk (Spec.map (ofHom (algebraMap k A)))` (+ simp lemmas `overSpec_left`, `overSpec_hom`, lemma `isAffineOpen_top_overSpec`, instance `flat_overSpec_hom` over a field).
- `Over.isPushout_sections_of_isAffineOpen` / `Over.isPushout_sections` — master squares for **arbitrary** `T : Over (Spec k)` with `⊤ : T.left.Opens` affine: `IsPushout (X.hom.appLE ⊤ V _) (T.hom.appLE ⊤ ⊤ _) ((fst X T).left.appLE V (fst⁻¹ᵁV) le_rfl) ((snd X T).left.appLE ⊤ (fst⁻¹ᵁV) _)` — affine `V` needs no flatness; qcqs `V` needs `[Flat T.hom]` (free for `overSpec`). These will serve the étale covers `T' E` later.
- `Over.sectionsAlgebra (X) (V) : Algebra k Γ(X.left, V)` — `@[reducible]`, **not global**; consumers must `attribute [local instance] Over.sectionsAlgebra` (house rule mirrored from `Scheme.overModule`; unfolding lemma `Over.ofHom_algebraMap_sections` is `rfl`; `Over.algebraMap_sections_comp_res`).
- `Over.resAlgHom (h : W ≤ V) : Γ(X.left, V) →ₐ[k] Γ(X.left, W)` (+ simp `resAlgHom_apply`).
- `Over.isPushout_algebraMap_sections` — the square with corners `k`, `A`: `IsPushout (ofHom (algebraMap k Γ(X.left,V))) (ofHom (algebraMap k A)) (fst-appLE) ((ΓSpecIso (.of A)).inv ≫ snd-appLE)`.
- **`Over.sectionsBaseChange (X) (A) (hV : IsCompact ↑V) (hV' : IsQuasiSeparated ↑V) : Γ(X.left, V) ⊗[k] A ≃+* Γ((X ⊗ overSpec k A).left, (fst X (overSpec k A)).left ⁻¹ᵁ V)`** (primary carrier: RingEquiv; CommRingCat face `Over.sectionsBaseChangeIso`; affine wrapper `Over.sectionsBaseChangeOfIsAffineOpen (hV : IsAffineOpen V)`).
- Computation faces: `sectionsBaseChange_tmul_one` (`s⊗1 ↦` fst-pullback, the k-algebra face), `sectionsBaseChange_one_tmul` (`1⊗a ↦` snd-pullback, the A-algebra face), `sectionsBaseChange_tmul` (product formula), `sectionsBaseChange_naturality` (restriction along `W ≤ V` = `Algebra.TensorProduct.map (resAlgHom) (AlgHom.id k A)`, general element).

**UniversalSections.lean** (hypotheses: `[IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]`, mirroring Curve/Sections.lean; regression checks confirm the frozen curve bundle discharges them via smooth ⇒ geometrically reduced):
- **`Over.isIso_appTop_snd_overSpec (C) (A) : IsIso ((snd C (overSpec k A)).left.appTop)`** — keystone: pushout of the Wave-1 iso `Γ(Spec k,⊤) ≅ Γ(C.left,⊤)`.
- `Over.universalSections (C) (A) : CommRingCat.of A ≅ Γ((C ⊗ overSpec k A).left, ⊤)` (hom = `ΓSpecIso.symm ≪≫` snd-pullback, i.e. the A-algebra structure map — documented as the A-face); `Over.universalSectionsEquiv : A ≃+* Γ(...)`.
- **Consistency gate (kernel-checked equation, not just an example)**: `Over.universalSections_self : Over.universalSections C k = ((Scheme.ΓSpecIso (.of k)).symm ≪≫ asIso C.hom.appTop) ≪≫ asIso ((fst C (overSpec k k)).left.appTop)` — literally Wave-1's `Γ(C,𝒪) ≅ k` composite from Curve/Sections.lean transported along the (iso) first projection. Supporting instances: `isIso_overSpec_self_hom`, `isIso_fst_left_overSpec_self`, `isIso_appTop_fst_left_overSpec_self`.

## Verification evidence

- `flock /tmp/ajc-lake.lock ~/.elan/bin/lake build` both modules: `✔ Built AlgebraicJacobian.Cohomology.SectionsBaseChange (5.8s)`, `✔ Built AlgebraicJacobian.Picard.UniversalSections (3.2s)`, "Build completed successfully (8562 jobs)."
- Axiom audit (all of: `isPullback_left`, `isPushout_sections`, `isPushout_algebraMap_sections`, `sectionsBaseChange`, `_tmul`, `_naturality`, `sectionsBaseChangeOfIsAffineOpen`, `isIso_appTop_snd_overSpec`, `universalSections`, `universalSectionsEquiv`, `universalSections_self`): exactly `[propext, Classical.choice, Quot.sound]`.

## Cut / deferred

- `prPullback_injective` (design's brick 3, listed for file 8): **skipped as instructed** — depends on lane L1's `CechPic`; deferral recorded in the module docstring TODO. Remaining gap: nothing else; both pinned bricks landed in full (with strictly more generality: arbitrary affine test `T` for the IsPushout masters, qcqs `V`).
- k-linear (`≃ₗ[k]`) face not separately bundled: it is one line from the RingEquiv + `sectionsBaseChange_tmul_one` (documented in the file header); the right module-instance choreography (over `k` vs over `K`) belongs to each consumer.

## Gotchas for downstream (Separatedness.lean, tangent engine, χ-ledger)

1. **Activate `attribute [local instance] Over.sectionsAlgebra`** before stating anything with `Γ(X.left,V) ⊗[k] A`; the file's statements embed that exact instance term.
2. **Instance-search flakiness** on goals shaped `IsIso (𝟙 (Spec (.of k)))` or `IsIso (f.appTop)` after `rw`: `infer_instance` can fail even when the instance exists (metavariable/transparency issue, reproducible in plain Mathlib). Use explicit terms (`exact IsIso.id _`, `pullback_fst_iso_of_right_iso _ _`, manual `⟨⟨(inv f).appTop, …⟩⟩`) — three worked examples are in UniversalSections.lean.
3. **`Over.pullback`/tensor instance opacity is real** for rewriting under `(X ⊗ T).left.presheaf.map`: `set_option backward.isDefEq.respectTransparency false in` (mathlib's own fix in Flat.lean) unblocks `appLE_map`-style rewrites — used once, on `sectionsBaseChange_naturality`; term-mode `exact (Category.id_comp _).symm`-style endings bypass ill-typed-at-instances-transparency rw failures.
4. `(C ⊗ T).left` is definitionally `Limits.pullback C.hom T.hom` and `fst/snd .left` are `pullback.fst/snd` (`Over.fst_left/snd_left` are rfl-simp lemmas); always enter scheme-land through `Over.isPullback_left` rather than re-unfolding.
5. Inequality side-conditions in `appLE` statements are pinned as `le_top.trans (Scheme.Hom.preimage_top _).ge` (never `by simp` — simp fails on these opens goals); they're proof-irrelevant, so consumers' own proofs unify.
