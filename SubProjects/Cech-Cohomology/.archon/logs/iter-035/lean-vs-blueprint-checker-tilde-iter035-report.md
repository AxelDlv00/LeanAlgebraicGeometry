# Lean ↔ Blueprint Check Report

## Slug
tilde-iter035

## Iteration
035

## Files audited
- Lean: `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/TildeExactness.lean`
- Blueprint: `/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (block `lem:tilde_preserves_kernels`, line 4327)

---

## Per-declaration

### `\lean{AlgebraicGeometry.tildePreservesFiniteLimits}` (chapter: `lem:tilde_preserves_kernels`)
- **Lean target exists**: no — declaration is absent from the Lean file (noted in file header under "Why `tildePreservesFiniteLimits` itself is NOT closed here")
- **Signature matches**: N/A (absent)
- **Proof follows sketch**: N/A (absent)
- **notes**: Absence is honestly documented: (a) no `\leanok` on the `\begin{lemma}` or `\begin{proof}` blocks for `lem:tilde_preserves_kernels`; (b) a `% NOTE:` comment at line 4352–4358 of the blueprint explicitly states the target is ABSENT from Mathlib and project-to-build; (c) the Lean file header devotes a full section to explaining why it is blocked. This is the expected state and not a cover-up.

### `\lean{AlgebraicGeometry.tilde_preservesFiniteColimits}` (chapter: `lem:tilde_preserves_kernels`)
- **Lean target exists**: yes (line 83–84)
- **Signature matches**: yes — `Limits.PreservesFiniteColimits (tilde.functor R)` as a right-exactness/left-adjoint consequence
- **Proof follows sketch**: yes — discharged by `inferInstance` (tilde is a left adjoint; instance already in Mathlib)
- **notes**: Clean.

### `\lean{AlgebraicGeometry.tilde_toStalk_map_injective}` (chapter: `lem:tilde_preserves_kernels`)
- **Lean target exists**: yes (lines 93–97)
- **Signature matches**: yes — injective `R`-module map `f` ⟹ `IsLocalizedModule.map` at a prime is injective; exactly the "localisation-is-flat" contribution described in the blueprint proof
- **Proof follows sketch**: yes — one-liner `IsLocalizedModule.map_injective`
- **notes**: Clean.

### `\lean{AlgebraicGeometry.tilde_preservesFiniteLimits_of_preservesKernels}` (chapter: `lem:tilde_preserves_kernels`)
- **Lean target exists**: yes (lines 105–109)
- **Signature matches**: yes — conditional `(∀ f, PreservesLimit (parallelPair f 0) (tilde.functor R)) → PreservesFiniteLimits (tilde.functor R)`, matching the blueprint reduction step
- **Proof follows sketch**: yes — `Functor.preservesFiniteLimits_of_preservesKernels _`
- **notes**: Clean. Serves as a recorded stepping-stone; the blueprint's proof of this reduction is implicit in the prose.

### `\lean{AlgebraicGeometry.tilde_stalkFunctor_map_toStalk}` (chapter: `lem:tilde_preserves_kernels`)
- **Lean target exists**: yes (lines 120–142)
- **Signature matches**: yes — the germ-naturality transport identity: `toStalk M x ≫ (Ab-stalk map of ~f)` equals `f ≫ toStalk N x`; exactly the "load-bearing step" of sub-step (A)
- **Proof follows sketch**: yes — proof uses `stalkFunctor_map_germ_apply` + `StructureSheaf.comapₗ_const`; the blueprint % NOTE at line 4413–4417 names this approach precisely
- **notes**: Axiom-clean (carried over from iter-034). This is the most substantive of the prior helpers.

### `\lean{AlgebraicGeometry.tildePreservesFiniteLimits_of_toPresheaf}` (chapter: `lem:tilde_preserves_kernels`)
- **Lean target exists**: yes (lines 153–159)
- **Signature matches**: yes — `PreservesFiniteLimits (~ ⋙ Scheme.Modules.toPresheaf (Spec (.of R))) → PreservesFiniteLimits (tilde.functor R)`, matching the blueprint sub-step (C) description
- **Proof follows sketch**: yes — `preservesFiniteLimits_of_reflects_of_preserves`; the blueprint % NOTE at line 4435–4438 names this lemma and approach
- **notes**: Clean. This closes the categorical-reduction half; remaining gap is supplying the hypothesis (jointly-reflecting stalk assembly).

---

## Red flags

### Placeholder / suspect bodies
None. Every declaration in the file has a concrete, non-trivial proof body:
- `tilde_preservesFiniteColimits`: `inferInstance` (legitimate — instance exists in Mathlib)
- `tilde_toStalk_map_injective`: direct Mathlib call
- `tilde_preservesFiniteLimits_of_preservesKernels`: direct Mathlib call
- `tilde_stalkFunctor_map_toStalk`: multi-step `erw` + `simp` + `rfl` proof
- `tildePreservesFiniteLimits_of_toPresheaf`: two-liner with typeclass witness
- `tilde_germ_algebraMap_smul`: `erw` + `rfl` using `PresheafOfModules.germ_smul`
- `stalkMapₗ`: `def` with explicit `toFun`/`map_add'`/`map_smul'` fields; `map_smul'` is non-trivial (uses germ-exist + two `stalkFunctor_map_germ_apply` rewrites + `Hom.app_smul`)
- `stalkMapₗ_eq`: `IsLocalizedModule.ext` applied after showing agreement on `toStalk M x`; genuinely non-trivial identification (see below)
- `stalkMapₗ_injective`: one-liner combining `stalkMapₗ_eq` + `tilde_toStalk_map_injective`

### `stalkMapₗ_eq` specifically — genuine identification, not a tautology
The theorem `stalkMapₗ f x = IsLocalizedModule.map x.asIdeal.primeCompl ...` identifies two maps of *different construction*: `stalkMapₗ` is assembled from germ R-linearity (`tilde_germ_algebraMap_smul`), while `IsLocalizedModule.map` is the abstract localization-module map. They are shown equal by `IsLocalizedModule.ext`, which requires proving they agree on the image of `(tilde.toStalk M x).hom`; the agreement uses `tilde_stalkFunctor_map_toStalk`. This is load-bearing, not circular.

### Excuse-comments
None found. The file header documents the open gap clearly and accurately (describes what remains and why), but does NOT use excusing language ("this is wrong but works for now", "placeholder", "TODO replace"). The header language is honest engineering documentation.

### Axioms / Classical.choice on non-trivial claims
None. No `axiom` declarations in the file. (Axiom-clean status matches iter-035 iteration record.)

---

## Unreferenced declarations (informational)

The following 4 declarations are in the Lean file but have **no** `\lean{...}` reference in `lem:tilde_preserves_kernels` or anywhere else in the chapter:

| Declaration | Kind | Should blueprint reference it? |
|---|---|---|
| `tilde_germ_algebraMap_smul` | theorem | Yes — it is the section-level R-linearity lemma driving `stalkMapₗ.map_smul'`; the blueprint sub-step (A) prose describes this step but does not name it |
| `stalkMapₗ` | def | **Yes** — this is the key definition of sub-step (A): the Ab-stalk map packaged as `M_𝔭 →ₗ[R] N_𝔭`; the blueprint % NOTE at line 4413 mentions it by name but it is not in any `\lean{}` list |
| `stalkMapₗ_eq` | theorem | **Yes** — this is the central content of sub-step (A): identifying `stalkMapₗ` with `IsLocalizedModule.map`; the blueprint % NOTE at line 4413–4417 describes this identification but does not add a `\lean{}` hint |
| `stalkMapₗ_injective` | theorem | **Yes** — the direct stalkwise injectivity consequence; feeds the remaining build toward the named target |

All four are substantial (not boilerplate helpers). They collectively constitute the sub-step (A) machinery that the remaining build (`tildePreservesFiniteLimits`) will consume. The blueprint sub-step (A) % NOTE section mentions `stalkMapₗ` by name in prose but does not promote it to a formal `\lean{}` block.

**This is coverage debt classified as major** (see Severity below).

---

## Blueprint adequacy for this file

- **Coverage**: 5/6 `\lean{...}`-listed declarations exist in the Lean file (1 absent: the named target, honestly documented). 4 additional substantive declarations exist in the Lean file with NO `\lean{...}` reference. Coverage = 5 realized + 1 documented-absent + 4 unreferenced substantive. Total Lean decls: 9. Total `\lean{...}` entries: 6.

- **Proof-sketch depth**: **partially under-specified** for the remaining build.
  - Sub-step (A) is adequately covered in the blueprint: the germ-naturality identity is named, `stalkMapₗ` is named in % NOTE, `IsLocalizedModule.ext` is the logical route, and the prover could follow this.
  - Sub-step (B) (jointly-reflecting stalk family) and sub-step (C) (categorical reduction) are covered at a functional level via % NOTE comments (`JointlyReflectIsomorphisms`, `Scheme.Modules.toPresheaf`, `preservesFiniteLimits_of_reflects_of_preserves`) and through the already-realized `tildePreservesFiniteLimits_of_toPresheaf`.
  - **Gap**: the remaining obligation — showing `∀ x, PreservesFiniteLimits (~ ⋙ toPresheaf ⋙ stalkFunctor x)` — is not described in the formal proof sketch. The blueprint says "stalkwise-flatness + jointly-reflecting" but does not say HOW to deliver `PreservesFiniteLimits` on the per-stalk composite via the `stalkMapₗ`/`stalkMapₗ_injective` machinery. A prover reaching this step cold would have to reconstruct the route from the % NOTEs plus the sub-step descriptions.
  - The `Scheme.Modules.toSheaf` gap: the blueprint correctly uses `Scheme.Modules.toPresheaf` throughout (not `toSheaf`). The % NOTE at line 4427 explicitly states the `ModuleCat R`-valued stalk path is DEAD. This is correctly specified.

- **Hint precision**: **loose** for the 4 unreferenced declarations. The % NOTE comments reference `stalkMapₗ` and `stalkMapₗ_eq` by name, but those names do not appear in any `\lean{...}` block — so the blueprint cross-reference is informal. The 6 `\lean{...}`-listed declarations that do exist are precisely described.

- **Generality**: matches need. The declarations are stated at the right generality (`variable {R : CommRingCat.{u}}`); no narrowing issue.

- **Recommended chapter-side actions** (for blueprint-writing subagent):
  1. Add `AlgebraicGeometry.stalkMapₗ`, `AlgebraicGeometry.stalkMapₗ_eq`, `AlgebraicGeometry.stalkMapₗ_injective`, and `AlgebraicGeometry.tilde_germ_algebraMap_smul` to the `\lean{...}` list for `lem:tilde_preserves_kernels`.
  2. Expand the sub-step (A) mechanization remark into a brief proof-sketch entry describing the `stalkMapₗ` definition, the `IsLocalizedModule.ext`-based identification, and the injectivity chain — enough for a prover to see the connection from the R-linearity lemma to `stalkMapₗ_injective`.
  3. Add a sub-step sketch for the per-stalk `PreservesFiniteLimits` delivery: how `stalkMapₗ_injective` (for every `x`) yields `PreservesFiniteLimits (~ ⋙ toPresheaf ⋙ stalkFunctor x)`, and how that feeds `jointlyReflectsLimit` to close `tildePreservesFiniteLimits_of_toPresheaf`'s hypothesis.

---

## Severity summary

- **must-fix-this-iter**: none
- **major**:
  - `AlgebraicGeometry.tildePreservesFiniteLimits` listed in `\lean{...}` but absent from Lean (expected, documented, no false `\leanok`; still a major gap the blueprint tracks)
  - `stalkMapₗ`, `stalkMapₗ_eq`, `stalkMapₗ_injective`, `tilde_germ_algebraMap_smul` are substantive declarations (def + 3 theorems forming the sub-step A core) with no `\lean{...}` coverage — coverage debt
- **minor**:
  - Blueprint proof-sketch for the remaining build (jointly-reflecting stalk assembly → `tildePreservesFiniteLimits`) is covered only in `% NOTE` comments, not in the formal proof-sketch steps

**Overall verdict**: The four new iter-035 helpers faithfully realize sub-step (A) of the blueprint sketch — no placeholders, no sorries, `stalkMapₗ_eq` is a genuine identification — and the named target's absence is honestly documented with no false `\leanok`; the primary finding is major coverage debt: all four new helpers lack `\lean{...}` blueprint references.
