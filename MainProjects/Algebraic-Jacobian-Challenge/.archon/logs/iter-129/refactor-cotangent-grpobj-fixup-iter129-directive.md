# Refactor Directive

## Slug
cotangent-grpobj-fixup-iter129

## Problem

Two iter-128 review-phase must-fix items, plus one iter-128 lean-auditor major:

1. **Hardcoded relative dimension `1`** in `AlgebraicGeometry.GrpObj.lieAlgebra` (`AlgebraicJacobian/Cotangent/GrpObj.lean:87-101`). The signature reads `[CategoryTheory.GrpObj G] [SmoothOfRelativeDimension 1 G.hom] [IsProper G.hom] [GeometricallyIrreducible G.hom]`. This is wrong on three counts (per `lean-vs-blueprint-checker-cotangent-grpobj-review128.md` S-1):
   - Blueprint prose pins "smooth ... group scheme" — dimension-agnostic.
   - Body construction is purely categorical (no use of the smoothness hypothesis).
   - Downstream consumer `thm:rigidity_over_kbar` applies `lieAlgebra` to an abelian variety `A` of *arbitrary* relative dimension `g := dim A`; the rel-dim-1 form is unusable for that consumer.

2. **Docstring-vs-body convention mismatch** in `AlgebraicGeometry.GrpObj.lieAlgebra` (per `lean-auditor-review128.md` must-fix + `lean-vs-blueprint-checker-cotangent-grpobj-review128.md` S-2). The opening docstring (lines 58-60) claims the return value is the *`k`-linear dual* of `η_G^* Ω_{G/k}` (i.e. the Lie algebra `𝔤`, the tangent space). The Status docstring (lines 79-82) and the body (lines 91-101) say it is the cotangent space `η_G^* Ω_{G/k}` itself (i.e. `𝔤^∨`). The body does NO dualisation step (no `Module.Dual`, no `LinearMap.dual`, no `ModuleCat.dual` call). The two docstrings disagree, and the declaration's name `lieAlgebra` (conventionally the tangent space `𝔤`) conflicts with the body (cotangent space `𝔤^∨`).

3. **Stale file header in `AlgebraicJacobian/Jacobian.lean:14-19`** (per `lean-auditor-review128.md` major): "Existence of such a witness is the *single remaining mathematical sorry* of the Phase-C scaffolding (`nonempty_jacobianWitness`)" — stale since iter-127 added `genusZeroWitness` (line 174-178) as a second `sorry`-bodied declaration in the same file. Header text is contradicted by file contents.

## Mathematical Justification

The body of `lieAlgebra G` computes `(ModuleCat.extendScalars ψ.hom).obj (M.obj (op ⊤))` where `M = Scheme.relativeDifferentialsPresheaf G.hom` and `ψ : Γ(G.left, ⊤) ⟶ CommRingCat.of k` is the ring map induced by the identity section. Concretely this is `k ⊗_{Γ(G.left, ⊤)} Ω_{G/k}(⊤)` — i.e. the **cotangent space** at the identity section (`𝔤^∨ = η_G^* Ω_{G/k}` in the blueprint's notation), NOT its dual.

The blueprint `RigidityKbar.tex` § Piece (i.a) `lem:GrpObj_lieAlgebra` encoding note explicitly authorizes either dualisation convention: "Whether to dualise inside the declaration (returning $\mathfrak g$) or to leave it as $\mathfrak g^\vee$ and let downstream consumers dualise is at the prover's discretion; the rigidity argument only needs *some* canonical fg-free $k$-module attached to the identity of $G$ and its dim/rank relation to $G$'s relative dimension." We choose the no-dualisation convention (cotangent, `𝔤^∨`) because the iter-128 body already implements it; renaming the declaration is cheaper than rewriting the body.

The signature must be relaxed from `[SmoothOfRelativeDimension 1 G.hom]` to a free natural-number binder `{n : ℕ} [SmoothOfRelativeDimension n G.hom]` so that:
- the downstream iter-129+ rank lemma `lieAlgebra_finrank_eq_dim G : Module.finrank k (lieAlgebra G) = n` can share `n` with this signature;
- the downstream consumer `rigidity_over_kbar` (which applies `lieAlgebra` to an abelian variety `A` of arbitrary `g := dim A`) can instantiate it for any `n`.

The blueprint chapter cross-references the choice of (a) cotangent vs (b) Lie-algebra-as-dual; the iter-129 blueprint-writer pass on `RigidityKbar.tex` (dispatched in parallel) will pin convention (a) and rename the `\lean{...}` hint to match the rename you perform here.

## Changes Requested

### File: `AlgebraicJacobian/Cotangent/GrpObj.lean`

(1) **Rename `lieAlgebra` → `cotangentSpaceAtIdentity`** throughout the file (declaration name, namespace path `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity`, all references in docstrings and comments).

(2) **Relax the signature**:

Old:
```lean
noncomputable def lieAlgebra (G : Over (Spec (.of k)))
    [CategoryTheory.GrpObj G] [SmoothOfRelativeDimension 1 G.hom] [IsProper G.hom]
    [GeometricallyIrreducible G.hom] :
    ModuleCat k :=
```

New:
```lean
noncomputable def cotangentSpaceAtIdentity (G : Over (Spec (.of k)))
    [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom] [IsProper G.hom]
    [GeometricallyIrreducible G.hom] :
    ModuleCat k :=
```

The body content (lines 91-101) is preserved verbatim. The `{n : ℕ}` is an implicit instance-resolution parameter; `[SmoothOfRelativeDimension n G.hom]` is a binder that the elaborator unifies from the smoothness instance available at the call site.

(3) **Rewrite the docstring** to align with the cotangent convention. Replace lines 56-86 with a docstring of approximately the following content (you may polish prose, but match the structural points):

```
/-- The **cotangent space at the identity** of a smooth proper geometrically
irreducible group scheme `G` over `k`, as a `k`-vector space (returned as
`ModuleCat k`).

Mathematically: `η_G^* Ω_{G/k}`, the pullback of the relative cotangent
sheaf along the identity section. By smoothness of `G` at `η_G` this is
a finitely-generated free `k`-module of rank equal to the relative
dimension of `G.hom`; the iter-129+ companion rank lemma
`cotangentSpaceAtIdentity_finrank_eq` (in a follow-up declaration) pins
the rank to `n` from the `[SmoothOfRelativeDimension n G.hom]` instance.

The Lie algebra `𝔤` of `G` (the tangent space at the identity) is the
`k`-linear dual of this module; downstream consumers that need `𝔤` may
take `Module.Dual k (cotangentSpaceAtIdentity G)`. We do not dualise here
because the rigidity argument is symmetric under dualisation (only the
finite-rank-free claim is consumed) and the un-dualised form is the
direct output of the pullback-along-section construction.

The bracket / Lie-algebra structure is NOT packaged here — only the
underlying `k`-module is needed for the rigidity argument.

**Construction (iter-128 prover lane).** The body uses the
pullback-along-section bridge:
1. The identity section `η_G : 𝟙_ ⟶ G` of the `GrpObj` structure gives
   a scheme morphism `η_G.left : Spec k ⟶ G.left` (using the definitional
   identification `(𝟙_ (Over (Spec (.of k)))).left = Spec (.of k)`).
2. Sections on the top open give a commutative ring map
   `Γ(G.left, ⊤) ⟶ Γ(Spec k, ⊤)`; composing with the canonical iso
   `Γ(Spec k, ⊤) ≅ k` (`Scheme.ΓSpecIso`) yields
   `ψ : Γ(G.left, ⊤) ⟶ CommRingCat.of k`.
3. `relativeDifferentialsPresheaf G.hom` evaluated at the top open
   yields a `Γ(G.left, ⊤)`-module, the module of global relative
   differentials of `G/k`.
4. Extension of scalars along `ψ` to `k` (i.e. tensoring with `k`
   over `Γ(G.left, ⊤)`) gives the cotangent space at the identity
   section as a `k`-module.

This compiles to a `ModuleCat k` with no `sorry`. The structural
properties (`Module.Free k`, `Module.Finite k`, rank `= n`) are
content for the iter-129+ rank lemma. -/
```

(4) **Update the file header** (lines 12-43) to reference the new name and the iter-129 rename:

The current header references `lieAlgebra` and "Lie algebra of a group scheme at the identity"; rewrite to "Cotangent space at the identity of a group scheme" and update internal references. The "Status (iter-128 prover lane: COMPLETE)" block should be updated to "Status (iter-129 fix-up: signature relaxed + renamed; iter-128 body preserved)".

### File: `AlgebraicJacobian/Jacobian.lean`

(5) **Rewrite the stale file header at lines 14-19** to reflect the post-iter-127 state. The header currently says:

> Existence of such a witness is the *single remaining mathematical sorry* of the Phase-C scaffolding (`nonempty_jacobianWitness`).

There are now TWO `sorry`-bodied declarations in the file: `genusZeroWitness` (line 174-178, iter-127 scaffold; body gated on M2.a closure iter-145+) and `nonempty_jacobianWitness` (line 197, OFF-LIMITS; gated on M2 + M3 closure).

Replace the misleading "single remaining" phrasing with an accurate two-sorry inventory. Keep the file's overall narrative (Phase-C Jacobian construction) intact; just fix the inventory count and add a note about the iter-127 `genusZeroWitness` scaffold.

You may polish prose at your discretion; the load-bearing change is the inventory accuracy.

### File: `AlgebraicJacobian.lean` (aggregator)

(6) **No changes**. The `import AlgebraicJacobian.Cotangent.GrpObj` line is preserved (the file location is unchanged, just the declaration name inside).

### `archon-protected.yaml`

(7) **No changes**. `cotangentSpaceAtIdentity` (formerly `lieAlgebra`) is NOT a protected declaration; the YAML's protected list contains only the nine signatures of the challenge interface. Confirm by checking the YAML.

## Affected files

- `AlgebraicJacobian/Cotangent/GrpObj.lean`: rename + signature relax + docstring rewrite.
- `AlgebraicJacobian/Jacobian.lean`: stale file header fix.
- `AlgebraicJacobian.lean`: unchanged.
- `archon-protected.yaml`: unchanged.

Project-wide grep for `lieAlgebra` should reveal zero remaining references after the rename (the iter-128 blueprint chapter `RigidityKbar.tex` uses `\lean{AlgebraicGeometry.GrpObj.lieAlgebra}` but the parallel blueprint-writer dispatch handles the chapter's `\lean{...}` hint update — do NOT edit blueprint chapters from this refactor lane).

## Expected outcome

- `AlgebraicJacobian/Cotangent/GrpObj.lean` has 0 sorries (preserved iter-128 close); declaration is `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity`; signature carries `{n : ℕ} [SmoothOfRelativeDimension n G.hom]`.
- `AlgebraicJacobian/Jacobian.lean` has 2 sorries (unchanged: `genusZeroWitness` + `nonempty_jacobianWitness`); file header accurately describes the two-sorry inventory.
- `lake build` clean (8330/8330 jobs).
- `lean_verify AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` returns kernel-only axioms `{propext, Classical.choice, Quot.sound}` — no `sorryAx`, no named axioms.
- Project sorry count unchanged (3 total).

## Constraints

- **NO body change** to `cotangentSpaceAtIdentity`. Lines 91-101 of the body are preserved verbatim.
- **NO touching `RigidityKbar.lean`** (the rename of `rigidity_over_kbar` is a low-priority cleanup deferred per STRATEGY.md § M2.a row, NOT in scope here).
- **NO editing blueprint chapters** — the parallel `blueprint-writer` dispatch handles `RigidityKbar.tex` updates including the renamed `\lean{...}` hint.
- **NO new axioms.** `lean_verify` after the refactor must show no `sorryAx` in the chain for `cotangentSpaceAtIdentity`.
- **NO new sorry sites.** This refactor is signature-only; it must not introduce any new `sorry`-bodied declaration.

If a problem appears during the rename (e.g. the elaborator cannot resolve the `{n : ℕ}` binder against the iter-128 body without further hints), STOP and write a PARTIAL report naming the specific Lean error. Do NOT bypass the signature relaxation by reverting to the hardcoded `1`.
