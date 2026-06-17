# iter-026 review

## Overall progress this iter
- **Total sorry**: 2 → 2 (no regression). Both intentional/frozen: superseded relative-form
  `CechAcyclic.lean:110` (`affine`) + frozen P5b `CechHigherDirectImage.lean:679`.
- **Build**: `AbsoluteCohomology.lean` → `lake env lean … EXIT 0`, diagnostic-clean, all 10 decls
  `lean_verify`-clean (`{propext, Classical.choice, Quot.sound}`). **But not yet imported into the
  build root** (see below).
- **Lanes planned 1, ran 1** (`AbsoluteCohomology.lean` — new-file scaffold).
- **+10 axiom-clean declarations**; **0 new sorries**; **all 6 PROGRESS objectives landed**.

## The headline: the Form-B absolute-cohomology phase opened and fully scaffolded in one lane
The iter-025 D1 decision (`H^p(U,F) := Ext^p_{X.Modules}(jShriekOU U, F)`, corepresenting object
`jShriekOU = sheafify(free(yoneda U))`) was realized end-to-end on the first prover attempt at the new
file. No blockers, no churn — exactly the low-risk reuse lane the analogist scoped. The strategic bet
of Form B is validated in the Lean itself: `absoluteCohomology_eq_zero_of_injective` is the one-liner
`Ext.eq_zero_of_injective e` because the injective sits in the **second** Ext argument, so the Form-A
"restriction-preserves-injectives" obligation is gone, not deferred. The covariant LES is three thin
off-the-shelf `Ext.covariant_sequence_exact₁/₂/₃` wrappers. Both audits confirm the Lean is faithful
(lean-auditor: clean, no weakening; lvb: 0 red flags, 3 pinned decls correct, 5 `\mathlibok` anchors
valid).

## This iter's analysis
- **Honest, clean convergence.** A single scoped lane closed its entire objective set with no sorries,
  no axioms, no churn. The dominant cost was Lean-engineering friction, not mathematics: the
  recurring **defeq-carrier `Preadditive` mismatch** (`erw [...]; rfl` for adjunction-`homEquiv`
  additivity), a **`HasExt` three-universe pin** (`HasExt.{u+1, u, u+1}`; bare `_` fails to unify the
  localized-hom universe `w`), the **`AddCommGrpCat` vs `AddCommGrp`** naming correction, and two
  `Ext.comp` restatement gotchas (`add_zero` not `by omega`; explicit `∃`-binder type for field
  notation). All four are now Knowledge-Base patterns.
- **One real must-fix surfaced by the audit, not the prover narrative.** The file compiles standalone
  but is **orphaned from the build root** — `AlgebraicJacobian.lean` does not `import` it. The prover
  flagged this (it cannot edit the root); lean-auditor independently raised it must-fix. Queued HIGH
  in recommendations. Until wired in, the umbrella build does not see the P5b output.

## The carried bookkeeping anomaly — still live
The iter-025 `\leanok` mis-removal is **not fully resolved**. `sync_leanok` iter=026 = added 4,
removed 0 (healthier than iter-025's removed-6), but `lem:ses_cech_h1` and `lem:injective_cech_acyclic`
— both axiom-clean and compiling in `CechBridge.lean` — still lack `\leanok`. Same most-plausible
cause: a build timeout in the sync window on CechBridge's heaviest decl (`maxHeartbeats 2000000`). I
did not touch `\leanok` (not my domain); flagged HIGH in recommendations for a sync re-run / budget
bump. This is a bookkeeping artifact, not un-proved work — the proofs are sound (verified iter-024/025
first-hand, and CechBridge was untouched this iter so the state is unchanged).

## Coverage / markers
- `unmatched` = 6, all the new `AbsoluteCohomology.lean` helpers (the 3 named decls are pinned and
  matched). Listed in recommendations for the planner to blueprint.
- blueprint-doctor: clean (no orphan chapters, no broken refs, no new axioms).
- **Manual marker changes: none** — the 5 Ext `\mathlibok` anchors were authored proactively by the
  plan-phase blueprint-writer (all lvb-confirmed valid); `\lean{}` pins match the prover's names; no
  `% NOTE:`/`\notready` action needed.

## Frontier ahead
P3b bridge complete; absolute-cohomology scaffold complete. The live frontier is **01EO
`cech_to_cohomology_on_basis`** (consumes the new covariant-LES + injective-vanishing + H⁰≅Γ wrappers
plus the P3b bridge), then **02KG `affine_serre_vanishing`**, which re-enables the frozen P5b. 01EO is
a sizeable dimension-shift lane — recommend effort-breaking it before a prover round.

## Subagent skips
- (none — both HIGHLY RECOMMENDED review subagents dispatched: lean-auditor `iter026`,
  lean-vs-blueprint-checker `abscohom`, since a `.lean` file was created and modified this iter.)
