# Progress-Critic Directive — iter019

Assess convergence per active route over the last K=4 iters (015–018). For each route:
verdict ∈ {CONVERGING, CHURNING, STUCK, UNCLEAR} + the corrective TYPE if not converging.

## Route FBC — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
Chapter: `Cohomology_FlatBaseChange.tex`. Phase FBC-A. STRATEGY `Iters left`: 2–3; phase entered very early (active many iters).
Signals:
- active-sorry count per iter: 015:4 → 016:4 → 017:4 → 018:4 (FLAT all 4 iters).
- helpers added per iter: 015 +1 (Seam-2 scaffold); 016 +1 (`pullbackPushforward_unit_comp`); 017 +4 (Seam-2 sub-lemmas, "motive wall dissolved"); 018 +0 (only a comment rewrite + one scaffolding line `rw [he,hinclA] at key`).
- prover status per iter: PARTIAL, PARTIAL, PARTIAL, PARTIAL.
- recurring blocker phrases: "motive is not type correct" / "dependent-leg-transport"; the **step-(iii) goal in `base_change_mate_fstar_reindex_legs` has been UNMOVED for 5 consecutive iters (014–018)**; iter-018 documented a new "literal-form lock" sub-obstacle and a ~150-LOC categorical telescoping recipe.
- note: iter-018's corrective WAS a blueprint expansion (reviewer GATE-PASS), but the post-prover per-file checker found that expansion STILL inadequate for step-iii.

## Route GF — `AlgebraicJacobian/Picard/FlatteningStratification.lean`
Chapter: `Picard_FlatteningStratification.tex`. Phase GF-alg. STRATEGY `Iters left`: 2–3.
Signals:
- active-sorry count per iter: 015:5 → 016:4 → 017:3 → 018:3.
- helpers/closures per iter: 016 closed the tower-descent helper; 017 CLOSED L5 (OreLocalization diamond defused); 018 L4 PARTIAL (foundation steps F1–F6 landed inside L4, isolated assembly residue, no new top-level decl).
- prover status: PARTIAL, COMPLETE(L5), PARTIAL(L4).
- blocker phrases: "OreLocalization instance diamond" (resolved 017); L4 "assembly residue" with injectivity+finiteness coupled through the witness g; "no missing Mathlib infra — every lemma confirmed present".

## Route QUOT — `AlgebraicJacobian/Picard/QuotScheme.lean`
Chapter: `Picard_QuotScheme.tex`. Phase QUOT-defs/SNAP foundation. STRATEGY `Iters left`: QUOT-defs 4–7, SNAP 2–4. Route-2 pivot first dispatched iter-017.
Signals:
- project-sorry count: 4 → 4 → 4 → 4 (the 4 sorries are PROTECTED stubs — not the active work; the active work is additive infrastructure building under mathlib-build mode).
- decls added per iter: 016 +3; 017 +13; 018 +20 (all axiom-clean; foundation poly-module + datum + ker/coker ambient calculus + base-case finiteness).
- prover status: building / foundation-complete; induction BODY not yet started.
- blocker phrases: "isDefEq/whnf pathology" (avoided by Route-2 ambient encoding — no pathology fired 017/018); "induction body" precisely decomposed (constructors → finite_transfer via Fin(r+1)↠Fin r ring surjection → base/step → (⊤,⊥) bridge), all engine lemmas confirmed present.
- note: 0 stub closures in 2 additive iters (017,018); iter-018 review flagged "QUOT must now CLOSE a stub / land the induction, not add more helpers, or treat as CHURNING".

## My PROGRESS.md `## Current Objectives` proposal for iter-019 (3 files)
1. `FlatBaseChange.lean` — FBC: after an **effort-break** of `base_change_mate_fstar_reindex_legs` into atomic sub-lemmas (the prover's 5-step recipe), a **fine-grained** prover formalizes + proves each atomic piece (NOT a verbatim re-dispatch of the whole-goal prove lane).
2. `FlatteningStratification.lean` — GF: prove L4 `exists_localizationAway_finite_mvPolynomial` (close the isolated assembly residue) after a blueprint Step-3 expansion.
3. `QuotScheme.lean` — QUOT [mathlib-build]: build the induction body (`subquotient_finite_transfer` → ker/coker constructors → base/step induction → (⊤,⊥) bridge → `gradedModule_hilbertSeries_rational`).

Run dispatch-sanity on this 3-file list.
