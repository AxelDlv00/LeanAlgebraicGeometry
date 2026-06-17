# lean-vs-blueprint-checker — Picard/Pic0AbelianVariety.lean ↔ Picard_Pic0AbelianVariety.tex

## Scope

Compare exactly one `.lean` file with its blueprint chapter,
bidirectionally.

- **Lean file**:
  `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/Pic0AbelianVariety.lean`
- **Blueprint chapter**:
  `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_Pic0AbelianVariety.tex`

## Why this file in particular

This is a NEW file landed this iter (iter-193 file-skeleton dispatch
addressing the iter-192 blueprint-doctor finding "chapter covers a
non-existent Lean file"). 244 LOC; 5 theorem skeletons under
`AlgebraicGeometry.Scheme.Pic0` matching the chapter's 5 `\lean{...}`
pins:
1. `tangentSpaceIso` (A.3.iii) — `Nonempty (Σ' (e : Spec k ⟶ Pic0Scheme.left), IsLocalRing.CotangentSpace stalk ≃+ Scheme.HModule kbar (toModuleKSheaf C) 1)`.
2. `smooth` (A.3.iv) — `Smooth (Pic0Scheme C).hom`.
3. `proper` (A.3.v) — `IsProper (Pic0Scheme C).hom`.
4. `geometricallyIrreducible` (A.3.vi) — `GeometricallyIrreducible (Pic0Scheme C).hom`.
5. `isAbelianVariety` (A.3.vii assembly) — 4-conjunct.

## What to check (bidirectional)

1. **Lean → blueprint**: do the 5 Lean theorem signatures match what
   the chapter declares? Are universes / typeclass arguments aligned?
   Pay special attention to `tangentSpaceIso`'s use of `AddEquiv`
   (instead of `LinearEquiv`) — the prover note says this is a
   universe-alignment workaround for the file-skeleton; verify the
   chapter doesn't require `LinearEquiv` semantically.
2. **Lean → blueprint**: the `Pic0` namespace (sibling to
   `Pic0Scheme` defined in `IdentityComponent.lean`) is a new
   project-wide naming choice. Does the chapter prose make this
   distinction clear?
3. **Blueprint → Lean**: is the chapter's recipe (Kleiman §5 with
   Milne §I.1 cross-reference) at a level of detail the Lean side
   needs in order to close each body in iter-194+?
4. **Blueprint → Lean**: the chapter references several siblings
   (FGAPicRepresentability, IdentityComponent). Are the cross-file
   dependencies clearly indicated? Are there missing `\uses{...}`?
5. **Coexistence**: a sibling iter-185 `Pic0Scheme.isAbelianVariety`
   pin exists in `IdentityComponent.lean`. Is the chapter / Lean
   file taking a clear position on which one is canonical, or are
   they both blueprint-pinned in parallel?

## Output

Write your report to
`.archon/task_results/lean-vs-blueprint-checker-pic0av-iter193.md`
per the wrapper's standard path. Flag any MUST-FIX-THIS-ITER mismatch
that would block downstream prover work on the 5 declarations.

## Strict context discipline

Read ONLY the two files named above + Mathlib references on demand.
Do NOT read `STRATEGY.md`, `PROGRESS.md`, other chapters, or session
journals.
