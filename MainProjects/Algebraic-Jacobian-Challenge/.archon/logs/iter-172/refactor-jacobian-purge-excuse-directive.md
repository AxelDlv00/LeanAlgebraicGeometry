# Refactor Directive (iter-172, slug `jacobian-purge-excuse`)

## Slug
jacobian-purge-excuse

## Target file

`AlgebraicJacobian/Jacobian.lean` (READ + EDIT).

## Task

Per iter-171 lean-auditor verdict (`task_results/lean-auditor-iter171.md` § Must-fix-this-iter): purge the CRITICAL excuse-comment block under `genusZeroWitness.isAlbaneseFor.key` at L237-263 AND refresh the stale strategic docstring on `genusZeroWitness` at L182-208. **Do not** attempt to close the `sorry` at L264-265 itself (proof body) — your write-domain is structural / textual only, no proof bodies.

### Task 1 — purge excuse-comment L237-263

The current block claims the proof "CANNOT be wired" due to three gates:
1. **Import cycle** (`Jacobian → RigidityKbar → Rigidity → Jacobian`) — INVALID under iter-163 Route C. `AbelianVarietyRigidity.lean` does NOT import `Rigidity.lean`/`Jacobian.lean`; it imports only `Genus.lean`, `Genus0BaseObjects.lean`, `RigidityLemma.lean`. Importing `AbelianVarietyRigidity` into `Jacobian.lean` is import-clean.
2. **CharZero gate** — INVALID. `rigidity_genus0_curve_to_grpScheme` (declared in `AbelianVarietyRigidity.lean` L315) is char-free; the `[CharZero kbar]` instance is explicitly dropped (audit confirmed).
3. **Base-change functor missing** — PARTIALLY valid but DOES NOT BLOCK the path. The Route C replacement still requires moving from `Over (Spec k)` to `Over (Spec k̄)` (algebraic closure), but this is a well-defined `Over.tensorLeft`-style pullback, and the descent step is `Flat.epi_of_flat_of_surjective` which IS in Mathlib. Not a "missing functor" — a real sub-build, but not the kind of "out-of-file plan-level gate" the current block claims.

**Replacement text** — replace L237-263 with the following honest narrative (LaTeX-free prose, Lean comment syntax `-- ...`):

```
      -- Genus-0 RIGIDITY (C.2): `f` equals the constant morphism at the identity.
      -- The route-C content `rigidity_genus0_curve_to_grpScheme` (declared in
      -- `AlgebraicJacobian.AbelianVarietyRigidity`) is char-free and import-clean
      -- (proven iter-163 onward). To consume it for the general `[Field k]` goal,
      -- this body needs to pull back `(C, A, f, P)` along an algebraic closure
      -- `Spec k̄ → Spec k`, apply `rigidity_genus0_curve_to_grpScheme` in the
      -- pulled-back setting, then descend the morphism equality along the
      -- faithfully-flat surjection (the descent step itself is
      -- `Flat.epi_of_flat_of_surjective`, already used below to cancel the
      -- terminal epimorphism). The pullback functor + the descent of a morphism
      -- equality is the residual sub-build; it is real but is not gated on
      -- any out-of-file plan-level decision.
```

### Task 2 — refresh docstring L182-208 on `genusZeroWitness`

The current docstring frames `genusZeroWitness.key` via the OLD `rigidity_over_kbar` + faithfully-flat-descent strategy (the iter-126/iter-156 CharZero fallback). Per iter-163 commitment, the route is now Route C with `rigidity_genus0_curve_to_grpScheme` (char-free).

**Replacement text** — replace the docstring block at L182-208 with:

```
/-- Genus-`0` Albanese witness. The witness object is the trivial terminal scheme
`𝟙_ (Over (Spec k))`; the `JacobianWitness` structural fields (proper, smooth,
geometrically irreducible, genus-stable, group-object) reduce to the
corresponding trivialities on `Spec k` via the structural cluster
`(𝟙_).hom = 𝟙 (Spec k)`. The `isAlbaneseFor` field consumes the **genus-0
abelian-variety rigidity** statement: for every pointed `(C, P)` and every
target group scheme `(A, η[A])`, the genus-0 hypothesis forces a morphism
`f : C ⟶ A` with `P ≫ f = η[A]` to equal `toUnit C ≫ η[A]`. Over an
algebraically closed base `k̄` this is
`AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme` (in
`AlgebraicJacobian.AbelianVarietyRigidity`, char-free, route-C, iter-163).
For a general `[Field k]` base the keystone is consumed via pullback to
`Spec k̄` + descent of the morphism equality along the faithfully-flat
surjection `Spec k̄ → Spec k`. The uniqueness clause cancels the epimorphism
`toUnit C` via `Flat.epi_of_flat_of_surjective` (smooth ⟹ flat,
geometrically irreducible ⟹ surjective on `Spec k`).

**Status (iter-172):** the `key` body remains `sorry`; the rigidity consumer
exists (declared) but still propagates upstream sorries from the iter-171
body skeleton in `Genus0BaseObjects.lean`. Wiring closes once
(i) the `Genus0BaseObjects` body-skeleton internal sorries discharge, and
(ii) the `k → k̄` pullback / descent step is filled. -/
```

### What to leave UNTOUCHED

- The `genusZeroWitness` declaration head + parameter list (L209-212).
- All fields `J`, `grpObj`, `proper`, `smooth`, `geomIrred`, `smoothGenus`, `isAlbaneseFor` — content unchanged.
- The `key` body at L264-265 — `sorry` STAYS. Refactor agents do NOT close proof bodies.
- All other declarations / docstrings in the file.
- The `positiveGenusWitness` block (L279-303).

### What about other minor stale comments

The lean-auditor flagged several minor stale comments elsewhere in the project (RigidityKbar.lean status block, Cotangent/GrpObj.lean L428-525, Cotangent/ChartAlgebra.lean L36-79). **DO NOT TOUCH THOSE** — write-domain is `Jacobian.lean` only this directive.

## Verification

After edits:

1. `lake build AlgebraicJacobian.Jacobian` — must exit 0 (sorry warnings only — `key` + `positiveGenusWitness` remain `sorry`).
2. `grep -n "CANNOT" AlgebraicJacobian/Jacobian.lean` — must return 0 matches (the excuse-comment is purged).
3. `grep -n "rigidity_over_kbar" AlgebraicJacobian/Jacobian.lean` — should return at most 1 match (the historical reference in your refresh; ideally 0).
4. Report the new line numbers of the docstring + the new line range of the replacement comment.

## Out of scope

- DO NOT add new `import` statements (the import shape stays as-is; wiring `rigidity_genus0_curve_to_grpScheme` is a separate iter-173+ structural step requiring careful import-graph analysis).
- DO NOT close the `key` sorry — that's a future prover lane.
- DO NOT touch `task_pending.md`, `STRATEGY.md`, blueprint chapters.
