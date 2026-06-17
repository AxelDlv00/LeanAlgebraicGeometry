# Blueprint Review Report

## Slug
tilde-rereview

## Iteration
035

## Scope
Fast-path scoped re-review of `lem:tilde_preserves_kernels` only
(`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`, L4327–4440).

---

## Verdict for `lem:tilde_preserves_kernels`

**complete: true**
**correct: true**
**must-fix: none**

Gate is satisfied. The planner may dispatch the TildeExactness prover this iter.

---

## Evidence

### 1. `\lean{}` gap — CLOSED

The statement block (L4329) now carries:

```
\lean{AlgebraicGeometry.tildePreservesFiniteLimits,
      AlgebraicGeometry.tilde_preservesFiniteColimits,
      AlgebraicGeometry.tilde_toStalk_map_injective,
      AlgebraicGeometry.tilde_preservesFiniteLimits_of_preservesKernels,
      AlgebraicGeometry.tilde_stalkFunctor_map_toStalk,
      AlgebraicGeometry.tildePreservesFiniteLimits_of_toPresheaf}
```

Both previously-missing iter-034 helpers — `tilde_stalkFunctor_map_toStalk` and
`tildePreservesFiniteLimits_of_toPresheaf` — are present. The `\lean{}` list is now
complete and names every Lean target the prover must discharge.

### 2. Proof-sketch gaps — CLOSED

The proof (L4369–4440) concludes with an explicit **Mechanization remarks** block containing three
itemized sub-steps at the formalize-level of detail the prover needs:

- **(A) R_𝔭-linearity of the stalk comparison** (L4401–4417): prose states the germ-naturality
  load-bearing step; `% NOTE` identifies `tilde_stalkFunctor_map_toStalk` + `germₗ` +
  `Scheme.Modules.Hom.app` Γ-linearity + `tilde_toStalk_map_injective` as the Lean package.
  Adequate for a prover: the step is named, its role explained, and the relevant helper cited.

- **(B) Stalkwise-iso ⟹ sheaf-iso** (L4418–4428): prose states the jointly-reflecting stalk
  family argument; `% NOTE` correctly flags the ModuleCat-stalk path as DEAD (private
  `toStalkₗ'`/`stalkIsoₗ`) and points to the abelian-presheaf route via
  `Scheme.Modules.toPresheaf`. Adequate for a prover: the live path is unambiguous.

- **(C) Reduction to the abelian-presheaf composite** (L4429–4438): prose states the categorical
  reduction; `% NOTE` names `tildePreservesFiniteLimits_of_toPresheaf` and the underlying
  `preservesFiniteLimits_of_reflects_of_preserves` assembler. Adequate for a prover: the
  reduction target and its Lean driver are both explicit.

### 3. Citation discipline — clean

- `% SOURCE:` line has the `(read from references/stacks-schemes.tex, L1425–1432)` parenthetical ✓
- `% SOURCE QUOTE:` is verbatim Stacks text ✓
- `% SOURCE QUOTE PROOF:` appears twice before the proof body (stalk computation quote +
  exactness-via-stalks quote) ✓
- `\textit{Source: ...}` visible attribution present in both statement and proof blocks ✓

### 4. Mathematical correctness — sound

The stalkwise-flatness argument is the standard proof: localization is flat, so
`M_𝔭 → N_𝔭` is exact; the stalk comparison map is therefore an isomorphism at every point;
a stalkwise isomorphism of sheaves of modules is a sheaf isomorphism. The finite-limit extension
is standard. No logical gap.

The three mechanization sub-steps correctly diagnose the Lean-specific obstacles:
linearity of the stalk map is non-trivial in Lean (the abelian-group stalk functor does not
automatically carry R-linearity); the ModuleCat stalk path is correctly marked dead; the
categorical reduction lemma is correctly identified. These are the actual remaining obstacles
consistent with the iter-034 memory (`tildePreservesFiniteLimits open on ONE gap = σ_x
R-linearity (germₗ) + jointlyReflectsLimit assembly`).

---

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

Overall verdict: `lem:tilde_preserves_kernels` is complete and correct with no must-fix remaining;
the gate is satisfied and the TildeExactness prover may be dispatched this iter.
