# Lean ↔ Blueprint Check Report

## Slug
tilde-iter034

## Iteration
034

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/TildeExactness.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (relevant block: `lem:tilde_preserves_kernels`, lines 4315–4386)

---

## Per-declaration

The blueprint block `lem:tilde_preserves_kernels` carries the `\lean{...}` hint at line 4317:
```
\lean{AlgebraicGeometry.tildePreservesFiniteLimits,
      AlgebraicGeometry.tilde_preservesFiniteColimits,
      AlgebraicGeometry.tilde_toStalk_map_injective,
      AlgebraicGeometry.tilde_preservesFiniteLimits_of_preservesKernels}
```

### `\lean{AlgebraicGeometry.tilde_preservesFiniteColimits}` (block: lem:tilde_preserves_kernels)
- **Lean target exists**: yes — line 83
- **Signature matches**: yes — `PreservesFiniteColimits (tilde.functor R)`, matches the "right-exactness half" described in prose
- **Proof follows sketch**: yes — `inferInstance` via `tilde.adjunction`, consistent with blueprint's colimit-from-adjunction rationale
- **Axiom status**: clean (`propext`, `Classical.choice`, `Quot.sound` only)
- **notes**: none

### `\lean{AlgebraicGeometry.tilde_toStalk_map_injective}` (block: lem:tilde_preserves_kernels)
- **Lean target exists**: yes — line 93
- **Signature matches**: yes — `Function.Injective (IsLocalizedModule.map ... f.hom)` for injective `f.hom`, using `tilde.toStalk` handles; matches "flatness core / localisation is flat" prose
- **Proof follows sketch**: yes — one-liner delegation to `IsLocalizedModule.map_injective`
- **Axiom status**: clean
- **notes**: none

### `\lean{AlgebraicGeometry.tilde_preservesFiniteLimits_of_preservesKernels}` (block: lem:tilde_preserves_kernels)
- **Lean target exists**: yes — line 105
- **Signature matches**: yes — conditioned on per-kernel `PreservesLimit (parallelPair f 0)`, concludes `PreservesFiniteLimits (tilde.functor R)`; consistent with the "reduction to kernel preservation" sub-step
- **Proof follows sketch**: yes — delegates to `Functor.preservesFiniteLimits_of_preservesKernels`
- **Axiom status**: clean
- **notes**: This decl and `tildePreservesFiniteLimits_of_toPresheaf` (new this iter) offer two different categorical reductions; both are in the file, only this one appears in the `\lean{...}` list.  The new decl (`via toPresheaf`) is now the preferred route per the file header.

### `\lean{AlgebraicGeometry.tildePreservesFiniteLimits}` (block: lem:tilde_preserves_kernels) — NAMED TARGET
- **Lean target exists**: **no** — intentionally absent; the declaration is missing from `TildeExactness.lean`
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Blueprint documentation of absence**: **adequate**.  The `% NOTE:` at lines 4340–4346 correctly states the declaration is "ABSENT from Mathlib and is project-to-build (Route-P P3 sub-gap)."  The block carries **no `\leanok`**, which is correct (`sync_leanok` would not set it without a formalized declaration).  No false `\leanok` present.
- **notes**: Gap is honestly surfaced. The `% NOTE:` does not yet cross-reference `tilde_stalkFunctor_map_toStalk` or `tildePreservesFiniteLimits_of_toPresheaf` as in-file progress toward this gap, but that is minor.

---

## Unreferenced declarations (informational)

The following two declarations exist in the Lean file but appear in **no** `\lean{...}` block in the blueprint.  Both are new this iter and substantive.

### `AlgebraicGeometry.tilde_stalkFunctor_map_toStalk` (line 120)
- **What it is**: Germ-naturality transport identity — for `f : M ⟶ N` and `x : PrimeSpectrum R`, the `Ab`-valued stalk map of `~f` (via `Scheme.Modules.toPresheaf`) intertwines the localisation maps `tilde.toStalk`: `toStalk M x ≫ (Ab-stalk map) = tilde.toStalk N x ∘ f.hom`.
- **Genuine / non-vacuous**: Yes.  The proof requires `stalkFunctor_map_germ_apply`, an `erw`/`congr` on the section naturality `StructureSheaf.comapₗ_const`, and reduction through `tilde.map` internals.  It is not a tautology.
- **Axiom status**: clean
- **Blueprint status**: unmatched — no `\lean{...}` reference anywhere in the chapter
- **Assessment**: This is a real sub-lemma on the critical path to `tildePreservesFiniteLimits`.  It should appear as a sub-step in `lem:tilde_preserves_kernels` (or a dedicated `\begin{lemma}...\end{lemma}` block).  **Major** finding — planner must add.

### `AlgebraicGeometry.tildePreservesFiniteLimits_of_toPresheaf` (line 153)
- **What it is**: Categorical reduction — `tildePreservesFiniteLimits` follows from `PreservesFiniteLimits (tilde.functor R ⋙ Scheme.Modules.toPresheaf (Spec (.of R)))` via `Limits.preservesFiniteLimits_of_reflects_of_preserves` (since `toPresheaf` is faithful, preserves limits, reflects isos, hence reflects finite limits).
- **Genuine / non-vacuous**: Yes.  The proof uses `Limits.preservesFiniteLimits_of_reflects_of_preserves`, which requires non-trivial typeclass preconditions on `toPresheaf` already discharged by Mathlib; the body is 2 lines of real categorical glue.
- **Axiom status**: clean
- **Blueprint status**: unmatched — no `\lean{...}` reference anywhere in the chapter
- **Assessment**: This is the **new preferred categorical reduction** (it refutes an earlier feared obstruction and supersedes `tilde_preservesFiniteLimits_of_preservesKernels` as the lead route).  It should appear as a sub-step in `lem:tilde_preserves_kernels`.  **Major** finding — planner must add.

---

## Red flags

### `scan_source` `opaque` warnings — FALSE POSITIVES
`lean_verify` reports pattern `opaque` at lines 37 and 117.  Both are inside Lean doc-comment strings (`/-! ... -/` and `/-- ... -/`), where the prose uses the English word "opaque" to describe the `Ab`-germ-induced stalk map.  There are **no** `opaque` declarations in the file.  Not a red flag.

No other red flags found:
- No `:= sorry` anywhere.
- No `:= True` or `:= rfl` on non-trivial claims.
- No `axiom` declarations.
- No excuse-comments (`-- TODO replace`, `-- temporary`, `-- placeholder`, `-- wrong but works for now`).

---

## Blueprint adequacy for this file

### Coverage
5/5 axiom-clean declarations are verifiably real.  Coverage of `\lean{...}` listing vs Lean file:
- 3 of the 4 `\lean{...}`-listed names are present in Lean and axiom-clean ✓
- 1 `\lean{...}`-listed name (`tildePreservesFiniteLimits`) is intentionally absent (named target gap, honestly documented) ✓
- 2 substantive Lean declarations (`tilde_stalkFunctor_map_toStalk`, `tildePreservesFiniteLimits_of_toPresheaf`) are unblueprinted — **flagged above as major**

### Proof-sketch depth: under-specified for the remaining work
The proof sketch (lines 4357–4386) gives the correct high-level mathematical argument: (1) kernels of sheaf maps checked on stalks, (2) stalk of `~M` is `M_𝔭`, (3) localisation is flat so preserves kernels, (4) stalkwise isos are isos of sheaves.  This is mathematically sound.

However, the blueprint does not provide enough detail to guide the **remaining formalization obligation** (the gap inside `tildePreservesFiniteLimits`):

1. **R-linearity of the Ab stalk map** — the next step requires showing the `Ab`-stalk map of `~f` equals `IsLocalizedModule.map` (hence is `R`-linear) via `germₗ` and `R`-linearity of `Scheme.Modules.Hom.app`.  The blueprint says "localisation is flat" but not how to identify the Lean stalk map as the localization map at the module level.
2. **Jointly-reflecting-stalks assembly** — the step from "each composite `~ ⋙ toPresheaf ⋙ stalkFunctor x` preserves finite limits" to "`~ ⋙ toPresheaf` preserves finite limits" via `JointlyReflectIsomorphisms.jointlyReflectsLimit` is not mentioned.
3. **Public Ab path vs dead ModuleCat path** — the blueprint does not warn that the `ModuleCat R`-valued stalk path is inaccessible due to Mathlib privacy (`toStalkₗ'`, `stalkIsoₗ`, `structurePresheafInModuleCat` are private), forcing the prover to use the `Ab` stalk path throughout.  This is a significant practical obstacle not captured in the proof sketch.
4. **`tildePreservesFiniteLimits_of_toPresheaf` as the categorical reduction** — the preferred final assembly step (replace the kernel-by-kernel reduction with the `toPresheaf`-reflects route) is absent from the blueprint.

A blueprint-writing pass should add these as sub-steps under `lem:tilde_preserves_kernels`.

### Hint precision: incomplete (missing 2 new decls)
The `\lean{...}` hint list accurately names the existing decls but is missing the two new ones.  No wrong hints.

### Generality: matches need
The scope of `lem:tilde_preserves_kernels` (finite-limit preservation for `tilde.functor R` on `Spec R`) is the correct level of generality for the downstream use.

### Recommended chapter-side actions (for blueprint-writing subagent)
1. **Add `tilde_stalkFunctor_map_toStalk` to `\lean{...}` list** and write a sub-step or sub-lemma block: "For `f : M ⟶ N`, the `Ab`-stalk map of `~f` via `toPresheaf` intertwines the localisation maps `tilde.toStalk`."
2. **Add `tildePreservesFiniteLimits_of_toPresheaf` to `\lean{...}` list** and write a sub-step or sub-lemma block: "It suffices to show `~ ⋙ Scheme.Modules.toPresheaf` preserves finite limits, since `toPresheaf` reflects them."
3. **Expand the proof sketch** with the three missing sub-steps: (a) R-linearity of Ab-stalk map via `germₗ`; (b) per-point `PreservesFiniteLimits` at each stalk; (c) jointly-reflecting-stalks assembly.
4. **Add a `% NOTE:` line** about the dead `ModuleCat R`-valued stalk path and the forced use of the `Ab` stalk path.
5. **Update `% NOTE:` at line 4340** to cross-reference `tilde_stalkFunctor_map_toStalk` and `tildePreservesFiniteLimits_of_toPresheaf` as in-file progress toward the named target.

---

## Severity summary

| Finding | Severity |
|---------|----------|
| `tilde_stalkFunctor_map_toStalk` has no `\lean{...}` entry in blueprint | **major** |
| `tildePreservesFiniteLimits_of_toPresheaf` has no `\lean{...}` entry in blueprint | **major** |
| Blueprint proof sketch under-specified for remaining formalization (R-linearity, jointly-reflecting stalks, Ab path) | **major** |
| `% NOTE:` doesn't cross-reference new decls as progress toward named target | minor |

**Must-fix-this-iter findings**: NONE.  No placeholder bodies, no sorry, no fake statements, no wrong signatures, no unauthorized axioms.  The named target's absence is honestly documented.

**Overall verdict**: All 5 axiom-clean declarations are genuine and correctly stated; the 2 new iter-034 decls need blueprint entries and the proof sketch needs sub-steps for the remaining stalkwise R-linearity + jointly-reflecting-stalks obligation before the prover can close `tildePreservesFiniteLimits`.
