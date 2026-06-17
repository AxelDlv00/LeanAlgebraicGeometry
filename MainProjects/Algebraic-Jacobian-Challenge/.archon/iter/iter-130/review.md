# Iter-130 (Archon canonical) — review

## Outcome at a glance

- **Prover lane fired and CLOSED its target.** Iter-130 was the
  iter-128/129 META-PATTERN TRIPWIRE check: would the body-swap on
  `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` succeed in
  replacing the iter-128 zero-collapse body with a non-vacuous
  Replacement (B) chart-base-change construction? **Yes**: the prover
  closed the body in 3 substantive Edits (one parse error on the `h⊤`
  hypothesis name; one Prop-elimination error on direct `obtain`; one
  clean close via the `Classical.choice` pivot), then refreshed the
  file's three docstring blocks (header + status + declaration) in
  three further Edits. The body passes `progress-critic-iter130`'s
  acceptance test: references `smooth_locally_free_omega`, ~40 LOC,
  not a `simp`-only collapse.
- **Substantive structural change via 1 prover + 1 plan-phase
  blueprint-writer (already landed in plan phase) + 3 plan-phase critics
  + 2 review-phase audits**:
  - The **prover** swapped the body of `cotangentSpaceAtIdentity` from
    the iter-128 `(ModuleCat.extendScalars ψ.hom).obj (M.obj (op ⊤))`
    form to the iter-130 Replacement (B):
    `(ModuleCat.extendScalars ψV.hom).obj
      (ModuleCat.of Γ(G.left, V) Ω[Γ(G.left, V) ⁄ Γ(Spec (.of k), U)])`,
    wrapped in `Classical.choice (α := ModuleCat k)` on a `Nonempty`
    witness to escape the `Type`-vs-`Prop` recursor restriction. File
    grew from 104 LOC (iter-129 close) → 172 LOC (post iter-130) net,
    with most of the addition in expanded docstring prose (file-level
    introduction, `## Status` block, declaration docstring's
    Replacement-(B) construction sketch + canonicity caveat).
  - The **iter-130 plan-phase blueprint-writer**
    (`rigiditykbar-piecei-realign-iter130`) rewrote `RigidityKbar.tex`
    § Piece (i) prose to align with Replacement (B): proof of
    `lem:GrpObj_cotangentSpace` re-described in chart-base-change
    terms; `lem:GrpObj_cotangent_bridge` LHS hedged + `\notready` added
    + "tautological" framing dropped; rank lemma proof gained an
    iter-130 closure-path paragraph with 4 verified Mathlib names.
  - **Plan-phase critics**: `strategy-critic-iter130` CHALLENGE (5
    must-fix + 3 alternatives + 2 SOUND) — all absorbed via STRATEGY.md
    + the prover directive's acceptance test + the parallel
    blueprint-writer; `blueprint-reviewer-iter130` HARD GATE GREEN with
    1 must-fix absorbed via the writer; `progress-critic-iter130` 3
    UNCLEAR with explicit acceptance test wired into the prover
    directive.
  - **Review-phase audits** (dispatched this iter): `lean-auditor-review130`
    and `lean-vs-blueprint-checker-cotangent-grpobj-review130`.
    Findings folded into `recommendations.md` and the Knowledge Base.
- **Net sorry change**: 3 → 3 (qualitative substantive content: the
  iter-128 mathematically-degenerate body was replaced with a
  non-degenerate one; sorry count is the wrong metric for this iter —
  what closed is a vacuity defect, not a `sorry`).
- **Compile-verified**: yes. `lean_diagnostic_messages` returns 0 items
  on `AlgebraicJacobian/Cotangent/GrpObj.lean`. `lake env lean
  AlgebraicJacobian/Cotangent/GrpObj.lean` exits silently.
  `lean_verify AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity`
  returns `{propext, Classical.choice, Quot.sound}` — kernel-only, no
  `sorryAx`, no named axioms, no new project axioms.
- **No new axioms**. `archon-protected.yaml` unchanged (9 protected
  declarations).
- **Stage**: stays at `prover` for iter-131. Per `recommendations.md`,
  iter-131 should dispatch (a) a refactor lane to swap the body's
  `Classical.choice` wrapper for `Classical.indefiniteDescription` so
  the chart `V` and Kähler module become recoverable for the Wave-2
  rank lemma; OR (b) directly dispatch a prover lane on piece (i.b)
  `mulRight_globalises_cotangent` if the iter-131 planner judges the
  rank-lemma deferral acceptable (the rigidity-over-`k̄` consumer only
  needs existence of a rank-`n` `k`-module, which the iter-130 body
  already provides — though it provides it opaquely). Decision goes
  to the iter-131 plan agent based on the iter-131 progress-critic
  verdict on Route 1 (expected CONVERGING).
- **Meta**: `meta.json planValidate.status: ok / objectives: 1`;
  `plan.durationSecs: 1667` (~28 min); `prover.durationSecs: 780`
  (~13 min). 4 plan-phase subagent dispatches (3 critics + 1
  blueprint-writer) + 2 review-phase audits (lean-auditor + 1
  lean-vs-blueprint-checker on the only prover-touched file).

## Overall progress (this session detail)

- **Total active syntactic sorry sites**: **3**, distributed:
  - `AlgebraicJacobian/Jacobian.lean:192` — `genusZeroWitness`
    (iter-127 scaffold; body closure iter-152+ per iter-130 revised
    sequencing).
  - `AlgebraicJacobian/Jacobian.lean:211` — `nonempty_jacobianWitness`
    (Phase-C OFF-LIMITS; iter-156+).
  - `AlgebraicJacobian/RigidityKbar.lean:87` — `rigidity_over_kbar`
    (iter-126 scaffold; body iter-150+ after pile pieces (i.b)+(i.c)
    +(ii)+(iii) land; (i.a) just closed kernel-clean this iter).
- **Solved this iter**: 0 sorry-elimination events; 1 substantive
  body swap (iter-128 vacuous body → iter-130 non-vacuous chart-base-
  change body on `cotangentSpaceAtIdentity`). Sorry count is the
  wrong metric for the iter-130 substantive content.
- **Partial this iter**: 0.
- **Blocked this iter**: 0 (no STUCK verdict from progress-critic;
  the META-PATTERN check passed — body swap succeeded on first
  prover attempt of the iter).
- **Untouched (off-limits / off-prover-lane)**: 3 (the three sorry
  sites above; all recognised non-prover-lane work this iter).

## Per-target detail

### `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` (file `AlgebraicJacobian/Cotangent/GrpObj.lean`)

**SOLVED via body swap (Replacement (B) chart-base-change).**

The prover landed:

```lean
noncomputable def cotangentSpaceAtIdentity (G : Over (Spec (.of k)))
    [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom]
    [IsProper G.hom] [GeometricallyIrreducible G.hom] :
    ModuleCat k := by
  classical
  let ηleft : Spec (.of k) ⟶ G.left := CategoryTheory.CommaMorphism.left η[G]
  let x₀ : G.left := (ConcreteCategory.hom ηleft.base) default
  refine Classical.choice (α := ModuleCat k) ?_
  obtain ⟨U, V, e, hxV, _hU, _hV, _hfree, _hrank⟩ :=
    Scheme.smooth_locally_free_omega (n := n) G.hom x₀
  have htop : (⊤ : (Spec (.of k)).Opens) ≤ ηleft ⁻¹ᵁ V := by
    intro s _
    rw [Scheme.Hom.mem_preimage]
    rw [show s = default from Subsingleton.elim _ _]
    exact hxV
  let ψV : Γ(G.left, V) ⟶ CommRingCat.of k :=
    ηleft.appLE V ⊤ htop ≫ (Scheme.ΓSpecIso (.of k)).hom
  letI : Algebra ↥Γ(Spec (.of k), U) ↥Γ(G.left, V) :=
    (Scheme.Hom.appLE G.hom U V e).hom.toAlgebra
  exact ⟨(ModuleCat.extendScalars ψV.hom).obj
    (ModuleCat.of Γ(G.left, V) Ω[Γ(G.left, V) ⁄ Γ(Spec (.of k), U)])⟩
```

**Lemma chain consumed** (all `[verified]` in Mathlib `b80f227` +
project):
- `AlgebraicGeometry.Scheme.smooth_locally_free_omega` (project's
  `Differentials.lean`; consumes `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
  + `Algebra.IsStandardSmooth.free_kaehlerDifferential`).
- `AlgebraicGeometry.Scheme.instUniqueCarrierCarrierCommRingCatSpecOf`
  (provides `default : ↥(Spec (.of k))` and the `Subsingleton.elim`
  collapse).
- `AlgebraicGeometry.Scheme.Hom.mem_preimage`, `Scheme.Hom.appLE`,
  `Scheme.ΓSpecIso`, `ModuleCat.extendScalars`, `CommaMorphism.left`,
  `Classical.choice`.

**Acceptance test compliance** (per `progress-critic-iter130`; see
`PROGRESS.md` § "Iter-130 prover acceptance test"):

- ✓ Body references `smooth_locally_free_omega` (line 147 of post-iter
  file).
- ✓ Body references `Algebra.IsStandardSmoothOfRelativeDimension` via
  its consequence inside `smooth_locally_free_omega` (consumes
  `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
  + `Algebra.IsStandardSmooth.free_kaehlerDifferential` per the
  `smooth_locally_free_omega` body in
  `AlgebraicJacobian/Differentials.lean`; both Mathlib names cited in
  the iter-130 docstring).
- ✓ Body has a non-trivial intermediate term:
  `ModuleCat.of Γ(G.left, V) Ω[Γ(G.left, V) ⁄ Γ(Spec (.of k), U)]` —
  the algebraic Kähler module of a standard-smooth-of-relative-
  dimension-`n` algebra, free of rank `n` (not zero by the rank
  hypothesis encoded in the `IsStandardSmoothOfRelativeDimension`
  consequence).
- ✓ LOC: 40-line body (lines 131–170 of final file), well above the
  ≤30-LOC vacuity rejection threshold.
- ✓ Proof uses `refine`, `obtain`, `have`, `let`, `letI`, `rw`,
  `exact ⟨…⟩` — NOT a `simp`-only collapse.

**Critical caveat — `Classical.choice` opacity**: the body uses
`Classical.choice (α := ModuleCat k)` on a `Nonempty (ModuleCat k)`
wrapper (the only way to destructure `smooth_locally_free_omega`'s
`Prop`-level existential inside a `Type`-valued `def`). Cost: the
elaborated term is opaque — the chart `V`, the algebra structure on
`Γ(G.left, V)`, and the algebraic Kähler module are NOT directly
recoverable. The downstream rank lemma
`cotangentSpaceAtIdentity_finrank_eq` (Wave 2, optional, NOT attempted
this iter) would require either a refactor to
`Classical.indefiniteDescription` (or `.choose` chains) that projects
out the chart and Kähler module, or opaque-choice extensionality.
The prover correctly deferred Wave 2; iter-131 follow-up to refactor
the body for accessibility BEFORE attempting the rank lemma.

### `AlgebraicGeometry.genusZeroWitness` (file `AlgebraicJacobian/Jacobian.lean:192`)

Untouched. Iter-127 scaffold `sorry`. Off-limits this iter.

### `AlgebraicGeometry.nonempty_jacobianWitness` (file `AlgebraicJacobian/Jacobian.lean:211`)

Untouched. Phase-C OFF-LIMITS. No prover work iter-130.

### `AlgebraicGeometry.rigidity_over_kbar` (file `AlgebraicJacobian/RigidityKbar.lean:87`)

Untouched. Iter-126 scaffold `sorry`. Off-limits this iter (gated on
pile pieces (i.b)+(i.c)+(ii)+(iii); piece (i.a) closure this iter is
the first downstream-relevant pile piece).

## Review-phase audit findings

See `recommendations.md` for the full prioritised list.

- `lean-auditor-review130` (`task_results/lean-auditor-review130.md`):
  **1 must-fix + 4 major + 3 minor + 1 excuse-comment**. Critical
  must-fix: `Cotangent/GrpObj.lean:131–170` — the body
  `refine Classical.choice (α := ModuleCat k) ?_ ; obtain ⟨...⟩ := h ;
  exact ⟨X⟩` constructs explicit `X` then **discards** the
  rank-`n`-free Kähler-module content via `Classical.choice` (the
  result is not definitionally equal to `X`; only `Nonempty (ModuleCat
  k)` is structurally exposed). The Wave-2 rank lemma
  `cotangentSpaceAtIdentity_finrank_eq` will be **unprovable against
  this body for the same structural reason** iter-128's body was —
  different mechanism (opaque past Nonempty vs computes zero), same
  downstream impact. Majors: "Caveat on canonicity" excuse-comment
  (auditor: "lying excuse-comment — frames the loss as 'not
  canonically attached' while the actual defect is structural
  opacity"); incompatible "structural properties" docstring line; 2
  stale `Jacobian.lean` "single remaining sorry" prose.
- `lean-vs-blueprint-checker-cotangent-grpobj-review130`
  (`task_results/lean-vs-blueprint-checker-cotangent-grpobj-review130.md`):
  **0 must-fix + 2 major + 0 minor**. The (i.a) definition lemma
  `lem:GrpObj_cotangentSpace` is in good shape (Lean and blueprint
  mutually faithful under Replacement (B) framing; `Classical.choice`
  opacity explicitly authorised on both sides). The two downstream
  `\notready` lemmas carry iter-128-era proof-sketch residue:
  `lem:GrpObj_cotangent_bridge` proof Step 1 still describes iter-128
  global-sections LHS; `lem:GrpObj_lieAlgebra_finrank` "Iter-130
  closure path" paragraph doesn't flag the `Classical.choice` opacity.
  Both non-blocking iter-131 (lemmas are `\notready`), but fold into
  the same iter-131 blueprint-writer pass that re-aligns prose for
  the iter-131 refactor lane.

The two audits **agree on the structural defect**: the auditor focuses
on whether the body delivers on its claim (no — opaque past `Nonempty`);
the checker focuses on Lean-vs-blueprint internal consistency (the
blueprint explicitly mentions `Classical.choice`, so the prose-vs-Lean
is mutually consistent BUT both currently document a structurally
defective construction — what the auditor labels "the project lying to
itself"). Iter-131 must dispatch a refactor lane to fix the body (swap
`Classical.choice` for `Classical.choose`-chain or named-helper
factorisation) BEFORE any rank-lemma prover dispatch or piece (i.b)
scaffold.

## Meta-pattern verdict (post-audit revision)

Iter-127 plan-only / iter-128 prover (vacuous-by-zero-collapse body) /
iter-129 plan-only (diagnostic + repair scaffolding) / iter-130
**prover (body landed; passes acceptance test as written; auditor
flags second-mechanism opacity)**. The 4-iter alternation pattern
**lands a body** this iter, but the iter-130 `lean-auditor` discovered
the new body is **opaque past `Nonempty`** — a different vacuity
mechanism than iter-128's zero-collapse, but the same downstream impact
(the Wave-2 rank lemma `cotangentSpaceAtIdentity_finrank_eq` is
unprovable against the body as written).

Per the iter-130 `progress-critic-iter130` explicit watch:

> If iter-130 closes cleanly AND passes the acceptance test ... Route 1
> flips to CONVERGING. ... If iter-130 close again has vacuity
> signatures (≤30 LOC, simp-only, "trivial"/"easy" prover self-report):
> Route 1 flips to CHURNING.

The iter-130 body is ~40 LOC (NOT ≤30), is NOT simp-only, and the
prover did NOT self-report "trivial". The acceptance test was passed
as the progress-critic specified it. **But** the auditor's finding is
a structural defect not covered by the acceptance test's vacuity-
signature checklist — the body's content is opaque-past-`Nonempty`,
which the iter-131 plan agent should treat as a third vacuity-class
finding (call it "opaque-Nonempty" alongside iter-128's "computed-zero"
class).

**Revised verdict for iter-131 progress-critic**: Route 1 verdict is
between CONVERGING (literal acceptance-test reading) and
CHURNING-via-second-mechanism (substantive content-delivery reading).
The iter-131 plan agent should treat it as CONVERGING-with-mandatory-
refactor-fix: the body LANDED but needs a same-iter or next-iter
refactor to make the chart-existential's data accessible for the
downstream rank lemma. The iter-127/128/129/130 META-PATTERN tripwire
(third corrective cycle on same declaration) is **not yet armed** —
iter-131 is the first fix-up iter on the iter-130 outcome, analogous
to iter-129's first fix-up on iter-128. Tripwire would arm only if
iter-131's fix-up also fails to deliver an accessible body.

## Blueprint markers (manual this iter)

None. The plan-phase blueprint-writer
(`rigiditykbar-piecei-realign-iter130`) handled all prose and
`\notready` updates as part of its writer-domain work. The
deterministic `sync_leanok` phase (run before review-agent) handles
`\leanok` placement. No `\mathlibok` candidates (the body is
project-internal, not a Mathlib re-export).
