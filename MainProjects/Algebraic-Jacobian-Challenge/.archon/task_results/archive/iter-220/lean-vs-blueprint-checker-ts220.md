# Lean ↔ Blueprint Check Report

## Slug
ts220

## Iteration
220

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration (section `sec:tensorobj_dual_infra`, internal-hom blocks)

### `\lean{PresheafOfModules.InternalHom.homModule}` (chapter: `def:presheaf_internal_hom_value`)
- **Lean target exists**: yes — `PresheafOfModules.InternalHom.homModule` at line 1082
- **Signature matches**: yes
  - Blueprint: "The abelian group of morphisms M → N carries a canonical R(T)-module structure. A global scalar f ∈ R(T) acts by post-composition with multiplication by f: `f • φ := φ ≫ globalSMul hT N f`."
  - Lean: `noncomputable def homModule (M N : PresheafOfModules.{u} (R ⋙ forget₂ CommRingCat RingCat)) : Module (R.obj (Opposite.op T) : Type u) (M ⟶ N)` with `smul f φ := φ ≫ globalSMul hT N f`. Exact match.
- **Proof follows sketch**: yes — the module axioms reduce to `globalSMul_{one,zero,add,mul}` ring-homomorphism facts and bilinearity of composition, exactly as described in blueprint.
- **notes**: Blueprint marked `\leanok`. The helpers `termRingMap`, `termRingMap_naturality`, `globalSMul`, `globalSMul_hom_apply`, and four `globalSMul_*` lemmas are all correct, axiom-clean, and appropriately not separately pinned.

---

### `\lean{PresheafOfModules.InternalHom.internalHomObjModule}` (chapter: `def:presheaf_internal_hom_slice_value`)
- **Lean target exists**: yes — `PresheafOfModules.InternalHom.internalHomObjModule` at line 1123
- **Signature matches**: yes
  - Blueprint: "Specialise `homModule` to the over-category `Over U`. The slice `C/U` has terminal object `Over.mk (𝟙 U)` at which the restricted ring takes value `R(U)`, so `homModule` makes `M|_U ⟶ N|_U` an `R(U)`-module."
  - Lean: `noncomputable def internalHomObjModule (U : C) (M N : ...) : Module (R.obj (Opposite.op U) : Type u) (restr U M ⟶ restr U N) := homModule (R := (Over.forget U).op ⋙ R) (T := Over.mk (𝟙 U)) Over.mkIdTerminal (restr U M) (restr U N)`. Perfect match.
- **Proof follows sketch**: yes — instantiates `homModule` at the terminal of `Over U`.
- **notes**: Blueprint marked `\leanok`. The helper `restr` (line 1112) is a clean implementation detail, correctly not separately pinned.

---

### `\lean{PresheafOfModules.InternalHom.restrictionMap}` (chapter: `lem:presheaf_internal_hom_restriction`)
- **Lean target exists**: yes — `PresheafOfModules.InternalHom.restrictionMap` at line 1136
- **Signature matches**: yes
  - Blueprint: "For g : V → U, the map `ℋom(M,N)(U) → ℋom(M,N)(V)`, `φ ↦ φ|_V`, carrying `M|_U ⟶ N|_U` to its further restriction `M|_V ⟶ N|_V`, realised via `pushforward₀ (Over.map g)`. Additive and semilinear over `R(g) : R(U) → R(V)`."
  - Lean: `noncomputable def restrictionMap {U V : C} (g : V ⟶ U) {M N : ...} (φ : restr U M ⟶ restr U N) : restr V M ⟶ restr V N` via `pushforward₀ (Over.map g)`. Exact match.
- **Proof follows sketch**: yes — additivity is `restrictionMap_add`/`restrictionMap_zero`; functoriality is `restrictionMap_id`/`restrictionMap_comp`; semilinearity is `restrictionMap_smul` (all axiom-clean). The semilinearity proof in Lean (`restrictionMap_globalSMul` + `restrictionMap_comp_hom`) follows the blueprint sketch of "restricting `f • φ = m_f ∘ φ` yields `m_{R(g)(f)} ∘ (φ|_V)`."
- **notes**: Blueprint marked `\leanok`. The intermediate helper `restrictionMapAddHom` (line 1226) and the `hom_app_heq`+`subst` device for `Over.map` pseudofunctoriality (lines 1160–1179) are clean implementation details consistent with the known `map_id`/`mapComp` non-rfl gotcha.

---

### `\lean{PresheafOfModules.internalHom}` (chapter: `def:presheaf_internal_hom`) — **NAME MISMATCH (must-fix)**
- **Lean target exists**: **yes, but under the wrong name**
  - Blueprint pins `\lean{PresheafOfModules.internalHom}`.
  - Built declaration is `PresheafOfModules.InternalHom.internalHom` (line 1293, inside `namespace InternalHom`, `section Assembly`).
  - No alias `PresheafOfModules.internalHom` is created.
- **Signature matches**: yes (modulo the name issue)
  - Blueprint: "The presheaf of R-modules assembled from (a) `internalHomObjModule`, (b) further-restriction maps, (c) semilinearity datum, via `PresheafOfModules.ofPresheaf`. Stated over single-universe base."
  - Lean: `noncomputable def internalHom (M N : PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)) : PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat) := @PresheafOfModules.ofPresheaf D _ ... (internalHomPresheaf M N) (fun X => internalHomObjModule X.unop M N) (fun {_ _} f r m => restrictionMap_smul f M N r m)`. Content matches perfectly.
- **Proof follows sketch**: yes — the three pieces (value modules, restriction maps, semilinearity) are exactly the blueprint's (a)/(b)/(c), assembled via `ofPresheaf`.
- **notes**: Blueprint does NOT have `\leanok` (appropriate: built this iter, `sync_leanok` runs after prover). The helper `internalHomPresheaf` (lines 1237–1249) is the underlying `Ab`-valued presheaf before the module structure is added; it is not separately blueprint-pinned and is a clean implementation detail. **The `\lean{...}` pin is wrong**: `PresheafOfModules.internalHom` does not exist; `sync_leanok` will fail to find the declaration and will not add `\leanok` even though the body is axiom-clean.

---

## Red flags

### Placeholder / suspect bodies

- `AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse` (line 1724): body is `:= sorry`. **Authorized placeholder** — the blueprint's `lem:tensorobj_inverse_invertible` explicitly marks the proof as "infrastructure-blocked" pending the dual infrastructure of `sec:tensorobj_dual_infra`. The docstring gives a complete explanation. Not a red flag.

- `AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj` (line 1774): body is `:= sorry`. **Authorized placeholder** — the blueprint's `thm:rel_pic_addcommgroup_via_tensorobj` marks this as the "iter-204+ closure target". Not a red flag.

### Excuse-comments
None found that are actively misleading. All substantive `sorry` bodies carry docstrings explaining the precise missing infrastructure, which is consistent with the blueprint. The comment at line 1728 ("BLOCKED at step 1: the dual `Linv` has no `SheafOfModules`-level construction") is an accurate documentation comment, not an excuse for wrong code.

### Axioms / Classical.choice on non-trivial claims
None found. The file is axiom-clean for the new declarations (per the directive confirming this for the iter-220 additions). The two `sorry` bodies are in previously-existing declarations that are authorized placeholders.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file are NOT `\lean{...}`-referenced by any blueprint block, and are helpers:

**Helpers for the H2/H1 substrate (before the internal-hom section):** `restrictScalarsRingIsoTensorEquiv`, `restrictScalarsRingIsoTensorEquiv_apply_tmul`, `restrictScalars_isIso_μ`, `restrictScalars_isIso_ε`, `restrictScalarsMonoidalOfRingEquiv`, `restrictScalars_isIso_μ_of_bijective`, `restrictScalars_isIso_ε_of_bijective` — these ARE covered by the multi-lean block `lem:restrictscalars_ringiso_strongmonoidal` (`\lean{restrictScalars_isIso_μ, restrictScalars_isIso_ε, restrictScalarsMonoidalOfRingEquiv, ...}`); no issue.

**Internal-hom helpers (namespace `InternalHom`):** `termRingMap`, `termRingMap_naturality`, `globalSMul`, `globalSMul_hom_apply`, `globalSMul_one`, `globalSMul_zero`, `globalSMul_add`, `globalSMul_mul`, `restr`, `restrictionMap_add`, `restrictionMap_zero`, `hom_app_heq`, `restrictionMap_id`, `restrictionMap_comp`, `restrictionMap_comp_hom`, `restrictionMap_globalSMul`, `restrictionMapAddHom`, `internalHomPresheaf`, `restrictionMap_smul` — all are implementation helpers for the four pinned declarations; acceptable as unreferenced.

**Substantive unreferenced declarations worth noting:**
- `internalHomPresheaf` (line 1237): the underlying `Ab`-presheaf assembly before the module structure. This is a non-trivial intermediate construction (12 lines, two functoriality proofs). The blueprint describes its content implicitly under `def:presheaf_internal_hom` parts (b)/(c), but does not give it a `\lean{...}` pin. **Minor**: consider adding a blueprint `\lean{PresheafOfModules.InternalHom.internalHomPresheaf}` reference for the documentation value.

---

## Blueprint adequacy for this file

- **Coverage**: The four `\lean{...}`-pinned declarations in `sec:tensorobj_dual_infra` correspond to the four main iter-220 builds (`homModule`, `internalHomObjModule`, `restrictionMap`, `internalHom`). All four have corresponding blueprint blocks with correct descriptions. Coverage: 4/4 pinned declarations. Unreferenced helpers: ~19 (all acceptable).
- **Proof-sketch depth**: **adequate** for the four pinned declarations. The blueprint's proof sketches match the actual Lean proof strategies, including the `Over.map` pseudofunctoriality device, the `pushforward₀ (Over.map g)` restriction-map realization, and the `ofPresheaf`/`restrictionMap_smul` assembly.
- **Hint precision**: **partially wrong** — the `\lean{...}` pin for `def:presheaf_internal_hom` (`PresheafOfModules.internalHom`) does not match the built declaration name (`PresheafOfModules.InternalHom.internalHom`). The other three hints are precise and correct.
- **Generality**: matches need — the single-universe restriction (requiring `Category.{u, u}`) is correctly noted in the Lean file's section comment (line 1272–1279) and is the one place where `PresheafOfModules.ofPresheaf` forces a universe constraint.

### Blueprint adequacy for NEXT sub-steps (dual / eval / sheafify)

The chapter is generally adequate for the next sub-steps, with one caveat:

- **`def:presheaf_dual`** (L2584): straightforward, pins `\lean{PresheafOfModules.dual}`. ADEQUATE. One line: `M^∨ := ℋom(M, R)`.
- **`lem:internal_hom_eval`** (L2604): pins `\lean{PresheafOfModules.internalHomEval}`. Proof sketch ("open-by-open contraction, naturality from `φ(s)|_V = (φ|_V)(s|_V)`") is ADEQUATE.
- **`lem:internal_hom_isSheaf`** (L2653): pins `\lean{AlgebraicGeometry.Scheme.Modules.dual}`. The sheaf-condition proof sketch ("section-wise gluing in the sheaf N") is adequate mathematically. **However**: the hint is confusing — it pins the *output object* (`dual`) rather than the *sheaf-condition verification*. A prover implementing `lem:internal_hom_isSheaf` will need to: (1) prove the presheaf internal hom satisfies the sheaf condition, AND (2) construct `AlgebraicGeometry.Scheme.Modules.dual` as the special case `N = O_X`. The blueprint does not clarify which Lean construction encodes step (1) separately. This is a **minor** adequacy gap — the two-step structure (sheaf condition → dual object) should be broken into two `\lean{...}` pins.
- **`lem:dual_isLocallyTrivial`** (L2708): pins `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}`. Proof sketch (trivialising opens, `ℋom(O_U, O_U) ≅ O_U` by evaluation at 1) is ADEQUATE and follows the `tensorObj_isLocallyTrivial` pattern.

**Recommended chapter-side actions:**
1. **MUST-FIX**: Correct the `\lean{...}` pin for `def:presheaf_internal_hom` from `PresheafOfModules.internalHom` to `PresheafOfModules.InternalHom.internalHom`. Without this fix, `sync_leanok` will not be able to verify the declaration and will not add `\leanok`, blocking the dashboard from correctly tracking iter-220 progress.
2. **MINOR**: Split `lem:internal_hom_isSheaf` into two blueprint blocks: one for the sheaf-condition verification (`\lean{...}` = TBD presheaf-level isSheaf lemma) and one for the `AlgebraicGeometry.Scheme.Modules.dual` construction. The current merge of both under one block with pin `\lean{AlgebraicGeometry.Scheme.Modules.dual}` hides the intermediate sheaf-condition step.
3. **INFORMATIONAL**: Consider adding `\lean{PresheafOfModules.InternalHom.internalHomPresheaf}` as a named helper block in the blueprint (or at least a `% NOTE:` annotation), since it is a substantive intermediate construction (~12 declarations of functoriality).

---

## Severity summary

- **must-fix-this-iter**:
  1. **`\lean{...}` name mismatch** for `def:presheaf_internal_hom`: blueprint pins `PresheafOfModules.internalHom`, built decl is `PresheafOfModules.InternalHom.internalHom`. This blocks `sync_leanok` from verifying the declaration and blocks the dashboard from tracking the iter-220 `internalHom` build correctly.

- **major**: none.

- **minor**:
  1. `lem:internal_hom_isSheaf` merges two distinct Lean objects (sheaf-condition verification + dual object construction) under one `\lean{...}` pin (`AlgebraicGeometry.Scheme.Modules.dual`), which under-specifies the intermediate proof step.
  2. `internalHomPresheaf` is a substantive intermediate that deserves a blueprint annotation.

**Overall verdict**: The iter-220 Lean additions are mathematically correct and faithful to the blueprint — signatures match, proof structures match, no unauthorized sorries, no fake or weakened definitions — but the `\lean{...}` pin for `def:presheaf_internal_hom` is wrong (`PresheafOfModules.internalHom` vs actual FQN `PresheafOfModules.InternalHom.internalHom`), which blocks `sync_leanok`. 4 declarations checked, 1 must-fix (name mismatch), 2 minors.
