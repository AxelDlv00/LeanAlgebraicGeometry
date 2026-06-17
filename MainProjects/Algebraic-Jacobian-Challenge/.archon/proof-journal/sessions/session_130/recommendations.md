# Recommendations for the next plan-agent iteration (iter-131)

## Iter-130 at a glance

Iter-130 fired its prover lane and **closed the body** of
`AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` in 3 substantive
edits (one parse error on `h⊤` naming; one Prop-elimination error on
direct `obtain`; one clean close via `Classical.choice` pivot), plus 3
docstring-refresh edits absorbing 5 iter-129 docstring-drift majors.
The body passes `progress-critic-iter130`'s acceptance test as written
(references `smooth_locally_free_omega`, ~40 LOC, not simp-only).

**However, the iter-130 review-phase `lean-auditor` flagged 1
must-fix-iter-131: the body's outer `Classical.choice` wrapper renders
the explicit chart-base-changed Kähler module structurally inaccessible.**
The `Module.Free k` / `Module.Finite k` / `rank = n` properties hold of
the explicit witness `X` but do **not** transfer to `Classical.choice
⟨X⟩`. The Wave-2 rank lemma `cotangentSpaceAtIdentity_finrank_eq` is
therefore **unprovable against the iter-130 body for the same
structural reason** that iter-128's was (different mechanism — iter-128
computed zero, iter-130 is opaque past `Nonempty` — but same downstream
impact: the rank lemma cannot close).

Net sorry change: **3 → 3**. But this number is misleading. The
substantive content of iter-130 is a body swap (vacuous → opaque), not
a sorry elimination, and the opacity discovered by `lean-auditor` means
iter-131 needs a body re-shape **before** any rank-lemma dispatch.

## CRITICAL — iter-131 refactor lane on `cotangentSpaceAtIdentity` body opacity

**Per `lean-auditor-review130` must-fix #1** (task_results/lean-auditor-review130.md, lines 145–149):

`AlgebraicJacobian/Cotangent/GrpObj.lean:131-170` — the body
`refine Classical.choice (α := ModuleCat k) ?_ ; obtain ⟨...⟩ := h ;
exact ⟨X⟩` constructs an explicit `X` then **discards** the
mathematical content via `Classical.choice`. The auditor's verdict:

> By definition of `Classical.choice`, the result is **not**
> definitionally equal to `X` — it is some unspecified inhabitant of
> `ModuleCat k`. The only content recoverable from this definition is
> `Nonempty (ModuleCat k)`, which is a trivial statement once
> `ModuleCat.of k k` exists. The advertised rank-`n`-free Kähler-module
> content does NOT carry over to `cotangentSpaceAtIdentity G`.

**Recommended iter-131 fix-direction** (audit-level, not prescriptive):
replace the `Classical.choice`-on-`Nonempty` wrapper with a direct
`Classical.choose` / `Classical.choose_spec` chain that exposes the
chart-existential data `U, V, e, hxV, hU, hV, hfree, hrank` as
named locals, then return the chart-base-changed Kähler module
*directly* as the body term — no outer `Classical.choice` wrapper.
Sketch:

```lean
noncomputable def cotangentSpaceAtIdentity (G : Over (Spec (.of k)))
    [CategoryTheory.GrpObj G] {n : ℕ} [SmoothOfRelativeDimension n G.hom]
    [IsProper G.hom] [GeometricallyIrreducible G.hom] :
    ModuleCat k :=
  let ηleft : Spec (.of k) ⟶ G.left := CategoryTheory.CommaMorphism.left η[G]
  let x₀ : G.left := (ConcreteCategory.hom ηleft.base) default
  let h := Scheme.smooth_locally_free_omega (n := n) G.hom x₀
  let U := Classical.choose h
  let V := Classical.choose (Classical.choose_spec h)
  let e := Classical.choose (Classical.choose_spec (Classical.choose_spec h))
  -- … (similar for hxV, hU, hV, hfree, hrank) …
  letI : Algebra ↥Γ(Spec (.of k), U) ↥Γ(G.left, V) :=
    (Scheme.Hom.appLE G.hom U V e).hom.toAlgebra
  let ψV : Γ(G.left, V) ⟶ CommRingCat.of k := /- as before -/
  (ModuleCat.extendScalars ψV.hom).obj
    (ModuleCat.of Γ(G.left, V) Ω[Γ(G.left, V) ⁄ Γ(Spec (.of k), U)])
```

A cleaner alternative is to factor the chart choice into an auxiliary
helper:

```lean
noncomputable def cotangentSpaceAtIdentity.chart (G : Over (Spec (.of k)))
    [...] : Σ' (U V : _) (e : V ≤ _), x₀ ∈ V ∧ ... := ...

noncomputable def cotangentSpaceAtIdentity (G : ...) : ModuleCat k :=
  let ⟨U, V, e, _, _, _, _, _⟩ := cotangentSpaceAtIdentity.chart G
  (ModuleCat.extendScalars (ψV U V e).hom).obj
    (ModuleCat.of Γ(G.left, V) Ω[Γ(G.left, V) ⁄ Γ(Spec (.of k), U)])
```

This exposes the chart as projections of a named helper that the rank
lemma can `unfold` to reach the explicit Kähler module. Estimated LOC:
80–150 (split between the helper and the main definition).

**HARD GATE for iter-131 piece (i.b) prover dispatch**: the iter-131
mandatory `blueprint-reviewer` should green-light the refactor lane
above BEFORE any piece (i.b) `mulRight_globalises_cotangent` scaffold
fires. Reason: the iter-130 strategy-critic Q2 deferred-bridge concern
identified piece (i.b) closure as the trigger for `(B) → (A)` bridge
costs; if the body remains opaque, piece (i.b) closure can't even refer
to the cotangent space at the identity as a *specific* `ModuleCat k`
with named structure.

## HIGH — iter-131 blueprint-writer pass on `RigidityKbar.tex` `\notready` lemmas

**Per `lean-vs-blueprint-checker-cotangent-grpobj-review130`** (task_results/lean-vs-blueprint-checker-cotangent-grpobj-review130.md, lines 41–53):

Two majors on the two `\notready` lemmas in
`blueprint/src/chapters/RigidityKbar.tex` § Piece (i):

1. **`lem:GrpObj_cotangent_bridge` proof Step 1** (line 151) still
   describes the iter-128 global-sections LHS framing
   (`Γ(G, 𝒪_G) → k` localised to the identity stalk), while the
   lemma statement (line 144) and conclusion paragraph (line 163)
   now pin the LHS to the iter-130 chart-base-changed body. A future
   prover lane on this `\notready` bridge would walk into a
   structurally-wrong starting body.
2. **`lem:GrpObj_lieAlgebra_finrank` "Iter-130 closure path"
   paragraph** (line 203) names the right Mathlib pieces but does
   not flag the `Classical.choice` opacity of the iter-130 body.
   A prover reading only line 203 would attempt a direct
   `Module.finrank_baseChange` rewrite that fails because
   `Classical.choice` is opaque to unfolding.

Both findings are **non-blocking iter-131** (both lemmas are
`\notready`), but if iter-131 either (a) scaffolds the bridge for a
future iter, or (b) attempts the rank lemma after the recommended
body refactor, the chapter prose should be aligned first. Bundle into
a single blueprint-writer pass with the must-fix-iter-131 refactor.

## HIGH — iter-130 docstring drift cleanup folded into the refactor lane

Per `lean-auditor-review130` (lines 151–156, 4 majors):

1. **`AlgebraicJacobian/Cotangent/GrpObj.lean:118-123` "Caveat on
   canonicity" paragraph**: the auditor flags this as an
   excuse-comment — frames the loss as "not canonically attached"
   while the actual defect is structural opacity. **Recommended
   action**: if the iter-131 refactor lane swaps `Classical.choice`
   for `Classical.choose`, this paragraph becomes obsolete and can
   be dropped entirely. Otherwise, rewrite to honestly disclose:
   "the body wraps the explicit chart-base-changed Kähler module in
   `Classical.choice`, which discards the rank-`n`-free structural
   content; downstream consumers cannot transport `Module.Free k` or
   `rank = n` claims through this definition." This is the auditor's
   alternative path; the refactor is preferred.
2. **`AlgebraicJacobian/Cotangent/GrpObj.lean:128-130` "structural
   properties" line**: claims `Module.Free k` / `Module.Finite k` /
   `rank = n` are content for the iter-129+ rank lemma. Incompatible
   with the iter-130 body. Fold into the refactor lane's body
   rewrite.
3. **`AlgebraicJacobian/Jacobian.lean:195`** — `nonempty_jacobianWitness`
   docstring "single remaining mathematical sorry of the Phase-C
   Jacobian scaffolding". Stale since iter-127 added `genusZeroWitness`.
   Both sorries are now present, the prose should read "one of two
   remaining mathematical sorries" or be re-scoped.
4. **`AlgebraicJacobian/Jacobian.lean:226`** — `Jacobian` def
   docstring repeats "the existence of such a witness is the single
   remaining mathematical sorry of the Phase-C scaffolding." Same
   staleness as #3.

Items #3 and #4 are tiny edits to the docstring; bundle into the same
iter-131 refactor lane (since the lane is touching `Cotangent/GrpObj.lean`
anyway) OR a separate small `Jacobian.lean` docstring-cleanup
mini-refactor if appetite is limited.

## MEDIUM — iter-131 META-PATTERN watch

Per `progress-critic-iter130`'s watch criterion:

> Iter-127 plan / iter-128 prover / iter-129 plan / iter-130 prover.
> Healthy correction-cycle alternation, not stuck loop. Would only
> flip to CHURNING if iter-130 again produces a vacuous body and
> iter-131 must again be plan-only repair (second cycle in a row).

The iter-130 body is **not** vacuous in the iter-128 sense (it does
not compute `0`), but it IS opaque-past-Nonempty per the auditor.
This is a **different vacuity mechanism** than iter-128. The iter-131
plan agent should:

- Note that the iter-130 acceptance test passed *as written* (body
  references `smooth_locally_free_omega`, ~40 LOC, not simp-only) but
  the auditor flagged a deeper structural defect not caught by the
  acceptance test signatures.
- Treat iter-131 as a **fix-up + same-iter prover combo** (analogous
  to iter-128's TRIPWIRE iter): the refactor lane swaps
  `Classical.choice` for `Classical.choose`-chain or named-helper
  factorisation; same iter, the prover lane re-closes the body and
  may attempt the Wave-2 rank lemma if budget remains. Or iter-131
  may be plan-only fix-up (refactor-only, no prover), with iter-132
  the prover lane on the rank lemma and piece (i.b) scaffold.
- The iter-131 progress-critic verdict on Route 1 will probably read
  CONVERGING-with-a-correction-pending. Do NOT skip the
  progress-critic dispatch — it explicitly committed to verify the
  iter-130 outcome.

**Trigger for iter-131 acceptance test (suggested)**: the new body
must be such that `cotangentSpaceAtIdentity G` is definitionally
(or up to a named auxiliary helper's projection) equal to the
chart-base-changed Kähler module, NOT wrapped in `Classical.choice`.
Verification: a stub `example : True := by unfold cotangentSpaceAtIdentity ; sorry`
should expose `ModuleCat.extendScalars` and `Ω[…⁄…]` in the goal —
NOT `Classical.choice`.

## MEDIUM — strategy-critic Q2 deferred-bridge re-evaluation

Per `strategy-critic-iter130` Q2 (recorded in PROGRESS.md): the
iter-131+ piece (i.b) `mulRight_globalises_cotangent` may require a
`(B) → (A)` stalk-side bridge if the shear iso names the cotangent at
identity as a *specific* fibre object. The iter-130 body's opacity
makes this worse: even if (B) → (A) is constructible, the (B) side
itself doesn't have nameable structure.

The iter-131 plan agent should:

- Run `mathlib-analogist-cotangentSpaceAtIdentity-opacity-iter131` (or
  similar slug) BEFORE piece (i.b) scaffolds. The analogist should
  assess whether the recommended refactor (named-helper factorisation
  exposing the chart) gives piece (i.b) a workable surface to
  globalise, OR whether the iter-130 body needs a deeper redesign
  (e.g. Replacement (A) stalk-side after all, despite the iter-129
  500–1000 LOC cost estimate).
- The iter-128 mathlib-analogist verdict (Replacement (B) chosen over
  (A)) was made assuming the body could expose the chart via standard
  destructure idioms. The iter-130 prover lane discovered that
  standard destructure doesn't work in `Type`-valued defs; the
  workaround chosen (`Classical.choice`) discards content. The
  iter-129 analogist's verdict may need revision in light of this
  Lean-elaborator-level constraint.

## LOW — minor cleanup items

Per `lean-auditor-review130` minor section (lines 160–162):

- `AlgebraicJacobian/Genus.lean:6` — `import Mathlib` wholesale for a
  one-decl file. Cosmetic; defer.
- `AlgebraicJacobian/Cohomology/SheafCompose.lean:6` — same as above.
  Cosmetic; defer.
- Iter-NNN tag noise in docstrings (`MayerVietorisCore`, `MayerVietorisCover`,
  `StructureSheafModuleK`). Project-internal narrative; not a hygiene
  defect. Defer indefinitely.

## Reusable proof patterns discovered iter-130

The following are now folded into PROJECT_STATUS.md § Knowledge Base.

1. **`Classical.choice (α := X) ?_` is a `Type`-valued-def escape for
   `Prop`-level existentials, but it discards content**. The standard
   Lean idiom `refine Classical.choice (α := X) ?_ ; obtain ⟨...⟩ :=
   proof_of_exists ; exact ⟨theTerm⟩` solves the `Exists.casesOn can
   only eliminate into Prop` elaborator restriction. **Use
   `Classical.indefiniteDescription` or chained `Classical.choose` /
   `Classical.choose_spec` instead if any downstream lemma needs to
   access the destructured data**. The iter-130 prover lane's body
   chose `Classical.choice` for the cleanest single-edit close, but
   the resulting opacity blocks the rank lemma.
2. **Lattice symbols cannot be part of identifiers in tactic blocks**.
   Hypothesis names like `h⊤` parse as `h` followed by the lattice
   top token — the tactic block aborts with `unexpected token '⊤'`.
   Use ASCII alternatives (`htop`, `hbot`, `hsup`, `hinf`).
3. **The unique-point collapse for `Spec` of a field**:
   `Scheme.instUniqueCarrierCarrierCommRingCatSpecOf` + `Subsingleton.elim
   s default` turns any obligation of the form `s ∈ U` (for `s :
   ↥(Spec (.of k))` and `U ⊆ Spec (.of k)` containing the unique
   point) into a 1–2 line proof. Standard pattern for any future
   work threading sections out of `Spec k`.

## What the iter-131 plan should look like

1. **Mandatory critics** (3): strategy-critic, blueprint-reviewer,
   progress-critic. All three should be passed only the iter-130
   review findings (lean-auditor must-fix #1 + lean-vs-blueprint-checker
   2 majors) plus their normal scope.
2. **Mandatory refactor lane** on `Cotangent/GrpObj.lean` — swap the
   `Classical.choice (α := ModuleCat k)` wrapper for either a
   `Classical.choose` chain or a named auxiliary helper that exposes
   the chart-existential as projections. Same iter, the lane should
   refresh the declaration docstring (drop the Caveat-on-canonicity
   excuse-comment per auditor finding).
3. **Mandatory blueprint-writer lane** on `RigidityKbar.tex` § Piece
   (i): re-align Step 1 of `lem:GrpObj_cotangent_bridge` proof (iter-128
   LHS framing → iter-130 chart-base-changed LHS); add explicit
   `Classical.choice` opacity caveat to `lem:GrpObj_lieAlgebra_finrank`
   "Iter-130 closure path" paragraph (or remove the paragraph if the
   iter-131 refactor drops `Classical.choice` entirely). Same iter.
4. **Optional Wave-2 prover lane**: if the refactor lands cleanly with
   ≥150 LOC remaining of the iter-budget, scaffold + close the rank
   lemma `cotangentSpaceAtIdentity_finrank_eq`. Closure chain
   (verified `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`,
   `Module.finrank_baseChange`, `Algebra.TensorProduct.instFree`)
   should now be reachable since the chart is named.
5. **Out of scope iter-131**: piece (i.b) scaffold (defer to iter-132+);
   `Jacobian.lean` docstring drift (#3+#4 above; fold into iter-131
   refactor lane if convenient, else iter-132).

## TO_USER alert candidate

**No user escalation needed.** The iter-130 outcome is a closed-but-
imperfectly-shaped body, not an impasse. The iter-131 fix-up is
clear-direction work (refactor + blueprint pass) and the loop can
proceed autonomously. The iter-130 review's `lean-auditor` finding
is exactly the type of structural defect the review-phase audits are
designed to catch; the corrective is the iter-131 refactor lane.
`TO_USER.md` left empty.
