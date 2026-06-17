# Blueprint-reviewer directive — iter-273 (whole-blueprint audit)

Audit the WHOLE blueprint (all 38 chapters). This iteration the DAG agent added
~165 new 1-to-1 helper-coverage blocks across nine chapters (Albanese
AuslanderBuchsbaum/CodimOneExtension, RiemannRoch WeilDivisor/OCofP/H1Vanishing,
Picard FGAPicRepresentability/IdentityComponent/SheafOverEquivalence/RelativeSpec)
and a further batch-2 set is landing in AbelianVarietyRigidity, Albanese
AlbaneseUP, and Picard QuotScheme. These are "Proved directly in Lean" helper
entries pinned 1-to-1 to previously-uncovered `lean-aux` declarations.

## What I need from you

1. Your standard per-chapter completeness + correctness checklist (complete?
   correct? proofs detailed enough? Lean targets well-formulated?), covering
   ALL chapters — the cross-chapter view is the point.

2. **Special attention to the new coverage blocks:** verify the one-line
   informal statements are FAITHFUL to the Lean signatures (not fabricated from
   the decl name), that each is wired into its chapter cone via a
   **statement-level** `\uses{}` (leandag ignores proof-block `\uses{}`), and
   that no new block duplicates an existing `\lean{}` pin.

3. Your `### Dependency & isolation findings` section: each broken/missing
   `\uses{}` and each isolated node tagged `wire-up` / `remove` / `keep`. The
   live leandag shows 3 isolated blueprint nodes — confirm they are the
   reviewer-certified isolation-EXEMPT set (`lem:S3_sep_2_*`, `lem:S3_pi_2_*`,
   `lem:isiso_sheafification_map_of_W`) and flag any NEW isolation.

4. The active-route `\lean{}` name-drift list (decls named in `\uses{}`/`\lean{}`
   that no longer exist in Lean) — the review-agent's correction domain; surface
   them for the loop.

5. Any `## Unstarted-phase blueprint proposals` per STRATEGY.md phases lacking
   blueprint coverage.

## Context the DAG agent already knows (do not re-flag as new)

- 204 `lean-aux` decls remain uncovered, dominated by the TensorObjSubstrate
  family (122) which is actively churning under the A.1.c.sub prover lane and is
  deliberately deferred until it stabilises. These are the criterion-5 coverage
  debt, tracked in DAG_STATUS.
- The Riemann–Roch chapters are permanently USER-paused; their coverage is
  1-to-1 hygiene only.
