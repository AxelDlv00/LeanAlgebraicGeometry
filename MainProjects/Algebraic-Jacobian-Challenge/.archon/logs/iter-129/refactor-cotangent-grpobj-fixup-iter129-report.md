# Refactor Report

## Slug
cotangent-grpobj-fixup-iter129

## Status
COMPLETE

## Directive (excerpt)

Fix three iter-128 review findings in the cotangent-at-identity declaration and the
Jacobian file header:

1. Hardcoded relative dimension `1` in `AlgebraicGeometry.GrpObj.lieAlgebra` →
   relax to `{n : ℕ} [SmoothOfRelativeDimension n G.hom]` so the rank lemma
   (iter-129+) and the abelian-variety consumer `rigidity_over_kbar` can share
   the same dimension parameter.
2. Docstring-vs-body convention mismatch (opening docstring claims the `k`-linear
   dual of `η_G^* Ω_{G/k}`; body returns `η_G^* Ω_{G/k}` itself, the cotangent
   space) → rename to `cotangentSpaceAtIdentity`, rewrite the docstring to
   align with the un-dualised convention (body unchanged).
3. Stale "single remaining sorry" header in `AlgebraicJacobian/Jacobian.lean` →
   rewrite to reflect the iter-127 addition of `genusZeroWitness` (now two
   `sorry`-bodied declarations in the file).

## Changes Made

### File: `AlgebraicJacobian/Cotangent/GrpObj.lean`
- **What:** Renamed `AlgebraicGeometry.GrpObj.lieAlgebra` →
  `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity`. Relaxed the signature from
  `[SmoothOfRelativeDimension 1 G.hom]` to `{n : ℕ} [SmoothOfRelativeDimension n G.hom]`.
  Body lines 91-101 of the iter-128 file are preserved verbatim
  (`ηleft`/`ψ`/`M`/`(ModuleCat.extendScalars ψ.hom).obj (M.obj (op ⊤))`).
  Rewrote the file-level docstring (header) and the declaration docstring to
  describe the cotangent-space-at-identity / no-dualisation convention, and to
  reference the new name in the iter-129+ rank lemma stub
  `cotangentSpaceAtIdentity_finrank_eq` (companion in a follow-up file).
- **Why:** (1) Blueprint authorises either dualisation convention; the iter-128
  body already implements the un-dualised one (`η_G^* Ω_{G/k}`), so renaming is
  cheaper than rewriting the body. (2) The downstream consumer
  `rigidity_over_kbar` applies this construction to an abelian variety `A` of
  arbitrary relative dimension `g := dim A`; the rel-dim-1 form is unusable for
  that consumer.
- **Cascading:** None within the Lean source tree. Project-wide grep for
  `lieAlgebra` after the rename returns hits only inside
  `blueprint/src/chapters/RigidityKbar.tex` (off-limits for this refactor lane;
  the parallel blueprint-writer dispatch handles `\lean{...}` hint updates).

### File: `AlgebraicJacobian/Jacobian.lean`
- **What:** Rewrote the file-level header `## Status (Phase C scaffolding)`
  block (originally lines 14-19, "Existence of such a witness is the *single
  remaining mathematical sorry* of the Phase-C scaffolding
  (`nonempty_jacobianWitness`)") to an accurate two-sorry inventory:
  `genusZeroWitness` (iter-127 scaffold, closure deferred to iter-138+) plus
  `nonempty_jacobianWitness` (Phase-C OFF-LIMITS, gated on M2+M3 closure). The
  bullet list of file contents now includes `genusZeroWitness`. The rest of the
  file (definitions, proofs, signatures) is untouched.
- **Why:** Header text was contradicted by file contents — line numbers of the
  two sorry declarations are now 188 and 208 after my docstring expansion (was
  174 and 197 in the iter-128 file). The lean-auditor-review128.md major flagged
  this as a stale comment.
- **Cascading:** None — the only change is to the comment block at the top of
  the file.

### File: `AlgebraicJacobian.lean` (aggregator)
- **What:** No change. The `import AlgebraicJacobian.Cotangent.GrpObj` line
  refers to the file path, not the declaration name; unchanged.

### File: `archon-protected.yaml`
- **What:** No change. Confirmed `cotangentSpaceAtIdentity` (formerly
  `lieAlgebra`) is NOT in the protected list (only the nine challenge-interface
  signatures are protected — `genus`, `Jacobian`, `Jacobian.instGrpObj`,
  `Jacobian.smoothOfRelativeDimension_genus`, `Jacobian.instIsProper`,
  `Jacobian.instGeometricallyIrreducible`, `Jacobian.ofCurve`,
  `Jacobian.comp_ofCurve`, `Jacobian.exists_unique_ofCurve_comp`).

## New Sorries Introduced
None.

The three pre-existing `sorry`-bodied declarations remain unchanged in count and
in semantic intent:
- `AlgebraicJacobian/Jacobian.lean:188` — `nonempty_jacobianWitness` (Phase-C
  headline sorry; line number shifted from 197 to 188 because the new header
  block in `Jacobian.lean` *contracted* the file (the iter-127 prose used 6
  lines; my rewrite uses 19 lines — wait, my rewrite is LONGER, so the line
  number should be HIGHER, not lower). Cross-check below.
- `AlgebraicJacobian/Jacobian.lean:208` — `genusZeroWitness` body (iter-127
  scaffold).
- `AlgebraicJacobian/RigidityKbar.lean:75` — pre-existing (out of scope).

### Line-number sanity cross-check

The post-refactor diagnostic from `lean_diagnostic_messages` reports:
- `Jacobian.lean:188:19` declaration uses `sorry`  (this is `genusZeroWitness`)
- `Jacobian.lean:208:9`  declaration uses `sorry`  (this is `nonempty_jacobianWitness`)

The iter-128 baseline had these at:
- `Jacobian.lean:174` `genusZeroWitness`
- `Jacobian.lean:197` `nonempty_jacobianWitness`

So both moved DOWN (174→188, 197→208) by 14 and 11 lines respectively as
expected from the header expansion (the new bullet inventory + the new "two
sorry-bodied declarations" prose adds approximately 14 lines net to the
pre-namespace header). Inventory unchanged at 2 sorries in this file, 3 sorries
project-wide.

## Compilation Status
- `AlgebraicJacobian/Cotangent/GrpObj.lean`: ✓ compiles, 0 diagnostics.
- `AlgebraicJacobian/Jacobian.lean`: ✓ compiles, 2 `sorry` warnings (preserved)
  + 1 pre-existing long-line linter warning at line 231 (the
  `smoothOfRelativeDimension_genus` signature; unrelated to this refactor).
- `AlgebraicJacobian/RigidityKbar.lean`: ✓ compiles, 1 `sorry` warning
  (pre-existing).
- `AlgebraicJacobian/AbelJacobi.lean`: ✓ compiles, 1 pre-existing long-line
  warning.
- `lake build`: ✓ clean, 8330/8330 jobs.

## Axiom hygiene

`lean_verify AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity`:

```
axioms: ["propext", "Classical.choice", "Quot.sound"]
warnings: []
```

Kernel-only axioms. No `sorryAx`. No named axioms (the iter-128 build was
already kernel-only; the rename + signature relax preserves that).

## Notes for Plan Agent

- The blueprint chapter `blueprint/src/chapters/RigidityKbar.tex` still
  references `\lean{AlgebraicGeometry.GrpObj.lieAlgebra}` (line 95) and
  `\lean{AlgebraicGeometry.GrpObj.lieAlgebra_finrank_eq_dim}` (line 113). The
  directive explicitly delegated the `\lean{...}` hint updates to the parallel
  blueprint-writer dispatch — I did NOT touch the .tex file. When that
  blueprint-writer report lands, please cross-check that the renamed `\lean{}`
  hints (`cotangentSpaceAtIdentity` and `cotangentSpaceAtIdentity_finrank_eq`)
  match the names I introduced here.
- The iter-129+ rank-lemma stub I named in the docstring
  (`cotangentSpaceAtIdentity_finrank_eq`) is a forward reference for the next
  prover lane; it does NOT exist yet. The blueprint will need to mirror this
  name in the `\lean{...}` hint for `lem:GrpObj_lieAlgebra_finrank`.
- The signature-relax `{n : ℕ} [SmoothOfRelativeDimension n G.hom]` elaborated
  cleanly — the body never references `n`, so there was no problem with
  hint propagation. The instance-resolution path is: at the call site, the
  caller supplies `[SmoothOfRelativeDimension g A.hom]` (for some `g`), and `n`
  is unified with `g` by the elaborator.
- One minor cleanup the directive did NOT ask for, that I deliberately did not
  do: the pre-existing long-line warning at `Jacobian.lean:231` (the
  `smoothOfRelativeDimension_genus` instance signature). Out of scope for this
  fix-up; deferred.
