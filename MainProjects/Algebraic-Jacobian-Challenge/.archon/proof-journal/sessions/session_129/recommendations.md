# Recommendations for the next plan-agent iteration (iter-130)

## Iter-129 at a glance

Plan-phase-only iter by design. No prover lane fired. Substantive
changes: 1 refactor (rename + signature relax in `Cotangent/GrpObj.lean`;
header rewrite in `Jacobian.lean`), 2 blueprint-writers (RigidityKbar
substantive rewrite + 4-chapter orphan deletion), 1 mathlib-analogist
(critical degeneracy discovery on the iter-128 body), 3 plan-phase
critics (all returned), 3 review-phase audits (lean-auditor + 2
lean-vs-blueprint-checkers). Net sorry change: **3 → 3** (refactor was
signature/header-only).

## CRITICAL — iter-130 MANDATORY prover lane

**Target**: `AlgebraicJacobian/Cotangent/GrpObj.lean` —
`AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity` body swap.

**Why critical**: the iter-129 `mathlib-analogist-lieAlgebra-rank-bridge-iter129`
discovered that the iter-128 body computes the **zero `k`-module** for
every smooth proper geometrically irreducible `G/k` with relative
dimension `n ≥ 1`. The body is kernel-clean and `lean_verify`-clean,
but proves a vacuous claim. The iter-130 rank-lemma scaffold + closure
**cannot** be staged against this body — the rank lemma is provably
false against it.

**Body swap to perform (Replacement B per analogist verdict)**:

1. Extract via `smooth_locally_free_omega` an affine chart `V ⊆ G.left`
   containing the identity-section image `η(pt)`, with
   `Algebra.IsStandardSmoothOfRelativeDimension n Γ(Spec k, U) Γ(G, V)`.
2. Build `ψ_V : Γ(G, V) ⟶ k` from the identity section restricted to `V`,
   composed with `Scheme.ΓSpecIso`.
3. Define the body as
   `(ModuleCat.extendScalars ψ_V.hom).obj (ModuleCat.of Γ(G, V) Ω[Γ(G, V) ⁄ Γ(Spec k, U)])`.

Estimated 200–400 LOC; 1–2 prover iters. Tradeoff: non-canonical
(depends on chart choice via `Classical.choice`). Acceptable for the
single live consumer (rigidity-over-`k̄`, which only needs *existence*
of a rank-`n` `k`-module). Document with a `% NOTE` in the declaration
docstring.

**Mathlib closure chain (all verified or expected; see `analogies/lieAlgebra-rank-bridge.md` § Decision 3)**:
1. `AlgebraicGeometry.IsSmoothOfRelativeDimension.exists_isStandardSmoothOfRelativeDimension` [verified]
2. `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth` [verified]
3. `Algebra.IsStandardSmooth.free_kaehlerDifferential` [verified]
4. `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` [verified]
5. `Module.Free.tensorProduct` + `Module.finrank_tensorProduct` [expected — Mathlib has the pattern]
6. `Module.finrank_eq_rank'` [verified]
7. `Scheme.ΓSpecIso` [verified]

**HARD GATE**: iter-130 mandatory `blueprint-reviewer` must green-light
first. The iter-129 RigidityKbar writer pass addressed the iter-128
blocking items, but the writer's bridge framing in `lem:GrpObj_cotangent_bridge`
is closer to Replacement (A) canonical stalk-side; the iter-130 body
swap is Replacement (B) chart-side. The two are different mathematical
objects (canonical vs chart-dependent) producing the same rank.
Chapter prose may need a minor iter-130 alignment paragraph reconciling
the two — this is **non-blocking** for the body swap itself, but the
reviewer should call out which of the two anchors is the "primary"
iter-130 target.

**Optional Wave 2 (if body swap closes early in iter-130)**: scaffold + close
`cotangentSpaceAtIdentity_finrank_eq` (rank lemma `finrank cotangentSpaceAtIdentity G = n`).
Additional 50–100 LOC against the closure chain above.

## HIGH — concurrent docstring refresh in the iter-130 body-swap lane

Per `lean-auditor-review129`: **5 major** docstring drift items in the
two files that received refactor work this iter. None are must-fix-now,
but bundling them into the iter-130 body-swap refactor (rather than a
separate iter) is the lowest-friction option:

- `AlgebraicJacobian/Cotangent/GrpObj.lean:70` — docstring still claims
  the body "is a finitely-generated free `k`-module of rank equal to
  the relative dimension of `G.hom`". Refresh to disclose the iter-128
  body's degeneracy + the iter-130 body swap that makes the claim true.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:99` — "structural properties
  (`Module.Free k`, `Module.Finite k`, rank `= n`) are content for the
  iter-129+ rank lemma" — same stale-claim category.
- `AlgebraicJacobian/Cotangent/GrpObj.lean:28` — file-level status block
  "is fully constructed (no `sorry`) via the pullback-along-section
  bridge". True at the Lean level, misleading at the math level. Refresh.
- `AlgebraicJacobian/Jacobian.lean:195` — `nonempty_jacobianWitness`
  docstring opens "This is the single remaining mathematical sorry of
  the Phase-C Jacobian scaffolding". Stale since iter-127 added
  `genusZeroWitness`. Refresh to "one of two remaining mathematical
  sorries" or similar.
- `AlgebraicJacobian/Jacobian.lean:226` — `Jacobian` docstring closes
  "the existence of such a witness is the single remaining mathematical
  sorry of the Phase-C scaffolding." Same issue.

The iter-130 body-swap refactor is editing the file anyway; folding
these into the same edit avoids a separate iter-131 cleanup round.

## MEDIUM — minor docstring residue in `Cotangent/GrpObj.lean`

Per `lean-auditor-review129` minor: lines 73–77 carry residual
dualisation-convention prose ("The Lie algebra `𝔤` of `G` … is the
`k`-linear dual of this module"). The iter-129 refactor rewrote the
docstring to drop dualisation; this paragraph survived as partial
cleanup. Strip in the iter-130 docstring refresh.

## HIGH — RigidityKbar.tex prose framing must be reframed for the iter-130 body swap

Per `lean-vs-blueprint-checker-cotangent-grpobj-review129` (1 major):
the iter-129 RigidityKbar writer pass frames the iter-128 body as the
**canonically-correct realisation** of `η_G^* Ω_{G/k}` and the new
bridge lemma as a **tautological identification** of two equal-by-
construction objects. Both framings are positively wrong if the iter-128
body is mathematically degenerate (per the parallel mathlib-analogist
finding). Specifically:

- `RigidityKbar.tex` `lem:GrpObj_cotangentSpace` proof line 115:
  "The iter-128 Lean construction *realises* `η_G^* Ω_{G/k}` as the
  extension of scalars …". The verb "realises" frames the body as
  canonical. **Recommended fix**: replace with "*currently encodes*
  `η_G^* Ω_{G/k}` as …" or equivalent hedge, with a one-sentence note
  that the iter-130 prover lane is scheduled to replace the body via
  Replacement (B).
- `RigidityKbar.tex` `lem:GrpObj_cotangentSpace` proof line 117: states
  the body is `g^∨ ≅ k ⊗_{Γ(G,𝒪_G)} (Ω_{G/k})(G)` without acknowledging
  the realisation may collapse to zero for the consumer class.
- `RigidityKbar.tex` `lem:GrpObj_cotangent_bridge` proof line 160: "the
  bridge is a **tautological** identification of two constructions of
  the same `k`-module". If the iter-128 body is degenerate, the bridge
  becomes a non-trivial *replacement*, not a tautology. **Recommended
  fix**: drop "tautological"; recast the bridge as the canonical
  *replacement* path that pins the correct cotangent.
- `RigidityKbar.tex` `lem:GrpObj_cotangent_bridge` statement line 141:
  "the left-hand side is the iter-128 evaluate-then-extend-scalars
  Lean body of `\cref{lem:GrpObj_cotangentSpace}`" — frames body as
  canonical LHS of the bridge iso. **Recommended fix**: hedge to "the
  iter-128 placeholder Lean body (scheduled for iter-130 replacement)".
- Optional minor: add `\notready` to `lem:GrpObj_cotangent_bridge` for
  consistency with `lem:GrpObj_lieAlgebra_finrank` (also no Lean
  counterpart).

**Iter-130 action**: dispatch a small `RigidityKbar.tex` alignment
blueprint-writer pass either (a) concurrent with the iter-130 body-swap
prover lane, or (b) immediately before the iter-130 mandatory
`blueprint-reviewer` runs the iter-130 HARD GATE. Option (b) is safer
because the reviewer will flag the framing drift and block the prover
lane if not addressed first; option (a) saves an iter if the reviewer
happens to be permissive about iter-130-staged prose.

Lean-side companion (minor, same checker): add a forward-reference to
`cotangentSpaceAtIdentity_iso_localRingCotangent` (the iter-130+ bridge)
in the `cotangentSpaceAtIdentity` docstring at `Cotangent/GrpObj.lean`
lines 62–101, alongside the existing `cotangentSpaceAtIdentity_finrank_eq`
reference. Fold into the iter-130 docstring refresh bundle.

## MEDIUM — minor stale line references in `Jacobian.tex`

Per `lean-vs-blueprint-checker-jacobian-review129` (PASS / 0 must-fix):

- `Jacobian.tex:398` references `Jacobian.lean:120–126` for
  `geometricallyIrreducible_id_Spec`; the actual location after the
  iter-129 header expansion is L134–140.
- `Jacobian.tex:410` references `Jacobian.lean:174–178` for the
  `genusZeroWitness` body; the actual location after the iter-129
  header expansion is L188–192.

Both line refs were correct relative to the pre-iter-129 file but were
not re-synced when the header inventory landed. Low-priority — the
chapter cross-references are not load-bearing. Defer to a small iter-131
blueprint-writer cleanup pass, OR fold into any iter-130 `Jacobian.tex`
edits if the planner is already touching the chapter.

## LOW — soft / informational

- **Soon (acknowledged, deferred)**: `Jacobian.tex` § C.2.a + § C.2
  prologue retain over-`k̄` framing that drifts from the iter-127 over-k
  commitment (`Jacobian.tex:319`, `Jacobian.tex:322`). Carry-over from
  iter-127 / iter-128 review; not blocking. The internal coherence of
  the chapter (§ C.2.f, § C.2.g, § Mathlib infrastructure summary point
  $\gamma$) describes the over-k commitment consistently. Defer to a
  later writer pass; not urgent for iter-130.
- **Soon (deferred)**: `RigidityKbar.tex` pieces (ii) and (iii) need
  their own chapter sections or subchapters before iter-131+ build
  lanes target them. Queue a blueprint-writer for iter-131+ once
  piece (i) body swap closes (iter-130).
- **Soon (deferred)**: `RigidityKbar.tex` rank-lemma proof could
  cross-reference `Differentials.tex` `thm:smooth_locally_free_omega`
  to shorten the closure path. Low-priority editorial.
- **Informational**: `RigidityKbar.tex` legacy variable name `kbar` in
  the Lean signature `[Field kbar]` — low-priority rename to `k` per
  the chapter's own over-k commitment paragraph. Defer.

## DO NOT retry / DO NOT assign

- **`AlgebraicJacobian/Jacobian.lean:208` `nonempty_jacobianWitness`** —
  Phase-C OFF-LIMITS sorry. Gated on M2 + M3 closure. Plan agent should
  NOT assign this in iter-130 or any iter before M2 + M3 land
  (iter-148+ in current sequencing).
- **`AlgebraicJacobian/Jacobian.lean:188` `genusZeroWitness`** —
  iter-127 scaffold body closure is gated on the cotangent-vanishing
  pile completing (`rigidity_over_kbar` body + downstream Albanese
  packaging). Plan agent should NOT assign this in iter-130; queue
  iter-138+.
- **`AlgebraicJacobian/RigidityKbar.lean:75` `rigidity_over_kbar`** —
  iter-126 scaffold body closure is gated on shared cotangent-vanishing
  pile pieces (i)+(ii)+(iii). Plan agent should NOT assign this in
  iter-130; queue iter-144+.
- **Iter-130 prover lane retrying the iter-128 evaluate-then-extend-scalars
  body shape** — that body is provably vacuous (computes zero) for
  the target class. The iter-130 lane MUST swap to Replacement (B)
  chart-side per analogist's verdict.

## Process / discipline reminders

1. **Mathlib-analogist consult is mandatory when a new declaration's
   construction differs structurally from the blueprint's proof sketch**
   (here: evaluate-then-extend-scalars vs `𝔪/𝔪²` stalk presentation),
   even if `lake build` and `lean_verify` are both clean. The iter-128
   shipping-without-analogist pattern produced kernel-clean vacuity
   that took an iter-129 retroactive consult to detect. See
   PROJECT_STATUS.md § Knowledge Base "Soundness lesson: kernel-clean
   does not imply mathematically correct" for the rule.

2. **`Ideal.IsLocalRing.CotangentSpace` is the canonical Mathlib name**;
   the older `IsRegularLocalRing.cotangentSpace` is phantom. Replace
   in any future strategy or blueprint prose. Already corrected in
   `RigidityKbar.tex` this iter.

3. **Iter-129 fallback rule does NOT trigger**. Its codified condition
   in `iter/iter-128/plan.md` was "iter-128 prover INCOMPLETE / PARTIAL
   with `lieAlgebra` still `sorry`", neither of which holds. The iter-128
   close was kernel-clean (the math degeneracy is a separate finding
   uncovered by the iter-129 analogist; it does not trigger the iter-128
   fallback). The iter-130 plan proceeds with normal planning + the
   iter-130 mandatory body-swap prover lane.

## Meta-pattern verdict

Per `progress-critic-iter129`: piece (i) is UNCLEAR (1 iter of COMPLETE
data + 1 iter of structural fix-up). The iter-130 body-swap is the
next data point. **If COMPLETE**, piece (i) flips to CONVERGING.
**If PARTIAL/INCOMPLETE**, the analogist's named Mathlib closure
chain has a gap the iter-129 verification did not catch; escalate to
strategy-critic + a second analogist consult on the specific failing
step.

META-PATTERN tripwire (3 consecutive plan-phase-only iters) is far
from re-firing. Sequence so far: iter-128 (prover-COMPLETE) → iter-129
(plan-only). Iter-130 + 131 + 132 would all need to be plan-only for
the tripwire to fire again.

## Quick summary for plan-agent iter-130 entry

- **iter-130 mandatory prover lane** on `Cotangent/GrpObj.lean` body swap (Replacement B).
- **Concurrent**: refresh 5 stale docstring items per `lean-auditor-review129` majors.
- **HARD GATE**: iter-130 mandatory `blueprint-reviewer` green-lights first; if it flags the writer's bridge-framing-vs-Replacement-B discrepancy, dispatch a small `RigidityKbar.tex` alignment writer pass.
- **No prover dispatch** on the three deferred sorries (`genusZeroWitness`, `nonempty_jacobianWitness`, `rigidity_over_kbar`) — all are queued behind iter-138+ / iter-148+ / iter-144+.
- **`USER_HINTS.md`** empty at iter-130 entry; auto-execute the body-swap lane per `iter/iter-129/plan.md § "Fallback if no user response"`.
