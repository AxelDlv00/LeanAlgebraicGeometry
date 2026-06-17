# Recommendations for the next plan iteration (post iter-045)

## CRITICAL / HIGH

### HIGH-1 — `tile_section_localization` is BLOCKED on Lean engineering (W1–W3), not math: change the approach before re-dispatching
Five consecutive prover iters (041–045) have advanced the keystone tile route but `tile_section_localization`
— the final leaf — is still not landed. **All mathematics is axiom-clean and present.** The obstruction is
now purely Lean-engineering (W1 noncomputable-aux hoist for any `Spec`-dependent `letI`/`have`; W2 `SMul R`
not synthesised for `IsScalarTower R R_g` on the tile carrier; W3 `whnf`/`isDefEq` timeout at 4M heartbeats).
**Do NOT re-dispatch the same `mathlib-build` "assemble it" objective** — two concrete attempts this iter
reproduced W1/W2 verbatim. The iter-045 plan's own reversal signal fires: **dispatch a mathlib-analogist
(api-alignment)** on underlying-type `restrictScalars` / `IsScalarTower` transport, with the W1–W3 error
state attached. Two concrete asks for that consult:
  - Is there a Mathlib idiom for installing an `R`-module / scalar-tower structure on a
    `Spec`-noncomputable carrier WITHOUT a `letI`/`have` (the only known route is one giant inline `exact @…`
    term, named in-file)?
  - **Design-shape question (the deeper one):** is installing `Module R` on a `modulesSpecToSheaf.obj`
    carrier the wrong shape? Would phrasing the descent on the `F`-side carrier from the start (so the
    `R`-structure is the native one and no dynamic install is needed) avoid W1/W2 entirely? A
    progress-critic "design-shape suspected" read would make `mathlib-analogist` the recommended corrective.
This is a genuine convergence risk: surface it to the progress-critic next plan phase (CHURNING is
plausible on the 041–045 PARTIAL pattern, even though each iter landed real axiom-clean infra).

### HIGH-2 — `sync_leanok` is fooled by a commented-out `lemma <name>` in the `.lean` file (DAG-poisoning)
The block `lem:tile_section_localization` carried `\leanok` (statement + proof) and `\lean{}` despite the
Lean decl being absent (only a commented-out sketch `/- … lemma tile_section_localization … -/` exists).
`sync_leanok` (iter-045, removed=0) did not clear it — the commented `lemma` text almost certainly fooled
the analyzer into "decl exists, no sorry → \leanok". **Review removed the two false `\leanok` this iter**
(authorized override), but the fix is fragile: next `sync_leanok` may re-add it. **Planner: instruct the
prover to rename/mangle the commented-out sketch** so it does NOT contain the literal `lemma
tile_section_localization` (e.g. wrap as ```` ```text ```` prose or rename to `tile_section_localization_SKETCH`
inside the comment). Until then, the keystone leaf's blueprint status is at risk of silently flipping back
to falsely-proved, which would mislead the planner into thinking 01I8 is essentially done.

### HIGH-3 — delete the stale "full assembly now unblocked" comment in the `.lean` file (lean-auditor MAJOR)
Lines 1068–1108 of `QcohTildeSections.lean` are a stale iter-043/044 progress note asserting
`tile_section_localization` is "NEXT, full assembly now unblocked" with "no math wall" — directly
contradicting the iter-045 W1–W3 blocked comment block immediately above it (lines 1003–1066). A future
prover reading the file will get contradictory guidance. Have the prover delete the stale block (review
does not edit `.lean`). See `task_results/lean-auditor-iter045.md`.

## MEDIUM

### MED-1 — author blueprint blocks for the 5 new unmatched Lean decls (coverage debt; DAG `unmatched`=6)
All are general-open companions of existing `V=⊤` blocks (or private wrappers). Dispatch a blueprint-writer
on `Cohomology_CechHigherDirectImage.tex`:
  - **`AlgebraicGeometry.modulesRestrictBasicOpen_smul_eq'`** — general-`V` tile-action `rfl` bridge.
    Companion of `lem:modulesRestrictBasicOpen_smul_eq`. Proof: `rfl`.
  - **`AlgebraicGeometry.tile_section_ring_identity'`** — general-`V` structure-sheaf ring identity.
    Companion of `lem:tile_section_ring_identity`. Deps: `tile_section_ring_identity` (⊤),
    `Scheme.Hom.appIso_inv_naturality`, `Scheme.Hom.opensFunctor` monotonicity, thin-cat `Subsingleton`.
    **Bundle the two private wrappers** `AlgebraicGeometry.appIso_inv_res` and
    `AlgebraicGeometry.appIso_inv_res_assoc` into THIS block's `\lean{…}` (private is NOT exempt from
    `unmatched`).
  - **`AlgebraicGeometry.tile_scalar_compat'`** — general-`V` scalar-tower compat (the `V=D(f̄)` instance
    is the keystone sub-need). Companion of `lem:tile_scalar_compat`. Deps:
    `modulesSpecToSheaf_smul_eq`, `modulesRestrictBasicOpen_smul_eq'`, `tile_section_ring_identity'`.
  - **`AlgebraicGeometry.CechAcyclic.affine`** (pre-existing dead, has-sorry) — deferred to the P5b
    assembly rework; not new debt.

### MED-2 — refresh the `lem:tile_section_localization` Step-4 sketch (lean-vs-blueprint `qts` Q3)
The Step-4 prose calls the `V=D(f̄)` analogue "mechanical reuse, not new mathematics", but realizing it
required 150+ LOC of new lemmas this iter, and the W1–W3 engineering walls are not mentioned anywhere.
After HIGH-1's mathlib-analogist returns, have a blueprint-writer fold the actual descent shape (inline
`exact` term, instance-plumbing constraints) into the sketch so the next assembly attempt is honestly
guided. Review already added a `% NOTE` on the now-stale `V=⊤`-only caveat.

## Blocked targets — do NOT re-assign as-is
- **`tile_section_localization`** via another plain `mathlib-build` assembly objective — W1/W2 reproduced
  twice with named errors. Needs the mathlib-analogist consult (HIGH-1) FIRST, then a re-dispatch with the
  inline-`exact`-term recipe (or the F-side-carrier reshape) explicitly in the objective.

## Reusable proof patterns discovered (also in PROJECT_STATUS.md KB)
- **Inline-only `Spec`-dependent instances:** never `letI`/`have` a `Module`/`IsScalarTower`/`LinearEquiv`
  whose def mentions `Spec` — it hoists to a noncomputable aux def and fails codegen even in a Prop lemma.
- **`appIso_inv_naturality` wrapper pattern:** restate the Mathlib naturality lemma with explicit
  `homOfLE`/image opens to get a `rw`-matchable form, plus a `Category.assoc`-folded variant for buried
  targets.

## Promising / on-track
- The 5 helpers are permanent, standalone progress (no dependency on the blocked lemma). The keystone route
  has landed axiom-clean decls every prover iter (040:+4, 041:+3, 042:+1, 043:+2, 044:+5, 045:+5).
- No honest off-keystone parallel lane exists yet (the only off-keystone frontier node
  `cech_augmented_resolution` is gated on 01I8). Single-lane focus remains correct UNTIL HIGH-1 resolves
  the engineering wall.
